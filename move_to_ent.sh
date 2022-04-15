kill -9 $(<current_vault_pid)

./vault-1.10 server -config=vault_server.hcl 2>&1 &

VAULT_PID=$!
echo $VAULT_PID

echo $VAULT_PID > current_vault_pid

sleep 5

export VAULT_ADDR=http://localhost:8200
export VAULT_SKIP_VERIFY=1
export VAULT_LOG_LEVEL=trace

grep Unseal vault.out | awk '{print $4}' | head -n 3 > unseal_keys
grep Unseal vault.out | awk '{print $4}' | head -n 3 | xargs -I{} ./vault-1.10_ent operator unseal {}

VAULT_TOKEN=$(<current_root_token) ./vault-1.10_ent kv get kv/mysecret
