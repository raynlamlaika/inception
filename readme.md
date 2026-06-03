## INCEPTION



# First let's walk step by step into the BASE of every service
    -- DATABASE
    -first is the ``MARIABD DATABASE`` the set of the DATABASE
    as first step is the installation of mariadb ofc:
    <apt-get update && apt-get install -y mariadb-server mariadb-client>
        - `mariadb-server`: The MariaDB server package. This installs the database daemon (usually `mysqld`) which stores your databases, listens on port 3306 by default, and should run where the database will reside (for example in a dedicated database container). After installation, run the secure setup and create the initial users and databases.
        - `mariadb-client`: The MariaDB client package. This provides command-line tools (like the `mysql` client) used to connect to a MariaDB/MySQL server. Install this on application containers or admin hosts that need to connect to the database. Example usage: `mysql -u root -p -h <db-host>`
    Next is start script to set-up:
        firs: we taking the envermment varibles:
            `MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)`
            `MYSQL_PASSWORD=$(cat /run/secrets/db_password)`
            `MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}`
            `MYSQL_USER=${MYSQL_USER:-wordpress}`
            for the data base this this the needed varibles: MYSQL_ROOT_PASSWORD, MYSQL_PASSWORD,MYSQL_DATABASE, MYSQL_USER
        next: we start mariadb in the background
            service mariadb start | we can use sysctl of user base support it
        service it takes service <name> start|stop|restart|status|reload
        we use service to manage the strat stop ... of the deamon of mariadb that he gonna run in the background
        after the start we wait for connection to connect with mariadb
            ```until mysqladmin -u root ping >/dev/null 2>&1 || { [ -n "$MYSQL_ROOT_PASSWORD" ] && mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" ping >/dev/null 2>&1; }; do```






# Next let's walk in nginx who gonna serve our wordpress in next
    -- LOADBALANCER
    first we start with the config setup
    we create server for stack to hold our routes and protocols ports ...
    first we specify the port that we gonna listen from : listen 443 ssl; listen [::]:443 ssl;
    first one for just the binding of the port in normal way that it suppert the ipv4 the second one it support ip v6

    







    
        
