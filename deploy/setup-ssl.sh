#!/bin/bash

# Script de configuração SSL/HTTPS com Let's Encrypt
# Para FamaChat v2.0

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Verificar se o domínio foi fornecido
if [ -z "$1" ]; then
    log_error "Uso: $0 <seu-dominio.com>"
    log_error "Exemplo: $0 famachat.seusite.com"
    exit 1
fi

DOMAIN=$1

log_info "🔒 Configurando SSL/HTTPS para o domínio: $DOMAIN"

# Verificar se o Nginx está rodando
if ! systemctl is-active --quiet nginx; then
    log_error "Nginx não está rodando. Execute: sudo systemctl start nginx"
    exit 1
fi

# Instalar Certbot
log_info "Instalando Certbot..."
sudo apt update
sudo apt install -y certbot python3-certbot-nginx

# Verificar se o domínio está apontando para o servidor
log_info "Verificando DNS do domínio..."
DOMAIN_IP=$(dig +short $DOMAIN 2>/dev/null || echo "")
SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || echo "")

if [ "$DOMAIN_IP" != "$SERVER_IP" ]; then
    log_warning "⚠️  O domínio $DOMAIN pode não estar apontando para este servidor"
    log_warning "DNS aponta para: $DOMAIN_IP"
    log_warning "IP do servidor: $SERVER_IP"
    log_warning "Continue apenas se tiver certeza da configuração DNS"
    
    read -p "Deseja continuar? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_error "Configuração SSL cancelada"
        exit 1
    fi
fi

# Atualizar configuração do Nginx com o domínio
log_info "Atualizando configuração do Nginx..."
sudo tee /etc/nginx/sites-available/famachat > /dev/null <<EOF
# Configuração Nginx para FamaChat v2.0 com SSL
server {
    listen 80;
    server_name ${DOMAIN};
    
    # Redirecionamento para HTTPS será configurado pelo Certbot
    
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

# Testar configuração do Nginx
log_info "Testando configuração do Nginx..."
sudo nginx -t

# Recarregar Nginx
sudo systemctl reload nginx

# Obter certificado SSL
log_info "Obtendo certificado SSL..."
sudo certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN

# Verificar se o certificado foi obtido com sucesso
if [ $? -eq 0 ]; then
    log_info "✅ Certificado SSL obtido com sucesso!"
else
    log_error "❌ Falha ao obter certificado SSL"
    exit 1
fi

# Configurar renovação automática
log_info "Configurando renovação automática..."
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer

# Testar renovação
log_info "Testando renovação automática..."
sudo certbot renew --dry-run

# Adicionar job cron adicional (backup)
(sudo crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | sudo crontab -

# Configurar headers de segurança adicionais
log_info "Configurando headers de segurança..."
sudo tee /etc/nginx/conf.d/security-headers.conf > /dev/null <<EOF
# Headers de segurança para FamaChat
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "no-referrer-when-downgrade" always;
add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
EOF

# Recarregar Nginx novamente
sudo nginx -t && sudo systemctl reload nginx

# Verificar se HTTPS está funcionando
log_info "Verificando HTTPS..."
sleep 5

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://$DOMAIN/health || echo "000")
if [ "$HTTP_CODE" = "200" ]; then
    log_info "✅ HTTPS está funcionando corretamente!"
else
    log_warning "⚠️  HTTPS pode não estar funcionando (HTTP $HTTP_CODE)"
fi

# Criar script de monitoramento SSL
log_info "Criando script de monitoramento SSL..."
sudo tee /usr/local/bin/ssl-check.sh > /dev/null <<EOF
#!/bin/bash

# Script de verificação SSL para FamaChat
DOMAIN="$DOMAIN"
LOGFILE="/var/log/famachat/ssl-check.log"
DATE=\$(date '+%Y-%m-%d %H:%M:%S')

# Verificar expiração do certificado
EXPIRY=\$(echo | openssl s_client -servername \$DOMAIN -connect \$DOMAIN:443 2>/dev/null | openssl x509 -noout -dates | grep notAfter | cut -d= -f2)
EXPIRY_TIMESTAMP=\$(date -d "\$EXPIRY" +%s)
CURRENT_TIMESTAMP=\$(date +%s)
DAYS_UNTIL_EXPIRY=\$(( (\$EXPIRY_TIMESTAMP - \$CURRENT_TIMESTAMP) / 86400 ))

echo "[\$DATE] Certificado SSL expira em \$DAYS_UNTIL_EXPIRY dias" >> \$LOGFILE

# Alertar se menos de 30 dias
if [ \$DAYS_UNTIL_EXPIRY -lt 30 ]; then
    echo "[\$DATE] ALERTA: Certificado SSL expira em \$DAYS_UNTIL_EXPIRY dias!" >> \$LOGFILE
    # Aqui você pode adicionar notificação por email se configurado
fi

# Verificar se HTTPS está respondendo
HTTP_CODE=\$(curl -s -o /dev/null -w "%{http_code}" https://\$DOMAIN/health)
if [ "\$HTTP_CODE" = "200" ]; then
    echo "[\$DATE] HTTPS funcionando corretamente" >> \$LOGFILE
else
    echo "[\$DATE] ERRO: HTTPS não está respondendo (HTTP \$HTTP_CODE)" >> \$LOGFILE
fi
EOF

sudo chmod +x /usr/local/bin/ssl-check.sh

# Configurar verificação SSL diária
(sudo crontab -l 2>/dev/null; echo "0 6 * * * /usr/local/bin/ssl-check.sh") | sudo crontab -

log_info "✅ Configuração SSL concluída com sucesso!"
log_info ""
log_info "📋 INFORMAÇÕES DO SSL:"
log_info "• Domínio: $DOMAIN"
log_info "• Certificado: Let's Encrypt"
log_info "• Renovação: Automática"
log_info "• Monitoramento: Diário às 6:00"
log_info ""
log_info "🌐 URLs disponíveis:"
log_info "• HTTPS: https://$DOMAIN"
log_info "• HTTP (redirecionado): http://$DOMAIN"
log_info ""
log_info "📁 Arquivos importantes:"
log_info "• Certificados: /etc/letsencrypt/live/$DOMAIN/"
log_info "• Logs SSL: /var/log/famachat/ssl-check.log"
log_info "• Config Nginx: /etc/nginx/sites-available/famachat"
log_info ""
log_warning "⚠️  Comandos úteis:"
log_warning "• Verificar certificado: sudo certbot certificates"
log_warning "• Renovar manualmente: sudo certbot renew"
log_warning "• Status renovação: sudo systemctl status certbot.timer"
log_warning "• Testar SSL: curl -I https://$DOMAIN"
