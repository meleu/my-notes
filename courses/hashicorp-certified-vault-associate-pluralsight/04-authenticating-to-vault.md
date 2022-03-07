# Authenticting to Vault


## Authentication Methods Overview

- Provided by plug-ins (bundled with the binary)
- Multiple methods allowed
- Reference external sources 
    - LDAP, GitHub, AWS IAM, etc.
- `Userpass` and `AppRole` are internal
- `Token` method is enabled by default
- Mounted on the path `/auth`
- Used to obtain a token

## Authentication Methods Categories

- Cloud providers: AWS, Azure, GCP
- Cloud native: Kubernetes, Cloud Foundry, GitHub, JWT
- Traditional: **LDAP**, RADIUS, Kerberos
- Vault native: Token, Userpass, AppRole


### Choosing an Auth Method

- Who is going to access Vault?
    - External/Internal user?
    - Human or machines?
- How are they going to access it?
    - Will they type credentials on a keyboard?
    - Machine storing credentials that is going to be submitted along with Vault requests?
- What do they use today?
    - Do they have GitHub accounts?
    - **Do they all have Active Directory?**
    - They all have certificates?

##  `Userpass` and `AppRole` Methods

- Userpass:
    - Meant for human operators
    - composed of a username and password

- AppRole
    - Used for machines and applications
    - Consists of `RoleID` and `SecretID`
    - Push or pull for `SecretID`


## Configuring an Auth Method

- All methods are enabled on `/sys/auth`
- Methods are enabled on a path
    - Defaults to method name
- Methods cannot be moved
- Methods can be tuned and configured
    - Tuning settings are common for all methods
    - Configuration settings are specific to a method

### Commands

```bash
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

Demo: <https://github.com/ned1313/Hashicorp-Certified-Vault-Associate-Getting-Started/tree/main/m4>

### Enabling Auth Methods

<https://github.com/ned1313/Hashicorp-Certified-Vault-Associate-Getting-Started/blob/main/m4/1-enable-auth-methods.sh>

```bash
# First of all we are going to start Vault in development mode
vault server -dev

# Now set your Vault address environment variable
export VAULT_ADDR=http://127.0.0.1:8200

# And log into Vault using the root token
vault login 

# First let's see what auth methods are avilable now
vault auth list

# Cool, now let's enable our first auth method using userpass
vault auth enable userpass

# And we'll also enable AppRole, but we'll do it using the UI
# Open your browser to http://127.0.0.1:8200/ui
# 'Access' tab > 'Enable new method' > AppRole > Next
# We are going to mount it at the path GloboAppRole
# Default lease TTL: 60 minutes

# Now let's check the list of auth methods again
vault auth list

# Oh no! We forgot to add descriptions! Better take care of that
vault auth tune \
  -description="Globomantics Userpass" \
  userpass/

vault auth tune \
  -description="Globomantics AppRole" \
  GloboAppRole/

vault auth list

# Much better! Now we can configure our two auth methods in step 2
```

### Configuring Userpass Method

<https://github.com/ned1313/Hashicorp-Certified-Vault-Associate-Getting-Started/blob/main/m4/2-configure-auth-methods.sh>

```bash
# We need to create a user in Userpass so we can log in
# But how do we do that?
# path-help to the rescue

vault path-help auth/userpass/

# Looks like we do that through the users path

vault path-help auth/userpass/users

vault path-help auth/userpass/users/something

# Let's write some data to create a new user

vault write auth/userpass/users/ned password=tacos

# We can also add a user through the UI
# We will add Amy who loves burritos

# Now we need to do a little config on the AppRole too

vault path-help auth/GloboAppRole

# Looks like we need to configure a role

vault path-help auth/GloboAppRole/role/something

# Okay armed with that we can create a new role for a web app

vault write \
  auth/GloboAppRole/role/webapp \
  role_name="webapp" \
  secret_id_num_uses=1 \
  secret_id_ttl=2h

# Sweet! We have configured our two auth methods.
# Next step is to actually use them!
```


## Using an Auth Method

```bash
# login using a token
vault login

# login with an auth method
vault login [options] [AUTH K=V...]
vault login -method=userpass username=ned

# write with an auth method
vault write [options] PATH [DATA K=V...]
vault write \
  auth/userpass/login/ned \
  password=globomantics

```

<https://github.com/ned1313/Hashicorp-Certified-Vault-Associate-Getting-Started/blob/main/m4/3-login-with-auth-methods.sh>

```bash
# Let's try logging in with our username and password first

vault login -method=userpass username=ned

# We can do the same in the Web UI

# Next let's log in with our AppRole method
# We're going to need to log back in with our root token first
vault login 

 # Alright now what do we need to log in with AppRole?

vault path-help auth/GloboAppRole/login

 # Okay, so we need the role_id and secret_id
 # Let's get the role_id first

vault read auth/GloboAppRole/role/webapp/role-id

roleId=ROLEID

# Now let's get the secret_id, since we're generating data we
# need to use the write command instead

vault write -force auth/GloboAppRole/role/webapp/secret-id

secretId=SECRETID

# And now we can log in! This also uses the write command
vault write auth/GloboAppRole/login role_id=$roleId secret_id=$secretId

# Sweet, now we could use that token in future requests

# Lastly, let's try logging in using the API with AppRole instead
curl --request POST \
  --data "{\"role_id\": \"$roleId\",\"secret_id\": \"$secretId\"}" \
  $VAULT_ADDR/v1/auth/GloboAppRole/login | jq
```

## Note: stopped taking notes here

I need to hurry with things at work and had to stop taking notes while in this lecture:

<https://app.pluralsight.com/course-player?clipId=87ac242c-f2e2-4aaa-abdb-53f5c98d60a4>


## Key Takeaways

- Auth methods use internal or external sources for authentication to Vault
- Multiple instances of the same method can be enabled on different paths, and the default path is the method's name.
- Pick an authentication method that suits the client environment.
- Auth methods are managed using the `vault auth` command.
- Auth methods are used with `vault login` or `vault write` commands.



