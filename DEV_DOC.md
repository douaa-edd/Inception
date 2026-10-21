# DEV_DOC.md — Developer Documentation

This document explains how to set up, build, run, and manage the Inception project.

---

## 1. Prerequisites

Before starting the project, make sure the following tools are installed:

* Docker
* Docker Compose
* Git
* Make
* A Linux environment or virtual machine

Check the installations with:

```bash
docker --version
docker compose version
git --version
make --version
```

---

## 2. Project Structure

The project is organized as follows:

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

The project contains three main services:

* NGINX
* WordPress
* MariaDB

The following bonus services are also included:

* Adminer
* FTP
* Portainer
* Redis
* Static Site

---

## 3. Clone the Repository

Clone the project repository:

```bash
git clone <repository-url>
cd inception
```

Make sure you are in the project root directory, where the `Makefile` is located.

---

## 4. Configuration

### Environment Variables

The project uses environment variables for configuration.

The environment configuration is stored in:

```text
srcs/.env
```

Typical configuration includes:

```text
DOMAIN_NAME=deddaidi.42.fr

MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=...
MYSQL_ROOT_PASSWORD=...

FTP_USER=...
FTP_PASS=...
```

The exact variables depend on the services enabled in the project.

Do not commit real passwords or sensitive information to Git.

---

## 5. Secrets

Sensitive credentials are stored separately from the regular configuration.

The project contains:

```text
secrets/
```

Secrets can contain sensitive information such as:

* database passwords;
* WordPress credentials;
* other service credentials.

Make sure the required secret files exist before starting the project.

Never publish real credentials in the repository.

---

## 6. Building the Project

The project can be built using the Makefile.

From the project root:

```bash
make
```

The Makefile handles the Docker Compose build and startup process.

To build the images without starting the services, Docker Compose can also be used directly:

```bash
docker compose -f srcs/docker-compose.yml build
```

---

## 7. Starting the Project

Using the Makefile:

```bash
make up
```

Or using Docker Compose:

```bash
docker compose -f srcs/docker-compose.yml up -d
```

To build the images and start the containers:

```bash
docker compose -f srcs/docker-compose.yml up -d --build
```

---

## 8. Stopping the Project

Using the Makefile:

```bash
make down
```

Or with Docker Compose:

```bash
docker compose -f srcs/docker-compose.yml down
```

Stopping the containers does not remove persistent data.

---

## 9. Container Management

### List Running Containers

```bash
docker ps
```

### List All Containers

```bash
docker ps -a
```

### View Container Logs

```bash
docker logs <container_name>
```

For example:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

### Follow Logs

```bash
docker logs -f <container_name>
```

### Open a Shell Inside a Container

```bash
docker exec -it <container_name> sh
```

For example:

```bash
docker exec -it wordpress sh
```

### Restart a Container

```bash
docker restart <container_name>
```

---

## 10. Docker Compose Commands

List the services:

```bash
docker compose -f srcs/docker-compose.yml ps
```

Start the services:

```bash
docker compose -f srcs/docker-compose.yml up -d
```

Stop the services:

```bash
docker compose -f srcs/docker-compose.yml down
```

Rebuild the images:

```bash
docker compose -f srcs/docker-compose.yml build
```

Rebuild and restart:

```bash
docker compose -f srcs/docker-compose.yml up -d --build
```

View logs:

```bash
docker compose -f srcs/docker-compose.yml logs
```

---

## 11. Docker Images

List the available images:

```bash
docker images
```

Remove an unused image:

```bash
docker rmi <image>
```

The project images are built from the Dockerfiles located inside the service directories.

---

## 12. Docker Volumes

List Docker volumes:

```bash
docker volume ls
```

Inspect a volume:

```bash
docker volume inspect <volume_name>
```

The project uses persistent storage for important application data.

The main persistent data includes:

* MariaDB database data;
* WordPress files;
* Portainer data.

---

## 13. Persistent Data

The project stores persistent data outside the temporary container filesystem.

The main data directories are:

```text
/home/deddaidi/data/mariadb
/home/deddaidi/data/wordpress
/home/deddaidi/data/portainer
```

### MariaDB

MariaDB stores its database files in:

```text
/home/deddaidi/data/mariadb
```

This contains the persistent WordPress database.

### WordPress

WordPress files are stored in:

```text
/home/deddaidi/data/wordpress
```

This allows WordPress files to survive container recreation.

### Portainer

Portainer stores its persistent data in:

```text
/home/deddaidi/data/portainer
```

---

## 14. Persistence and Container Lifecycle

Containers are replaceable. Removing a container does not necessarily remove the persistent data stored in volumes or mounted host directories.

For example:

```bash
docker compose down
```

stops and removes the containers, but the persistent project data remains available.

When the project is started again:

```bash
make up
```

the services can reuse the existing persistent data.

---

## 15. Cleaning the Project

To stop and remove the project containers:

```bash
make down
```

To completely clean the project, including persistent data:

```bash
make fclean
```

> **Warning:** `make fclean` removes persistent project data. This operation is irreversible.

---

## 16. Useful Development Workflow

A typical development workflow is:

### 1. Start the project

```bash
make up
```

### 2. Check the containers

```bash
docker ps
```

### 3. Check the logs if necessary

```bash
docker compose -f srcs/docker-compose.yml logs
```

### 4. Make configuration or code changes

Modify the appropriate service files under:

```text
srcs/requirements/
```

### 5. Rebuild the affected services

```bash
docker compose -f srcs/docker-compose.yml up -d --build
```

### 6. Check that the services are running

```bash
docker compose -f srcs/docker-compose.yml ps
```

### 7. Stop the project when finished

```bash
make down
```
