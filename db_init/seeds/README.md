# Seeds

This sets up the databases schema, users and other basic stuff, ideally **not** including any higher-level changes. It should only be used to get the application working in it's basic, and known, state.

TODO: For now, not the entire `seeds` directory is being read, rather, the `scripts/*` point to a specific `.sql` file which is then executed conditionally. In other words, the filenames are static, unless changed in `scripts/*`.