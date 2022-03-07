# Selecting a Deployment Model

## Deployment Components

- Compute
    - Bare Metal / VM / Container
    - Multiple Operating Systems
- Network
    - Client and storage communication
    - Load balancer or DNS
- Storage
    - HashiCorp or community support
    - High availability support
- Certificates
    - API TLS certificate
    - Storage backend traffic


## Deployment Considerations

- High Availability
    - Service level agreement and uptime
    - Component failure
- Monitoring
    - Health monitoring
    - Capacity monitoring
- Protection
    - Key shares
    - Server configuration
    - Storage backend
- Key shares & Unseal key
    - Distribute key shares
    - Auto unseal


## Configuration Options

- HCL or JSON
- Supports multiple files
- Passed using config flag
    - It can be specified multiple times or be a directory with multiple files.
- Loaded when service starts
    - No way to update configs without a restart


## Parameter Categories

- Single value
- Listener (how Vault listen/respond)
- Storage (storage backend configs)
- Seal (define auto-unseal)
- Telemetry (sending information to external monitoring services)
- Service registration (register Vault either with Kubernetes or Consul and make services available)


### Single Value Parameters

`Vault-Confic.hcl`
```hcl
# General Settings
ui = [true | false]

disable_mlock = [true | false]

log_level = "level"
log_format = ["standard" | "json"]

max_lease_ttl = "768h"
default_lease_ttl = "768h"

cluster_addr = "https://address:port"
api_addr = "https://address:port"
```

### Listener Parameters

- Address Information
- HTTP timeouts
- Request control
- Proxy behavior
- TLS settings
- X-Forwarded-For

Example `Vault-Config.hcl`:
```hcl
# Listener Settings

listener "tcp" {
  # listener address
  address = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"

  # TLS settings
  tls_disable = 0;
  tls_cert_file = "/opt/vault/tls/vault-full.pem"
  tls_key_file = "/opt/vault/tls/vault-key.pem"
  tls_min_version = "tls12"
}
```


### Storage Backend Parameters

Defines where data is persisted.

- Storage types
    - Object
    - Database
    - Key/Value
    - File
    - Memory (doesn't persist)
- Integrated Storage (Raft) - complicated
    - Local storage
    - Highly available
    - Replicated
- Things to consider:
    - Support
    - High availability
    - Storage configuration

Example with Consul `Vault-Config-Consul-Storage.hcl`
```hcl
# Storage Settings
storage "consul" {
  address = "127.0.0.1:8500"
  path = "vault"
}
```


## Deployment Design

Globomantics Scenario

- Deploy in Azure
- Publicly available endpoint
- Use third-party certificates
- SLA of 99.99% for Vault
- Auto unseal of Vault


Claro Scenario

- Deploy on kubernetes
- Internally available
- Use own certificates (??)
- SLA of 99.99% for Vault (??)
- Auto unseal (not sure how)

## Azure Kubernetes Service Deployment

Example for Globomantics

> HashiCorp recommends a dedicated k8s cluster for Vault due to the sensitive nature of the information being stored by Vault.

- Dedicated k8s cluster
- Vault namespace
- In the Vault namespace, create a Secret with the TLS certificate
- Consul (available as a Helm chart)
- Vault (available as a Helm chart)
- Public endpoint
- public hostname defined through annotations for the Service


## Module Summary

- Vault deployment depends on requirements
- Vault configuration is define by HCL or JSON files
- Listener controls how Vault receives requests
- Storage determines where data is stored


