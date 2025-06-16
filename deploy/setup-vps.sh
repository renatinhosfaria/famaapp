#!/bin/bash

# Script de configuração inicial do VPS para FamaChat v2.0
# Autor: Setup automático para Ubuntu 22.04
# Data: $(date)

set -e  # Para na primeira falha

echo "🚀 Iniciando configuração do servidor VPS para FamaChat v2.0..."

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 1. Atualização do sistema
log_info "Atualizando sistema..."
sudo apt update && sudo apt upgrade -y

# 2. Verificar dependências já instaladas
log_info "Verificando dependências já instaladas..."

# Verificar se Node.js está instalado
if command -v node >/dev/null 2>&1; then
    node_version=$(node --version)
    npm_version=$(npm --version)
    log_info "Node.js já instalado: $node_version"
    log_info "NPM já instalado: $npm_version"
else
    log_info "Instalando Node.js 20 LTS..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt install -y nodejs
fi

# Verificar se PostgreSQL está instalado
if command -v psql >/dev/null 2>&1; then
    pg_version=$(sudo -u postgres psql -t -c "SELECT version();" | head -n1 | awk '{print $2}')
    log_info "PostgreSQL já instalado: $pg_version"
    sudo systemctl start postgresql
    sudo systemctl enable postgresql
else
    log_info "Instalando PostgreSQL..."
    sudo apt install -y postgresql postgresql-contrib
    sudo systemctl start postgresql
    sudo systemctl enable postgresql
fi

# Verificar se PM2 está instalado
if command -v pm2 >/dev/null 2>&1; then
    pm2_version=$(pm2 --version)
    log_info "PM2 já instalado: $pm2_version"
else
    log_info "Instalando PM2..."
    sudo npm install -g pm2
fi

# Instalar dependências que podem estar faltando
log_info "Instalando dependências complementares..."
sudo apt install -y curl wget git unzip software-properties-common apt-transport-https ca-certificates gnupg lsb-release htop iotop nethogs

# 6. Instalação do Nginx
log_info "Instalando Nginx..."
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# 7. Configuração de usuário para aplicação
log_info "Criando usuário para aplicação..."
sudo useradd -m -s /bin/bash famachat || log_warning "Usuário famachat já existe"
sudo usermod -aG www-data famachat

# 8. Criação de diretórios
log_info "Criando estrutura de diretórios..."
sudo mkdir -p /var/www/famachat
sudo mkdir -p /var/log/famachat
sudo mkdir -p /var/lib/famachat/uploads
sudo mkdir -p /etc/famachat

# Definir permissões
sudo chown -R famachat:www-data /var/www/famachat
sudo chown -R famachat:www-data /var/log/famachat
sudo chown -R famachat:www-data /var/lib/famachat
sudo chmod -R 755 /var/www/famachat
sudo chmod -R 755 /var/lib/famachat

# 9. Configuração do firewall (melhorada)
log_info "Configurando firewall..."

# Definir regras antes de habilitar para evitar bloqueio SSH
sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Permitir SSH primeiro (crítico)
sudo ufw allow ssh
sudo ufw allow 22/tcp

# Permitir serviços web
sudo ufw allow 'Nginx Full'
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Permitir aplicação (temporário para desenvolvimento)
sudo ufw allow 3000/tcp
sudo ufw allow 3001/tcp

# PostgreSQL (apenas se necessário acesso externo - normalmente não recomendado)
# sudo ufw allow from 192.168.0.0/16 to any port 5432

# Habilitar firewall
sudo ufw --force enable

# Mostrar status
sudo ufw status verbose

# 10. Instalação do Docker (opcional para containers de desenvolvimento)
log_info "Instalando Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER
sudo usermod -aG docker famachat

# 11. Configuração de logs do sistema
log_info "Configurando rotação de logs..."
sudo tee /etc/logrotate.d/famachat > /dev/null <<EOF
/var/log/famachat/*.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 644 famachat www-data
    postrotate
        systemctl reload nginx > /dev/null 2>&1 || true
    endscript
}
EOF

# 12. Configuração de monitoramento básico
log_info "Instalando ferramentas de monitoramento..."
sudo apt install -y htop iotop nethogs

# 13. Configuração de backup automático
sudo mkdir -p /backup/famachat
sudo chown famachat:www-data /backup/famachat

log_info "✅ Configuração inicial concluída!"
log_info "Próximos passos:"
log_info "1. Configure o banco de dados PostgreSQL"
log_info "2. Clone o repositório do projeto"
log_info "3. Configure as variáveis de ambiente"
log_info "4. Execute o deploy da aplicação"

log_warning "⚠️  Reinicie o servidor para garantir que todas as configurações sejam aplicadas"
log_warning "⚠️  Configure SSL/HTTPS antes do deploy em produção"
