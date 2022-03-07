# Operating Vault Server

## Vault Server Architecture

3 Components:

- HTTP/S API
- Barrier
- Storage Backend

![[Pasted image 20211117101044.png]]

### Inside the Barrier

![[Pasted image 20211117102003.png]]

Example:

1. A request comes in through the **API**, and reaches the **Core** within the **Barrier**.
2. The request is then forwarded to the **Path Routing**.
3. Assuming it's a login request, it goes to the **Auth** component.
4. The authentication might have a **Policy** associated.
5. A successful authentication issues a **Token**.
6. There's also the **Secrets Engine**.
7. And the **System**.
8. Any actions that takes place within the barrier needs to be **Audited**.


## Storage Backend

<https://app.pluralsight.com/course-player?clipId=1c25855e-1aa2-4379-9089-1232e53deee7>


## Installation Scenario

<https://app.pluralsight.com/course-player?clipId=0e87a68c-9934-4724-bc4d-4cf66cada910>


## Setting up the Consul Server

<https://app.pluralsight.com/course-player?clipId=baa66d7e-8b5e-4910-8cf1-d669a6000cf6>

Created 2 servers: 1 for Vault and another for Consul

Connect to the server to be used as the Consul server and follow the instructions here: <https://github.com/ned1313/Getting-Started-Vault/blob/master/m5/consul/consul-deploy.sh>


## Install the Consul Agent in the Vault Server

<https://app.pluralsight.com/course-player?clipId=70a94006-81c4-4dea-91d0-50b083c8451f>

Connect to the server to be used as the Vault server and follow the instructions here: <https://github.com/ned1313/Getting-Started-Vault/blob/master/m5/consul/consul-deploy-agent.sh>

## Vault Server Configuration

<https://app.pluralsight.com/course-player?clipId=94763d48-073f-45fd-af3b-c8e5e350b93f>

Connect to the server to be used as the Vault server and follow the instructions here: <https://github.com/ned1313/Getting-Started-Vault/blob/master/m5/vault/vault-deploy.sh>

Note:
```hcl
  disable_mlock = true
```

Prevents any information in memory to be written in disk. Because data in memory means they're within the Barrier, therefore unencrypted.


In 4 minutes of the video, there are some commands used to setup letsencrypt and have a free TLS certificate.


## Server Operations

- Cluster: init & step down
- Vault server: seal, unseal, rekey
- Encryption key: key-status & rotate
- Root token: generate-root
- Storage: migrate

commands: <https://github.com/ned1313/Getting-Started-Vault/blob/master/m5/m5-serveroperations.sh>


## Conclusion

- Nothing leaves the barrier unencrypted
- Everythin in the barrier is audited
- Plan your pilot to support HA


