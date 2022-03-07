# Interacting with Vault

## Running Vault in Development Mode

### install

<https://learn.hashicorp.com/tutorials/vault/getting-started-install>

```bash
# add HashiCorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

# add the official HashiCorp Linux repository
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Update and install
sudo apt-get update && sudo apt-get install vault
```

### Launch vault in dev mode

- Dev Mode Features:
    - Running on localhost
    - Without SSL
    - in-memory storage
    - starts unsealed
    - UI enabled
    - key/value secrets engine enabled

```bash
vault server -dev
```

Remember to store Vault server address and root token in env vars.


## Exercise files

<https://github.com/ned1313/Hashicorp-Certified-Vault-Associate-Getting-Started>

## Interacting with Vault

- CLI
- UI (web)
- API


### Vault CLI

```bash
# basic vault command structure
vault <command> <subcommand> [options] [ARGS]

# getting help
vault <command> -help
vault path-help PATH
```


### Environment Variables

Env vars used by the CLI:

- `VAULT_ADDR` - Vault server address
- `VAULT_TOKEN` - token value for requests
- `VAULT_SKIP_VERIFY` - no verify TLS certificate
- `VAULT_FORMAT` - specify output format


### Vault UI

- Uses the API
- Not enabled by default
- Run on same port as API
- Basic console

Usually available at <http://127.0.0.1:8200/ui/>


### Vault API

- RESTful
- Used by UI and CLI
- Only way to interact with Vault
- `curl` with `X-Vault-Token` header


## Key Takeaways

- Vault is a single binary for client and server
- Vault can be started in dev mode for local testing
- All Vault communication goes through the API
- You can interact with Vault using the CLI, UI or API
- Use `VAULT_ADDR` and `VAULT_TOKEN`with the CLI

