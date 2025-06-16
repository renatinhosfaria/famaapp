# Deploy FAMA Sistema no VPS com Docker Swarm + Traefik

## Resumo da Configuração

Seu projeto está configurado para deploy em produção no VPS usando:
- **Docker Swarm** para orquestração de containers
- **Traefik 3.4.1** como proxy reverso (já configurado)
- **PostgreSQL 17.5** existente no VPS (já configurado)
- **2 réplicas** da aplicação para alta disponibilidade
- **Backup automático** diário
- **Health checks** e monitoramento

## 1. Preparação do VPS (Execute apenas uma vez)

### Conectar ao VPS e executar setup:
```bash
ssh root@144.126.134.23
cd /tmp
wget https://raw.githubusercontent.com/seu-repo/setup-vps.sh
chmod +x setup-vps.sh
./setup-vps.sh
```

**Ou executar manualmente:**
```bash
# Como root
apt update && apt upgrade -y
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh

# Criar usuário deploy
useradd -m -s /bin/bash deploy
usermod -aG sudo,docker deploy

# Inicializar Swarm (se não estiver ativo)
docker swarm init

# Criar redes
docker network create --driver overlay network_public
docker network create --driver overlay network_internal

# Criar volumes
docker volume create volume_swarm_postgres_data
docker volume create volume_swarm_postgres_backups
docker volume create volume_swarm_uploads
docker volume create volume_swarm_logs

# Criar diretórios
mkdir -p /var/www/fama-sistema /var/backups/fama-sistema
chown deploy:deploy /var/www/fama-sistema /var/backups/fama-sistema
```

## 2. Transferir Arquivos do Projeto

### No seu computador local:
```bash
# Baixar todos os arquivos do Replit
# Copiar para o VPS
scp -r projeto-completo/* deploy@144.126.134.23:/var/www/fama-sistema/
```

### Ou via Git:
```bash
ssh deploy@144.126.134.23
cd /var/www/fama-sistema
git clone https://github.com/seu-usuario/fama-sistema.git .
```

## 3. Configurar Ambiente de Produção

```bash
ssh deploy@144.126.134.23
cd /var/www/fama-sistema

# Copiar arquivo de ambiente
cp production.env .env.production

# Ajustar permissões
chmod +x deploy.sh backup-script.sh
chmod 600 .env.production
```

### Verificar configurações no .env.production:
- `DATABASE_URL`: postgresql://postgres:IwOLgVnyOfbN@postgres:5432/neondb
- `APP_URL`: https://famachat.com.br
- `CORS_ORIGIN`: https://famachat.com.br

## 4. Deploy da Aplicação

```bash
cd /var/www/fama-sistema
./deploy.sh production
```

### O script automaticamente:
- Faz backup do banco atual
- Constrói nova imagem Docker
- Remove stack anterior
- Cria volumes e redes necessários
- Faz deploy da nova versão
- Executa health checks
- Mostra status final

## 5. Verificar Deploy

### Comandos úteis:
```bash
# Ver status dos serviços
docker service ls

# Ver logs em tempo real
docker service logs -f fama-sistema_fama-sistema
docker service logs -f fama-sistema_postgres

# Ver detalhes de um serviço
docker service inspect fama-sistema_fama-sistema

# Escalar aplicação
docker service scale fama-sistema_fama-sistema=3

# Health check manual
curl https://famachat.com.br/api/health
```

## 6. Configuração do Traefik

Seu docker-compose.yml já está configurado com os labels corretos para seu Traefik:

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.fama-sistema.rule=Host(`famachat.com.br`)"
  - "traefik.http.routers.fama-sistema.entrypoints=websecure"
  - "traefik.http.routers.fama-sistema.tls.certresolver=letsencryptresolver"
  - "traefik.http.services.fama-sistema.loadbalancer.server.port=3000"
```

## 7. Backup e Monitoramento

### Backup automático já configurado:
- **Diário às 2:00 AM** via cron
- **Retenção de 30 dias**
- Inclui: banco, uploads, logs, configurações, certificados

### Executar backup manual:
```bash
cd /var/www/fama-sistema
./backup-script.sh
```

### Monitoramento:
- **Health check a cada 5 minutos**
- **Logs em /var/log/fama-sistema/**
- **Métricas do Docker Swarm**

## 8. Arquitetura Final

```
Internet → Traefik (443/80) → fama-sistema (2 réplicas) → PostgreSQL
                            ↓
                         Volumes persistentes
                    (uploads, logs, banco, certificados)
```

### Recursos configurados:
- **Aplicação**: 2 réplicas, 512MB RAM cada
- **PostgreSQL**: 1 réplica, 1GB RAM
- **SSL**: Automático via Let's Encrypt
- **Health checks**: /api/health endpoint
- **Load balancing**: Automático entre réplicas

## 9. Comandos de Manutenção

### Deploy de nova versão:
```bash
cd /var/www/fama-sistema
git pull origin main
./deploy.sh production
```

### Rollback rápido:
```bash
# Ver histórico de imagens
docker images fama-sistema

# Usar imagem anterior
docker service update --image fama-sistema:TAG_ANTERIOR fama-sistema_fama-sistema
```

### Parar aplicação:
```bash
docker stack rm fama-sistema
```

### Restaurar backup:
```bash
# Banco de dados
zcat /var/backups/fama-sistema/db_backup_YYYYMMDD_HHMMSS.sql.gz | \
  docker exec -i CONTAINER_POSTGRES psql -U postgres neondb

# Uploads
docker run --rm -v volume_swarm_uploads:/volume -v /var/backups/fama-sistema:/backup \
  alpine tar -xzf /backup/uploads_backup_YYYYMMDD_HHMMSS.tar.gz -C /volume
```

## 10. Segurança

### Firewall configurado:
- Porta 22 (SSH)
- Porta 80 (HTTP → redirect HTTPS)
- Porta 443 (HTTPS)
- Porta 5432 (PostgreSQL - apenas para backup)

### Fail2ban ativo para proteção SSH

### Certificados SSL automáticos via Traefik + Let's Encrypt

## Suporte

Em caso de problemas:

1. **Verificar logs**: `docker service logs -f fama-sistema_fama-sistema`
2. **Status dos serviços**: `docker service ls`
3. **Health check**: `curl https://famachat.com.br/api/health`
4. **Espaço em disco**: `df -h`
5. **Memória**: `free -h`

O sistema está configurado para alta disponibilidade e recuperação automática em caso de falhas.