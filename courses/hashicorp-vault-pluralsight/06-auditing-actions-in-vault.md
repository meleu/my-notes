# Auditing Actions in Vault

## Overview

- Auditing architecture
- Enabling auditing
- Reviewing audit logs


## Audit Architecture and Device Types

- Auditing Device Types
    - JSON Files
    - syslog
    - socket
        - TCP
        - UDP
        - Unix sockets


## Audit Commands

```bash
# enable audit device
vault audit enable -path=vault_path [type]


# disable audit device
vault audit disable [path]

# list audit devices
vault audit list -detailed
```


## Audit Scenario

When auditing is not possible, Vault stop working.


## Enabling Auditing

<https://app.pluralsight.com/course-player?clipId=6ec1cabc-07f2-4664-a6ba-b724c4a15306>

Get the files from here: <https://github.com/ned1313/Getting-Started-Vault/blob/master/m6/m6-auditconfig.sh>

## Revieweing Audit Data

<https://app.pluralsight.com/course-player?clipId=688af759-0d41-4d57-a9e2-bdc279461496>

Practice: <https://app.pluralsight.com/course-player?clipId=e263433e-15c2-4ad6-966c-8b681fb11fcb>

## Conclusion

- Everything is audited
- Auditing must be available (otherwise Vault stop working)
- Sensitive data is hashed (unless you explicitly says Vault to not do it)


