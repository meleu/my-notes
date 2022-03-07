# AWS Services

## 1 - Introduction to AWS

Core services:

- Compute:
    - EC2
- Storage:
    - S3
- Database:
    - RDS
- Networking & Content Delivery
    - VPC
- Security, Identity & Compliance
    - IAM
- Containers
    - ECR - registry
    - Elastic Kubernetes Service

### Scopes of Services

- Global
    - Regions
        - AZ Scopes

![[Pasted image 20211011100304.png]]



## Create an AWS account

<https://aws.amazon.com/>


## IAM - Manage Users, Roles and Permissions

IAM: Identity and Access Management

Once you create an root account, it's better to create an admin account, with less permissions

- ROOT users
    - ADMIN users
        - System Users

Users vs. Roles

Role for each Service, Policy specific to Service.
