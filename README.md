# FamaChat v2.0

Sistema de gestão imobiliária para o mercado brasileiro com integração WhatsApp e automação de leads.

## Funcionalidades

- **Gestão de Clientes**: CRUD completo com atribuição de corretores
- **Sistema de Leads**: Integração com Facebook Lead Ads e Evolution API
- **WhatsApp Business**: Automação via Evolution API v2
- **Dashboard Analytics**: Métricas de performance e conversão
- **Gestão de Usuários**: Sistema de permissões (GESTOR/CONSULTOR)
- **Reports**: Relatórios detalhados de produção e vendas

## Tecnologias

- **Frontend**: React.js + TypeScript + Vite
- **Backend**: Node.js + Express + TypeScript
- **Banco de dados**: PostgreSQL + Drizzle ORM
- **Autenticação**: JWT + bcrypt
- **Deploy**: Docker + Docker Swarm
- **Integração**: Evolution API, Facebook Lead Ads

## Estrutura do Projeto

```
├── client/          # Frontend React
├── server/          # Backend Node.js
├── shared/          # Schema e tipos compartilhados
├── uploads/         # Arquivos de upload
├── nginx/           # Configuração Nginx
└── docker/          # Configurações Docker
```

## Configuração de Desenvolvimento

1. Clone o repositório
2. Instale as dependências: `npm install`
3. Configure as variáveis de ambiente no `.env`
4. Execute as migrações: `npm run db:push`
5. Inicie o servidor: `npm run dev`

## Deploy em Produção

### Docker Swarm (Recomendado)

```bash
# Build da imagem
docker build -t famachat:latest .

# Deploy do stack
docker stack deploy -c docker-compose.prod.yml famachat
```

### Portainer

Use o arquivo `famachat-network-fixed.yml` para deploy via Portainer.

## Configuração de Ambiente

```env
# Banco de dados
DATABASE_URL=postgresql://user:password@host:port/database

# Evolution API
EVOLUTION_API_URL=https://evolution-api.example.com
EVOLUTION_API_KEY=your-api-key

# OpenAI (opcional)
OPENAI_API_KEY=your-openai-key
```

## Endpoints Principais

- `GET /` - Interface principal
- `GET /health` - Status da aplicação
- `POST /api/init-database` - Inicialização do banco
- `POST /api/auth/login` - Autenticação
- `/api/clientes` - CRUD de clientes
- `/api/leads` - Gestão de leads
- `/api/whatsapp` - Integração WhatsApp

## Credenciais Padrão

- **Usuário**: admin
- **Senha**: admin123

## Suporte

Para suporte técnico ou dúvidas sobre implementação, entre em contato através dos canais oficiais.

## Licença

Proprietário - FamaChat © 2024