# OpenWebUI

All "Open WebUI" JSON files inside this directory will be pre-loaded into the Open WebUI database (`postgres-owui`).

Function JSON files **have** to start with `function-`, otherwise they won't be read. 

Likewise, the config file has to start with `config-`. If multiple `config` files exist, all of them will be inserted with an increeasing ID. The implications of this are unknown - but, it looks like it just uses the last inserted one.
