# Using Vault Tokens

## Token Overview

Tokens are a collections of data used to access Vault.

## Token Creation

- Auth method
- Parent token
- Root token


## Root Tokens

- Root tokens can do **ANYTHING**.
- Do not expire
- Created in three ways
    - Initialize Vault server
    - Existing root token
    - Using operator command
- Revoke as soon as possible

Situations where you use a root token:

- Perform initial setup
- Auth method unavailable
- Emergency situation

**Revoke the root token as soon as possible**

## Token Properties

- id
- accessor
- type
- policies
- TTL (Time To Live)
- orphaned


## Demo

<https://github.com/ned1313/Hashicorp-Certified-Vault-Associate-Getting-Started/tree/main/m6>