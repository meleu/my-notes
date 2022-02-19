# Controlling Access in Vault

[Pluralsight videos](https://app.pluralsight.com/course-player?clipId=f4efab6b-9543-4a8d-80c7-af7143ba5b4e)


## Authentication Methods

- Internal Authentication
- External Authentication
- Multiple Methods

```bash
# enable an auth method
vault auth enable [method]

# write the config to an auth method
vault write auth/[method]/config

# add a role to the auth method
vault write auth/[method]/role/[role_name]

# disable an auth method
vault auth disable [method]
```

### Demonstration

```bash
## list current auth methods
vault auth list


## enable userpass auth method
vault auth enable userpass


## get help about the userpass auth method
vault path-help auth/userpass


## add a user to the userpass auth method
vault write auth/userpass/users/arthur password=dent


## list current users
vault list auth/userpass/users


## start an userpass authenticated session
vault login -method=userpass username=arthur

# (set the token as VAULT_TOKEN)

## check current token
vault token lookup


## reset password (note: only root can do it)
vault write auth/userpass/users/arthur/password \
  password=tricia


## remove an account
vault delete auth/userspass/users/arthur


## disable userpass authentication method
vault auth disable auth/userpass
```


## Active Directory Authentication

<https://app.pluralsight.com/course-player?clipId=67c39a6b-bac3-4bfa-bf29-b163553d867c>

## Vault Policies

Vault policies govern

- Who
- What
- How

Policies are written via HCL or JSON (mostly HCL)

### Policy Document

```hcl
path "path_of_secret_data/[*]" {
  capabilities = ["create", "read", "update"...]
  required parameters = ["param_name"]
  allowed parameters = {
    param_name = ["list", "of", "values"]
  }
  denied_parameters = {
    param_name = ["list", "of", "values"]
  }
}
```


### Working with Policies

```bash
# list all policies
vault policy list

# create a policy
vault policy write [policyName] [policyFile.hcl]

# update a policy
vault write sys/policy/[policyName] policy=[policyFile.hcl]

# delete a policy
vault delete sys/policy/[policyName]
```


### Creating Policies

- <https://app.pluralsight.com/course-player?clipId=faa208fe-4b8c-4051-a814-08d3ba28f33c> - the policy file was just briefly explained and I didn't understand it very well.


### Configuring LDAP Authentication

- <https://app.pluralsight.com/course-player?clipId=2d876c04-ec71-487e-a0b1-c46be901644d>


## Client Tokens

- Two types:
    - Service Token
    - Batch Token
- have policies
- have metadata
- have a hierarchy
    - service token can create child tokens
    - when a parent token is revoked, the chilld tokens are also revoked
    - it's possible to create orphan tokens to not be part of such hierarchy
- token accessors
    - have access to the token's metadata, but not to the token itself


## Response Wrapping

- <https://app.pluralsight.com/course-player?clipId=0ee44201-a8a0-4ba5-9f3f-8d6eea7d45b2>


## Conclusion

- Authentication is all about tokens
- Policies are added to tokens
- Tokens are the foundation of Vault access

