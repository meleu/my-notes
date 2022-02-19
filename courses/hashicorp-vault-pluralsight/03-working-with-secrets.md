# Working with Secrets

[Plurasight videos](https://app.pluralsight.com/course-player?clipId=fc9e2da0-f6c1-4c80-8df1-9eb37a2e57c9)

## Secret Lifecycle

- Create
- Read
- Update
- Delete
- Destroy
- Metadata Destroy



## Key value secrets

| Version 1                       | Version 2                           |
| ------------------------------- | ----------------------------------- |
| No versioning, last key wins    | Versioning of past secrets          |
| Faster with fewer storage calls | Possibly less performant            |
| Deleted items are gone          | Deleted items and metadata retained |
| Can be upgraded to version 2    | Cannot be downgraded                |
| Default version on creation     | Can be specified at creation                                    |


## Secrets engines

Secret Engines is the mechanism by which Vault stores secrets.

Secret Engines are responsible for doing with data:

- Store
- Generate
- Encrypt

**Lifecycle:**

- Enable
- Disable
- Move
- Tune


**Vault Paths**

- API rules everything
- Everything is a path
- Enables path-help
- API docs or bust


### Working with Secret Engines

```bash
# enable
vault secrets enable [options] TYPE

# disable
vault secrets disable [options] PATH

# move
vault secrets move [options] SOURCE DESTINATION

# tune - ALERT: didn't find this command available
vault secrets tune [options] PATH
```

Demonstration:
```bash
# enable a new key-value secrets engine path
vault secrets enable -path=dev-a kv

# via API (dev-b.json file must exist)
# dev-b.json contents:
# {
#   "type": "kv",
#   "options": {
#     "version": "1"
#   }
# }
curl \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  --request POST \
  --data @dev-b.json
  VAULT_ADDR/v1/sys/mounts/dev-b
  
# view the secrets engine paths
vault secrets list
vault secrets list -format=json

# add secrets to the new paths
vault kv put \
  dev-a/arthur \
  love=trillian \
  friend=ford
vault kv get dev-a/arthur

# alternate commands (only works for v1)
vault write dev-a/arthur enemy=zaphod
vault read dev-a/arthur

# move secrets path
vault secrets move dev-a dev-a-moved

# dev-b-moved.json contents:
# {
#   "from": "dev-b",
#   "to": "dev-b-moved"
# }
curl \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  --request POST \
  --data @dev-b-moved.json \
  VAULT_ADDR/v1/sys/remount

# check how the paths has been changed
vault secrets list


# upgrade the secrets engine to v2
vault kv enable-versioning dev-a-moved

# dev-b-moved-v2.json contents:
# {
#   "options":{
#     "version": "2"
#   }
# }
curl \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  --request POST \
  --data @dev-b-moved-v2.json \
  VAULT_ADDR/v1/sys/mounts/dev-b-moved/tune

# check it has `data.options.version: 2`
curl \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  VAULT_ADDR/v1/sys/mounts/dev-b-moved/tune

# creating a new secrets engine on v2
vault secrets enable \
  -path=dev-c \
  -version=2 \
  kv

# disable the secrets engine
vault secrets disable dev-a-moved

# disable via API
curl \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  --request DELETE \
  VAULT_ADDR/v1/sys/mounts/dev-b-moved/tune
```


### Using MySQL as a Storage Backend

https://app.pluralsight.com/course-player?clipId=56f968a6-5abb-4ac3-ac53-81488d1c43ff

Using MySQL as a docker container:
```bash
# creating a mysql server container
docker container run \
  --name vault-mysql \
  --publish 3306:3306 \
  --env MYSQL_ROOT_PASSWORD=my-password \
  --detach \
  mysql

# connecting to the mysql server
docker container run \
  --rm \
  -it \
  mysql \
    mysql \
      -h <mysql-ip> \
      -u root \
      -p
```

Once connected to the MySQL server, create an user for Vault:
```sql
-- create a role for the developers
CREATE ROLE 'dev-role';

-- create an user for Vault
CREATE USER 'vault'@'<my-ip>' IDENTIFIED BY 'VaultPassword';

-- create a database for the developers
CREATE DATABASE devdb;

-- allow vault user to do anything
GRANT ALL ON *.* TO 'vault'@'<my-ip>';

-- allow vault user to grant access to other users
GRANT GRANT OPTION ON devdb.* TO 'vault'@'<my-ip>';
```


Back to Vault:
```bash
# enable the database secret engine
vault secrets enable database

# creating an instance of the database secret
# engine using the MySQL plugin
vault write database/config/dev-mysql-database \
  plugin_name=mysql-database-plugin \
  connection_url="{{username}}:{{password}}@tcp(<mysql-ip>:3306)/" \
  allowed_roles="dev-role" \
  username="vault" \
  password="VaultPassword"
# database secret engine name: dev-mysql-database
# plugin to talk to the db: mysql-database-plugin
# allowed_roles: the role created directly in mysql


# creating a new role to be used by devs
vault write database/roles/dev-role \
  db_name=dev-mysql-database \
  creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}'; GRANT ALL ON devdb.* TO '{{name}}'@'%';" \
  default_ttl='1h' \
  max_ttl='24h'


# getting credentials for a user/password
# with the dev-role:
# vault read database/creds/${roleName}
vault read database/creds/dev-role
```

Check if the user/password was created in the mysql server:
```sql
SELECT User FROM mysql.user;
SHOW GRANTS FOR '<username>'
```

## Dynamic secrets

- Create secrets on demand
- Lease issued for each secret
- Lease sets validity period
- Control renewal and revocation


### Demo

```bash
# renew the lease
# note: if increment makes the lease time
#       after 'max_ttl', the value is capped
#       at 'max_ttl'.
vault lease renew -increment=<seconds> <lease_id>


# once you finish using your credentials, revoke it
vault lease revoke <lease_id>
```



## Conclusion

- Secrets are more than key/value pairs
- Secrets engines make Vault extensible
- Dynamic secrets are kinda awesome