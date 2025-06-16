# Deploy FAMA Sistema - Resumo Executivo

## Configuração Atual
- **PostgreSQL 17.5** já rodando no VPS (stack: postgres)
- **Traefik 3.4.1** já configurado no VPS
- **Docker Swarm** ativo no VPS
- **Projeto** rodando no Replit com dados no Neon Database

## Arquivos de Deploy Criados
- `docker-compose.yml` - Stack do FAMA Sistema (sem PostgreSQL)
- `production.env` - Configuração para conectar no PostgreSQL do VPS
- `deploy.sh` - Script automatizado de deploy
- `prepare-database.sh` - Preparação do banco neondb no PostgreSQL
- `migrate-data-to-vps.sh` - Migração dos dados do Neon para VPS
- `backup-script.sh` - Backup automático (adaptado para PostgreSQL externo)

## Processo de Deploy (2 Passos Apenas)

### 1. Copiar Arquivos para VPS
```bash
scp -r projeto-completo/* deploy@144.126.134.23:/var/www/fama-sistema/
```
**Ação**: Transfere código e configurações para o VPS

### 2. Deploy da Aplicação (Execute no VPS)
```bash
ssh deploy@144.126.134.23
cd /var/www/fama-sistema
chmod +x deploy.sh backup-script.sh
./deploy.sh production # Deploy direto da aplicação
```
**Ação**: Como o banco `neondb` já existe no PostgreSQL, a aplicação conectará diretamente

## Resultado Final
- **URL**: https://famachat.com.br
- **SSL**: Automático via Traefik + Let's Encrypt
- **Replicas**: 2 instâncias da aplicação
- **Backup**: Diário às 2:00 AM
- **Monitoramento**: Health checks automáticos

## Comandos Úteis Pós-Deploy
```bash
# Status dos serviços
docker service ls

# Logs da aplicação
docker service logs -f fama-sistema_fama-sistema

# Escalar aplicação
docker service scale fama-sistema_fama-sistema=3

# Verificar saúde
curl https://famachat.com.br/api/health

# Backup manual
./backup-script.sh
```

## Conectividade do Banco
- **Host interno**: `tasks.postgres_postgres:5432` (containers)
- **Host externo**: `144.126.134.23:5432` (acesso direto)
- **Banco**: `neondb`
- **Usuário**: `postgres`

## Vantagens da Configuração
- Utiliza infraestrutura existente (PostgreSQL + Traefik)
- Alta disponibilidade com múltiplas réplicas
- SSL automático sem configuração adicional
- Backup e monitoramento automatizados
- Zero downtime deployment