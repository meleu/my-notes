# Vault: Configuring Basic Authentication

## Vault Authentication Methods

- Provided by plug-ins
- Multiple methods allowed
- Reference external sources
    - LDAP, GitHub, AWS IAM, etc.
- Token method is enabled by default
- Used to obtain a token
    - all subsequent interactions happens with the token


- Example: Username & Password
    - Meant for humans
    - Composed of a username and password
    - Internal to Vault


## Configuring an Auth Method

- All methods are enabled on `/sys/auth`
- Methods are enabled on a path
    - Defaults to method name
- Methods cannot be moved
- Methods can be tuned and configured
    - Tuning settings are common for all methods
    - Configuration settings are specific to a method

```
# list existing auth methods
vault auth list

# enable an auth method
vault auth enable [options] TYPE
vault auth enable -path=globopass userpass

# tune an auth method
vault auth tune [options] PATH
vault auth tune -description='First userpass' globopass/

# disable an auth method
vault auth disable [options] PATH
vault auth disable globopass/
```

## Globomantics Requirements

- Revoke root tokens as soon as possible
- Well defined permissions for Vault admins

Demo:

```
# First let's see what auth methods are avilable now
vault auth list

# Cool, now let's enable our first auth method using userpass
vault auth enable userpass

# Now let's check the list of auth methods again
vault auth list

# Oh no! We forgot to add descriptions! Better take care of that
vault auth tune -description="Globomantics Userpass" userpass/

vault auth list

# Let's write some data to create a new user
vault write auth/userpass/users/globoadmin password=burritos
```


## Policies

- Policies define permissions in Vault
- Multiple options for assignemnt
    - Token, identity, auth methods
- Most specific wins
- No versioning
- Default policy
- Root policy


### Policy Commands

```
vault policy list

# read contents of a policy
vault policy read [options] NAME
vault policy read secrets-mgmt

# write a new policy or update an existing policy
vault policy write [options] NAME PATH|<stdin>
vault policy write secrets-mgmt secrets.mgmt.hcl

# delete a policy
vault policy delete [options] NAME
vault policy delete secrets-mgmt

# format a policy per HCL guidelines
vault policy fmt [options] PATH
vault policy fmt secrets-mgmt.hcl
```

Demo:
```
# First we can check and see what policies exist right now
vault policy list 

# Now we'll create a policy for Vault administration
# This policy is based off an example provided by HashiCorp
vault policy write vault-admins vault-admins.hcl

# Next we can assign the policy to the globoadmin user
vault write auth/userpass/users/globoadmin token_policies="vault-admins"

# Now we can log in as globoadmin and a few actions
vault login -method=userpass username=globoadmin

# List all secrets engines
vault secrets list

# Enable a secrets engine
vault secrets enable -path=testing -version=1 kv

# List all policies
vault policy list

# Things look good! Let's revoke the current root token 
# and use the admin account from here on out
vault token revoke ROOT_TOKEN
```

## Main takeaways:

- Auth methods are used to obtain a Vault token
- Policies define the permissions associated with a token
- Root tokens are not meant for administrative work
    - only when there's an emergency and there are no other ways to log into Vault and it should be revoked as soon as possible.
    
    
    
    