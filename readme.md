about inception



first use docker compose to creat severl services for in semple infrastructure
`Docker Compose is a tool for defining and running multi-container Docker applications. It simplifies the management of complex applications that require multiple services, such as a web server, a database, and other supporting components.`



waht a docker-compose.yaml is :
A Docker Compose file, typically named docker-compose.yml, is a YAML-formatted configuration file used by Docker Compose to define and manage multi-container Docker applications. It acts as a blueprint for your application's services, networks, and volumes, enabling you to orchestrate the entire application stack with a single command.

the denifits of that is to manage multiple docker app and Simplified management
and also the portability witch is Allows starting, stopping, and rebuilding the entire application stack with single commands (e.g., docker compose up, docker compose down).






src
```
inception/
├── Makefile
├── docker-compose.yml
├── .env                     # environment variables (optional, recommended)
└── srcs/
    ├── requirements/
    │   ├── nginx/
    │   │   ├── Dockerfile
    │   │   ├── conf/
    │   │   │   └── default.conf
    │   ├── wordpress/
    │   │   ├── Dockerfile
    │   │   ├── tools/
    │   │   │   └── setup.sh
    │   ├── mariadb/
    │   │   ├── Dockerfile
    │   │   ├── conf/
    │   │   │   └── my.cnf
    │   │   ├── tools/
    │   │   │   └── init.sql
    ├── .env            # local env copy for compose context if needed
    └── volumes/        # (optional) bind-mounted folders for persistent data
```
