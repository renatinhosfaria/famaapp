# Configuração Docker para FamaChat v2.0
# Multi-stage build para otimização

# Estágio 1: Build
FROM node:20-alpine AS builder

WORKDIR /app

# Copiar package files
COPY package*.json ./
COPY tsconfig.json ./
COPY vite.config.ts ./
COPY tailwind.config.ts ./
COPY postcss.config.js ./

# Instalar dependências
RUN npm ci --only=production --silent

# Copiar código fonte
COPY client/ ./client/
COPY server/ ./server/
COPY shared/ ./shared/
COPY public/ ./public/

# Build da aplicação
RUN npm run build

# Estágio 2: Produção
FROM node:20-alpine AS production

# Instalar dependências do sistema
RUN apk add --no-cache \
    curl \
    tzdata \
    && rm -rf /var/cache/apk/*

# Configurar timezone
ENV TZ=America/Sao_Paulo

# Criar usuário não-root
RUN addgroup -g 1001 -S famachat && \
    adduser -S famachat -u 1001 -G famachat

WORKDIR /app

# Copiar package files
COPY package*.json ./

# Instalar apenas dependências de produção
RUN npm ci --only=production --silent && \
    npm cache clean --force

# Copiar build da aplicação
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/public ./public

# Criar diretórios necessários
RUN mkdir -p /app/uploads /app/logs && \
    chown -R famachat:famachat /app

# Trocar para usuário não-root
USER famachat

# Expor porta
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# Comando de inicialização
CMD ["node", "--no-deprecation", "dist/index.js"]
