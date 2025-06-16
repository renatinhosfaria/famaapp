#!/bin/bash

# Backup do banco de dados FAMA Sistema
TIMESTAMP=$(date '+%Y%m%d-%H%M%S')
DB_BACKUP_FILE="fama-database-backup-$TIMESTAMP.sql"

echo "Criando backup do banco de dados..."

if [ -n "$DATABASE_URL" ]; then
    echo "Usando DATABASE_URL para backup..."
    pg_dump "$DATABASE_URL" > "$DB_BACKUP_FILE"
    
    if [ $? -eq 0 ]; then
        echo "✓ Backup do banco criado: $DB_BACKUP_FILE"
        
        # Comprimir o backup
        gzip "$DB_BACKUP_FILE"
        echo "✓ Backup comprimido: $DB_BACKUP_FILE.gz"
        echo "✓ Tamanho: $(du -h $DB_BACKUP_FILE.gz | cut -f1)"
        
        # Mostrar primeiras linhas para validar
        echo ""
        echo "Primeiras linhas do backup:"
        zcat "$DB_BACKUP_FILE.gz" | head -10
        
    else
        echo "❌ Erro ao criar backup do banco"
        exit 1
    fi
else
    echo "❌ DATABASE_URL não encontrada"
    exit 1
fi