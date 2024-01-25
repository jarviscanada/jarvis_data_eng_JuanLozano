# Linux Cluster Monitoring Agent
## Introduction
The Linux Cluster Monitoring Agent is a tool designed to continuously monitor and log hardware specifications and resource usages, such as CPU specifications, load and memory availability of nodes in a Linux cluster.
The tool provides system administrators with a means to monitor system health and performance. This project is engineered using Bash for scripting the monitoring agents, PostgresSQL for data storage, Docker for deploying the database, and Git for version control and managing the codebase, ensuring a scalable, and maintainable monitoring solution.

## Quick Start
- To start a PSQL instance using `psql_docker.sh`:

`./scripts/psql_docker.sh start db_username db_password`

- To create tables using `ddl.sql`:

`psql -h localhost -U postgres -d host_agent -f ddl.sql`

- To insert hardware specs data into the database using `host_info.sh` _(this can only be done once per host)_:

`./scripts/host_info.sh localhost 5432 host_agent postgres password`

- To ***MANUALLY*** insert hardware usage data into the database using `host_usage.sh`:

`./scripts/host_usage.sh localhost 5432 host_agent postgres password`

- Crontab setup:

```
crontab -e
* * * * * bash /path/host_usage.sh localhost 5432 host_agent postgres password &> /tmp/host_usage.log
```

# Implementation
## Architecture

## Database Modeling
### host_info

| Column           | Type      | Short Description                        |
|------------------|-----------|------------------------------------------|
| id               | SERIAL    | Primary Key                              |
| hostname         | VARCHAR   | Unique name of the host                  | 
| cpu_number       | INT2      | Number of CPUs in the current hardware   | 
| cpu_architecture | VARCHAR   | Architecture of the CPU                  |
| cpu_model        | VARCHAR   | Model of the CPU                         | 
| cpu_mhz          | FLOAT8    | Clock speed of the CPU                   | 
| l2_cache         | INT4      | Size of the L2 cache                     | 
| timestamp        | TIMESTAMP | Time when the hardware data was captured |
| total_mem        | INT4      | Total memory                             |

### host_usage

| Column         | Type      | Short Description                     |
|----------------|-----------|---------------------------------------|
| timestamp      | TIMESTAMP | Time when the usage data was captured |
| host_id        | INT       | Foreign key to `host_info` id         | 
| memory_free    | INT4      | Current free memory                   | 
| cpu_idle       | INT2      | Idle CPU percentage                   |
| cpu_kernel     | INT2      | Kernel CPU percentage                 | 
| disk_io        | INT4      | Disk I/O                              
| disk_available | INT4      | Available disk space                  | 








