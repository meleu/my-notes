# Running the Development Instance

Installing Vault: [[05-installing-vault]]

## Development Mode

- Running on localhost without SSL
- In-memory storage
- Starts unsealed with token cached
- UI enabled
- key/value secrets engine enabled


```bash
vault server -dev
# export VAULT_ADDR='http://127.0.0.1:8200'
# vault login

# it's also possible to specify an arbitrary root token
vault server -dev -dev-root-token-id=1234567890

# interesting info about the token can be seen via
vault token lookup
# examples important info: policies, id
```

Exercises: <https://github.com/ned1313/Installing-and-Configuring-HashiCorp-Vault/tree/main/m3>


## Interacting with Vault

- CLI
- UI
- API (actually everything happens via API)


