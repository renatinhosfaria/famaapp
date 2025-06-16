#!/bin/bash

# Configuração rápida do PostgreSQL para FamaChat
# Execute no seu VPS Ubuntu 22.04

set -e

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Gerar senhas seguras
DB_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
READONLY_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)

# Definir variáveis
DB_NAME="famachat_db"
DB_USER="famachat_user"
DB_READONLY_USER="famachat_readonly"

log_info "🗄️ Configurando PostgreSQL para FamaChat..."

# Criar diretórios necessários
sudo mkdir -p /var/www/famachat
sudo mkdir -p /var/log/famachat
sudo mkdir -p /var/lib/famachat/uploads
sudo mkdir -p /backup/famachat

# Criar usuário famachat se não existir
sudo useradd -m -s /bin/bash famachat 2>/dev/null || true
sudo usermod -aG www-data famachat

# Definir permissões
sudo chown -R famachat:www-data /var/www/famachat
sudo chown -R famachat:www-data /var/log/famachat
sudo chown -R famachat:www-data /var/lib/famachat
sudo chown famachat:www-data /backup/famachat

log_info "Criando banco de dados e usuários..."

# Executar comandos SQL
sudo -u postgres psql <<EOF
-- Criar banco de dados
CREATE DATABASE ${DB_NAME};

-- Criar usuário principal
CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASSWORD}';

-- Criar usuário readonly
CREATE USER ${DB_READONLY_USER} WITH PASSWORD '${READONLY_PASSWORD}';

-- Conceder permissões
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

\l
\q
EOF

# Criar arquivo .env para produção
ENV_FILE="/var/www/famachat/.env.production"
log_info "Criando arquivo de variáveis de ambiente..."

sudo tee $ENV_FILE > /dev/null <<EOF
# Configuração FamaChat v2.0 - Produção
# Gerado em $(date)

# PostgreSQL
DATABASE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@localhost:5432/${DB_NAME}
DB_HOST=localhost
DB_PORT=5432
DB_NAME=${DB_NAME}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}

# Aplicação
NODE_ENV=production
PORT=3000

# Segurança (ALTERE ESTAS CHAVES!)
JWT_SECRET=$(openssl rand -base64 64)
SESSION_SECRET=$(openssl rand -base64 64)

# Upload
UPLOAD_DIR=/var/lib/famachat/uploads
MAX_FILE_SIZE=10485760

# Logs
LOG_LEVEL=info
LOG_FILE=/var/log/famachat/app.log

# WhatsApp/Evolution API (CONFIGURE DEPOIS)
# EVOLUTION_API_URL=https://your-evolution-api.com
# EVOLUTION_API_KEY=your-api-key
# EVOLUTION_INSTANCE_NAME=your-instance

# OpenAI (OPCIONAL)
# OPENAI_API_KEY=your-openai-key
EOF

# Definir permissões do .env
sudo chown famachat:www-data $ENV_FILE
sudo chmod 600 $ENV_FILE

# Criar arquivo .env para desenvolvimento
DEV_ENV_FILE="/var/www/famachat/.env.development"
sudo tee $DEV_ENV_FILE > /dev/null <<EOF
# Configuração FamaChat v2.0 - Desenvolvimento

# PostgreSQL
DATABASE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@localhost:5432/${DB_NAME}

# Aplicação
NODE_ENV=development
PORT=3001

# Segurança (desenvolvimento)
JWT_SECRET=dev-jwt-secret-change-in-production
SESSION_SECRET=dev-session-secret-change-in-production

# Upload
UPLOAD_DIR=/var/lib/famachat/uploads
MAX_FILE_SIZE=10485760

# Logs verbosos
LOG_LEVEL=debug
LOG_FILE=/var/log/famachat/app-dev.log
EOF

sudo chown famachat:www-data $DEV_ENV_FILE
sudo chmod 600 $DEV_ENV_FILE

# Criar script de backup
sudo tee /usr/local/bin/backup-famachat-db.sh > /dev/null <<EOF
#!/bin/bash
DATE=\$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup/famachat"
DB_NAME="${DB_NAME}"
BACKUP_FILE="\${BACKUP_DIR}/famachat_backup_\${DATE}.sql"

mkdir -p \$BACKUP_DIR
sudo -u postgres pg_dump \$DB_NAME > \$BACKUP_FILE
gzip \$BACKUP_FILE
find \$BACKUP_DIR -name "famachat_backup_*.sql.gz" -mtime +7 -delete
echo "Backup concluído: \${BACKUP_FILE}.gz"
EOF

sudo chmod +x /usr/local/bin/backup-famachat-db.sh

# Configurar backup diário
(sudo crontab -l 2>/dev/null; echo "0 2 * * * /usr/local/bin/backup-famachat-db.sh") | sudo crontab -

log_info "✅ PostgreSQL configurado com sucesso!"
log_info ""
log_info "📋 INFORMAÇÕES:"
log_info "Database: ${DB_NAME}"
log_info "User: ${DB_USER}"
log_info "Arquivos .env criados em /var/www/famachat/"
log_info ""
log_warning "⚠️ As senhas foram geradas automaticamente e estão nos arquivos .env"
log_warning "⚠️ Configure as variáveis do WhatsApp/Evolution API depois"

echo ""
echo "Próximo passo: Fazer deploy da aplicação"
echo "1. Transfira seu código para /var/www/famachat"
echo "2. Execute: npm install && npm run build"
echo "3. Configure PM2 e Nginx"
