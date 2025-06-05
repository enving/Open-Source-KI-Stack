#!/bin/sh
set -e
# set -x

POSTGRES_HOST="postgres-n8n"
POSTGRES_PORT="5432"
POSTGRES_DB="n8n"
POSTGRES_USER="n8n_user"
POSTGRES_PASSWORD=${POSTGRES_N8N_PASSWORD:-dev_pwd}

export PGPASSWORD="$POSTGRES_PASSWORD"

WORKFLOW_DIR="/db_init/n8n"

echo "🔍 Waiting for PostgreSQL at $POSTGRES_HOST:$POSTGRES_PORT..."

# Wait until Postgres is responding
for i in $(seq 1 60); do
  if pg_isready -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" >/dev/null 2>&1; then
    echo "✅ PostgreSQL is up!"
    break
  fi
  echo "⏳ PostgreSQL not ready yet... attempt $i"
  sleep 2
done

echo "🔎 Checking if table already exists..."

TABLE_EXISTS=$(psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -t -c "
  SELECT to_regclass('public.user') IS NOT NULL;" | xargs)

if [ "$TABLE_EXISTS" = "t" ]; then
  echo "✅ Table exists. Skipping seed."
else
  echo "⚡️ Seeding database..."
  psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f ./db_init/seeds/n8n.sql
  echo "✅ Database seeded!"
fi

echo "⚡️ Inserting workflows from directory: $WORKFLOW_DIR"

PROJECT_ID="default-project-id"

for WORKFLOW_FILE in "$WORKFLOW_DIR"/workflow-*.json; do
  echo "🔎 Processing $WORKFLOW_FILE..."

  # Extract JSON fields
  NAME=$(jq -r '.name' "$WORKFLOW_FILE")
  NODES=$(jq -c '.nodes' "$WORKFLOW_FILE" | sed "s/'/''/g")
  CONNECTIONS=$(jq -c '.connections' "$WORKFLOW_FILE" | sed "s/'/''/g")
  SETTINGS=$(jq -c '.settings' "$WORKFLOW_FILE" | sed "s/'/''/g")
  PINDATA=$(jq -c '.pinData' "$WORKFLOW_FILE" | sed "s/'/''/g")
  VERSION_ID=$(jq -r '.versionId' "$WORKFLOW_FILE")
  ID=$(jq -r '.id' "$WORKFLOW_FILE")
  META=$(jq -c '.meta' "$WORKFLOW_FILE" | sed "s/'/''/g")

  psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" <<EOF
INSERT INTO "public"."workflow_entity"
  ("name", "active", "nodes", "connections", "createdAt", "updatedAt", "settings", "staticData", "pinData", "versionId", "triggerCount", "id", "meta", "parentFolderId", "isArchived")
VALUES
  ('$NAME', 't', '$NODES', '$CONNECTIONS', NOW(), NOW(), '$SETTINGS', NULL, '$PINDATA', '$VERSION_ID', 0, '$ID', '$META', NULL, 'f');
EOF

  psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" <<EOF
INSERT INTO "public"."shared_workflow"
  ("workflowId", "projectId", "role", "createdAt", "updatedAt")
VALUES
  ('$ID', '$PROJECT_ID', 'workflow:owner', NOW(), NOW());
EOF

  echo "✅ Workflow $NAME ($ID) inserted!"
done

echo "🎉 All workflows inserted successfully!"
