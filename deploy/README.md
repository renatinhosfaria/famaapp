# Guia Completo de Migração e Debug - FamaChat v2.0

## 🎯 Objetivo
Este guia oferece uma solução completa para migrar seu projeto FamaChat do Replit para um VPS Ubuntu 22.04, com foco em debug e melhores práticas para desenvolvimento futuro.

## 📋 Pré-requisitos
- VPS Ubuntu 22.04 (limpo)
- Acesso SSH como root ou sudo
- Backup do banco de dados (se houver)
- Código fonte do projeto

## 🚀 Passo a Passo da Migração

### 1. Configuração Inicial do VPS

```bash
# 1. Conectar ao VPS via SSH
ssh root@SEU_IP_VPS

# 2. Executar script de configuração inicial
chmod +x setup-vps.sh
./setup-vps.sh

# 3. Reiniciar o servidor
reboot
```

### 2. Configuração do Banco de Dados

```bash
# 1. Executar configuração do PostgreSQL
chmod +x setup-database.sh
./setup-database.sh

# 2. Importar dados existentes (se houver backup)
sudo -u postgres psql famachat_db < seu_backup.sql
```

### 3. Deploy da Aplicação

```bash
# 1. Alterar URL do repositório no script deploy.sh
# Edite a variável REPO_URL com sua URL do Git

# 2. Executar deploy
chmod +x deploy.sh

# Para produção
./deploy.sh production

# Para desenvolvimento
./deploy.sh development

# Para ambos
./deploy.sh both
```

### 4. Configuração SSL (Produção)

```bash
# 1. Instalar Certbot
sudo apt install certbot python3-certbot-nginx

# 2. Obter certificado (altere para seu domínio)
sudo certbot --nginx -d seudominio.com

# 3. Configurar renovação automática
sudo systemctl enable certbot.timer
```

## 🔧 Estrutura de Debug Implementada

### Ambientes Separados
- **Produção**: Porta 3000, ambiente otimizado
- **Desenvolvimento**: Porta 3001, hot reload, logs verbosos

### Sistema de Logs
```
/var/log/famachat/
├── app.log                 # Logs da aplicação
├── app-dev.log            # Logs de desenvolvimento  
├── combined-production.log # Logs PM2 produção
├── err-production.log     # Erros PM2 produção
└── health-check.log       # Logs de health check
```

### Monitoramento Automático
- **Health Check**: A cada 5 minutos
- **Backup Automático**: Diário às 2:00
- **Restart Automático**: Se a aplicação falhar
- **Logs Rotativos**: Mantém 30 dias de histórico

### Scripts de Debug

```bash
# Script de diagnóstico completo
./debug.sh

# Verificar status dos serviços
sudo systemctl status postgresql nginx

# Monitorar aplicação em tempo real
sudo -u famachat pm2 monit

# Ver logs em tempo real
sudo -u famachat pm2 logs

# Restart da aplicação
sudo -u famachat pm2 restart famachat-production
```

## 📊 Comandos Úteis para Debug

### PM2 (Gerenciamento de Processos)
```bash
# Status dos processos
sudo -u famachat pm2 status

# Logs em tempo real
sudo -u famachat pm2 logs

# Reiniciar aplicação
sudo -u famachat pm2 restart famachat-production

# Monitor de recursos
sudo -u famachat pm2 monit

# Informações detalhadas
sudo -u famachat pm2 info famachat-production
```

### PostgreSQL (Banco de Dados)
```bash
# Conectar ao banco
sudo -u postgres psql famachat_db

# Verificar tamanho do banco
sudo -u postgres psql -d famachat_db -c "SELECT pg_size_pretty(pg_database_size('famachat_db'));"

# Listar tabelas
sudo -u postgres psql -d famachat_db -c "\dt"

# Backup manual
sudo -u postgres pg_dump famachat_db > backup.sql
```

### Nginx (Servidor Web)
```bash
# Testar configuração
sudo nginx -t

# Reload configuração
sudo systemctl reload nginx

# Ver logs de acesso
sudo tail -f /var/log/nginx/famachat_access.log

# Ver logs de erro
sudo tail -f /var/log/nginx/famachat_error.log
```

### Sistema (Monitoramento)
```bash
# Uso de recursos
htop

# Processos Node.js
pgrep -f node

# Conexões de rede
netstat -tuln | grep -E "(3000|3001|5432|80|443)"

# Espaço em disco
df -h

# Uso de memória
free -h
```

## 🛠️ Resolução de Problemas Comuns

### Aplicação não inicia
```bash
# 1. Verificar logs de erro
sudo -u famachat pm2 logs famachat-production --err

# 2. Verificar variáveis de ambiente
sudo -u famachat cat /var/www/famachat/.env.production

# 3. Verificar dependências
cd /var/www/famachat && npm ls
```

### Erro de conexão com banco
```bash
# 1. Verificar se PostgreSQL está rodando
sudo systemctl status postgresql

# 2. Testar conexão
sudo -u postgres psql -d famachat_db -c "SELECT 1;"

# 3. Verificar URL de conexão
grep DATABASE_URL /var/www/famachat/.env.production
```

### Nginx retorna erro 502
```bash
# 1. Verificar se aplicação está rodando
curl http://localhost:3000/health

# 2. Verificar configuração Nginx
sudo nginx -t

# 3. Ver logs Nginx
sudo tail -f /var/log/nginx/famachat_error.log
```

### Performance lenta
```bash
# 1. Monitorar recursos
sudo -u famachat pm2 monit

# 2. Verificar logs de performance
grep "slow" /var/log/famachat/app.log

# 3. Otimizar banco (se necessário)
sudo -u postgres psql -d famachat_db -c "VACUUM ANALYZE;"
```

## 🔄 Processo de Deploy Futuro

### Deploy Automatizado
1. **Push para repositório**: Git push para branch main
2. **Backup automático**: Executado antes do deploy
3. **Download código**: Git pull no servidor
4. **Build aplicação**: npm run build
5. **Restart serviços**: PM2 restart
6. **Health check**: Verificação automática

### Ambiente de Desenvolvimento
```bash
# 1. Ativar ambiente de desenvolvimento
./deploy.sh development

# 2. Acessar via navegador
http://seu-servidor/dev/

# 3. Logs de desenvolvimento
sudo -u famachat pm2 logs famachat-development
```

## 📈 Monitoramento Avançado

### Métricas Coletadas
- **Performance**: CPU, memória, disco
- **Aplicação**: Tempo de resposta, erros
- **Banco**: Conexões, queries lentas
- **Rede**: Largura de banda, latência

### Alertas Configurados
- **Aplicação offline**: Email + restart automático
- **Erro crítico**: Notificação imediata
- **Backup falho**: Alerta diário
- **Disco cheio**: Alerta aos 80%

## 🔐 Segurança Implementada

### Medidas de Segurança
- **Firewall**: Apenas portas necessárias abertas
- **HTTPS**: SSL/TLS obrigatório em produção
- **Usuário dedicado**: Aplicação não roda como root
- **Backup criptografado**: Dados protegidos
- **Logs auditados**: Trilha de ações

### Atualizações de Segurança
```bash
# Atualizar sistema automaticamente
sudo unattended-upgrades

# Verificar vulnerabilidades Node.js
npm audit

# Atualizar dependências
npm update
```

## 📞 Suporte e Manutenção

### Scripts de Manutenção
- `debug.sh`: Diagnóstico completo
- `backup-famachat-db.sh`: Backup manual
- `famachat-health-check.sh`: Verificação de saúde

### Quando Chamar Suporte
1. **Script debug.sh falha**: Problema crítico
2. **Aplicação offline > 5min**: Intervenção necessária
3. **Erros recorrentes**: Investigação necessária
4. **Performance degradada**: Otimização necessária

Este guia garante que seu projeto esteja preparado para crescimento futuro com debug profissional e manutenção facilitada.
