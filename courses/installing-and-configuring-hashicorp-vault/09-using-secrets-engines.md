# Vault: Using Secrets Engines

Secrets engines are plugins used by Vault to handle sensitive data.

3 different ways that secret engines handle sensitve data:

- Store: sensitive data is stored securely by Vault
- Generate: Vault generates and manages sensitive data
- Encrypt: Vault provides encryption services for existing data


## Key Value Engine

Store key/value pairs at a path.


## Transit Engine

- Encryption as a service
- Does not store data
- Supported actions:
    - Encrypt/decrypt
    - Sign and verify
    - Generate hashes
    - Create random bytes
- Engine manages keys


## Globomantics Requirements

- Enable a k/v secrets engine for developers
- Enable a Transit secrets engine for DBAs


## Enabling Secrets engines

- Engines are enabled on a path
    - Defaults to engine name
- All engines are enabled on `/sys/mounts`


## Basic commands

```bash
vault secrets list

# enable a new secrets engine
vault secrets enable [options] TYPE
vault secrets enable -path=GloboKV kv

# tune a secrets engine setting
vault secrets tune [options] PATH
vault secrets tune -description="Globomantics Default KV" GloboKV

# move an existing secrets engine
vault secrets move [options] SOURCE DEST
vault secrets move GloboKV GlovoKV1

# disable a secrets engine
# DESTROYS ALL DATA!!
vault secrets disable [options] PATH
vault secrets disable GloboKV1
```




