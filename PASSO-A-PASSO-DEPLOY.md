# Passo a Passo Completo - Deploy FAMA Sistema no VPS

## PRÉ-REQUISITOS
- VPS com IP: 144.126.134.23
- PostgreSQL 17.5 rodando no Docker Swarm
- Traefik 3.4.1 configurado
- Acesso SSH ao VPS como usuário `deploy`
- Cliente `scp` instalado no seu computador

---

## PASSO 1: PREPARAR AMBIENTE LOCAL

### 1.1 Baixar projeto do Replit
```bash
# No seu computador, criar diretório de trabalho
mkdir ~/fama-deploy
cd ~/fama-deploy

# Baixar arquivos do Replit (manual ou via Git)
# Você precisa copiar todos os arquivos do Replit para esta pasta
```

### 1.2 Verificar arquivos necessários
```bash
# Verificar se os arquivos de deploy estão presentes
ls -la

# Devem existir estes arquivos:
# - docker-compose.yml
# - Dockerfile  
# - production.env
# - deploy.sh
# - backup-script.sh
# - server/ (diretório)
# - client/ (diretório)
# - shared/ (diretório)
# - public/ (diretório)
# - package.json
# - package-lock.json
```

---

## PASSO 2: VERIFICAR INFRAESTRUTURA DO VPS

### 2.1 Testar conexão SSH
```bash
ssh deploy@144.126.134.23

# Se conectar com sucesso, você verá o prompt do VPS
# Se der erro, configure as chaves SSH primeiro
```

### 2.2 Verificar Docker Swarm
```bash
# No VPS, verificar se Swarm está ativo
docker info | grep Swarm
# Deve mostrar: Swarm: active

# Verificar serviços rodando
docker service ls
# Deve mostrar: traefik e postgres_postgres
```

### 2.3 Verificar PostgreSQL
```bash
# Verificar se PostgreSQL está rodando
docker service ls | grep postgres
# Deve mostrar: postgres_postgres

# Testar conexão com banco
docker exec -it $(docker ps --filter "name=postgres_postgres" --format "{{.Names}}" | head -1) psql -U postgres -l

# Verificar se banco neondb existe
# Se não existir, criar:
docker exec -it $(docker ps --filter "name=postgres_postgres" --format "{{.Names}}" | head -1) psql -U postgres -c "CREATE DATABASE neondb;"
```

### 2.4 Verificar Traefik
```bash
# Verificar se Traefik está rodando
docker service ls | grep traefik

# Verificar rede pública
docker network ls | grep network_public
```

### 2.5 Sair do VPS
```bash
exit
# Voltar para seu computador local
```

---

## PASSO 3: PREPARAR DIRETÓRIOS NO VPS

### 3.1 Criar estrutura de diretórios
```bash
# Do seu computador, executar comandos remotos
ssh deploy@144.126.134.23 "sudo mkdir -p /var/www/fama-sistema"
ssh deploy@144.126.134.23 "sudo chown deploy:deploy /var/www/fama-sistema"
ssh deploy@144.126.134.23 "mkdir -p /var/backups/fama-sistema"
ssh deploy@144.126.134.23 "mkdir -p /var/log/fama-sistema"
```

### 3.2 Verificar diretórios criados
```bash
ssh deploy@144.126.134.23 "ls -la /var/www/ | grep fama"
ssh deploy@144.126.134.23 "ls -la /var/backups/ | grep fama"
```

---

## PASSO 4: TRANSFERIR ARQUIVOS

### 4.1 Transferir arquivos de configuração
```bash
# Do diretório ~/fama-deploy no seu computador
cd ~/fama-deploy

# Transferir arquivo principal do Docker
scp docker-compose.yml deploy@144.126.134.23:/var/www/fama-sistema/

# Transferir Dockerfile
scp Dockerfile deploy@144.126.134.23:/var/www/fama-sistema/

# Transferir configuração de ambiente (renomeando)
scp production.env deploy@144.126.134.23:/var/www/fama-sistema/.env.production

# Transferir scripts
scp deploy.sh deploy@144.126.134.23:/var/www/fama-sistema/
scp backup-script.sh deploy@144.126.134.23:/var/www/fama-sistema/

# Transferir dependências
scp package.json deploy@144.126.134.23:/var/www/fama-sistema/
scp package-lock.json deploy@144.126.134.23:/var/www/fama-sistema/
```

### 4.2 Transferir código fonte
```bash
# Transferir diretórios do código
scp -r server/ deploy@144.126.134.23:/var/www/fama-sistema/
scp -r client/ deploy@144.126.134.23:/var/www/fama-sistema/
scp -r shared/ deploy@144.126.134.23:/var/www/fama-sistema/
scp -r public/ deploy@144.126.134.23:/var/www/fama-sistema/

# Se houver outros arquivos importantes (tsconfig, etc)
scp tsconfig.json deploy@144.126.134.23:/var/www/fama-sistema/ 2>/dev/null || true
scp vite.config.ts deploy@144.126.134.23:/var/www/fama-sistema/ 2>/dev/null || true
scp tailwind.config.ts deploy@144.126.134.23:/var/www/fama-sistema/ 2>/dev/null || true
```

### 4.3 Verificar transferência
```bash
ssh deploy@144.126.134.23 "ls -la /var/www/fama-sistema/"
# Deve mostrar todos os arquivos transferidos

ssh deploy@144.126.134.23 "ls -la /var/www/fama-sistema/server/"
# Deve mostrar arquivos do servidor

ssh deploy@144.126.134.23 "ls -la /var/www/fama-sistema/client/"
# Deve mostrar arquivos do cliente
```

---

## PASSO 5: CONFIGURAR PERMISSÕES

### 5.1 Conectar ao VPS
```bash
ssh deploy@144.126.134.23
cd /var/www/fama-sistema
```

### 5.2 Ajustar permissões dos scripts
```bash
# Tornar scripts executáveis
chmod +x deploy.sh
chmod +x backup-script.sh

# Proteger arquivo de configuração
chmod 600 .env.production

# Verificar permissões
ls -la *.sh
ls -la .env.production
```

### 5.3 Verificar configuração do banco
```bash
# Verificar string de conexão
grep DATABASE_URL .env.production
# Deve mostrar: postgresql://postgres:IwOLgVnyOfbN@tasks.postgres_postgres:5432/neondb

# Verificar outras configurações importantes
grep APP_URL .env.production
grep NODE_ENV .env.production
```

---

## PASSO 6: EXECUTAR DEPLOY

### 6.1 Verificar pré-requisitos do deploy
```bash
# Ainda no VPS (/var/www/fama-sistema)

# Verificar se Docker Swarm está ativo
docker info | grep "Swarm: active"

# Verificar se PostgreSQL está acessível
docker exec $(docker ps --filter "name=postgres_postgres" --format "{{.Names}}" | head -1) pg_isready -U postgres

# Verificar rede pública
docker network ls | grep network_public
```

### 6.2 Executar script de deploy
```bash
# Executar deploy (isso vai demorar alguns minutos)
./deploy.sh production

# O script vai mostrar cada etapa:
# ✓ Verificando Docker Swarm
# ✓ Fazendo backup do banco de dados
# ✓ Construindo nova imagem Docker
# ✓ Removendo stack existente
# ✓ Verificando volumes do Swarm
# ✓ Fazendo deploy da nova stack
# ✓ Aguardando serviços ficarem prontos
# ✓ Deploy concluído com sucesso
```

### 6.3 Monitorar o deploy
```bash
# Em outro terminal, conectar ao VPS e monitorar
ssh deploy@144.126.134.23

# Ver status dos serviços
docker service ls

# Acompanhar logs da aplicação
docker service logs -f fama-sistema_fama-sistema

# Se houver erros, ver logs mais detalhados
docker service logs --details fama-sistema_fama-sistema
```

---

## PASSO 7: VERIFICAR APLICAÇÃO

### 7.1 Aguardar aplicação ficar disponível
```bash
# Aguardar alguns minutos para aplicação inicializar completamente
# O deploy script já faz essa verificação, mas você pode testar manualmente

# Testar health check local (no VPS)
curl -f http://localhost:3000/api/health

# Se retornar JSON com status "healthy", aplicação está funcionando
```

### 7.2 Testar acesso externo
```bash
# Do seu computador (não no VPS)
curl -I https://famachat.com.br

# Deve retornar HTTP/2 200 com certificado SSL válido

# Testar API
curl https://famachat.com.br/api/health

# Deve retornar: {"status":"healthy","timestamp":"..."}
```

### 7.3 Testar aplicação web
```bash
# Abrir navegador e acessar:
# https://famachat.com.br

# Verificar:
# - Página carrega sem erros
# - SSL está ativo (cadeado verde)
# - Login funciona
# - Dashboard carrega dados
```

---

## PASSO 8: VERIFICAR BANCO DE DADOS

### 8.1 Conectar ao banco
```bash
# No VPS
docker exec -it $(docker ps --filter "name=postgres_postgres" --format "{{.Names}}" | head -1) psql -U postgres -d neondb
```

### 8.2 Verificar dados
```sql
-- Listar tabelas
\dt

-- Verificar dados essenciais
SELECT COUNT(*) FROM sistema_users;
SELECT COUNT(*) FROM clientes;
SELECT COUNT(*) FROM clientes_agendamentos;

-- Verificar usuário admin
SELECT username, "fullName", role, department FROM sistema_users WHERE role = 'Gestor';

-- Sair do PostgreSQL
\q
```

---

## PASSO 9: CONFIGURAR BACKUP

### 9.1 Testar backup manual
```bash
# No VPS
cd /var/www/fama-sistema
./backup-script.sh

# Verificar se backup foi criado
ls -la /var/backups/fama-sistema/
```

### 9.2 Verificar backup automático
```bash
# Verificar se cron job foi configurado (durante setup do VPS)
crontab -l | grep fama-sistema

# Deve mostrar:
# 0 2 * * * deploy /var/www/fama-sistema/backup-script.sh
```

---

## PASSO 10: CONFIGURAR MONITORAMENTO

### 10.1 Verificar logs
```bash
# Ver logs da aplicação
docker service logs --tail 50 fama-sistema_fama-sistema

# Ver logs do PostgreSQL
docker service logs --tail 50 postgres_postgres

# Ver logs do Traefik
docker service logs --tail 50 traefik_traefik
```

### 10.2 Configurar alertas (opcional)
```bash
# Criar script de verificação
cat > /usr/local/bin/check-fama.sh << 'EOF'
#!/bin/bash
if ! curl -f -s https://famachat.com.br/api/health > /dev/null; then
    echo "$(date): FAMA Sistema não está respondendo" | mail -s "ALERTA: FAMA Sistema" seu@email.com
fi
EOF

chmod +x /usr/local/bin/check-fama.sh

# Adicionar ao cron (a cada 5 minutos)
(crontab -l 2>/dev/null; echo "*/5 * * * * /usr/local/bin/check-fama.sh") | crontab -
```

---

## PASSO 11: COMANDOS DE MANUTENÇÃO

### 11.1 Ver status geral
```bash
# Status de todos os serviços
docker service ls

# Uso de recursos
docker stats --no-stream

# Espaço em disco
df -h

# Logs recentes
docker service logs --tail 20 fama-sistema_fama-sistema
```

### 11.2 Escalar aplicação
```bash
# Aumentar para 3 réplicas
docker service scale fama-sistema_fama-sistema=3

# Diminuir para 1 réplica
docker service scale fama-sistema_fama-sistema=1

# Voltar para 2 réplicas (padrão)
docker service scale fama-sistema_fama-sistema=2
```

### 11.3 Atualizar aplicação
```bash
# Baixar nova versão (se usando Git)
cd /var/www/fama-sistema
git pull origin main

# Fazer novo deploy
./deploy.sh production
```

### 11.4 Rollback (se necessário)
```bash
# Ver histórico de imagens
docker images fama-sistema

# Usar imagem anterior
docker service update --image fama-sistema:VERSAO_ANTERIOR fama-sistema_fama-sistema
```

---

## RESOLUÇÃO DE PROBLEMAS

### Problema: Aplicação não inicia
```bash
# Ver logs detalhados
docker service logs --details fama-sistema_fama-sistema

# Verificar se banco está acessível
docker exec $(docker ps --filter "name=postgres_postgres" --format "{{.Names}}" | head -1) pg_isready -U postgres
```

### Problema: SSL não funciona
```bash
# Ver logs do Traefik
docker service logs traefik_traefik | grep famachat

# Verificar configuração DNS
nslookup famachat.com.br
```

### Problema: Dados não aparecem
```bash
# Verificar conexão com banco
docker exec -it $(docker ps --filter "name=postgres_postgres" --format "{{.Names}}" | head -1) psql -U postgres -d neondb -c "SELECT COUNT(*) FROM clientes;"
```

---

## CONCLUSÃO

Após seguir todos estes passos, você terá:

✅ **Aplicação rodando**: https://famachat.com.br  
✅ **SSL automático**: Certificado Let's Encrypt  
✅ **Alta disponibilidade**: 2 réplicas da aplicação  
✅ **Backup automático**: Diário às 2:00 AM  
✅ **Monitoramento**: Health checks e logs  
✅ **Escalabilidade**: Fácil aumento de réplicas  

O sistema estará em produção usando sua infraestrutura existente (PostgreSQL + Traefik) com todas as funcionalidades operacionais.