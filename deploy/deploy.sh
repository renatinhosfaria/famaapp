#!/bin/bash

# Script de deploy do FamaChat v2.0
# Configuração para ambiente de produção e desenvolvimento

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

log_debug() {
    echo -e "${BLUE}[DEBUG]${NC} $1"
}

# Configurações
APP_DIR="/var/www/famachat"
USER="famachat"
GROUP="www-data"
REPO_URL="https://github.com/seu-usuario/famachat.git"  # ALTERE AQUI
BRANCH="main"

# Função para verificar se o comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Verificações iniciais
log_info "🚀 Iniciando deploy do FamaChat v2.0..."

# Verificar se os comandos necessários existem
if ! command_exists node; then
    log_error "Node.js não está instalado"
    exit 1
fi

if ! command_exists npm; then
    log_error "NPM não está instalado"
    exit 1
fi

if ! command_exists pm2; then
    log_error "PM2 não está instalado"
    exit 1
fi

# Verificar se o usuário famachat existe
if ! id "$USER" &>/dev/null; then
    log_error "Usuário $USER não existe. Execute o setup-vps.sh primeiro"
    exit 1
fi

# Função para fazer deploy
deploy_app() {
    local env_mode=$1
    local port=$2
    
    log_info "📦 Fazendo deploy para ambiente: $env_mode"
    
    # Ir para o diretório da aplicação
    cd $APP_DIR
    
    # Se for a primeira vez, clonar o repositório
    if [ ! -d ".git" ]; then
        log_info "Clonando repositório..."
        sudo -u $USER git clone $REPO_URL .
    else
        log_info "Atualizando código..."
        sudo -u $USER git fetch origin
        sudo -u $USER git reset --hard origin/$BRANCH
    fi
    
    # Instalar dependências
    log_info "Instalando dependências..."
    sudo -u $USER npm ci --only=production
    
    # Executar build
    log_info "Executando build..."
    sudo -u $USER npm run build
    
    # Configurar variáveis de ambiente
    if [ "$env_mode" = "production" ]; then
        ENV_FILE=".env.production"
    else
        ENV_FILE=".env.development"
    fi
    
    if [ ! -f "$ENV_FILE" ]; then
        log_error "Arquivo $ENV_FILE não encontrado. Execute setup-database.sh primeiro"
        exit 1
    fi
    
    # Executar migrações do banco
    log_info "Executando migrações do banco..."
    sudo -u $USER npm run db:push
    
    # Configurar PM2
    log_info "Configurando PM2..."
    
    # Criar configuração PM2 específica para o ambiente
    PM2_CONFIG="ecosystem.${env_mode}.config.js"
    
    sudo -u $USER tee $PM2_CONFIG > /dev/null <<EOF
module.exports = {
  apps: [{
    name: 'famachat-${env_mode}',
    script: 'dist/index.js',
    cwd: '${APP_DIR}',
    instances: ${env_mode} === 'production' ? 'max' : 1,
    exec_mode: ${env_mode} === 'production' ? 'cluster' : 'fork',
    env: {
      NODE_ENV: '${env_mode}',
      PORT: ${port}
    },
    env_file: '${ENV_FILE}',
    error_file: '/var/log/famachat/err-${env_mode}.log',
    out_file: '/var/log/famachat/out-${env_mode}.log',
    log_file: '/var/log/famachat/combined-${env_mode}.log',
    time: true,
    autorestart: true,
    watch: ${env_mode} === 'development' ? 'true' : 'false',
    max_memory_restart: '1G',
    node_args: '--max-old-space-size=1024',
    kill_timeout: 5000,
    wait_ready: true,
    listen_timeout: 10000,
    reload_delay: 1000,
    max_restarts: 10,
    min_uptime: '10s',
    source_map_support: true,
    instance_var: 'INSTANCE_ID'
  }]
};
EOF
    
    # Parar aplicação se estiver rodando
    log_info "Parando aplicação anterior..."
    sudo -u $USER pm2 stop famachat-${env_mode} 2>/dev/null || true
    sudo -u $USER pm2 delete famachat-${env_mode} 2>/dev/null || true
    
    # Iniciar aplicação
    log_info "Iniciando aplicação..."
    sudo -u $USER pm2 start $PM2_CONFIG
    
    # Salvar configuração PM2
    sudo -u $USER pm2 save
    
    # Configurar PM2 para iniciar automaticamente
    pm2 startup systemd -u $USER --hp /home/$USER
    
    log_info "✅ Deploy do ambiente $env_mode concluído!"
    log_info "Aplicação rodando na porta $port"
}

# Função para configurar Nginx
setup_nginx() {
    log_info "🌐 Configurando Nginx..."
    
    # Configuração do Nginx
    sudo tee /etc/nginx/sites-available/famachat > /dev/null <<EOF
# Configuração Nginx para FamaChat v2.0
server {
    listen 80;
    server_name _;  # Altere para seu domínio
    
    # Logs
    access_log /var/log/nginx/famachat_access.log;
    error_log /var/log/nginx/famachat_error.log;
    
    # Tamanho máximo de upload
    client_max_body_size 10M;
    
    # Gzip compression
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
    
    # Ambiente de desenvolvimento (opcional)
    location /dev/ {
        proxy_pass http://localhost:3001/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF
    
    # Habilitar site
    sudo ln -sf /etc/nginx/sites-available/famachat /etc/nginx/sites-enabled/
    sudo rm -f /etc/nginx/sites-enabled/default
    
    # Testar configuração
    sudo nginx -t
    
    # Reiniciar Nginx
    sudo systemctl reload nginx
    
    log_info "✅ Nginx configurado com sucesso!"
}

# Função para configurar monitoramento
setup_monitoring() {
    log_info "📊 Configurando monitoramento..."
    
    # Instalar PM2 Web Monitor (opcional)
    sudo npm install -g pm2-web
    
    # Criar script de monitoramento
    sudo tee /usr/local/bin/famachat-health-check.sh > /dev/null <<EOF
#!/bin/bash

# Health check do FamaChat
# Verifica se a aplicação está respondendo

URL="http://localhost:3000/health"
LOGFILE="/var/log/famachat/health-check.log"
DATE=\$(date '+%Y-%m-%d %H:%M:%S')

# Fazer requisição
HTTP_CODE=\$(curl -s -o /dev/null -w "%{http_code}" \$URL)

if [ "\$HTTP_CODE" = "200" ]; then
    echo "[\$DATE] OK - Aplicação respondendo (HTTP \$HTTP_CODE)" >> \$LOGFILE
    exit 0
else
    echo "[\$DATE] ERROR - Aplicação não respondeu (HTTP \$HTTP_CODE)" >> \$LOGFILE
    
    # Tentar reiniciar aplicação
    echo "[\$DATE] Tentando reiniciar aplicação..." >> \$LOGFILE
    sudo -u famachat pm2 restart famachat-production
    
    exit 1
fi
EOF
    
    sudo chmod +x /usr/local/bin/famachat-health-check.sh
    
    # Configurar cron para health check a cada 5 minutos
    (sudo crontab -l 2>/dev/null; echo "*/5 * * * * /usr/local/bin/famachat-health-check.sh") | sudo crontab -
    
    log_info "✅ Monitoramento configurado!"
}

# Função principal
main() {
    case "${1:-}" in
        "production")
            deploy_app "production" 3000
            setup_nginx
            setup_monitoring
            ;;
        "development")
            deploy_app "development" 3001
            ;;
        "both")
            deploy_app "production" 3000
            deploy_app "development" 3001
            setup_nginx
            setup_monitoring
            ;;
        *)
            echo "Uso: $0 {production|development|both}"
            echo ""
            echo "Ambientes disponíveis:"
            echo "  production   - Deploy para produção (porta 3000)"
            echo "  development  - Deploy para desenvolvimento (porta 3001)"
            echo "  both         - Deploy ambos ambientes"
            exit 1
            ;;
    esac
}

main "$@"

log_info "🎉 Deploy concluído com sucesso!"
log_info ""
log_info "📋 Próximos passos:"
log_info "1. Configure SSL/HTTPS com certbot"
log_info "2. Configure as variáveis do WhatsApp/Evolution API"
log_info "3. Configure backup automatizado"
log_info "4. Configure monitoramento adicional"
log_info ""
log_info "🔗 URLs:"
log_info "• Produção: http://seu-servidor/"
log_info "• Desenvolvimento: http://seu-servidor/dev/"
log_info "• PM2 Monitor: pm2 monit"
