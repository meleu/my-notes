# Deploying Vault Server


## Certificate Provisioning

- Third party certificate from public CA
- Using ACME protocol and Let's Encrypt
- Can be automated for renewal
- Prerequisites
    - Registered public domain
    - OpenSSL installed


Files for practice: <https://github.com/ned1313/Installing-and-Configuring-HashiCorp-Vault/blob/main/m5/1-cert-gen/certbot.sh>

Interesting certbot command:
```bash
sudo certbot \
  certonly \
  --manual \
  -d $vm_request_name \
  --agree-tos \
  -m noone@${domain_name} \
  --no-eff-email \
  --preferred-challenges dns
```

Interesting command to create the PFX file:
```bash
openssl pkcs12 \
  -export \
  -out vm-certificate-to-import.pfx \
  -inkey vm_privkey.pem \
  -in vm_fullchain.pem \
  -passout pass:
```


## Deploy the Azure VM Infrastructure

<https://app.pluralsight.com/course-player?clipId=7ae296b5-d429-4c65-953a-b3bffca735ed>



## Azure Kubernetes Service Deployment

- Prerequisites:
    - kubectl
    - Helm

<https://github.com/ned1313/Installing-and-Configuring-HashiCorp-Vault/blob/main/m5/3-aks/1-spinning-up-aks.sh>

## Create the TLS Secret & Deploy the Consul Storage

<https://github.com/ned1313/Installing-and-Configuring-HashiCorp-Vault/blob/main/m5/3-aks/2-deploying-using-helm.sh>


## Inspecting the Overrides File

<https://github.com/ned1313/Installing-and-Configuring-HashiCorp-Vault/blob/main/m5/3-aks/overrides.yaml>

Possible version I'll need for Claro:
```yaml
# Vault Helm Chart Value Overrides
global:  
  enabled: true  
  tlsDisable: true

server:

  readinessProbe:
    enabled: true
    path: "/v1/sys/health?standbyok=true&sealedcode=204&uninitcode=204"
  livenessProbe:
    enabled: true
    path: "/v1/sys/health?standbyok=true"
    initialDelaySeconds: 60

  extraEnvironmentVars:
    VAULT_SKIP_VERIFY: true

  extraVolumes:
    - type: secret
      name: vault-tls

  ha:
    enabled: true
    replicas: 3
    config: |
      listener "tcp" {
        address = "[::]:8200"
        cluster_address = "[::]:8201"
      }

      # probably it would be postgres
      storage "consul" {
        path = "vault"
        address = "HOST_IP:8500"
      }

      service_registration "kubernetes" {}

  # not sure about the configs here
  service:
    type: LoadBalancer
    annotations: |
      "service.beta.kubernetes.io/azure-dns-label-name": "CLUSTER_NAME"
```



## Module Summary

- Preparing TLS certificates and files
- Deploying Vault on a VM
- Deploying Vault with a helm chart
