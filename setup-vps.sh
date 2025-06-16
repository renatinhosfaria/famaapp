#!/bin/bash

# Script de preparação do VPS para FAMA Sistema
# Execute este script uma única vez no VPS antes do primeiro deploy

set -e

echo "🔧 Configurando VPS para FAMA Sistema com Docker Swarm + Traefik"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Verificar se está rodando como root
if [[ $EUID -ne 0 ]]; then
   print_error "Este script deve ser executado como root (sudo)"
   exit 1
fi

# Atualizar sistema
print_status "Atualizando sistema..."
apt update && apt upgrade -y

# Instalar dependências básicas
print_status "Instalando dependências básicas..."
apt install -y curl wget git htop nano vim ufw fail2ban

# Instalar Docker
print_status "Instalando Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
else
    print_warning "Docker já está instalado"
fi

# Criar usuário deploy
print_status "Configurando usuário deploy..."
if ! id "deploy" &>/dev/null; then
    useradd -m -s /bin/bash deploy
    usermod -aG sudo deploy
    usermod -aG docker deploy
    
    # Configurar SSH para o usuário deploy
    mkdir -p /home/deploy/.ssh
    chmod 700 /home/deploy/.ssh
    chown deploy:deploy /home/deploy/.ssh
    
    print_warning "Configure as chaves SSH para o usuário deploy em /home/deploy/.ssh/authorized_keys"
else
    print_warning "Usuário deploy já existe"
    usermod -aG sudo deploy
    usermod -aG docker deploy
fi

# Configurar firewall
print_status "Configurando firewall..."
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 5432/tcp  # PostgreSQL para backup/acesso direto
ufw --force enable

# Inicializar Docker Swarm
print_status "Inicializando Docker Swarm..."
if ! docker info | grep -q "Swarm: active"; then
    docker swarm init
    print_status "Docker Swarm inicializado"
else
    print_warning "Docker Swarm já está ativo"
fi

# Criar redes do Swarm
print_status "Criando redes do Docker Swarm..."
docker network create --driver overlay network_public 2>/dev/null || print_warning "Rede network_public já existe"
docker network create --driver overlay network_internal 2>/dev/null || print_warning "Rede network_internal já existe"

# Criar volumes do Swarm
print_status "Criando volumes do Docker Swarm..."
docker volume create volume_swarm_postgres_data 2>/dev/null || print_warning "Volume postgres_data já existe"
docker volume create volume_swarm_postgres_backups 2>/dev/null || print_warning "Volume postgres_backups já existe"
docker volume create volume_swarm_uploads 2>/dev/null || print_warning "Volume uploads já existe"
docker volume create volume_swarm_logs 2>/dev/null || print_warning "Volume logs já existe"
docker volume create volume_swarm_certificates 2>/dev/null || print_warning "Volume certificates já existe"
docker volume create volume_swarm_traefik_logs 2>/dev/null || print_warning "Volume traefik_logs já existe"

# Criar diretórios de trabalho
print_status "Criando diretórios de trabalho..."
mkdir -p /var/www/fama-sistema
mkdir -p /var/backups/fama-sistema
mkdir -p /var/log/fama-sistema

# Configurar permissões
chown deploy:deploy /var/www/fama-sistema
chown deploy:deploy /var/backups/fama-sistema
chown deploy:deploy /var/log/fama-sistema

# Configurar logrotate
print_status "Configurando rotação de logs..."
cat > /etc/logrotate.d/fama-sistema << EOF
/var/log/fama-sistema/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    copytruncate
}
EOF

# Configurar backup automático
print_status "Configurando backup automático..."
cat > /etc/cron.d/fama-sistema-backup << EOF
# Backup diário às 2:00 AM
0 2 * * * deploy /var/www/fama-sistema/backup-script.sh >> /var/log/fama-sistema/backup.log 2>&1

# Limpeza de logs antigos às 3:00 AM
0 3 * * * root find /var/log/fama-sistema -name "*.log" -mtime +30 -delete
EOF

# Configurar monitoramento básico
print_status "Instalando ferramentas de monitoramento..."
apt install -y htop iotop nethogs

# Otimizações do sistema
print_status "Aplicando otimizações do sistema..."
cat >> /etc/sysctl.conf << EOF

# Otimizações para FAMA Sistema
net.core.somaxconn = 1024
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_keepalive_time = 600
vm.swappiness = 10
fs.file-max = 100000
EOF

# Aplicar configurações do sysctl
sysctl -p

# Configurar limites de arquivos
cat >> /etc/security/limits.conf << EOF

# Limites para usuário deploy
deploy soft nofile 65536
deploy hard nofile 65536
EOF

# Verificar se o Traefik está rodando
print_status "Verificando Traefik..."
if docker service ls | grep -q traefik; then
    print_status "Traefik já está rodando no Swarm"
else
    print_warning "Traefik não foi encontrado. Certifique-se de deployar o Traefik antes do FAMA Sistema"
fi

# Configurar monitoramento de saúde
print_status "Configurando script de monitoramento..."
cat > /usr/local/bin/check-fama-health.sh << 'EOF'
#!/bin/bash
STACK_NAME="fama-sistema"
DOMAIN="famachat.com.br"

# Verificar se os serviços estão rodando
if ! docker service ls | grep -q "${STACK_NAME}_fama-sistema"; then
    echo "$(date): ERRO - Serviço fama-sistema não está rodando" >> /var/log/fama-sistema/health.log
    exit 1
fi

# Verificar se a aplicação responde
if ! curl -f -s https://$DOMAIN/api/health > /dev/null; then
    echo "$(date): ERRO - Aplicação não está respondendo" >> /var/log/fama-sistema/health.log
    exit 1
fi

echo "$(date): OK - Sistema funcionando normalmente" >> /var/log/fama-sistema/health.log
EOF

chmod +x /usr/local/bin/check-fama-health.sh

# Adicionar monitoramento ao cron
cat >> /etc/cron.d/fama-sistema-backup << EOF

# Verificação de saúde a cada 5 minutos
*/5 * * * * deploy /usr/local/bin/check-fama-health.sh
EOF

print_status "Reiniciando serviços..."
systemctl restart cron
systemctl restart fail2ban

echo ""
echo "=================================================="
echo -e "${GREEN}✓ VPS configurado com sucesso!${NC}"
echo "=================================================="
echo "Próximos passos:"
echo "1. Configure as chaves SSH para o usuário deploy"
echo "2. Faça deploy do Traefik (se ainda não estiver rodando)"
echo "3. Copie os arquivos do projeto para /var/www/fama-sistema"
echo "4. Execute o script de deploy: ./deploy.sh production"
echo ""
echo "Informações importantes:"
echo "- Usuário: deploy"
echo "- Diretório do projeto: /var/www/fama-sistema"
echo "- Diretório de backup: /var/backups/fama-sistema"
echo "- Logs: /var/log/fama-sistema/"
echo ""
echo "Comandos úteis:"
echo "- docker service ls"
echo "- docker stack ls"
echo "- docker service logs -f fama-sistema_fama-sistema"
echo "=================================================="