# DB_INIT

This directory contains files that initialize all the databases, such as postgres ones for `n8n`, `openwebui` and `qdrant`.

`scripts/entrypoint.sh` kicks off the whole process, which in turn executes all the `.sh` files in that same directory, which populate the databases. 

Refer to the README inside `seeds` and `scripts` for more information.

This is mainly for development purposes, but could be adjusted accordingly by changing how the `docker-compose.dev.yml > db-init` service calls the scripts.