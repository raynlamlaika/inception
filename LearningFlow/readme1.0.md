docker compose is the main way to start all the servers.
docker compose:
    it was first released in December 2014 by Docker. The main purpose of it
    is to simplify the management of multiple containers.

Work flow of docker compose:
    Setup the env:
        define environment variables (via .env file or directly in the .yml)
        that will be injected into containers at runtime.

    Build phase:
        CLI: docker compose build
        .yml: build: .
        here is where the Dockerfile gets set up, builds the image and tags it locally.
        if you use `image: nginx:latest` it will pull the image from Docker Hub.
                **DOCKERHUB: online registry of predefined images**
    Create Network:
        docker compose automatically creates a bridge network
        to make all services join this network.
        They resolve each other via service name (DNS-based).
        this is one of the powerful things in docker — it manages the network of the apps
        to make them connected to each other.
    Create Volumes:
        it creates persistent storage.
            ***any non-volatile data storage mechanism—such as HDDs, SSDs, or cloud storage—that
            retains data even after a device loses power, the application terminates, or a container restarts***
    Container Startup:
        here is where we create the container, attach the network and mount the volumes,
        inject environment variables, and start containers in dependency order.
    Runtime Management:
        docker compose up        -> start all services (add -d to run in background/detached mode)
        docker compose down      -> stop and remove containers, networks
        docker compose ps        -> list running containers
        docker compose logs      -> view output logs from services
        docker compose restart   -> restart all or specific services
        docker compose exec <service> <cmd> -> run a command inside a running container


here is an example of the .yml file:

# NOTE: YAML does NOT support // comments. Use # for comments.
# The `version` field is deprecated in modern Docker Compose (v2+) and can be omitted.

version: "3.9" # define the docker-compose version (optional in Compose v2+)

services: # define all app services
  app: # name of the service -> becomes the container name prefix and internal DNS hostname
    build: . # tells docker where to build the image. '.' means current directory, equivalent to `docker build .`
    ports: # map host ports to container ports
      - "3000:3000" # HOST_PORT:CONTAINER_PORT
    depends_on: # defines dependencies — these services start before this one
      - db # this service depends on the db service
    environment: # inject environment variables into the container
      DB_HOST: db
      DB_USER: postgres
      DB_PASS: password

  db:
    image: postgres:15
    volumes:
      - db_data:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: password

volumes:
  db_data:

# deep drive into docker








# work of the inception 
first i did setup the nginx for serving the requiest that are comming 
with https (for securty i will use the TLS.2 protocole)


build may i will put it in the current dir : build: .
and put the port bridget to the : 443:443

443 cus is the port can used for https requiest ``check why later``




## docker file

first docker file is powerfull tool to set up and  build in docker image 
Docker-image: is readOnly template that have every peace to run the service
OSlayer->Depandencies->application code -> commands to run
      Each instruction in a Dockerfile creates a new read-only layer:
                [ writable container layer ]  ← runtime changes
                [ layer 3: COPY app files   ]
                [ layer 2: RUN apt-get      ]
                [ layer 1: FROM debian      ]  ← base image

      Docker uses a Union Filesystem (like OverlayFS) to merge all layers into a single unified view.
      and it also use Namespaces(for the isolation)
      pid-net-mnt-uts-ipc-user
      at the top of that he user the cgroups (Resource Controle) to manage the cpu memory and Disk I/O and Network bandwidth


Image Storage
Images are stored as content-addressable blobs identified by a SHA256 hash. Each layer has its own hash. Docker reuses layers across images if the hash matches — this saves disk space.
  sha256:a3b4c5d6... → base layer
  sha256:f1e2d3c4... → next layer

form here it come  to the big Pov:
            Dockerfile → docker build → Image → docker run → Container



this is in example of Dockerfile with explaining every line:



# ─── BASE IMAGE ───────────────────────────────────────────────
# Start from an official lightweight Debian-based image
FROM debian:bullseye-slim

# ─── METADATA ─────────────────────────────────────────────────
# Add labels for documentation/maintainability
LABEL maintainer="you@example.com"
LABEL version="1.0"
LABEL description="A full example Dockerfile"

# ─── ENVIRONMENT VARIABLES ────────────────────────────────────
# Set env vars available during build AND runtime
ENV APP_DIR=/app \
    APP_PORT=8080 \
    DEBIAN_FRONTEND=noninteractive

# ─── ARGUMENTS ────────────────────────────────────────────────
# Build-time variables (only available during build)
ARG BUILD_ENV=production

# ─── SYSTEM DEPENDENCIES ──────────────────────────────────────
# Update packages and install dependencies in ONE layer (best practice)
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    python3 \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ─── WORKING DIRECTORY ────────────────────────────────────────
# All following commands run from this directory inside the container
WORKDIR $APP_DIR

# ─── COPY FILES ───────────────────────────────────────────────
# Copy requirements first (layer caching optimization)
# Docker won't re-run pip install unless requirements.txt changes
COPY requirements.txt .

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# ─── FILE PERMISSIONS ─────────────────────────────────────────
RUN chmod +x entrypoint.sh

# ─── CREATE NON-ROOT USER (security best practice) ────────────
RUN useradd -m -u 1001 appuser && \
    chown -R appuser:appuser $APP_DIR
USER appuser

# ─── EXPOSE PORT ──────────────────────────────────────────────
# Documents which port the app listens on (does NOT publish it)
EXPOSE $APP_PORT

# ─── VOLUMES ──────────────────────────────────────────────────
# Declare a mount point for persistent data
VOLUME ["/app/data"]

# ─── HEALTHCHECK ──────────────────────────────────────────────
# Docker will periodically check if the container is healthy
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost:$APP_PORT/health || exit 1

# ─── ENTRYPOINT vs CMD ────────────────────────────────────────
# ENTRYPOINT: fixed command, always runs — cannot be overridden easily
# CMD: default arguments — can be overridden at runtime with docker run
ENTRYPOINT ["./entrypoint.sh"]
CMD ["--env", "production"]




Instruction   ->:   Purpose
FROM          ->:   Base image to build on
LABEL         ->:   Metadata
ENV           ->:   Runtime + build environment variables
ARG           ->:   Build-time only variables
RUN           ->:   Execute commands during build
WORKDIR       ->:   Set working directory
COPY          ->:   Copy files from host to image
EXPOSE        ->:   Document the port the app uses
VOLUME        ->:   Declare persistent storage mount
USER          ->:   Switch to non-root user (security)
HEALTHCHECK   ->:   Monitor container health
ENTRYPOINT    ->:   Fixed executable
CMD           ->:   Default arguments (overridable)