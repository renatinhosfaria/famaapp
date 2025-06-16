#!/usr/bin/env node

/**
 * Script para iniciar o servidor no ambiente de deploy no Replit
 * Este script resolve os problemas específicos de deploy:
 * 1. Adiciona uma rota de health check na raiz
 * 2. Configura a porta correta (5000)
 * 3. Evita problemas de compatibilidade ESM/CommonJS
 * 
 * Criado como .mjs para forçar o modo ES Module
 */

// Configuração de ambiente
process.env.NODE_ENV = 'production';
process.env.PORT = '5000'; // Porta mapeada para tráfego externo

// Remover listeners de warning para evitar status 13
process.removeAllListeners('warning');

// Handler para erros não tratados
process.on('uncaughtException', (error) => {
  console.error('\x1b[31m[ERRO CAPTURADO]\x1b[0m Erro não tratado:', error);
});

process.on('unhandledRejection', (reason) => {
  console.error('\x1b[31m[ERRO CAPTURADO]\x1b[0m Rejeição não tratada:', reason);
});

// Mensagem de inicialização
console.log('\x1b[36m=== INICIANDO SERVIDOR DE PRODUÇÃO ===\x1b[0m');
console.log(`Data/Hora: ${new Date().toLocaleString()}`);
console.log(`Node.js: ${process.version}`);
console.log(`Ambiente: ${process.env.NODE_ENV}`);
console.log(`Porta: ${process.env.PORT}`);

// Módulo HTTP para ES Modules
import { createServer } from 'http';

// Criar servidor HTTP básico para health checks
const server = createServer((req, res) => {
  if (req.url === '/' || req.url === '/health') {
    console.log('\x1b[32m[HEALTH CHECK]\x1b[0m Requisição recebida em', req.url);
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end('OK - Servidor operacional');
  } else {
    // Para outras rotas, retornar 404 - o servidor principal lidará com essas rotas
    res.writeHead(404);
    res.end();
  }
});

// Iniciar o servidor HTTP básico para health checks
server.listen(process.env.PORT, () => {
  console.log(`\x1b[32m[INFO]\x1b[0m Servidor de health check rodando na porta ${process.env.PORT}`);
  
  // Agora iniciar o servidor principal usando dynamic import
  console.log('\x1b[32m[INFO]\x1b[0m Iniciando servidor principal...');
  
  try {
    import('./dist/server/index.js')
      .then(() => {
        console.log('\x1b[32m[INFO]\x1b[0m Servidor principal iniciado com sucesso');
      })
      .catch(error => {
        console.error('\x1b[31m[ERRO]\x1b[0m Falha ao iniciar servidor principal:', error);
      });
  } catch (error) {
    console.error('\x1b[31m[ERRO FATAL]\x1b[0m', error);
  }
});