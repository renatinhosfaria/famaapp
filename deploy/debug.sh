#!/bin/bash

# Script de debug e diagnóstico para FamaChat v2.0
# Coleta informações do sistema para debug

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

log_debug() {
    echo -e "${BLUE}[DEBUG]${NC} $1"
}

# Header
echo "================================================"
echo "🔍 FamaChat v2.0 - Script de Debug e Diagnóstico"
echo "$(date)"
echo "================================================"
echo ""

# Função para verificar status de serviços
check_service_status() {
    local service=$1
    if systemctl is-active --quiet $service; then
        log_info "$service está rodando ✅"
    else
        log_error "$service não está rodando ❌"
        systemctl status $service --no-pager -l || true
    fi
    echo ""
}

# Função para verificar portas
check_port() {
    local port=$1
    local service=$2
    if netstat -tuln | grep -q ":$port "; then
        log_info "Porta $port ($service) está em uso ✅"
    else
        log_warning "Porta $port ($service) não está em uso ⚠️"
    fi
}

# Função para verificar logs
check_logs() {
    local logfile=$1
    local lines=${2:-20}
    
    if [ -f "$logfile" ]; then
        log_info "📄 Últimas $lines linhas de $logfile:"
        echo "----------------------------------------"
        tail -n $lines "$logfile" 2>/dev/null || log_warning "Erro ao ler $logfile"
        echo "----------------------------------------"
    else
        log_warning "Arquivo de log $logfile não encontrado"
    fi
    echo ""
}

# 1. Informações do sistema
log_info "🖥️  INFORMAÇÕES DO SISTEMA"
echo "OS: $(lsb_release -d | cut -f2)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo "CPU: $(nproc) cores"
echo "Memória Total: $(free -h | awk '/^Mem:/ { print $2 }')"
echo "Memória Disponível: $(free -h | awk '/^Mem:/ { print $7 }')"
echo "Disco (/)): $(df -h / | awk 'NR==2 { print $3 "/" $2 " (" $5 " usado)" }')"
echo ""

# 2. Verificação de serviços
log_info "🔧 STATUS DOS SERVIÇOS"
check_service_status "postgresql"
check_service_status "nginx"

# 3. Verificação de portas
log_info "🌐 STATUS DAS PORTAS"
check_port "22" "SSH"
check_port "80" "HTTP"
check_port "443" "HTTPS"
check_port "3000" "App Produção"
check_port "3001" "App Desenvolvimento"
check_port "5432" "PostgreSQL"
echo ""

# 4. Status do PM2
log_info "⚙️  STATUS DO PM2"
if command -v pm2 >/dev/null 2>&1; then
    sudo -u famachat pm2 status 2>/dev/null || log_warning "PM2 não está rodando ou não há processos"
    echo ""
    
    # Informações detalhadas dos processos PM2
    sudo -u famachat pm2 info famachat-production 2>/dev/null || log_warning "Processo famachat-production não encontrado"
    echo ""
else
    log_error "PM2 não está instalado"
fi

# 5. Verificação do banco de dados
log_info "🗄️  STATUS DO BANCO DE DADOS"
if systemctl is-active --quiet postgresql; then
    # Verificar conexão
    sudo -u postgres psql -d famachat_db -c "SELECT version();" 2>/dev/null || log_warning "Erro ao conectar com o banco famachat_db"
    
    # Verificar tamanho do banco
    DB_SIZE=$(sudo -u postgres psql -d famachat_db -t -c "SELECT pg_size_pretty(pg_database_size('famachat_db'));" 2>/dev/null | xargs)
    log_info "Tamanho do banco: $DB_SIZE"
    
    # Verificar tabelas
    TABLE_COUNT=$(sudo -u postgres psql -d famachat_db -t -c "SELECT count(*) FROM information_schema.tables WHERE table_schema='public';" 2>/dev/null | xargs)
    log_info "Número de tabelas: $TABLE_COUNT"
    
    # Verificar conexões ativas
    ACTIVE_CONNECTIONS=$(sudo -u postgres psql -t -c "SELECT count(*) FROM pg_stat_activity WHERE state='active';" 2>/dev/null | xargs)
    log_info "Conexões ativas: $ACTIVE_CONNECTIONS"
else
    log_error "PostgreSQL não está rodando"
fi
echo ""

# 6. Verificação de arquivos e permissões
log_info "📁 VERIFICAÇÃO DE ARQUIVOS"
APP_DIR="/var/www/famachat"
UPLOAD_DIR="/var/lib/famachat/uploads"
LOG_DIR="/var/log/famachat"

for dir in "$APP_DIR" "$UPLOAD_DIR" "$LOG_DIR"; do
    if [ -d "$dir" ]; then
        OWNER=$(stat -c "%U:%G" "$dir")
        PERMS=$(stat -c "%a" "$dir")
        SIZE=$(du -sh "$dir" 2>/dev/null | cut -f1)
        log_info "$dir - Owner: $OWNER, Permissions: $PERMS, Size: $SIZE"
    else
        log_warning "Diretório $dir não encontrado"
    fi
done
echo ""

# 7. Verificação de variáveis de ambiente
log_info "🔐 VERIFICAÇÃO DE CONFIGURAÇÃO"
ENV_PROD="/var/www/famachat/.env.production"
ENV_DEV="/var/www/famachat/.env.development"

for env_file in "$ENV_PROD" "$ENV_DEV"; do
    if [ -f "$env_file" ]; then
        log_info "Arquivo $env_file existe ✅"
        # Verificar algumas variáveis sem mostrar valores sensíveis
        if grep -q "DATABASE_URL" "$env_file"; then
            log_info "  DATABASE_URL configurada ✅"
        else
            log_warning "  DATABASE_URL não encontrada ⚠️"
        fi
        
        if grep -q "JWT_SECRET" "$env_file"; then
            log_info "  JWT_SECRET configurada ✅"
        else
            log_warning "  JWT_SECRET não encontrada ⚠️"
        fi
    else
        log_warning "Arquivo $env_file não encontrado"
    fi
done
echo ""

# 8. Verificação de logs
log_info "📊 LOGS DA APLICAÇÃO"
check_logs "/var/log/famachat/combined-production.log" 10
check_logs "/var/log/famachat/err-production.log" 5
check_logs "/var/log/nginx/famachat_error.log" 5
check_logs "/var/log/postgresql/postgresql-$(date +%Y-%m-%d)*.log" 5

# 9. Teste de conectividade
log_info "🌐 TESTE DE CONECTIVIDADE"

# Teste local
if curl -s -f http://localhost:3000/health >/dev/null 2>&1; then
    log_info "Health check local (3000) funcionando ✅"
else
    log_warning "Health check local (3000) falhando ⚠️"
fi

# Teste via Nginx
if curl -s -f http://localhost/health >/dev/null 2>&1; then
    log_info "Health check via Nginx (80) funcionando ✅"
else
    log_warning "Health check via Nginx (80) falhando ⚠️"
fi
echo ""

# 10. Verificação de recursos
log_info "📈 MONITORAMENTO DE RECURSOS"

# CPU
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
log_info "Uso de CPU: ${CPU_USAGE}%"

# Memória
MEM_USAGE=$(free | grep Mem | awk '{printf("%.1f%%", ($3/$2) * 100.0)}')
log_info "Uso de Memória: $MEM_USAGE"

# Disco
DISK_USAGE=$(df / | tail -1 | awk '{print $5}')
log_info "Uso de Disco (/): $DISK_USAGE"

# Processos Node.js
NODE_PROCESSES=$(pgrep -f node | wc -l)
log_info "Processos Node.js ativos: $NODE_PROCESSES"
echo ""

# 11. Últimas atividades
log_info "🕒 ATIVIDADES RECENTES"
echo "Últimos logins:"
last -n 5 | head -5

echo ""
echo "Últimos 5 processos que falharam:"
journalctl --since "1 hour ago" --no-pager -p err | tail -5 || echo "Nenhum erro recente"

echo ""
echo "================================================"
log_info "✅ Diagnóstico concluído!"
echo "================================================"

# 12. Sugestões baseadas nos resultados
echo ""
log_info "💡 SUGESTÕES DE DEBUG:"

# Verificar se algum serviço crítico não está rodando
if ! systemctl is-active --quiet postgresql; then
    echo "• Iniciar PostgreSQL: sudo systemctl start postgresql"
fi

if ! systemctl is-active --quiet nginx; then
    echo "• Iniciar Nginx: sudo systemctl start nginx"
fi

# Verificar se PM2 tem processos
if ! sudo -u famachat pm2 list 2>/dev/null | grep -q "famachat"; then
    echo "• Iniciar aplicação: cd /var/www/famachat && sudo -u famachat pm2 start ecosystem.production.config.js"
fi

# Verificar logs se houver erros
if [ -f "/var/log/famachat/err-production.log" ] && [ -s "/var/log/famachat/err-production.log" ]; then
    echo "• Verificar logs de erro: tail -f /var/log/famachat/err-production.log"
fi

echo "• Monitorar em tempo real: sudo -u famachat pm2 monit"
echo "• Verificar logs da aplicação: sudo -u famachat pm2 logs"
echo "• Restart da aplicação: sudo -u famachat pm2 restart famachat-production"
