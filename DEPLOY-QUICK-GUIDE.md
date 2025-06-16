# Deploy Rápido - FAMA Sistema no VPS

## Situação Atual
✅ PostgreSQL 17.5 rodando no VPS com banco `neondb` configurado  
✅ Traefik 3.4.1 ativo no Docker Swarm  
✅ Dados já estão no PostgreSQL do VPS  

## Deploy em 2 Comandos

### 1. Copiar arquivos para VPS
```bash
scp -r {docker-compose.yml,Dockerfile,production.env,deploy.sh,backup-script.sh,server,client,shared,public,package.json,package-lock.json} deploy@144.126.134.23:/var/www/fama-sistema/
```

### 2. Executar deploy
```bash
ssh deploy@144.126.134.23 "cd /var/www/fama-sistema && chmod +x deploy.sh && ./deploy.sh production"
```

## Resultado
- Aplicação disponível em: **https://famachat.com.br**
- SSL automático via Traefik + Let's Encrypt
- 2 réplicas da aplicação para alta disponibilidade
- Conecta diretamente no PostgreSQL existente

## Verificação
```bash
# Testar aplicação
curl https://famachat.com.br/api/health

# Ver logs
ssh deploy@144.126.134.23 "docker service logs -f fama-sistema_fama-sistema"

# Status dos serviços
ssh deploy@144.126.134.23 "docker service ls"
```

## Comandos de Manutenção
```bash
# Atualizar aplicação
ssh deploy@144.126.134.23 "cd /var/www/fama-sistema && ./deploy.sh production"

# Escalar para 3 réplicas
ssh deploy@144.126.134.23 "docker service scale fama-sistema_fama-sistema=3"

# Backup manual
ssh deploy@144.126.134.23 "cd /var/www/fama-sistema && ./backup-script.sh"
```