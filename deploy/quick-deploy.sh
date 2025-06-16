#!/bin/bash

# Deploy rápido do FamaChat v2.0
# Execute após configurar o banco de dados

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

APP_DIR="/var/www/famachat"
USER="famachat"

log_info "🚀 Deploy rápido do FamaChat v2.0..."

# Verificar se o código está no diretório
if [ ! -f "$APP_DIR/package.json" ]; then
    log_error "Código não encontrado em $APP_DIR"
    log_error "Primeiro transfira seu código para o servidor"
    log_error ""
    log_error "Opções:"
    log_error "1. Via Git: git clone https://github.com/seu-repo/famachat.git $APP_DIR"
    log_error "2. Via SCP/SFTP: transfira os arquivos para $APP_DIR"
    log_error "3. Via rsync: rsync -av local-folder/ servidor:$APP_DIR/"
    exit 1
fi

cd $APP_DIR

# Verificar se arquivo .env existe
if [ ! -f ".env.production" ]; then
    log_error "Arquivo .env.production não encontrado"
    log_error "Execute primeiro o quick-setup-db.sh"
    exit 1
fi

# Instalar dependências
log_info "Instalando dependências..."
sudo -u $USER npm ci --only=production

# Executar build
log_info "Executando build..."
sudo -u $USER npm run build

# Verificar se build foi criado
if [ ! -d "dist" ]; then
    log_error "Build falhou - diretório dist não foi criado"
    exit 1
fi

# Criar configuração PM2 para produção
log_info "Configurando PM2..."
sudo -u $USER tee ecosystem.production.config.js > /dev/null <<EOF
module.exports = {
  apps: [{
    name: 'famachat-production',
    script: 'dist/index.js',
    cwd: '${APP_DIR}',
    instances: 'max',
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    },
    env_file: '.env.production',
    error_file: '/var/log/famachat/err-production.log',
    out_file: '/var/log/famachat/out-production.log',
    log_file: '/var/log/famachat/combined-production.log',
    time: true,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    node_args: '--max-old-space-size=1024',
    kill_timeout: 5000,
    wait_ready: true,
    listen_timeout: 10000,
    reload_delay: 1000,
    max_restarts: 10,
    min_uptime: '10s'
  }]
};
EOF

# Executar migrações do banco (se existir)
log_info "Executando migrações do banco..."
if grep -q "db:push" package.json; then
    sudo -u $USER npm run db:push
else
    log_warning "Script db:push não encontrado - migrações manuais podem ser necessárias"
fi

# Parar PM2 se estiver rodando
sudo -u $USER pm2 stop famachat-production 2>/dev/null || true
sudo -u $USER pm2 delete famachat-production 2>/dev/null || true

# Iniciar aplicação
log_info "Iniciando aplicação..."
sudo -u $USER pm2 start ecosystem.production.config.js

# Salvar configuração PM2
sudo -u $USER pm2 save

# Configurar PM2 para iniciar automaticamente
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u $USER --hp /home/$USER

# Configurar Nginx
log_info "Configurando Nginx..."
sudo tee /etc/nginx/sites-available/famachat > /dev/null <<EOF
server {
    listen 80;
    server_name _;
    
    access_log /var/log/nginx/famachat_access.log;
    error_log /var/log/nginx/famachat_error.log;
    
    client_max_body_size 10M;
    
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/javascript
        application/xml+rss
        application/json;
    
    # Arquivos estáticos
    location /uploads/ {
        alias /var/lib/famachat/uploads/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Proxy para aplicação
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
        proxy_read_timeout 300s;
        proxy_connect_timeout 300s;
        proxy_send_timeout 300s;
    }
}
EOF

# Habilitar site
sudo ln -sf /etc/nginx/sites-available/famachat /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Testar e recarregar Nginx
sudo nginx -t && sudo systemctl reload nginx

# Criar script de health check
sudo tee /usr/local/bin/famachat-health-check.sh > /dev/null <<EOF
#!/bin/bash
URL="http://localhost:3000/health"
LOGFILE="/var/log/famachat/health-check.log"
DATE=\$(date '+%Y-%m-%d %H:%M:%S')

HTTP_CODE=\$(curl -s -o /dev/null -w "%{http_code}" \$URL)

if [ "\$HTTP_CODE" = "200" ]; then
    echo "[\$DATE] OK - Aplicação respondendo (HTTP \$HTTP_CODE)" >> \$LOGFILE
    exit 0
else
    echo "[\$DATE] ERROR - Aplicação não respondeu (HTTP \$HTTP_CODE)" >> \$LOGFILE
    echo "[\$DATE] Tentando reiniciar aplicação..." >> \$LOGFILE
    sudo -u famachat pm2 restart famachat-production
    exit 1
fi
EOF

sudo chmod +x /usr/local/bin/famachat-health-check.sh

# Configurar health check a cada 5 minutos
(sudo crontab -l 2>/dev/null; echo "*/5 * * * * /usr/local/bin/famachat-health-check.sh") | sudo crontab -

log_info "✅ Deploy concluído com sucesso!"
log_info ""
log_info "🌐 URLs disponíveis:"
log_info "• Aplicação: http://seu-ip-servidor/"
log_info "• Health check: http://seu-ip-servidor/health"
log_info ""
log_info "📊 Comandos úteis:"
log_info "• Status PM2: sudo -u famachat pm2 status"
log_info "• Logs: sudo -u famachat pm2 logs"
log_info "• Monitor: sudo -u famachat pm2 monit"
log_info "• Restart: sudo -u famachat pm2 restart famachat-production"
log_info ""
log_warning "⚠️ Próximos passos:"
log_warning "1. Teste a aplicação no navegador"
log_warning "2. Configure SSL/HTTPS se necessário"
log_warning "3. Configure as variáveis do WhatsApp no .env.production"
log_warning "4. Configure backup externo se necessário"
