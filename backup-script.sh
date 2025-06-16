#!/bin/bash

# Script de backup automático para FAMA Sistema (Docker Swarm)
# Configurar no crontab: 0 2 * * * /var/www/fama-sistema/backup-script.sh

set -e

PROJECT_DIR="/var/www/fama-sistema"
BACKUP_DIR="/var/backups/fama-sistema"
DATE=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=30
STACK_NAME="fama-sistema"

# Criar diretório de backup
mkdir -p $BACKUP_DIR

echo "Iniciando backup do FAMA Sistema - $(date)"

# Backup do banco de dados (PostgreSQL externo)
echo "Fazendo backup do banco de dados..."
POSTGRES_CONTAINER=$(docker ps --filter "name=postgres_postgres" --format "{{.Names}}" | head -1)
if [ ! -z "$POSTGRES_CONTAINER" ]; then
    docker exec $POSTGRES_CONTAINER pg_dump -U postgres neondb | gzip > $BACKUP_DIR/db_backup_$DATE.sql.gz
    echo "Backup do banco concluído: db_backup_$DATE.sql.gz"
else
    echo "ERRO: Container PostgreSQL não encontrado"
    exit 1
fi

# Backup dos volumes do Swarm
echo "Fazendo backup dos volumes..."

# Backup do volume de uploads
docker run --rm -v volume_swarm_uploads:/volume -v $BACKUP_DIR:/backup alpine tar -czf /backup/uploads_backup_$DATE.tar.gz -C /volume .
echo "Backup dos uploads concluído: uploads_backup_$DATE.tar.gz"

# Backup dos logs
docker run --rm -v volume_swarm_logs:/volume -v $BACKUP_DIR:/backup alpine tar -czf /backup/logs_backup_$DATE.tar.gz -C /volume .
echo "Backup dos logs concluído: logs_backup_$DATE.tar.gz"

# Backup das configurações
echo "Fazendo backup das configurações..."
if [ -d "$PROJECT_DIR" ]; then
    tar -czf $BACKUP_DIR/config_backup_$DATE.tar.gz -C $PROJECT_DIR .env.production docker-compose.yml Dockerfile deploy.sh 2>/dev/null || true
    echo "Backup das configurações concluído: config_backup_$DATE.tar.gz"
fi

# Backup dos certificados SSL (se existirem)
echo "Fazendo backup dos certificados SSL..."
docker run --rm -v volume_swarm_certificates:/volume -v $BACKUP_DIR:/backup alpine tar -czf /backup/certificates_backup_$DATE.tar.gz -C /volume . 2>/dev/null || echo "Nenhum certificado encontrado"

# Criar arquivo de metadados do backup
cat > $BACKUP_DIR/backup_metadata_$DATE.txt << EOF
Backup FAMA Sistema - $(date)
========================================
Data: $DATE
Stack: $STACK_NAME
Versão Docker: $(docker --version)
Status dos serviços:
$(docker service ls --filter "name=${STACK_NAME}" --format "table {{.Name}}\t{{.Replicas}}\t{{.Image}}")

Arquivos incluídos:
- db_backup_$DATE.sql.gz (Banco PostgreSQL)
- uploads_backup_$DATE.tar.gz (Arquivos enviados)
- logs_backup_$DATE.tar.gz (Logs da aplicação)
- config_backup_$DATE.tar.gz (Configurações)
- certificates_backup_$DATE.tar.gz (Certificados SSL)

Para restaurar:
1. Restaurar banco: zcat db_backup_$DATE.sql.gz | docker exec -i CONTAINER_POSTGRES psql -U postgres neondb
2. Restaurar uploads: tar -xzf uploads_backup_$DATE.tar.gz -C /caminho/uploads/
3. Restaurar configurações: tar -xzf config_backup_$DATE.tar.gz -C /var/www/fama-sistema/
EOF

# Verificar tamanhos dos backups
echo "Verificando tamanhos dos backups..."
du -h $BACKUP_DIR/*_$DATE.* 2>/dev/null | while read size file; do
    echo "  $file: $size"
done

# Remover backups antigos
echo "Removendo backups antigos (mais de $RETENTION_DAYS dias)..."
find $BACKUP_DIR -name "*backup_*.gz" -mtime +$RETENTION_DAYS -delete
find $BACKUP_DIR -name "*backup_*.txt" -mtime +$RETENTION_DAYS -delete

# Verificar espaço em disco
DISK_USAGE=$(df $BACKUP_DIR | tail -1 | awk '{print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt 85 ]; then
    echo "AVISO: Disco com mais de 85% de uso ($DISK_USAGE%)"
fi

# Log do backup
echo "Backup concluído com sucesso em: $(date)" >> $BACKUP_DIR/backup.log
echo "Arquivos salvos em: $BACKUP_DIR"
echo "Retenção: $RETENTION_DAYS dias"

echo "Backup concluído com sucesso!"