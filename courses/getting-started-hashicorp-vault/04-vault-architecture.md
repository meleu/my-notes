# Learning the Vault Architecture

 ## Vault Components
 
 - Storage Backends (acho que isso será o ponto crítico na Claro)
 - Secrets Engines (Core Functionality you're after)
 - Authentication Methods
 - Audit Devices
 
 ### Storage Backends
 
 - Storage is defined in the **main Vault configuration file** with desired parameters.
 - There is **only one** storage backend per Vault cluster!
 
 
 ### Secret Engines
 
 - Can *store*, *generate*, or *encrypt* data.
 - Many secrets engines connect to other services to **generate dynamic credentials** on-demand.
 - Many secrets engines can be *enabled* and used as needed.
     - Even _multiple_ secrets engines of the _same type_.
 - Secret engines are enabled and isolated at a "path"
     - All interactions are done directly with the "path" itself


### Auth Methods

- Responsible for assigning identity and policies to a user
- Multiple authentication methods can be enabled depending on your use case.
    - Can be differentiated by **human vs. system** methods
- Once authenticated, Vault will **issue a client token** used to make all subsequent requests (read/write).
    - The **fundamental goal** of all auth methods is to obtain a token
    - Each token has an associated **policy(ies)** and a **TTL**.
- Default authentication method for a new Vault deployment = _tokens_


### Audit Devices

- Keeps detailed log of all *requests* and *responses*.
- Log is formatted using JSON
- *Sensitive info is hashed*
- Can (and should) have _more than one_ audit device enabled
    - Vault requires at least one audit device to write the log before completing the Vault request - if enabled
    - **Prioritizes safety over availability**


## Vault Architecture

![[Pasted image 20211102100804.png]]

**The Barrier:**

- All the core components in the middle, are protected by the **Barrier**.
- A request must be authenticated in order to cross the Barrier.
- Anything that moves outside the Barrier is encrypted.
- Vault inherently don't trust the storage backend (that's why the data there is encrypted)


### Vault Paths

- Everything in Vault is path-based
- The path *prefix* tells Vault which component a request should be routed
- Secret engines, auth methods, and audit devices are "mounted" at a specified path
    - Often referred to as a "**mount**"
- System backend is a default backend in Vault, which is mounted at the `/sys` endpoint
- Vault components can be enabled at **ANY** path you'd like using the `--path` flag
    - Each componentndoes have a *default path* you can use as well
- Reserved Paths:
    - `auth/`
    - `cubbyhole/`
    - `identity/`
    - `secret/`
    - `sys/`


## Vault Data Protection

![[Pasted image 20211102120840.png]]

- Master Key:
    - Used to decrypt the encryption key
    - Never written to storage when using traditional unseal mechanism
    - Written to core/master (storage backend) when using Auto Unseal

- Encryption Key
    - used to encrypt/decrypt data written to storage backend
    - encrypted by the Master Key
    - stored alongside the data in a keyring on the storage backend
    - can be easily rotated (manual operation)


## Seal and Unseal

- Vault starts **sealed**, meaning it knows where to access the data, and how, but can'r decrypt it.
- Unsealing Vault means that a node can **reconstruct the master key** in order to decrypt the encryption key, and ultimately read the data.
- After unsealing, the encryptin key is *stored in memory*.
- Sealing Vault means to "throw away" the encryption key and require another unseal to perform any further operations.
    - You can manually seal Vault via UI, CLI or API
- When would I seal Vault?
    - Key shards are inadvertently exposed
    - Detection of a compromise or network intrusion
    - Spyware/malware on the Vault nodes

### Seal and Unseal - Options

- Key Sharding (Shamir)
- Cloud Auto Unseal (requires a cloud provider)
- Transit Auto Unseal (requires another Vault cluster)


### Unsealiing with Auto Unseal

It's a service used with cloud providers.


### Transit Auto Unseal

- Uses the Transit Secret Engine of a different Vault cluster
- The Transiot Secret Engine may be configured in a Namespace
- The Transit Unseal supports key rotation
- The core Vault cluster must be highly-available


## Vault Initialization

- Initializing Vault prepares the backend storage to receive data
- Only need to initialize **one time** via a single node
- Vault initialization is when Vault **creates the master key and key shares**
- Options to define thresholds, key shares, recovery keys, and encryption.
- Vault initialization is also where the initial root token is generated and returned to the user.


## Configuration File

- Written in HCL or JSON
    - HCL = HashiCorp Configuration Language
- Specified when starting Vault using the `-config`flag:
```
vault server -config <file>
```
- usually stored in `/etc/vault.d/vault.hcl`



### What's configured in the file?

- Storage Backend
- Listener(s) and Port
- TLS certificate
- Seal Type
- Cluster Name
- Log Level
- UI
- Cluster IP and Port
- etc...

### What's NOT in the file?

- Secrets Engines
- Authentication Methods
- Audit Devices
- Policies
- Entities & Groups

### Available Stanzas

- `seal` - seal type
- `listener` - addresses/ports for Vault
- `storage` - storage backend
- `telemetry` - where to publish metrics to upstream systems

### Examples of parameters

- `cluster_name` - identifier for the cluster
- `log_level` - specifies the log level to use
- `ui` - enables the built-in web UI
- `api_addr` - address to advertise to other Vault servers
- `cluster_addr` - address to advertise to other Vault servers


## Storage Backend

- **location** for storage of Vault data
- Open-source users can choose a storage backend based on their preferences.

![[Pasted image 20211104171653.png]]


## Audit Device

- keep detailed log of all authenticated requests and responses to Vault
- JSON format
- sensitive information is hashed
- should be protected as a user with permission can still check the value of those secrets via `/sts/audit-hash` API and compare to the log file
```
vault audit enable file file_path=/var/log/vault_audit_log.log
```


- File:
    - writes to a file
    - does NOT assist with log rotation
    - use fluentd or similar tool to send to collector
- Syslog:
    - writes to a syslog
    - sends to a local agent only
- Socket:
    - writes to a tcp, udp, or unix socket
    - unreliable (due to underlying protocol)
    - should be used where strong guarantees are required

**Notes**:

- can and should have more than one audit device enabled
- if there are any audit device enabled, Vault requires that it can write to the log before completing the client request.
    - Prioritizes safety over availability.
- If Vault cannot write to a persistent log, it will stop responding to client requests - which means Vault is down!


### Vault Interfaces

- Three type of interfaces:
    - UI
    - CLI
    - HTTP API

- Not all features are available via UI and CLI, but **all** features can be accessed using HTTP API.
- UI must be enabled via configuration file
- Authentication is **required** to access any of the interfaces

![[Pasted image 20211104174651.png]]
