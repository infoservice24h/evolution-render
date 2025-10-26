# QR Code Scanning - Configuração Completa

Este documento detalha todas as configurações disponíveis para o sistema de QR Code scanning do Evolution API.

## 📋 Sumário

1. [Variáveis de Ambiente](#variáveis-de-ambiente)
2. [Configurações do Banco de Dados](#configurações-do-banco-de-dados)
3. [Configurações de Autenticação](#configurações-de-autenticação)
4. [Configurações do QR Code](#configurações-do-qr-code)
5. [Configurações de Cache](#configurações-de-cache)
6. [Configurações de Webhook](#configurações-de-webhook)
7. [Configurações de Rate Limiting](#configurações-de-rate-limiting)
8. [Configurações de Interface](#configurações-de-interface)
9. [Configurações Avançadas](#configurações-avançadas)
10. [Validação de Configurações](#validação-de-configurações)

## 🌍 Variáveis de Ambiente

### **Configurações Principais**

```env
# ========================================
# CONFIGURAÇÕES GERAIS DO SISTEMA
# ========================================

# URL do servidor (importante para webhooks)
SERVER_URL=http://localhost:8080

# Porta do servidor
SERVER_PORT=8080

# Ambiente (development, production, test)
NODE_ENV=development

# Recarregar automaticamente (development)
AUTO_RELOAD=false

# ========================================
# AUTENTICAÇÃO E SEGURANÇA
# ========================================

# API Key principal para autenticação
AUTHENTICATION_API_KEY=BQYHJGJHJ1234567890ABCDEF

# Tipo de autenticação (apikey ou jwt)
AUTHENTICATION_TYPE=apikey

# Tempo de expiração do token (em segundos)
AUTHENTICATION_TOKEN_EXPIRY=3600

# ========================================
# CONFIGURAÇÕES DO QR CODE
# ========================================

# Número máximo de QR codes por instância
QRCODE_LIMIT=30

# Cor do QR code (formato hexadecimal)
QRCODE_COLOR=#22c55e

# Timeout para geração de QR code (em milissegundos)
QRCODE_TIMEOUT=45000

# Intervalo de atualização do QR code (em segundos)
QRCODE_REFRESH_INTERVAL=30

# ========================================
# CONFIGURAÇÕES DA SESSÃO WHATSAPP
# ========================================

# Nome do cliente para identificação no WhatsApp
CONFIG_SESSION_PHONE_CLIENT=Evolution API

# Nome do navegador para simulação
CONFIG_SESSION_PHONE_NAME=Chrome

# ========================================
# CONFIGURAÇÕES DE LOGGING
# ========================================

# Nível de log (error, warn, info, debug, trace)
LOG_LEVEL=info

# Logs específicos do Baileys
LOG_BAILEYS=error

# Salvar logs no arquivo
LOG_SAVE=true

# Diretório dos logs
LOG_DIR=logs

# ========================================
# CONFIGURAÇÕES DE CORS
# ========================================

# Origens permitidas (separadas por vírgula)
CORS_ORIGIN=*

# Métodos HTTP permitidos
CORS_METHODS=GET,POST,PUT,DELETE,OPTIONS

# Headers permitidos
CORS_ALLOWED_HEADERS=Content-Type,Authorization,apikey
```

### **Configurações de Database**

```env
# ========================================
# CONFIGURAÇÕES DO BANCO DE DADOS
# ========================================

# Provedor do banco (postgresql ou mysql)
DATABASE_PROVIDER=postgresql

# PostgreSQL
DATABASE_CONNECTION_HOST=localhost
DATABASE_CONNECTION_PORT=5432
DATABASE_CONNECTION_DATABASE=evolution_api
DATABASE_CONNECTION_USERNAME=postgres
DATABASE_CONNECTION_PASSWORD=password
DATABASE_CONNECTION_SSL=false
DATABASE_CONNECTION_SSL_KEY=
DATABASE_CONNECTION_SSL_CERT=
DATABASE_CONNECTION_SSL_CA=

# MySQL (alternativa)
# DATABASE_CONNECTION_HOST=localhost
# DATABASE_CONNECTION_PORT=3306
# DATABASE_CONNECTION_DATABASE=evolution_api
# DATABASE_CONNECTION_USERNAME=root
# DATABASE_CONNECTION_PASSWORD=password

# Pool de conexões
DATABASE_CONNECTION_POOL_MIN=2
DATABASE_CONNECTION_POOL_MAX=10
DATABASE_CONNECTION_POOL_IDLE=30000
DATABASE_CONNECTION_POOL_ACQUIRE=60000

# Salvar dados no banco
DATABASE_SAVE_DATA_INSTANCE=true
DATABASE_SAVE_DATA_NEW_MESSAGE=true
DATABASE_SAVE_DATA_MESSAGE_UPDATE=true
DATABASE_SAVE_DATA_CONTACTS=true
DATABASE_SAVE_DATA_CHATS=true
```

### **Configurações de Cache**

```env
# ========================================
# CONFIGURAÇÕES DE CACHE
# ========================================

# Redis (recomendado para produção)
CACHE_REDIS_ENABLED=false
CACHE_REDIS_HOST=localhost
CACHE_REDIS_PORT=6379
CACHE_REDIS_PASSWORD=
CACHE_REDIS_DB=0
CACHE_REDIS_SAVE_INSTANCES=true

# Cache local (fallback)
CACHE_LOCAL_ENABLED=true
CACHE_LOCAL_TTL=3600

# Configurações específicas
CACHE_MESSAGE_TTL=300
CACHE_CONTACT_TTL=3600
CACHE_CHAT_TTL=1800
CACHE_QRCODE_TTL=60
```

### **Configurações de Webhook**

```env
# ========================================
# CONFIGURAÇÕES DE WEBHOOK
# ========================================

# Webhook global
WEBHOOK_GLOBAL_ENABLED=false
WEBHOOK_GLOBAL_URL=https://your-webhook-url.com/webhook
WEBHOOK_GLOBAL_WEBHOOK_HEADERS={"Authorization": "Bearer your-token"}

# Eventos de webhook
WEBHOOK_EVENTS_APPLICATION_STARTUP=true
WEBHOOK_EVENTS_INSTANCE_CREATE=true
WEBHOOK_EVENTS_INSTANCE_DELETE=true
WEBHOOK_EVENTS_QRCODE_UPDATED=true
WEBHOOK_EVENTS_CONNECTION_UPDATE=true
WEBHOOK_EVENTS_MESSAGES_SET=true
WEBHOOK_EVENTS_MESSAGES_UPSERT=true
WEBHOOK_EVENTS_MESSAGES_EDITED=true
WEBHOOK_EVENTS_MESSAGES_UPDATE=true
WEBHOOK_EVENTS_MESSAGES_DELETE=true
WEBHOOK_EVENTS_SEND_MESSAGE=true
WEBHOOK_EVENTS_CONTACTS_SET=true
WEBHOOK_EVENTS_CONTACTS_UPSERT=true
WEBHOOK_EVENTS_PRESENCE_UPDATE=true
WEBHOOK_EVENTS_CHATS_SET=true
WEBHOOK_EVENTS_CHATS_UPSERT=true
WEBHOOK_EVENTS_CHATS_UPDATE=true
WEBHOOK_EVENTS_CHATS_DELETE=true
WEBHOOK_EVENTS_GROUPS_UPSERT=true
WEBHOOK_EVENTS_GROUPS_UPDATE=true
WEBHOOK_EVENTS_GROUP_PARTICIPANTS_UPDATE=true

# Configurações avançadas
WEBHOOK_WEBHOOK_BY_EVENTS=false
WEBHOOK_WEBHOOK_BASE64=false
```

## 🗄️ Configurações do Banco de Dados

### **PostgreSQL Schema**

```sql
-- Configurações específicas para PostgreSQL
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tabela de instâncias
CREATE TABLE "Instance" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "name" VARCHAR(255) UNIQUE NOT NULL,
  "integration" VARCHAR(50),
  "token" VARCHAR(255),
  "connectionStatus" VARCHAR(50) DEFAULT 'close',
  "ownerJid" VARCHAR(255),
  "profileName" VARCHAR(255),
  "profilePicUrl" TEXT,
  "number" VARCHAR(50),
  "businessId" VARCHAR(255),
  "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para performance
CREATE INDEX idx_instance_name ON "Instance"(name);
CREATE INDEX idx_instance_connection_status ON "Instance"(connectionStatus);
```

### **MySQL Schema**

```sql
-- Configurações específicas para MySQL
CREATE TABLE `Instance` (
  `id` VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
  `name` VARCHAR(255) UNIQUE NOT NULL,
  `integration` VARCHAR(50),
  `token` VARCHAR(255),
  `connectionStatus` VARCHAR(50) DEFAULT 'close',
  `ownerJid` VARCHAR(255),
  `profileName` VARCHAR(255),
  `profilePicUrl` TEXT,
  `number` VARCHAR(50),
  `businessId` VARCHAR(255),
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Índices para performance
CREATE INDEX idx_instance_name ON `Instance`(name);
CREATE INDEX idx_instance_connection_status ON `Instance`(connectionStatus);
```

## 🔐 Configurações de Autenticação

### **API Key Configuration**

```typescript
// Configuração no arquivo .env
AUTHENTICATION_API_KEY=your-secure-api-key-here

// Validação da API key
const validateApiKey = (providedKey: string): boolean => {
  const validKey = process.env.AUTHENTICATION_API_KEY;
  return providedKey === validKey && validKey !== 'BQYHJGJHJ';
};
```

### **Token de Sessão (Segurança Extra)**

```typescript
// Configurações de token temporário
const TOKEN_CONFIG = {
  expiry: 3600 * 1000,  // 1 hora em milissegundos
  algorithm: 'HS256',   // Algoritmo para assinatura
  secret: process.env.TOKEN_SECRET || 'fallback-secret'
};

// Geração de token seguro
const generateSessionToken = (): string => {
  return crypto.randomBytes(32).toString('hex');
};
```

## 📱 Configurações do QR Code

### **Configurações de Geração**

```typescript
// Configurações do QR Code
export const QRCODE_CONFIG = {
  // Limite de QR codes por instância
  LIMIT: parseInt(process.env.QRCODE_LIMIT) || 30,

  // Cor do QR code
  COLOR: process.env.QRCODE_COLOR || '#22c55e',

  // Configurações de geração
  OPTIONS: {
    margin: 3,
    scale: 4,
    errorCorrectionLevel: 'H',  // Alto nível de correção
    color: {
      light: '#ffffff',  // Cor de fundo
      dark: process.env.QRCODE_COLOR || '#22c55e'  // Cor do QR code
    }
  },

  // Timeouts
  TIMEOUT: parseInt(process.env.QRCODE_TIMEOUT) || 45000,
  REFRESH_INTERVAL: parseInt(process.env.QRCODE_REFRESH_INTERVAL) || 30,
};
```

### **Configurações de Display**

```css
/* CSS para o container do QR code */
.qr-code-container {
  width: 256px;        /* 256x256 pixels */
  height: 256px;
  margin: 0 auto;
  border: 2px solid #e5e7eb;
  border-radius: 12px;
  background: white;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* Loading spinner */
.qr-loading {
  width: 48px;
  height: 48px;
  border: 4px solid #f3f4f6;
  border-top: 4px solid #22c55e;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
```

## 💾 Configurações de Cache

### **Redis Configuration**

```env
# Redis para cache distribuído
CACHE_REDIS_ENABLED=true
CACHE_REDIS_HOST=localhost
CACHE_REDIS_PORT=6379
CACHE_REDIS_PASSWORD=your-redis-password
CACHE_REDIS_DB=0
CACHE_REDIS_SAVE_INSTANCES=true

# TTL específico para QR codes
CACHE_QRCODE_TTL=60
```

### **Cache Keys Pattern**

```javascript
// Padrão de chaves de cache
const CACHE_KEYS = {
  INSTANCE: 'instance:{instanceName}',
  QRCODE: 'qrcode:{instanceName}',
  CONNECTION_STATE: 'connection:{instanceName}',
  PROFILE: 'profile:{instanceName}',
  WEBHOOK: 'webhook:{instanceName}'
};

// Função para gerar chave
const getCacheKey = (pattern, params) => {
  return pattern.replace(/{(\w+)}/g, (match, key) => params[key]);
};
```

## 🔗 Configurações de Webhook

### **Webhook Events para QR Code**

```typescript
// Eventos específicos de QR code
const QRCODE_EVENTS = {
  QRCODE_UPDATED: 'qrcode.updated',
  CONNECTION_UPDATE: 'connection.update',
  INSTANCE_CREATE: 'instance.create',
  INSTANCE_DELETE: 'instance.delete'
};

// Payload do webhook
const webhookPayload = {
  event: 'qrcode.updated',
  instanceName: 'minha-instancia',
  timestamp: new Date().toISOString(),
  data: {
    qrcode: {
      code: '2@ABC123...',
      base64: 'data:image/png;base64,...',
      count: 1
    },
    connectionStatus: 'connecting'
  }
};
```

### **Configuração de Headers**

```env
# Headers personalizados para webhook
WEBHOOK_GLOBAL_WEBHOOK_HEADERS={
  "Authorization": "Bearer your-webhook-token",
  "Content-Type": "application/json",
  "User-Agent": "Evolution-API/2.0"
}
```

## ⏱️ Configurações de Rate Limiting

### **Rate Limiting para QR Code**

```typescript
// Configuração de rate limiting
const RATE_LIMIT_CONFIG = {
  windowMs: 60 * 1000,  // 1 minuto
  max: 10,              // 10 tentativas por minuto
  message: {
    error: 'Too many requests',
    message: 'Rate limit exceeded. Try again later.',
    retryAfter: 60
  },
  standardHeaders: true,
  legacyHeaders: false,
};

// Aplicar rate limiting por endpoint
const createRateLimit = (maxRequests = 10) => {
  return rateLimit({
    windowMs: RATE_LIMIT_CONFIG.windowMs,
    max: maxRequests,
    message: RATE_LIMIT_CONFIG.message,
    standardHeaders: RATE_LIMIT_CONFIG.standardHeaders,
    legacyHeaders: RATE_LIMIT_CONFIG.legacyHeaders,
  });
};
```

### **Rate Limiting por IP**

```javascript
// Middleware de rate limiting por IP
const rateLimitByIP = (req, res, next) => {
  const clientIP = req.ip || req.connection.remoteAddress;
  const now = Date.now();
  const windowStart = now - RATE_LIMIT_CONFIG.windowMs;

  // Limpar IPs antigos
  rateLimitMap = rateLimitMap.filter(entry => entry.resetTime > windowStart);

  // Verificar limite do IP atual
  let ipEntry = rateLimitMap.find(entry => entry.ip === clientIP);

  if (!ipEntry) {
    ipEntry = { ip: clientIP, count: 0, resetTime: now + RATE_LIMIT_CONFIG.windowMs };
    rateLimitMap.push(ipEntry);
  }

  if (ipEntry.count >= RATE_LIMIT_CONFIG.max) {
    return res.status(429).json(RATE_LIMIT_CONFIG.message);
  }

  ipEntry.count++;
  next();
};
```

## 🎨 Configurações de Interface

### **Configurações de Tema**

```javascript
// Configuração de tema
const THEME_CONFIG = {
  default: 'light',  // Tema padrão
  colors: {
    primary: {
      light: '#22c55e',   // Verde Evolution
      dark: '#16a34a'     // Verde mais escuro
    },
    success: '#10b981',
    error: '#ef4444',
    warning: '#f59e0b',
    info: '#3b82f6'
  },
  fonts: {
    title: ['Lato', 'system-ui', 'sans-serif'],
    body: ['Open Sans', 'system-ui', 'sans-serif']
  }
};
```

### **Configurações de Responsividade**

```css
/* Breakpoints para responsividade */
.mobile-first {
  /* Mobile (default) */
  max-width: 767px;
}

.tablet {
  /* Tablet */
  min-width: 768px;
  max-width: 1023px;
}

.desktop {
  /* Desktop */
  min-width: 1024px;
}

/* Container responsivo */
.qr-container {
  width: 100%;
  max-width: 400px;
  margin: 0 auto;
  padding: 1rem;
}

@media (min-width: 768px) {
  .qr-container {
    max-width: 500px;
    padding: 2rem;
  }
}
```

## ⚙️ Configurações Avançadas

### **Configurações de Proxy**

```env
# Proxy para conexões WhatsApp
PROXY_ENABLED=false
PROXY_HOST=your-proxy-host.com
PROXY_PORT=3128
PROXY_PROTOCOL=http
PROXY_USERNAME=your-username
PROXY_PASSWORD=your-password

# Lista de proxies (para rotação)
PROXY_LIST_URL=https://your-proxy-list-url.com/proxies.txt
```

### **Configurações de SSL/HTTPS**

```env
# Configurações SSL
SSL_ENABLED=false
SSL_KEY_PATH=/path/to/private-key.pem
SSL_CERT_PATH=/path/to/certificate.pem
SSL_CA_PATH=/path/to/ca-certificate.pem

# Configurações HSTS
HSTS_ENABLED=true
HSTS_MAX_AGE=31536000
```

### **Configurações de Performance**

```env
# Configurações de performance
PERFORMANCE_MAX_INSTANCES=100
PERFORMANCE_MAX_CONNECTIONS_PER_INSTANCE=10
PERFORMANCE_CLEANUP_INTERVAL=300000

# Configurações de garbage collection
GC_INTERVAL=30000
GC_THRESHOLD=100
```

## ✅ Validação de Configurações

### **Script de Validação**

```bash
#!/bin/bash
# validate-config.sh - Valida configurações do sistema

echo "=== Validação de Configurações ==="

# 1. Verificar API Key
echo -n "1. API Key: "
if [ -n "$AUTHENTICATION_API_KEY" ] && [ "$AUTHENTICATION_API_KEY" != "BQYHJGJHJ" ]; then
    echo "✅ OK"
else
    echo "❌ NÃO CONFIGURADA"
fi

# 2. Verificar Banco de Dados
echo -n "2. Database: "
if [ "$DATABASE_PROVIDER" = "postgresql" ]; then
    if pg_isready -h "$DATABASE_CONNECTION_HOST" -p "$DATABASE_CONNECTION_PORT" 2>/dev/null; then
        echo "✅ PostgreSQL OK"
    else
        echo "❌ PostgreSQL OFFLINE"
    fi
elif [ "$DATABASE_PROVIDER" = "mysql" ]; then
    if mysqladmin ping -h "$DATABASE_CONNECTION_HOST" -u "$DATABASE_CONNECTION_USERNAME" -p"$DATABASE_CONNECTION_PASSWORD" --silent; then
        echo "✅ MySQL OK"
    else
        echo "❌ MySQL OFFLINE"
    fi
else
    echo "❌ Provider inválido: $DATABASE_PROVIDER"
fi

# 3. Verificar Redis (se habilitado)
if [ "$CACHE_REDIS_ENABLED" = "true" ]; then
    echo -n "3. Redis: "
    if redis-cli -h "$CACHE_REDIS_HOST" -p "$CACHE_REDIS_PORT" ping >/dev/null 2>&1; then
        echo "✅ OK"
    else
        echo "❌ OFFLINE"
    fi
else
    echo "3. Redis: ❌ DESABILITADO"
fi

# 4. Verificar Porta
echo -n "4. Porta $SERVER_PORT: "
if netstat -tln | grep ":$SERVER_PORT " >/dev/null 2>&1; then
    echo "❌ OCUPADA"
else
    echo "✅ LIVRE"
fi

# 5. Verificar Permissões
echo -n "5. Permissões: "
if [ -w "public/qrcode" ]; then
    echo "✅ OK"
else
    echo "❌ SEM PERMISSÃO"
fi

echo "=== Validação Concluída ==="
```

### **Validação Programática**

```typescript
// Validação de configurações no código
export class ConfigValidator {
  static validate(): { valid: boolean; errors: string[] } {
    const errors: string[] = [];

    // Validar API Key
    if (!process.env.AUTHENTICATION_API_KEY ||
        process.env.AUTHENTICATION_API_KEY === 'BQYHJGJHJ') {
      errors.push('AUTHENTICATION_API_KEY deve ser configurada com um valor seguro');
    }

    // Validar Database
    if (!['postgresql', 'mysql'].includes(process.env.DATABASE_PROVIDER)) {
      errors.push('DATABASE_PROVIDER deve ser postgresql ou mysql');
    }

    // Validar Porta
    const port = parseInt(process.env.SERVER_PORT);
    if (isNaN(port) || port < 1 || port > 65535) {
      errors.push('SERVER_PORT deve ser um número entre 1 e 65535');
    }

    // Validar URL
    if (!process.env.SERVER_URL || !this.isValidUrl(process.env.SERVER_URL)) {
      errors.push('SERVER_URL deve ser uma URL válida');
    }

    return {
      valid: errors.length === 0,
      errors
    };
  }

  private static isValidUrl(url: string): boolean {
    try {
      new URL(url);
      return true;
    } catch {
      return false;
    }
  }
}
```

## 🚀 Configurações de Produção

### **Configuração para Produção**

```env
# ========================================
# CONFIGURAÇÕES DE PRODUÇÃO
# ========================================

# Ambiente
NODE_ENV=production

# Servidor
SERVER_URL=https://your-domain.com
SERVER_PORT=8080

# SSL
SSL_ENABLED=true
SSL_KEY_PATH=/etc/ssl/private/your-key.pem
SSL_CERT_PATH=/etc/ssl/certs/your-cert.pem

# Database (PostgreSQL recomendado)
DATABASE_PROVIDER=postgresql
DATABASE_CONNECTION_HOST=localhost
DATABASE_CONNECTION_PORT=5432
DATABASE_CONNECTION_DATABASE=evolution_prod
DATABASE_CONNECTION_USERNAME=evolution_user
DATABASE_CONNECTION_PASSWORD=strong_password_here
DATABASE_CONNECTION_SSL=true

# Cache Redis
CACHE_REDIS_ENABLED=true
CACHE_REDIS_HOST=localhost
CACHE_REDIS_PORT=6379
CACHE_REDIS_PASSWORD=redis_password_here

# Logs
LOG_LEVEL=warn
LOG_SAVE=true
LOG_DIR=/var/log/evolution

# Rate Limiting mais restritivo
QRCODE_LIMIT=10

# CORS restritivo
CORS_ORIGIN=https://your-frontend-domain.com

# Webhook
WEBHOOK_GLOBAL_ENABLED=true
WEBHOOK_GLOBAL_URL=https://your-app.com/webhook

# Performance
PERFORMANCE_MAX_INSTANCES=1000
```

### **Configuração para Desenvolvimento**

```env
# ========================================
# CONFIGURAÇÕES DE DESENVOLVIMENTO
# ========================================

# Ambiente
NODE_ENV=development
AUTO_RELOAD=true

# Servidor
SERVER_URL=http://localhost:8080
SERVER_PORT=8080

# Database
DATABASE_PROVIDER=postgresql
DATABASE_CONNECTION_HOST=localhost
DATABASE_CONNECTION_PORT=5432
DATABASE_CONNECTION_DATABASE=evolution_dev
DATABASE_CONNECTION_USERNAME=postgres
DATABASE_CONNECTION_PASSWORD=password

# Cache (desabilitado para desenvolvimento)
CACHE_REDIS_ENABLED=false
CACHE_LOCAL_ENABLED=true

# Logs detalhados
LOG_LEVEL=debug
LOG_BAILEYS=debug

# Rate Limiting mais permissivo
QRCODE_LIMIT=100

# CORS permissivo
CORS_ORIGIN=*

# Sem SSL
SSL_ENABLED=false
```

## 📊 Monitoramento de Configurações

### **Endpoint de Status**

```typescript
// Endpoint para verificar configurações
app.get('/config/status', (req, res) => {
  const configStatus = {
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV,
    database: {
      provider: process.env.DATABASE_PROVIDER,
      connected: checkDatabaseConnection(),
      instances: getInstanceCount()
    },
    cache: {
      redis: process.env.CACHE_REDIS_ENABLED === 'true' ? 'enabled' : 'disabled',
      connected: checkRedisConnection()
    },
    qrcode: {
      limit: process.env.QRCODE_LIMIT,
      color: process.env.QRCODE_COLOR,
      generated: getQRCodesGenerated()
    },
    performance: {
      uptime: process.uptime(),
      memory: process.memoryUsage(),
      instances: getActiveInstances()
    }
  };

  res.json(configStatus);
});
```

---

**Evolution API** - QR Code Configuration
Versão: 2.0.0
Data: 2025
