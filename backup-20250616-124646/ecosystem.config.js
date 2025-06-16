module.exports = {
  apps: [{
    name: 'fama-sistema',
    script: 'server/index.js',
    cwd: '/var/www/fama-sistema',
    instances: 'max', // Usa todos os cores disponíveis
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    },
    env_file: '.env.production',
    error_file: './logs/err.log',
    out_file: './logs/out.log',
    log_file: './logs/combined.log',
    time: true,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    node_args: '--max-old-space-size=1024',
    kill_timeout: 5000,
    wait_ready: true,
    listen_timeout: 10000,
    reload_delay: 1000,
    max_restarts: 10,
    min_uptime: '10s'
  }]
};