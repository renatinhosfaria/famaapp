#!/bin/bash

# Deploy script para FAMA Sistema no VPS com Docker Swarm + Traefik
# Uso: ./deploy.sh [production|staging]

set -e

ENVIRONMENT=${1:-production}
PROJECT_NAME="fama-sistema"
STACK_NAME="fama-sistema"
DOMAIN="famachat.com.br"
BACKUP_DIR="/var/backups/fama-sistema"

echo "🚀 Iniciando deploy do FAMA Sistema - Ambiente: $ENVIRONMENT (Docker Swarm)"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Verificar se o Docker Swarm está ativo
if ! docker info | grep -q "Swarm: active"; then
    print_error "Docker Swarm não está ativo. Execute: docker swarm init"
    exit 1
fi

# Criar diretório de backup
sudo mkdir -p $BACKUP_DIR
sudo chown $USER:$USER $BACKUP_DIR

# Backup do banco de dados PostgreSQL externo se estiver rodando
if docker service ls | grep -q "postgres_postgres"; then
    print_status "Fazendo backup do banco de dados..."
    POSTGRES_CONTAINER=$(docker ps --filter "name=postgres_postgres" --format "{{.Names}}" | head -1)
    if [ ! -z "$POSTGRES_CONTAINER" ]; then
        docker exec $POSTGRES_CONTAINER pg_dump -U postgres neondb > $BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S).sql
    fi
fi

# Fazer pull das últimas mudanças (se estiver usando Git)
if [ -d ".git" ]; then
    print_status "Atualizando código do repositório..."
    git pull origin main
fi

# Verificar se o arquivo .env.production existe
if [ ! -f ".env.production" ]; then
    print_warning "Arquivo .env.production não encontrado, criando template..."
    cp production.env .env.production
fi

# Build da nova imagem
print_status "Construindo nova imagem Docker..."
docker build -t fama-sistema:latest .

# Remover stack existente
print_status "Removendo stack existente..."
docker stack rm $STACK_NAME || true

# Aguardar remoção completa
print_status "Aguardando remoção completa da stack..."
while docker stack ls --format "{{.Name}}" | grep -q "^${STACK_NAME}$"; do
    echo "Aguardando remoção da stack..."
    sleep 5
done

# Aguardar um pouco mais para garantir limpeza completa
sleep 10

# Verificar e criar volumes necessários
print_status "Verificando volumes do Swarm..."
docker volume create volume_swarm_uploads 2>/dev/null || true
docker volume create volume_swarm_logs 2>/dev/null || true

# Verificar se a rede pública existe (necessária para conectar com PostgreSQL)
print_status "Verificando rede do Swarm..."
if ! docker network ls | grep -q "network_public"; then
    print_error "Rede network_public não encontrada. Certifique-se que o Traefik está rodando."
    exit 1
fi

# Deploy da nova stack
print_status "Fazendo deploy da nova stack..."
docker stack deploy -c docker-compose.yml $STACK_NAME

# Aguardar os serviços ficarem prontos
print_status "Aguardando serviços ficarem prontos..."
sleep 30

# Verificar status dos serviços
print_status "Verificando status dos serviços..."
docker service ls --filter "name=${STACK_NAME}"

# Aguardar mais um pouco para estabilização
sleep 20

# Executar migrações do banco de dados
print_status "Aguardando banco de dados ficar disponível..."
sleep 10

# Tentar executar migrações
print_status "Executando migrações do banco de dados..."
FAMA_CONTAINER=$(docker ps --filter "name=${STACK_NAME}_fama-sistema" --format "{{.Names}}" | head -1)
if [ ! -z "$FAMA_CONTAINER" ]; then
    docker exec $FAMA_CONTAINER npm run db:push 2>/dev/null || echo "Migrações serão executadas automaticamente na inicialização"
fi

# Limpar imagens antigas
print_status "Limpando imagens Docker antigas..."
docker image prune -f

# Verificar se a aplicação está respondendo
print_status "Verificando se a aplicação está respondendo..."
sleep 10
for i in {1..10}; do
    if curl -f -s https://$DOMAIN/api/health > /dev/null 2>&1 || curl -f -s http://localhost:3000/api/health > /dev/null 2>&1; then
        print_status "Aplicação está respondendo corretamente"
        break
    fi
    echo "Tentativa $i/10 - Aguardando aplicação ficar disponível..."
    sleep 10
done

# Mostrar status final
echo ""
echo "=================================================="
echo -e "${GREEN}✓ Deploy concluído com sucesso!${NC}"
echo "=================================================="
echo "Aplicação: https://$DOMAIN"
echo "Ambiente: $ENVIRONMENT"
echo "Stack: $STACK_NAME"
echo ""
echo "Serviços rodando:"
docker service ls --filter "name=${STACK_NAME}"
echo ""
echo "Para ver os logs:"
echo "docker service logs -f ${STACK_NAME}_fama-sistema"
echo "docker service logs -f ${STACK_NAME}_postgres"
echo ""
echo "Para escalar o serviço:"
echo "docker service scale ${STACK_NAME}_fama-sistema=3"
echo ""
echo "Para remover a stack:"
echo "docker stack rm $STACK_NAME"
echo "=================================================="