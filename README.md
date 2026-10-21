*This project has been created as part of the 42 curriculum by deddaidi.*

# Inception

## Description

**Inception** is a system administration project from the 42 curriculum. The goal is to build a small infrastructure using **Docker** and **Docker Compose**.

The project consists of several isolated services running in Docker containers and communicating through a dedicated Docker network.

### Main Services

* **NGINX** — Web server and reverse proxy with HTTPS/TLS.
* **WordPress** — Content Management System.
* **MariaDB** — Database used by WordPress.

### Bonus Services

The project also includes the following bonus services:

* **Adminer** — Web interface for managing the MariaDB database.
* **FTP** — File Transfer Protocol service used to transfer WordPress files.
* **Redis** — In-memory data store used as a cache for WordPress.
* **Portainer** — Web interface for managing Docker containers and resources.
* **Static Site** — A personal resume website served as an additional website.

---

## Project Structure

```text
.
├── secrets
└── srcs
    └── requirements
        ├── bonus
        │   ├── adminer
        │   ├── ftp
        │   │   ├── conf
        │   │   └── tools
        │   ├── portainer
        │   ├── redis
        │   └── static_site
        │       └── conf
        ├── mariadb
        │   ├── conf
        │   └── tools
        ├── nginx
        │   └── conf
        └── wordpress
            ├── conf
            └── tools
```

The project separates the main services from the bonus services. Each service contains its own configuration files and, when necessary, scripts used during container initialization.

---

## Architecture

The infrastructure is composed of several Docker containers connected through a dedicated Docker network.

```text
                         HTTPS :443
                             |
                             v
                        +----------+
                        |  NGINX   |
                        +----+-----+
                             |
              +--------------+--------------+---------------+
              |              |              |               |
              v              v              v               v
        +-----------+  +-----------+  +-------------+  +-------------+
    +---| WordPress |  |  Static   |  |   Adminer      |  Portainer  |
    |   |           |  |   Site    |  |             |  |             |
    |   +-----+-----+  +-----------+  +------+------+  +------+------+
    |         |                            |
    |         v                            |
    |   +-----------+                      |
    |   |  MariaDB  |<---------------------+
    |   +-----------+
    |         
    |         
    |     +-------+
    +---->| Redis |
          +-------+

        +-----------+       
        |    FTP    |       
        +-----------+    
```

Each service runs in its own container. The containers communicate through the Docker network when communication is required.

---

## Docker

Docker is used to containerize each service independently.

Each container has its own:

* filesystem;
* processes;
* configuration;
* dependencies;
* network identity.

Docker Compose is used to define and manage the complete infrastructure.

Using Docker allows the project to be:

* reproducible;
* isolated;
* easier to deploy;
* easier to manage;
* composed of independent services.

The containers communicate through a dedicated Docker network instead of using the host network directly.

---

## Virtual Machines vs Docker

### Virtual Machines

A Virtual Machine emulates a complete computer. It includes a complete operating system on top of virtualized hardware.

This generally requires more:

* CPU;
* RAM;
* storage;
* startup time.

### Docker

Docker containers share the host operating system kernel while keeping applications isolated.

| Virtual Machines            | Docker                 |
| --------------------------- | ---------------------- |
| Complete operating system   | Shares the host kernel |
| Higher resource usage       | Lower resource usage   |
| Slower startup              | Fast startup           |
| Larger storage requirements | Lightweight            |
| Hardware virtualization     | Process isolation      |

For this project, Docker is appropriate because several services can run independently without requiring a complete operating system for each service.

---

## Secrets vs Environment Variables

### Environment Variables

Environment variables are useful for configuration values that do not need to be hidden.

For example:

```text
DOMAIN_NAME=deddaidi.42.fr
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
```

They allow configuration to be changed without modifying the Docker images.

### Secrets

Secrets are intended for sensitive information such as:

* passwords;
* private keys;
* credentials.

Secrets are stored separately from the source code and can be provided to containers when needed.

For this project, sensitive credentials are kept separately from the public source code.

---

## Docker Network vs Host Network

### Docker Network

The project uses a dedicated Docker network.

Containers can communicate with each other using their service names.

For example:

```text
wordpress -> mariadb:3306
```

This provides:

* service isolation;
* controlled communication;
* internal DNS resolution;
* reduced exposure of internal services.

### Host Network

With host networking, a container uses the host's network directly.

This reduces network isolation and can also cause port conflicts with services running on the host.

For this project, a dedicated Docker network is preferred because the services need to communicate with each other while remaining isolated from the host network.

---

## Docker Volumes vs Bind Mounts

### Docker Volumes

Docker volumes are managed by Docker and are mainly used to store persistent application data.

For example:

```text
MariaDB
    |
    +-- Database data

WordPress
    |
    +-- WordPress files
```

If a container is removed, data stored in a volume can remain available.

### Bind Mounts

A bind mount directly maps a directory from the host into a container.

Example:

```text
Host directory
      |
      v
/home/user/data/mariadb
      |
      v
/var/lib/mysql
```

Bind mounts are useful when direct access to files from the host is required.

### Comparison

| Docker Volumes                              | Bind Mounts                                |
| ------------------------------------------- | ------------------------------------------ |
| Managed by Docker                           | Managed by the user                        |
| Docker manages the storage location         | User chooses the host path                 |
| Well suited for persistent application data | Useful when direct host access is required |
| Less dependent on host filesystem structure | Depends on the host directory structure    |

Persistent data in this project is stored outside the container's temporary writable layer so that it can survive container restarts and recreation.

---

## Instructions

### Requirements

The project requires:

* Docker
* Docker Compose
* Git
* A Linux environment or virtual machine

### Clone the Repository

```bash
git clone <repository-url>
cd inception
```

### Configure the Environment

Create the required environment configuration and secrets according to the project configuration.

Sensitive passwords and credentials must not be committed to the Git repository.

### Build and Start

From the project root:

```bash
make
```

Or using Docker Compose:

```bash
docker compose up --build
```

### Access the Website

Once the infrastructure is running, open a web browser and access:

**https://deddaidi.42.fr**

The browser may display a warning because the project uses a self-signed TLS certificate.

### Stop the Infrastructure

```bash
make down
```

Or:

```bash
docker compose down
```

### Check Running Containers

```bash
docker ps
```

### Check Logs

```bash
docker compose logs
```

For a specific service:

```bash
docker compose logs nginx
docker compose logs wordpress
docker compose logs mariadb
```

---

## Services

### NGINX

NGINX is the entry point of the infrastructure.

It is responsible for:

* HTTPS/TLS;
* receiving client requests;
* routing requests to the appropriate service;
* acting as a reverse proxy.

### WordPress

WordPress provides the main web application.

It communicates with MariaDB for database operations and can use Redis for caching.

### MariaDB

MariaDB is the database server used by WordPress.

It stores information such as:

* WordPress users;
* posts;
* pages;
* settings;
* other application data.

### Adminer

Adminer provides a web interface for managing and inspecting the MariaDB database.

### FTP

The FTP service allows authorized users to transfer files to and from the WordPress directory.

### Redis

Redis is used as an in-memory cache.

It can reduce repeated database operations and improve WordPress performance.

### Portainer

Portainer provides a web-based interface for managing Docker resources such as:

* containers;
* images;
* networks;
* volumes.

### Static Site

The static site is an additional website containing a personal resume.

It is served independently from the WordPress application and is accessed through NGINX.

---

## Persistence

Containers are designed to be replaceable. Therefore, important data must not depend on the container's writable layer.

The project uses persistent storage for important application data, especially:

* MariaDB database data;
* WordPress files.

This allows the data to remain available after containers are restarted or recreated.

---

## Useful Docker Commands

List all containers:

```bash
docker ps -a
```

List images:

```bash
docker images
```

List volumes:

```bash
docker volume ls
```

List networks:

```bash
docker network ls
```

Inspect a container:

```bash
docker inspect <container>
```

Open a shell inside a running container:

```bash
docker exec -it <container> sh
```

View the complete Compose configuration:

```bash
docker compose config
```

---

## Resources

* [Architecture of Docker — GeeksforGeeks](https://www.geeksforgeeks.org/devops/architecture-of-docker/)
* [A Simple Documentation for Inception](https://purple-page-995.notion.site/A-simple-Documentation-for-inception-dd60c488201741b09f1ed64157245bdf)

---

## AI Usage

AI tools were used as a learning and assistance resource during the project.

They were used for:

* Helping understand some technical concepts.
* Assisting in writing the README and documentation.
* Debugging errors.
