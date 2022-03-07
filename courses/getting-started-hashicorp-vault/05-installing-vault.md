# Installing Vault

## Installing and Running a Vault Server

- Vault is platform agnostic.
    - kubernetes
    - cloud-based machines
    - vmware virtual machines
    - physical servers
    - laptop

### Order of Operations

1. Install Vault
2. Create Configuration File
3. Initialize Vault
4. Unseal Vault

### Installing Vault

- <https://vaultproject.io>
- <https://releases.hashicorp.com/vault>

Using the Vault Helm Chart to install/configure Vault on Kubernetes:
```bash
helm install vault hashicorp/vault
```

#### Running Vault Dev Server

```bash
vault server -dev
```

- Quickly run Vault without configuration
- **Non-persistent - runs in memory**
- Automatically initialized and unsealed
- Insecure - doesn't use TLS
- Enables the UI - available at localhost
- Listens to 127.0.0.1:8200
- Provides an Unseal key
- Mounts a key-value v2 secret engine
- Automatically logs in as root
- Provides a root token

**NEVER USE DEV SERVER MODE IN PRODUCTION**

dummy session:
```bash
vault server -dev

vault status

# get the list of currently enabled secret engines
vault secrets list

# write data to a secret
vault kv put secret/vaultcourse/meleu user=meleu

# get data back
vault kv get secret/vaultcourse/meleu
```


## Running Vault Server in Production

- Deploy one or more persistent nodes via configuration file
- Use a **storage backend** that meets the requirements
- Multiple Vault nodes will be configured as a cluster
- Deploy close to your applications
- Most likely, you'll **automate the provisioning of Vault**.


Starting Vault:
```bash
vault server -config=<file>
```

In production it'll probably be managed by `systemctl`.

(In the course the author mentions "you also need a systemd file to manage the service". I don't know what exactly he means with "systemd file".)

### Single Node

Not a recommended architecture, because:

- No redundancy
- No scalability

Prefer a Multi-Node setup.


### Step-by-step Manual Install

1. download
2. unpack
3. set path to executable
4. add configuration file & customize
5. create systemd service file
6. download consul from hashicorp?
7. configure and join consul cluster?
8. launch vault service


### Lab

- files needed:
    - `/etc/systemd/system/vault.service` - [example](https://github.com/btkrausen/hashicorp/blob/master/vault/config_files/vault.service)
    - `/etc/vault.d/vault.hcl` - [example](https://github.com/btkrausen/hashicorp/blob/master/vault/config_files/vault.hcl)

Once you have the files:
```bash
sudo systemctl start vault

# check if it's running:
sudo systemctl status vault

# check the logs
sudo journalctl -u vault
```


## Configuring Integrated Storage Backend

