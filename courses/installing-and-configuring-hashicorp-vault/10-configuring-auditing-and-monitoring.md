# Vault: Configuring Auditing and Monitoring

- <https://app.pluralsight.com/course-player?clipId=109dd57f-b08f-4538-a4e8-3e070ed3bbbd>


## Monitoring Disambiguation

Monitoring consists of:

- Telemetry
- **Logging**
- **Auditing**

This module focuses in logging and auditing.


## Vault Server Logs

Where Vault sends the logs? It's defined in in either:

- Configuration file
- Environment variables
- CLI

You can see it in real time with the monitor command


## Auditing Activity

- captures all requests and responses through the API
- implemented through device types
    - file, socket, syslog
- onde device MUST be available (otherwise Vault stops working)
- sensitive data is hashed (not in plain-text)
    - verified with `/sys/audit-hash`


## Capturing Audit Data

```bash
# enable audit device
vault audit enable [options] TYPE [settings]
vault audit enable \
  -path=file-audit file \
  file_path=/opt/vault/logs/auditlog

# disable audit device
vault audit disable PATH
vault audit disable file-audit

# list audit devices
vault audit list [options]
```


## Globomantics Requirements

- Capture audit logs with Azure Log Analytics
- Ensure at least one audit device is available
- Sensitive values should not be in clear text

Demo videos:

- <https://app.pluralsight.com/course-player?clipId=78d10ffc-f385-4bbb-a47a-1f43fecddf46>
- <https://app.pluralsight.com/course-player?clipId=2f9a645a-c78a-402c-9f5e-e21de76b1739>


## Hardening Vault Server

- System level
    - run unprivileged
    - run single tenant
    - disable swap and command history
    - disable core dumps
    - protect storage
    - use SELinux or AppArmor
- Networking
    - disable remote access
    - restrict network traffic
    - end-to-end TLS
- Vault Configuration
    - enable auditing
    - avoid root tokens
    - immutable and frequent upgrades


## Module Summary

- Vault logging can be set in multiple places and captures server activity
- Auditing captures all requests and responses from the API
- Sensitive dta is hashed by default and can be confirmed with the `audit-hash` API endpoint
- Apply proper hardening to your vault servers per HashiCorp and your organization




