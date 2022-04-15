VAULT_ADDR=http://localhost:8200 VAULT_SKIP_VERIFY=1 VAULT_TOKEN=$(cat current_root_token) ./vault-1.10_ent kv put kv/mysecret foo=bar
