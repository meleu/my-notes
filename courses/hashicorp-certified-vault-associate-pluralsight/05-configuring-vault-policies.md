# Configuring Vault Policies

- Policy overview
- Policy syntax
- Design a policy
- Configure a policy


## Vault Policy Overview

- Policies define permissions in Vault
- Multiple options for assignment
    - Token
    - identity
    - auth methods
- Most specific wins
- No versioning
- Default policy (can be edited, but not deleted)
- Root policy (can't be changed neither deleted)

## Reviewing the Default Policy

```hcl
# allow token to look up their own properties
path "auth/token/lookup-self" { ... }

# allow tokens to renew themselves
path "auth/token/renew-self" { ... }

# allow tokens to revoke themselves
path "auth/token/revoke-self" { ... }

# allow a token to look up its own capabilities on a path
path "sys/capabilities-self" { ... }

# allow a token to look up its own entity by id or name
path "identity/entity/id/{{identity.entity.id}}" { ... }



```

## Policy Syntax

- HCL or JSON
- Components of a policy:
    - Path
    - Capabilities

Path examples:
```hcl
# basic path expression
path "somepath/in/vault"

# Using the glob '*'
# Match "secrets/globo/web1/"
# and "secrets/globo/webapp/apikeys"
path "secrets/globo/web*"

# Using the path segment match '+'
# Match "secrets/globo/webapp1/apikeys"
# and "secrets/globo/webapp2/apikeys"
path "secrets/globo/+/apikeys"

# Using a parameter
# resolve to the name of the entity
path "secret/{{identity.entity.name}}/*"

# Used in the default policy
# Allow a token to look up its own entity by id or name
path "identity/entity/id/{{identity.entity.id}}"
path "identity/entity/name/{{identity.entity.name}}"
```

### Capabalities

- CRUD
    - **`create`** - create a new key
    - **`read`** - read data from a key
    - **`update`** - alter data for a key
    - **`delete`** - remove a key
- **`list`**: enumerate keys
    - No access to key data
    - Not implied by the read
- **`sudo`** - special permissions
    - Root-protected paths
    - Do not imply other actions
- **`deny`** - disable access
    - Overrides all other actions
    - Denies the full path

```hcl
# allow read access to an apikey
path "secrets/globo/webapp/apikey" {
  capabilities = ["read"]
}

# allow read and list access to webapp path
path "secrets/globo/webapp/*" {
  capabilities = ["read", "list"]
}

# allow full access to apikey in globo paths
path "secrets/globo/+/apikey" {
  capabilities = ["create", "read", "update", "delete"]
}

##########################################
# deny access to the globo privileged path

# this is allowing "full access"
path "secrets/globo/webapp/*" {
  capabilities = ["create", "read", "list", "update", "delete"]
}

# and this "deny" overwrites full access to 
# privileged path
path "secrets/globo/webapp/privileged*" {
  capabilities = ["deny"]
}

```

### Globomantics Scenario

#### Use Case 1

- Jr admins need to manage secrets engines
- Follow the principle of least privileged access
- No access to contents of secrets engines

#### Solution:

- Create a secrets engine management policy
- Assign the policy to junior administrators


#### Use Case 2

- Grant access to the accounting secrets engine
- Deny access to privileged information for regular accountants
- Allow management of metadata

#### Solution

- Create an accounting policy
- Add a deny rule for privileged path
- Add access to the metadata path


## Policy Creation and Assignement

### Policy Assignment

- Directly on token when created
- Applied through an authentication method
- Assigned to an entity through the identity secrets engine

### Policy CLI Commands

```bash
# list existing policies
vault policy list

# read the contentes of a policy
vault policy read [options] NAME
vault policy read secrets-mgmt

# write a new policy or update an existing policy
vault policy write [options] NAME PATH | <stdin>
vault policy write secrets-mgmt secrets-mgmt.hcl

# delete a policy
vault policy delete [options] NAME
vault policy delete secrets-mgmt

# format a policy per HCL guidelines
vault policy fmt [options] PATH
vault policy fmt secrets-mgmt.hcl

```

## Demo

<https://app.pluralsight.com/course-player?clipId=c2233d9e-27d7-42e9-8002-460dd179c3dc>

Practice: <https://github.com/ned1313/Hashicorp-Certified-Vault-Associate-Getting-Started/tree/main/m5>

Through the UI: <https://app.pluralsight.com/course-player?clipId=362d11d4-747a-46a4-8060-80d8a544043a>




## Key Takeaways

- Policies are associated with tokens directly or indirectly, defining the actions allowed by the token.
- The root policy can do ANYTHING. It cannot be modified or deleted.
- The default policy is assigned to new tokens by default. It can be modified, but not deleted.
- Paths define where actions can be taken; capabilities define what actions can be taken.
- Policies can be assigned directly to a token, through an auth method, or through the identity secrets engine.
 

