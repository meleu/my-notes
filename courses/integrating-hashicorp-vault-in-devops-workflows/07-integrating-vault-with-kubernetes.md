# Integrating Vault With Kubernetes

## Vault Helm Chart

```bash
# helm 3 & kubernetes 1.14+
# use helm --dry-run flag outside of local experiments

helm install vault hashicorp/vault # standalone

helm install vault hashicorp/vault \
  --set "server.dev.enabled=true" # dev

helm install vault hashicorp/vault \
  --set "server.ha.enabled=true" # HA

helm install vault hashicorp/vault \
  --set "injector.externalVaultAddr=..." # external
```


