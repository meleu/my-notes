# Workshop AWS Serverless

## Arquitetura de microsserviços

2001 - 2002

2001: Aplicação monolítica + teams
2002: Microsserviços - 2 pizza teams


## 2pizza teams - fast & agile

- full ownership & autonomy
- you build it, you run it
- DevOps - small, nimble teams
- Focused innovation


## Serverless means...

- No servers to provision or manage
- Pay for value
- Scales with usage
- Availability and fault tolerance built in


## Serverless benefits

- greater agility
- less overhead
- better focus
- increased scale
- more flexibility
- faster time to market

## Serverless is more than compute

COMPUTE

- AWS Lambda
- AWS Fargate

DATA STORES

- Amazon S3
- Amazon Aurora Serverless
- Amazon Dynamo DB

INTEGRATION

...


## AWS Lambda

Event Driven -> Function as a Service -> Serverless FaaS (Lambda)


## Serverless Applications

Event Source -> Function -> services (anything)

Tipos de eventos:

- changes in data state
- requests to endpoints
- changes in resource state

Function:

- Node.js
- Python
- Java
- PowerShell
- C#
- Go
- Ruby
- BYOR (Bring Your Own Runtime)


## Anatomy of a Lambda Function

### Handler() function

Function to be executed upon invocation.


### Event object

Data sent during lambda function invocation.


### Context object

Methods available to interact with runtime information (request ID, log group, more).



## Fine-grained pricing

- Buy compute time in 1ms increments
- Low request charge
- No hourly, daily, or monthly minimums
- No per-device fees
- Never pay for idle

Dá pra testar no Free Tier


## Amazon API Gateway

- Create a unified API frontend for multiple micro-services.
- DDoS protection and throttling for your backend.
- Authenticate and authorize requests to a backend.
- Throttle, meter, and monetize API usage by third-party developers.


## HTTP APIs for Amazon API Gateway

Achieve up to 67%"cos reduction and 50% latency reduction compared to REST APIs. HTTP APIs are also easier to configure than REST APIs, allowing customers to focus more time on building applications.

- Reduce application costs by up to 67%
- Reduce application latency by up to 50%
- Configure HTTP APIs easier and faster than before


## Amazon DynamoDB

Fast and flexible NoSQL database service for any scale

Performance at scale:

- Handles millions of requests per second
- Delivers single-digit-millisecond latency
- Automated global replication
- New advanced streaming with Amazon Kinesis Data Streams for DynamoDB

No servers to manage

- maintenance free
- auto scaling
- on-demand capacity mode
- change data capture for integration with AWS Lambda, Amazon Redshift, Amazon Elasticsearch Service

Enterprise ready

- ACID transactions
- Encryption at rest
- Conctinuous backups (PITR), and on-demand backup and restore
- NoSQL Workbench
- Export table data to S3
- PartiQL support (a SQL-compatible query language)


## AWS AppSync

Real-time and offline data using GraphQL

- real-time collaboration
- offline programming model with sync
- your data sources
- fine-grained access control

## Business workflow is rarely sequential start to finish

## AWS Step Functions + Lambda

"Serverless" workflow management with zero administration:

- makes it easy to coordinate the components of distributed applications and microservices using visual workflows.
- Automatically triggers and tracks each step and retries when there are errors, so your applicattion executes in order and as expected
- logs the state of each step, so when things do go wrong, you can diagnose and debug problems quickly


## Step Functions: Integrations

Simplify building workloads such as order processing, report generation, and data analysis.

Write and maintain less code; add services in minutes.

More service integrations:

- Amazon Simple Notification Service
- Amazon Simple Queue Service
- Amazon SageMaker
- AWS Glue
- AWS Glue
- AWS Batch
- Amazon Elastic Container Service
- AWS Fargate
- Amazon EMR


## AWS Step Functions - Express Workflows

- Launched at re:Invent on 12/03/2019
- A new type of AWS Step function workflow that compliment existing step functions standard workflows for long running, auditable workflows
- const effective at scale: 100K TPS
- Short duration workflows: <5 min
- applications such as IoT data ingestion, streaming data processing and transformation, and high volume microservices orchestration

## Amazon EventBridge

A serverless event bus service for AWS services, your own applications, and SaaS prociders.

- Serverless. Pay only for the events you process.
- Simplified scaling - avoids increasing costs to sustain and manage resources
- No upfront investments


## AWS Serverless Application Model (SAM)

- AWS CloudFromation extension optimized for serverless
- New serverless resource types: functions, APIs, and tables.
- Supports anything AWS CloudFormation supports
- Open specification (Apach 2.0)


## AWS Command Line Interface (AWS CLI)

CLI tool for local development, debugging, testing, deploying, and monitoring of serverless applications

Supports API Gateway "proxy-style" and Lambda service API testing

Response object and function logs available...

## AWS Serverless Application Repository


## Cloud Development Kit (CDK)

IaS usando linguagem de programação

Software development framework for defining cloud infrastructure using familiar programming languages.

Getting Started:

- cdkworkshop.com
- aws.amazon.com/cdk
- aws.amazon.com/vscode


## Amplify

Fastest way to develop cloud powered apps

Tres components principais:

- Framework
    - CLI
- Cloud Services
- Developer Tools

The Amplify Framework, an open source client framework, includes libraries, a CLI toolchain, and UI components

The CLI toolchain enables easy integration with Cloud Services such as Amazon Cognito, AWS, AppSync, and Amazon Pinpoint.

Developer Tools for building, testing, deploying, and hosting the entire app - frontend and backend.

### Use cases

- blogs or static web apps
- serverless web apps
- progressive web apps


## Monitoring

### Metrics, logging and tracing

- CloudWatch Metrics
- CloudWatch Logs
- AWS X-Ray (tracing)

