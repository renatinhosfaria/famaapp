#!/bin/bash

# Script de backup do projeto FAMA Sistema
# Data: $(date '+%Y-%m-%d %H:%M:%S')

BACKUP_DIR="backup-$(date '+%Y%m%d-%H%M%S')"
PROJECT_ROOT="."

echo "Criando backup do projeto FAMA Sistema..."
echo "Diretório de backup: $BACKUP_DIR"

# Criar diretório de backup
mkdir -p "$BACKUP_DIR"

# Função para copiar arquivos, excluindo node_modules e outros desnecessários
copy_project_files() {
    echo "Copiando arquivos do projeto..."
    
    # Copiar arquivos de configuração principais
    cp -r client "$BACKUP_DIR/" 2>/dev/null || echo "Aviso: client não encontrado"
    cp -r server "$BACKUP_DIR/" 2>/dev/null || echo "Aviso: server não encontrado"
    cp -r shared "$BACKUP_DIR/" 2>/dev/null || echo "Aviso: shared não encontrado"
    
    # Copiar arquivos de configuração
    cp package*.json "$BACKUP_DIR/" 2>/dev/null
    cp tsconfig.json "$BACKUP_DIR/" 2>/dev/null
    cp vite.config.ts "$BACKUP_DIR/" 2>/dev/null
    cp tailwind.config.ts "$BACKUP_DIR/" 2>/dev/null
    cp drizzle.config.ts "$BACKUP_DIR/" 2>/dev/null
    cp postcss.config.js "$BACKUP_DIR/" 2>/dev/null
    cp ecosystem.config.js "$BACKUP_DIR/" 2>/dev/null
    cp vitest.config.ts "$BACKUP_DIR/" 2>/dev/null
    
    # Copiar arquivos de deploy
    cp docker-compose.yml "$BACKUP_DIR/" 2>/dev/null
    cp Dockerfile "$BACKUP_DIR/" 2>/dev/null
    cp deploy.sh "$BACKUP_DIR/" 2>/dev/null
    cp *.conf "$BACKUP_DIR/" 2>/dev/null
    cp *.md "$BACKUP_DIR/" 2>/dev/null
    
    # Copiar scripts
    cp *.sh "$BACKUP_DIR/" 2>/dev/null
    
    echo "Arquivos do projeto copiados com sucesso!"
}

# Função para fazer backup do banco de dados
backup_database() {
    echo "Fazendo backup do banco de dados..."
    
    if [ -n "$DATABASE_URL" ]; then
        # Extrair informações da URL do banco
        DB_URL=$DATABASE_URL
        TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
        BACKUP_FILE="$BACKUP_DIR/database_backup_$TIMESTAMP.sql"
        
        # Fazer dump do banco usando a URL completa
        pg_dump "$DB_URL" > "$BACKUP_FILE" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo "Backup do banco de dados criado: $BACKUP_FILE"
            # Comprimir o backup do banco
            gzip "$BACKUP_FILE"
            echo "Backup do banco comprimido: $BACKUP_FILE.gz"
        else
            echo "Erro ao fazer backup do banco de dados. Tentando método alternativo..."
            
            # Método alternativo usando variáveis individuais se disponíveis
            if [ -n "$PGHOST" ] && [ -n "$PGDATABASE" ] && [ -n "$PGUSER" ]; then
                PGPASSWORD=$PGPASSWORD pg_dump -h $PGHOST -p ${PGPORT:-5432} -U $PGUSER -d $PGDATABASE > "$BACKUP_FILE" 2>/dev/null
                
                if [ $? -eq 0 ]; then
                    echo "Backup do banco de dados criado (método alternativo): $BACKUP_FILE"
                    gzip "$BACKUP_FILE"
                    echo "Backup do banco comprimido: $BACKUP_FILE.gz"
                else
                    echo "Aviso: Não foi possível fazer backup do banco de dados"
                fi
            else
                echo "Aviso: Variáveis do banco não encontradas, pulando backup do BD"
            fi
        fi
    else
        echo "Aviso: DATABASE_URL não encontrada, pulando backup do banco"
    fi
}

# Função para criar arquivo de informações do sistema
create_system_info() {
    echo "Criando informações do sistema..."
    
    INFO_FILE="$BACKUP_DIR/system_info.txt"
    
    cat > "$INFO_FILE" << EOF
BACKUP DO PROJETO FAMA SISTEMA
==============================
Data do backup: $(date '+%Y-%m-%d %H:%M:%S')
Usuário: $(whoami)
Sistema: $(uname -a)
Diretório: $(pwd)

INFORMAÇÕES DO NODE.JS:
Node.js: $(node --version 2>/dev/null || echo "Não instalado")
NPM: $(npm --version 2>/dev/null || echo "Não instalado")

INFORMAÇÕES DO PROJETO:
EOF
    
    if [ -f "package.json" ]; then
        echo "Package.json encontrado:" >> "$INFO_FILE"
        echo "Nome: $(grep '"name"' package.json | cut -d'"' -f4)" >> "$INFO_FILE"
        echo "Versão: $(grep '"version"' package.json | cut -d'"' -f4)" >> "$INFO_FILE"
        echo "" >> "$INFO_FILE"
    fi
    
    echo "ESTRUTURA DE ARQUIVOS:" >> "$INFO_FILE"
    find . -type f -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.json" | grep -v node_modules | sort >> "$INFO_FILE"
    
    echo "Arquivo de informações criado: $INFO_FILE"
}

# Função para comprimir o backup
compress_backup() {
    echo "Comprimindo backup..."
    tar -czf "$BACKUP_DIR.tar.gz" "$BACKUP_DIR"
    
    if [ $? -eq 0 ]; then
        echo "Backup comprimido criado: $BACKUP_DIR.tar.gz"
        # Remover diretório descomprimido
        rm -rf "$BACKUP_DIR"
        echo "Diretório temporário removido"
    else
        echo "Erro ao comprimir backup"
    fi
}

# Executar funções de backup
copy_project_files
backup_database
create_system_info
compress_backup

echo ""
echo "=========================================="
echo "BACKUP CONCLUÍDO COM SUCESSO!"
echo "=========================================="
echo "Arquivo de backup: $BACKUP_DIR.tar.gz"
echo "Data: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""
echo "Para restaurar o backup:"
echo "1. Extrair: tar -xzf $BACKUP_DIR.tar.gz"
echo "2. Instalar dependências: npm install"
echo "3. Restaurar banco (se necessário): psql \$DATABASE_URL < database_backup_*.sql"
echo "=========================================="