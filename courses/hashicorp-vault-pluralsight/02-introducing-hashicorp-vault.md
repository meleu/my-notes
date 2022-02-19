# Introducing HashiCorp Vault

[Pluralsight videos](https://app.pluralsight.com/course-player?clipId=83785bed-b9b2-4dd9-b614-c7aace76d623)

## Concepts

**Vault** stores **secrets**, and make them available to **clients** through an **API**.

Clients have access to secrets after **authenticated**.

Authenticated clients receive a **token**. What they can do with the token is determined by a **policies**

The actions performed in Vault are stored in an **audit log**.


## Use Cases

- Secrets Management
- Data Protection


## Comparison

- Azure Key Vault
- AWS Key Management Service
- Hardware security modules
- Configuration management

Main difference: Vault is open-source and cloud agnostic.


## Installation

<https://releases.hashicorp.com/vault>


## Globomantics Scenario

Globomantics is a fictional company. Here's what we have in this scenario:

- a Vault server
- Developers
- Web Tier
- MySQL
- Consul
- Active Directory
- Azure AD (authentication for Web Tier)
- Syslog

## Starting a Dev Server

```bash
vault server -dev
```

## Basic Secret Management

```bash
# write a secret to kv (key-value) store
vault kv put <storepath>/<keyname> key=value

# retrieve the secret
vault kv get <storepath>/<keyname>

# retrieve as json
vault kv get -format=json <storepath>/<keyname>

# get a specific version
vault kv get -version=1 secret/hg2g
vault kv get -version=2 secret/hg2g

# update (same as write)
vault kv put <storepath>/<keyname> key=value

# delete the secret
vault kv delete <storepath>/<keyname>
```

Example:
```bash
# you'll need to clone the repo
# git clone git@github.com:ned1313/Getting-Started-Vault.git

# write a secret
vault kv put secret/hg2g answer=42

# insert a value via API (curl command)
# needs the `marvin.json` file from the git repo
curl \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  --request POST \
  --data @marvin.json \
  "${VAULT_ADDR}/v1/secret/data/marvin

# get the secret
vault kv get secret/hg2g

# getting via API
curl \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  "${VAULT_ADDR}/v1/secret/data/marvin

# getting a specific version via API
curl \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  "${VAULT_ADDR}/v1/secret/data/hg2g?version=1


# put a new secret in and a new
# value for an existing secret
vault kv put secret/hg2g answer=54 ford=prefect
vault kv get secret/hg2g

# delete the secrets
vault kv delete secret/hg2g
vault kv get secret/hg2g

# deleting via API
curl \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  --request DELETE \
  "${VAULT_ADDR}/v1/secret/data/marvin
```


## Conclusion

- Vault is a secrets management platform
- API first, API always
- Cloud agnostic

