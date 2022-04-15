if [ ! -f vault-1.10_ent ]
then
    if [ ! -f vault_1.10.0+ent_linux_amd64.zip ]
    then
        curl -o vault_1.10.0+ent_linux_amd64.zip https://releases.hashicorp.com/vault/1.10.0+ent/vault_1.10.0+ent_linux_amd64.zip
    fi
    unzip -o vault_1.10.0+ent_linux_amd64.zip vault && mv vault vault-1.10_ent
fi

if [ ! -f vault-1.10 ]
then
    if [ ! -f vault_1.10.0_linux_amd64.zip ]
    then
        curl -o vault_1.10.0_linux_amd64.zip https://releases.hashicorp.com/vault/1.10.0/vault_1.10.0_linux_amd64.zip
    fi
    unzip -o vault_1.10.0_linux_amd64.zip vault && mv vault vault-1.10
fi

if [ ! -f vault-1.4.6 ]
then
    if [ ! -f vault_1.4.6_linux_amd64.zip ]
    then
        curl -o vault_1.4.6_linux_amd64.zip https://releases.hashicorp.com/vault/1.4.6/vault_1.4.6_linux_amd64.zip
    fi
    unzip -o vault_1.4.6_linux_amd64.zip vault && mv vault vault-1.4.6
fi

VAULT_VERSION=1.4.6

./vault-$VAULT_VERSION server -config=vault_server.hcl 2>&1 &
VAULT_PID=$!
echo $VAULT_PID

echo $VAULT_PID > current_vault_pid

sleep 5

export VAULT_ADDR=http://localhost:8200
export VAULT_SKIP_VERIFY=1
export VAULT_LOG_LEVEL=trace

./vault-$VAULT_VERSION operator init 2>&1 | tee vault.out

grep Unseal vault.out | awk '{print $4}' | head -n 3 > unseal_keys
grep Unseal vault.out | awk '{print $4}' | head -n 3 | xargs -I{} ./vault-$VAULT_VERSION operator unseal {}

if [ ! -f current_root_token ]
then
    ROOT_TOKEN=$(grep "Root Token" vault.out | awk '{print $4}')
    echo $ROOT_TOKEN > current_root_token
fi

sleep 10
VAULT_TOKEN=$(<current_root_token) ./vault-$VAULT_VERSION secrets enable -version=2 kv
sleep 2 
VAULT_TOKEN=$(<current_root_token) ./vault-$VAULT_VERSION kv put kv/mysecret foo=bar 

cat current_root_token
echo kill -TERM $VAULT_PID
