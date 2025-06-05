#!/bin/sh
set -e
# set -x

POSTGRES_HOST="postgres-owui"
POSTGRES_PORT="5432"
POSTGRES_DB="openwebui"
POSTGRES_USER="owui_user"
POSTGRES_PASSWORD=${POSTGRES_N8N_PASSWORD:-dev_pwd}

export PGPASSWORD="$POSTGRES_PASSWORD"

OPENWEBUI_DIR="/db_init/openwebui"

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
  psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f ./db_init/seeds/openwebui.sql
  echo "✅ Database seeded!"
fi

for FUNCTION_FILE in "$OPENWEBUI_DIR"/function-*.json; do
  echo "🔎 Processing $FUNCTION_FILE..."

  # If the JSON file is an array, iterate over each object
  COUNT=$(jq 'length' "$FUNCTION_FILE")
  for i in $(seq 0 $((COUNT - 1))); do
    ID=$(jq -r ".[$i].id" "$FUNCTION_FILE")
    USER_ID=$(jq -c ".[$i].user_id" "$FUNCTION_FILE" | sed "s/'/''/g")
    NAME=$(jq -r ".[$i].name" "$FUNCTION_FILE")
    TYPE=$(jq -r ".[$i].type" "$FUNCTION_FILE")
    CONTENT=$(jq -r ".[$i].content" "$FUNCTION_FILE" | sed "s/'/''/g")
    META=$(jq -c ".[$i].meta" "$FUNCTION_FILE" | sed "s/'/''/g")
    CREATED_AT=$(jq -r ".[$i].created_at" "$FUNCTION_FILE")
    UPDATED_AT=$(jq -r ".[$i].updated_at" "$FUNCTION_FILE")
    VALVES=$(jq -c ".[$i].valves" "$FUNCTION_FILE" | sed "s/'/''/g")
    IS_ACTIVE=$(jq -r ".[$i].is_active" "$FUNCTION_FILE")
    IS_GLOBAL=$(jq -r ".[$i].is_global" "$FUNCTION_FILE")

    psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" <<EOF
INSERT INTO "public"."function"
  ("id", "user_id", "name", "type", "content", "meta", "created_at", "updated_at", "valves", "is_active", "is_global")
VALUES
  ('$ID', '$USER_ID', '$NAME', '$TYPE', '$CONTENT', '$META', '$CREATED_AT', '$UPDATED_AT', '$VALVES', '$IS_ACTIVE', '$IS_GLOBAL')
EOF
    echo "✅ Workflow $NAME ($ID) inserted!"
  done
done

# Process config-*.json files
for CONFIG_FILE in "$OPENWEBUI_DIR"/config-*.json; do
  echo "🔎 Processing config $CONFIG_FILE..."

  # Load the JSON content as a single-line escaped string for SQL
  CONFIG_DATA=$(jq -c '.' "$CONFIG_FILE" | sed "s/'/''/g")
  VERSION=$(jq -r ".version" "$CONFIG_FILE")

  psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" <<EOF
INSERT INTO "public"."config"
  ("data", "version", "created_at", "updated_at")
VALUES
  ('$CONFIG_DATA', '$VERSION', NOW(), NOW())
EOF

  echo "✅ Config from $CONFIG_FILE inserted!"
done

echo "🎉 All functions and configs inserted successfully!"
