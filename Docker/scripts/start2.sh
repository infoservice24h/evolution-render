#!/bin/bash
set -e # Sai se algum comando falhar

echo "Starting Evolution API..."

# Passo 1: Executar as migrações do Prisma
echo "Deploying Prisma migrations..."
# O DATABASE_URL deve estar definido como variável de ambiente no Render
npx prisma migrate deploy --schema ./prisma/postgresql-schema.prisma
if [ $? -ne 0 ]; then
    echo "Prisma migrate deploy failed"
    exit 1
else
    echo "Prisma migrate deploy succeeded"
fi

# Passo 2: Iniciar a aplicação Node.js
echo "Starting Node.js application..."
npm run start:prod

# Opcional: adicione um trap para lidar com sinais de parada corretamente
# trap 'exit' SIGTERM
# wait # Aguarda processos em segundo plano, se houver
