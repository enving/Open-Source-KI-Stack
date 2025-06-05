# DB_INIT

This directory contains files that initialize all the databases, such as posgtres-ones for `n8n` and `openwebui`.

`scripts/entrypoint.sh` kicks off the whole process, which in turn executes all the `.sh` files in that same directory, which populate the databases. 

Refer to the README inside `seeds` and `scripts` for more information.