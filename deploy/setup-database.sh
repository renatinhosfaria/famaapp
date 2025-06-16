#!/bin/bash

# Script de configuração do banco de dados PostgreSQL
# Para o projeto FamaChat v2.0

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

# Função para gerar senha segura
generate_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-25
}

# Verificar se o PostgreSQL está rodando
if ! systemctl is-active --quiet postgresql; then
    log_error "PostgreSQL não está rodando. Execute: sudo systemctl start postgresql"
    exit 1
fi

log_info "🗄️  Configurando banco de dados PostgreSQL para FamaChat..."

# Gerar senhas seguras
DB_PASSWORD=$(generate_password)
READONLY_PASSWORD=$(generate_password)

# Definir variáveis
DB_NAME="famachat_db"
DB_USER="famachat_user"
DB_READONLY_USER="famachat_readonly"
DB_HOST="localhost"
DB_PORT="5432"

log_info "Criando banco de dados e usuários..."

# Executar comandos SQL como usuário postgres
sudo -u postgres psql <<EOF
-- Criar banco de dados
CREATE DATABASE ${DB_NAME};

-- Criar usuário principal
CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASSWORD}';

-- Criar usuário readonly para monitoramento
CREATE USER ${DB_READONLY_USER} WITH PASSWORD '${READONLY_PASSWORD}';

-- Conceder permissões ao usuário principal
GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} TO ${DB_USER};
ALTER USER ${DB_USER} CREATEDB;

-- Conectar ao banco e conceder permissões no schema
\c ${DB_NAME}
GRANT ALL ON SCHEMA public TO ${DB_USER};
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${DB_USER};
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ${DB_USER};
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO ${DB_USER};
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO ${DB_USER};

-- Permissões readonly
GRANT CONNECT ON DATABASE ${DB_NAME} TO ${DB_READONLY_USER};
GRANT USAGE ON SCHEMA public TO ${DB_READONLY_USER};
GRANT SELECT ON ALL TABLES IN SCHEMA public TO ${DB_READONLY_USER};
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO ${DB_READONLY_USER};

-- Mostrar bancos criados
\l
\q
EOF

log_info "✅ Banco de dados configurado com sucesso!"

# Criar arquivo de configuração de ambiente
ENV_FILE="/var/www/famachat/.env.production"
log_info "Criando arquivo de variáveis de ambiente..."

sudo tee $ENV_FILE > /dev/null <<EOF
# Configuração do Banco de Dados - FamaChat v2.0
# Gerado automaticamente em $(date)

# PostgreSQL
DATABASE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}
DB_HOST=${DB_HOST}
DB_PORT=${DB_PORT}
DB_NAME=${DB_NAME}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}

# PostgreSQL Readonly (para monitoramento)
DATABASE_READONLY_URL=postgresql://${DB_READONLY_USER}:${READONLY_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}

# Configurações da aplicação
NODE_ENV=production
PORT=3000

# JWT Secret (ALTERE ESTA CHAVE!)
JWT_SECRET=$(openssl rand -base64 64)

# Session Secret (ALTERE ESTA CHAVE!)
SESSION_SECRET=$(openssl rand -base64 64)

# Configurações de upload
UPLOAD_DIR=/var/lib/famachat/uploads
MAX_FILE_SIZE=10485760

# Configurações do WhatsApp/Evolution API
# EVOLUTION_API_URL=https://your-evolution-api.com
# EVOLUTION_API_KEY=your-api-key
# EVOLUTION_INSTANCE_NAME=your-instance

# Configurações do OpenAI (opcional)
# OPENAI_API_KEY=your-openai-key

# Configurações de email (opcional)
# SMTP_HOST=smtp.gmail.com
# SMTP_PORT=587
# SMTP_USER=your-email@gmail.com
# SMTP_PASS=your-app-password

# Logs
LOG_LEVEL=info
LOG_FILE=/var/log/famachat/app.log
EOF

# Definir permissões do arquivo .env
sudo chown famachat:www-data $ENV_FILE
sudo chmod 600 $ENV_FILE

# Criar arquivo de ambiente para desenvolvimento
DEV_ENV_FILE="/var/www/famachat/.env.development"
sudo tee $DEV_ENV_FILE > /dev/null <<EOF
# Configuração de Desenvolvimento - FamaChat v2.0

# PostgreSQL
DATABASE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}

# Configurações da aplicação
NODE_ENV=development
PORT=3001

# JWT Secret (desenvolvimento)
JWT_SECRET=dev-jwt-secret-change-in-production

# Session Secret (desenvolvimento)
SESSION_SECRET=dev-session-secret-change-in-production

# Configurações de upload
UPLOAD_DIR=/var/lib/famachat/uploads
MAX_FILE_SIZE=10485760

# Logs mais verbosos para desenvolvimento
LOG_LEVEL=debug
LOG_FILE=/var/log/famachat/app-dev.log

# Hot reload habilitado
VITE_HMR_PORT=24678
EOF

sudo chown famachat:www-data $DEV_ENV_FILE
sudo chmod 600 $DEV_ENV_FILE

# Configurar PostgreSQL para conexões locais
log_info "Configurando PostgreSQL para conexões locais..."

PG_VERSION=$(sudo -u postgres psql -t -c "SELECT version();" | grep -oP "PostgreSQL \K[0-9]+")
PG_CONFIG_DIR="/etc/postgresql/${PG_VERSION}/main"

# Backup da configuração original
sudo cp ${PG_CONFIG_DIR}/postgresql.conf ${PG_CONFIG_DIR}/postgresql.conf.backup
sudo cp ${PG_CONFIG_DIR}/pg_hba.conf ${PG_CONFIG_DIR}/pg_hba.conf.backup

# Configurar postgresql.conf para melhor performance
sudo tee -a ${PG_CONFIG_DIR}/postgresql.conf > /dev/null <<EOF

# Configurações otimizadas para FamaChat
# Adicionado em $(date)

# Conexões
max_connections = 100

# Memória
shared_buffers = 256MB
effective_cache_size = 1GB
work_mem = 4MB
maintenance_work_mem = 64MB

# Logs
log_destination = 'stderr'
logging_collector = on
log_directory = '/var/log/postgresql'
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
log_statement = 'mod'
log_min_duration_statement = 1000

# Performance
checkpoint_completion_target = 0.7
wal_buffers = 16MB
default_statistics_target = 100
EOF

# Reiniciar PostgreSQL
log_info "Reiniciando PostgreSQL..."
sudo systemctl restart postgresql

# Criar script de backup
log_info "Criando script de backup automático..."
sudo tee /usr/local/bin/backup-famachat-db.sh > /dev/null <<EOF
#!/bin/bash

# Script de backup do banco FamaChat
# Executa backup completo do banco de dados

DATE=\$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup/famachat"
DB_NAME="${DB_NAME}"
BACKUP_FILE="\${BACKUP_DIR}/famachat_backup_\${DATE}.sql"

# Criar diretório se não existir
mkdir -p \$BACKUP_DIR

# Executar backup
sudo -u postgres pg_dump \$DB_NAME > \$BACKUP_FILE

# Comprimir backup
gzip \$BACKUP_FILE

# Manter apenas backups dos últimos 7 dias
find \$BACKUP_DIR -name "famachat_backup_*.sql.gz" -mtime +7 -delete

echo "Backup concluído: \${BACKUP_FILE}.gz"
EOF

sudo chmod +x /usr/local/bin/backup-famachat-db.sh

# Configurar cron para backup diário
log_info "Configurando backup automático diário..."
(sudo crontab -l 2>/dev/null; echo "0 2 * * * /usr/local/bin/backup-famachat-db.sh") | sudo crontab -

log_info "✅ Configuração do PostgreSQL concluída!"
log_info ""
log_info "📋 INFORMAÇÕES IMPORTANTES:"
log_info "Database: ${DB_NAME}"
log_info "User: ${DB_USER}"
log_info "Host: ${DB_HOST}"
log_info "Port: ${DB_PORT}"
log_info ""
log_info "📁 Arquivos criados:"
log_info "• Produção: $ENV_FILE"
log_info "• Desenvolvimento: $DEV_ENV_FILE"
log_info "• Script backup: /usr/local/bin/backup-famachat-db.sh"
log_info ""
log_warning "⚠️  As senhas foram geradas automaticamente e estão nos arquivos .env"
log_warning "⚠️  Configure as variáveis do WhatsApp/Evolution API nos arquivos .env"
log_warning "⚠️  Backup automático configurado para executar diariamente às 2:00"
