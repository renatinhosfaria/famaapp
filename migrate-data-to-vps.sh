#!/bin/bash

# Script para migrar dados do Neon Database para o PostgreSQL do VPS
# Execute este script ANTES do primeiro deploy

set -e

# Configurações
VPS_HOST="144.126.134.23"
VPS_USER="deploy"
POSTGRES_STACK_NAME="postgres"
DB_NAME="neondb"
DB_USER="postgres"
DB_PASSWORD="IwOLgVnyOfbN"
BACKUP_DIR="/tmp/fama-migration"

echo "🔄 Migrando dados do Neon Database para PostgreSQL do VPS"

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

# Criar diretório temporário para backup
mkdir -p $BACKUP_DIR

# Fazer dump do banco atual (Neon)
print_status "Fazendo backup do banco Neon atual..."
if command -v pg_dump &> /dev/null; then
    pg_dump "postgresql://postgres:IwOLgVnyOfbN@144.126.134.23:5432/neondb?sslmode=disable" > $BACKUP_DIR/neon_backup.sql
    print_status "Backup do Neon concluído: $BACKUP_DIR/neon_backup.sql"
else
    print_error "pg_dump não encontrado. Instale o cliente PostgreSQL:"
    echo "Ubuntu/Debian: sudo apt install postgresql-client"
    echo "macOS: brew install postgresql"
    exit 1
fi

# Verificar se conseguimos conectar no VPS
print_status "Testando conexão com VPS..."
if ! ssh -q $VPS_USER@$VPS_HOST exit; then
    print_error "Não foi possível conectar ao VPS. Verifique:"
    echo "1. SSH configurado para $VPS_USER@$VPS_HOST"
    echo "2. Chaves SSH instaladas"
    exit 1
fi

# Verificar se PostgreSQL está rodando no VPS
print_status "Verificando PostgreSQL no VPS..."
POSTGRES_RUNNING=$(ssh $VPS_USER@$VPS_HOST "docker service ls | grep postgres_postgres | wc -l")
if [ "$POSTGRES_RUNNING" -eq 0 ]; then
    print_error "PostgreSQL não está rodando no VPS"
    exit 1
fi

# Copiar backup para o VPS
print_status "Copiando backup para o VPS..."
scp $BACKUP_DIR/neon_backup.sql $VPS_USER@$VPS_HOST:/tmp/

# Executar restauração no VPS
print_status "Executando restauração no VPS..."
ssh $VPS_USER@$VPS_HOST << 'EOF'
set -e

# Verificar se o banco neondb existe, se não, criar
POSTGRES_CONTAINER=$(docker ps --filter "name=postgres_postgres" --format "{{.Names}}" | head -1)
if [ -z "$POSTGRES_CONTAINER" ]; then
    echo "ERRO: Container PostgreSQL não encontrado"
    exit 1
fi

# Verificar se banco existe
DB_EXISTS=$(docker exec $POSTGRES_CONTAINER psql -U postgres -lqt | cut -d \| -f 1 | grep -w neondb | wc -l)

if [ "$DB_EXISTS" -eq 0 ]; then
    echo "Criando banco neondb..."
    docker exec $POSTGRES_CONTAINER psql -U postgres -c "CREATE DATABASE neondb WITH ENCODING='UTF8';" || exit 1
fi

# Restaurar backup
echo "Restaurando dados..."
docker exec -i $POSTGRES_CONTAINER psql -U postgres -d neondb < /tmp/neon_backup.sql

echo "Verificando dados restaurados..."
TABLE_COUNT=$(docker exec $POSTGRES_CONTAINER psql -U postgres -d neondb -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" -t | xargs)
echo "Tabelas restauradas: $TABLE_COUNT"

# Limpar arquivo temporário
rm -f /tmp/neon_backup.sql
EOF

# Verificar migração
print_status "Verificando migração..."
TABLE_COUNT=$(ssh $VPS_USER@$VPS_HOST "docker exec \$(docker ps --filter 'name=postgres_postgres' --format '{{.Names}}' | head -1) psql -U postgres -d neondb -c \"SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';\" -t" | xargs)

print_status "Tabelas migradas: $TABLE_COUNT"

# Testar conexão com a aplicação
print_status "Testando string de conexão da aplicação..."
if psql "postgresql://postgres:IwOLgVnyOfbN@$VPS_HOST:5432/neondb?sslmode=disable" -c "SELECT COUNT(*) FROM clientes;" >/dev/null 2>&1; then
    print_status "Conexão da aplicação funcionando"
else
    print_warning "Verifique se a porta 5432 está acessível externamente"
fi

# Limpar arquivos temporários
rm -rf $BACKUP_DIR

echo ""
echo "=================================================="
echo -e "${GREEN}✓ Migração concluída com sucesso!${NC}"
echo "=================================================="
echo "Dados migrados do Neon Database para PostgreSQL do VPS"
echo "Próximo passo: executar deploy da aplicação"
echo ""
echo "Para verificar os dados no VPS:"
echo "ssh $VPS_USER@$VPS_HOST"
echo "docker exec -it \$(docker ps --filter 'name=postgres_postgres' --format '{{.Names}}' | head -1) psql -U postgres -d neondb"
echo "=================================================="