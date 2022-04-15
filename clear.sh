VAULT_PID=$(<current_vault_pid)
echo $VAULT_PID
kill -TERM $VAULT_PID

rm -rf current_vault_pid current_root_token raft vault.db vault.log vault.out unseal_keys
