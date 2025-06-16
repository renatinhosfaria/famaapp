#!/bin/bash

# Backup rápido do projeto FAMA Sistema
BACKUP_DIR="fama-backup-$(date '+%Y%m%d-%H%M%S')"

echo "Criando backup do projeto..."
mkdir -p "$BACKUP_DIR"

# Copiar código fonte
echo "Copiando código fonte..."
cp -r client "$BACKUP_DIR/"
cp -r server "$BACKUP_DIR/"
cp -r shared "$BACKUP_DIR/"

# Copiar configurações
echo "Copiando arquivos de configuração..."
cp package*.json "$BACKUP_DIR/" 2>/dev/null
cp tsconfig.json "$BACKUP_DIR/" 2>/dev/null
cp vite.config.ts "$BACKUP_DIR/" 2>/dev/null
cp tailwind.config.ts "$BACKUP_DIR/" 2>/dev/null
cp drizzle.config.ts "$BACKUP_DIR/" 2>/dev/null
cp postcss.config.js "$BACKUP_DIR/" 2>/dev/null
cp ecosystem.config.js "$BACKUP_DIR/" 2>/dev/null
cp vitest.config.ts "$BACKUP_DIR/" 2>/dev/null

# Copiar arquivos de deploy
echo "Copiando arquivos de deploy..."
cp docker-compose.yml "$BACKUP_DIR/" 2>/dev/null
cp Dockerfile "$BACKUP_DIR/" 2>/dev/null
cp deploy.sh "$BACKUP_DIR/" 2>/dev/null
cp nginx-fama-sistema.conf "$BACKUP_DIR/" 2>/dev/null
cp *.md "$BACKUP_DIR/" 2>/dev/null

# Criar informações do backup
cat > "$BACKUP_DIR/backup-info.txt" << EOF
BACKUP FAMA SISTEMA
==================
Data: $(date '+%Y-%m-%d %H:%M:%S')
Diretório original: $(pwd)

ARQUIVOS INCLUÍDOS:
- Código fonte completo (client, server, shared)
- Arquivos de configuração
- Scripts de deploy
- Documentação

PARA RESTAURAR:
1. Extrair arquivos
2. npm install
3. Configurar variáveis de ambiente
4. npm run dev
EOF

# Comprimir
echo "Comprimindo backup..."
tar -czf "$BACKUP_DIR.tar.gz" "$BACKUP_DIR"
rm -rf "$BACKUP_DIR"

echo ""
echo "✓ Backup criado: $BACKUP_DIR.tar.gz"
echo "✓ Tamanho: $(du -h $BACKUP_DIR.tar.gz | cut -f1)"
echo ""