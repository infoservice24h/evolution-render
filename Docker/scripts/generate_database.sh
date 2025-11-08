#!/bin/bash

source ./Docker/scripts/env_functions.sh

if [ "$DOCKER_ENV" != "true" ]; then
    export_env_vars
fi

if [[ "$DATABASE_PROVIDER" == "postgresql" || "$DATABASE_PROVIDER" == "mysql" || "$DATABASE_PROVIDER" == "psql_bouncer" ]]; then
    export DATABASE_URL
    echo "Generating database for $DATABASE_PROVIDER"
    echo "Database URL: $DATABASE_URL"

    # --- MODIFICAÇÃO AQUI ---
    echo "Deploying Prisma migrations..."
    # Use o nome real do schema ANTES da substituição pelo runWithProvider.js
    npx prisma migrate deploy --schema ./prisma/postgresql-schema.prisma
    if [ $? -ne 0 ]; then
        echo "Prisma migrate deploy failed"
        exit 1
    else
        echo "Prisma migrate deploy succeeded"
    fi
    # --- FIM DA MODIFICAÇÃO ---

    npm run db:generate
    if [ $? -ne 0 ]; then
        echo "Prisma generate failed"
        exit 1
    else
        echo "Prisma generate succeeded"
    fi
else
    echo "Error: Database provider $DATABASE_PROVIDER invalid."
    exit 1
fi
