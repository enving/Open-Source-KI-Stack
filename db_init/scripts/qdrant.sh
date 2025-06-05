#!/bin/sh
set -e

QDRANT_URL=${QDRANT_URL:-http://qdrant:6333}
COLLECTION_NAME="FRL1_"

echo "🔍 Waiting for Qdrant at $QDRANT_URL..."

# Wait until Qdrant is responding
for i in $(seq 1 30); do
  if curl -s "$QDRANT_URL/collections" >/dev/null; then
    echo "✅ Qdrant is up!"
    break
  fi
  echo "⏳ Qdrant not ready yet... attempt $i"
  sleep 2
done

# Check if collection exists
if curl -s -o /dev/null -w "%{http_code}" "$QDRANT_URL/collections/$COLLECTION_NAME" | grep -q "200"; then
  echo "✅ Collection '$COLLECTION_NAME' already exists."
else
  echo "📦 Creating collection '$COLLECTION_NAME'..."
  curl -X PUT "$QDRANT_URL/collections/$COLLECTION_NAME" \
    -H "Content-Type: application/json" \
    -d '{
      "vectors": {
        "size": 1536,
        "distance": "Cosine"
      }
    }'
  echo "✅ Collection '$COLLECTION_NAME' created."
fi