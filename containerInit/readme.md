## Notes

### Virtualization takeaway
Virtualization layers software over hardware so one physical machine can be split into several virtual machines (VMs). Each VM receives its own slice of CPU, memory, and storage, which gives us isolation and fast provisioning.

### `ldd` in one sentence
`ldd <binary>` prints the dynamic libraries required by that executable. Missing libraries in the output mean the binary will fail to start inside a minimal root filesystem.

### Core primitives we explore
- **`chroot`** – change the visible root directory for a process.
- **Namespaces** – isolate resources (PIDs, network, mounts, IPC, etc.).
- **Control groups (cgroups)** – limit or account for CPU, memory, block I/O.
- **`runc`** – low-level CLI that combines namespaces + cgroups to start containers.

## Base container sandbox
Launch a privileged Ubuntu playground so kernel features are available:

```bash
docker run -it --name docker-host --rm --privileged ubuntu:bionic
```

Inside the container:
1. Create a mini rootfs (e.g., `mkdir -p newroot/{bin,lib64,...}`).
2. Copy `bash` and its `ldd` dependencies.
3. Run `chroot newroot /bin/bash` to point `/` at `newroot` and observe how isolation begins.

## Namespaces quick notes
- Namespaces keep one user/process from seeing or killing another user’s processes.
- `unshare` lets us create a new namespace for a child process (`network`, `PID`, `user`, `mount`, etc.).
- Example: `unshare --pid --fork --mount-proc /bin/bash` to spawn a shell with its own PID view.

## cgroups refresher
- cgroups cap memory, CPU, blkio, devices, freezer, etc.
- Prevent runaway processes from exhausting host resources.
- Tooling: `cgcreate`, `cgexec`, systemd slices, or direct writes under `/sys/fs/cgroup` (v2).

## Handy Docker CLI tags
- `-it`: interactive terminal.
- `-d`: run in background; combine as `-dit`.
- `docker attach <id>`: re-enter a running container’s TTY.
- `docker exec <id> <cmd>`: run a new process inside a container.
- `docker kill <id>`: send SIGKILL (container still exists on disk).
- `docker rm <id>`: delete a stopped container (`-f` stops + removes).
- `docker pause` / `docker unpause`: freeze and resume all container processes.
- `docker container prune`: delete every stopped container (careful!).
- `docker history <image>`: show layer history.
- `docker info`: host/daemon details (e.g., `Docker Root Dir`).

## Dockerfile vs CLI
You can replicate any long `docker run ...` sequence with a Dockerfile so build/run steps stay documented. Example: `docker run -it sha256:... ls` overrides the image `CMD` with `ls`. Naming images (`docker build -t miniserv .`) is easier than remembering SHA hashes.

## Image housekeeping
- Location: `docker info | grep 'Docker Root Dir'`.
- List images: `docker images`.
- Remove resources: `docker rm -f <container>` or `docker rmi -f <image>`.

## Port publishing cheat sheet

```bash
docker run --init --rm --publish 1227:1227 modir
```

- `--init`: small init process to forward signals (helps Ctrl+C).
- `--publish host:container`: map host port → container port.
- `EXPOSE 1227` in the Dockerfile documents the internal port; publishing actually opens it.
- Let Docker pick a random host port with `-P`, then inspect `docker ps`:

```
CONTAINER ID   IMAGE   COMMAND   PORTS
7db77a3e7cf7   modir   "./serv" 0.0.0.0:32769->1227/tcp
```

Connect with `nc 127.0.0.1 32769` (or `curl`) to talk to the service.

## Layer caching + `.dockerignore`
Every Dockerfile instruction creates a layer. Changing a higher layer invalidates everything below it, so order expensive steps carefully. Use `.dockerignore` like `.gitignore` to skip files (e.g., `.git`, `secrets/`, `node_modules/`) and keep builds lean.
