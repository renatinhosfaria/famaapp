# FamaChat v2.0 - Configuração VPS Ubuntu 22.04

Este diretório contém todos os scripts e configurações necessárias para migrar o FamaChat do Replit para um VPS Ubuntu 22.04 com foco em debug e melhores práticas.

## 📁 Estrutura dos Arquivos

```
deploy/
├── README.md                 # Guia completo de migração
├── setup-vps.sh            # Configuração inicial do VPS
├── setup-database.sh       # Configuração PostgreSQL
├── setup-ssl.sh           # Configuração SSL/HTTPS
├── deploy.sh              # Script de deploy da aplicação
└── debug.sh              # Script de diagnóstico e debug
```

## 🚀 Ordem de Execução

### 1. Configuração Inicial
```bash
chmod +x setup-vps.sh
./setup-vps.sh
reboot
```

### 2. Configuração do Banco
```bash
chmod +x setup-database.sh
./setup-database.sh
```

### 3. Deploy da Aplicação
```bash
# Edite REPO_URL no deploy.sh com sua URL do Git
chmod +x deploy.sh
./deploy.sh production
```

### 4. Configuração SSL (Opcional)
```bash
chmod +x setup-ssl.sh
./setup-ssl.sh seudominio.com
```

### 5. Debug e Monitoramento
```bash
chmod +x debug.sh
./debug.sh
```

## 🔧 Funcionalidades Implementadas

### ✅ Ambiente de Produção
- PM2 com cluster mode
- Nginx como reverse proxy
- PostgreSQL otimizado
- Logs estruturados
- Health check automático
- Backup automatizado
- SSL/HTTPS com Let's Encrypt

### ✅ Ambiente de Desenvolvimento
- Hot reload habilitado
- Logs verbosos
- Port separada (3001)
- Acesso via /dev/

### ✅ Monitoramento
- Health check a cada 5 minutos
- Backup diário às 2:00
- Rotação de logs (30 dias)
- Monitoramento SSL
- Alertas automáticos

### ✅ Segurança
- Firewall configurado
- Usuário dedicado (não-root)
- Headers de segurança
- SSL/TLS obrigatório
- Backup criptografado

## 📊 Monitoramento e Debug

### Comandos Essenciais
```bash
# Status geral
./debug.sh

# PM2
sudo -u famachat pm2 status
sudo -u famachat pm2 logs
sudo -u famachat pm2 monit

# Serviços
sudo systemctl status postgresql nginx

# Logs
tail -f /var/log/famachat/combined-production.log
tail -f /var/log/nginx/famachat_error.log
```

### URLs de Acesso
- **Produção**: http://seu-servidor/ ou https://seudominio.com/
- **Desenvolvimento**: http://seu-servidor/dev/
- **Health Check**: http://seu-servidor/health

## 🔄 Deploy Futuro

Para atualizações futuras:
```bash
cd /var/www/famachat
sudo -u famachat git pull origin main
sudo -u famachat npm run build
sudo -u famachat pm2 restart famachat-production
```

## 🆘 Suporte

Se algo não funcionar:
1. Execute `./debug.sh` para diagnóstico
2. Verifique logs em `/var/log/famachat/`
3. Consulte o README.md completo
4. Verifique se todos os serviços estão rodando

## 🎯 Próximos Passos

Após a migração bem-sucedida:
1. Configurar domínio personalizado
2. Configurar SSL/HTTPS
3. Configurar backup externo
4. Configurar monitoramento avançado
5. Configurar CI/CD automático

---

**Nota**: Todos os scripts foram testados em Ubuntu 22.04 e seguem as melhores práticas de segurança e performance para aplicações Node.js em produção.
