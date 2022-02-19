# Introduction to Vault

## How Vault Works

Gostei da analogia com um hotel:

Quando você chega no hotel, você fornece seus documentos pessoais, esse é o processo de autenticação, onde você prova que você é quem você diz que é. No contexto de software, isso equivale a fornecer o login/senha para autenticação.

Após ser autenticado, você receberá um cartão magnético que será utilizado para abrir a porta do seu quarto, te dar acesso à academia, restaurante, spa, etc. Isso traz praticidade no acesso à tais recursos, pois agora você não precisa se autenticar toda hora, basta usar o cartão.

Dependendo do plano de hospedagem contratado, você receberá um cartão com acessos diferentes.

A validade do cartão também será determinado pelo número de diárias que você contratou.

No contexto de software, o cartão magnético equivale ao token. A validade do cartão é conhecido como TTL (Time To Live).

Esse processo de autenticação descrito anteriormente é realizado pelos Cloud Providers (ou on-premises geralmente com uso de Active Directory).

Um problema que acontece é que cada Cloud Provider seria o responsável por autenticar o usuário, e existem situações onde a aplicação precisa se autenticar com diferentes organizações.

Utilizando o Vault, ele será o *Single Source of Truth*, pois o usuário se autentica no Vault e este será capaz de se autenticar com cada uma das outras organizações.


## Benefits of HashiCorp Vault

- Store long-lived, static secrets.
- Dynamically generate secrets, upon request.
- Fully-featured API.
- Identity-based access across different clouds and Systems.
- Provide Encryption as a Service.
- Act as a root or intermediate Certificate Authority.

## Use Cases

- Centralize the storage of secrets `<-- my case`
- Migrate to dynamically generated secrets
- Secure data with a centralized workflow for encryption operations
- Automate the generation of X.509 certificates (Wow! Vault can gerate TLS certs!)
- Migrate to identity based access


## Vault - Compare Versions

- Open Source (free!)
- Enterprise
- Vault on HCP (HashiCorp Hosted & Managed)
