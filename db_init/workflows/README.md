# Workflows

All workflows inside this directory will be pre-loaded into the n8n database (`postgres-n8n`). 
If one with the same ID already exists in the database, the query will silently fail and be skipped.

These JSON files are also compatible with the native import function found in n8n, so if you already have an existing installation, you can import them manually, too.