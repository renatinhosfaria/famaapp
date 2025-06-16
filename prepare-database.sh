#!/bin/bash

# Script para preparar o banco PostgreSQL existente para o FAMA Sistema
# Execute este script após o primeiro deploy para criar o banco neondb

set -e

POSTGRES_STACK_NAME="postgres"
POSTGRES_SERVICE_NAME="${POSTGRES_STACK_NAME}_postgres"
DB_NAME="neondb"
DB_USER="postgres"
DB_PASSWORD="IwOLgVnyOfbN"

echo "🗃️ Preparando banco PostgreSQL para FAMA Sistema"

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

# Verificar se o PostgreSQL está rodando
print_status "Verificando se PostgreSQL está rodando..."
if ! docker service ls | grep -q "$POSTGRES_SERVICE_NAME"; then
    print_error "Serviço PostgreSQL não encontrado. Certifique-se que o stack postgres está rodando."
    exit 1
fi

# Aguardar PostgreSQL ficar disponível
print_status "Aguardando PostgreSQL ficar disponível..."
for i in {1..30}; do
    POSTGRES_CONTAINER=$(docker ps --filter "name=${POSTGRES_SERVICE_NAME}" --format "{{.Names}}" | head -1)
    if [ ! -z "$POSTGRES_CONTAINER" ]; then
        if docker exec $POSTGRES_CONTAINER pg_isready -U $DB_USER >/dev/null 2>&1; then
            print_status "PostgreSQL está disponível"
            break
        fi
    fi
    echo "Aguardando PostgreSQL... ($i/30)"
    sleep 2
done

if [ -z "$POSTGRES_CONTAINER" ]; then
    print_error "Container PostgreSQL não encontrado"
    exit 1
fi

# Verificar se o banco neondb já existe
print_status "Verificando se banco neondb existe..."
DB_EXISTS=$(docker exec $POSTGRES_CONTAINER psql -U $DB_USER -lqt | cut -d \| -f 1 | grep -w $DB_NAME | wc -l)

if [ "$DB_EXISTS" -eq 0 ]; then
    print_status "Criando banco de dados neondb..."
    docker exec $POSTGRES_CONTAINER psql -U $DB_USER -c "CREATE DATABASE $DB_NAME WITH ENCODING='UTF8' LC_COLLATE='pt_BR.UTF-8' LC_CTYPE='pt_BR.UTF-8';" || {
        print_warning "Erro ao definir locale pt_BR.UTF-8, criando com locale padrão..."
        docker exec $POSTGRES_CONTAINER psql -U $DB_USER -c "CREATE DATABASE $DB_NAME WITH ENCODING='UTF8';"
    }
    print_status "Banco neondb criado com sucesso"
else
    print_warning "Banco neondb já existe"
fi

# Verificar conexão com o banco neondb
print_status "Testando conexão com banco neondb..."
if docker exec $POSTGRES_CONTAINER psql -U $DB_USER -d $DB_NAME -c "SELECT version();" >/dev/null 2>&1; then
    print_status "Conexão com neondb estabelecida"
else
    print_error "Erro ao conectar com banco neondb"
    exit 1
fi

# Listar bancos existentes
print_status "Bancos disponíveis:"
docker exec $POSTGRES_CONTAINER psql -U $DB_USER -l

echo ""
echo "=================================================="
echo -e "${GREEN}✓ Banco PostgreSQL preparado com sucesso!${NC}"
echo "=================================================="
echo "Banco: $DB_NAME"
echo "Usuário: $DB_USER"
echo "Host: tasks.${POSTGRES_SERVICE_NAME} (dentro do Swarm)"
echo "Porta: 5432"
echo ""
echo "String de conexão para aplicação:"
echo "postgresql://$DB_USER:$DB_PASSWORD@tasks.${POSTGRES_SERVICE_NAME}:5432/$DB_NAME"
echo "=================================================="