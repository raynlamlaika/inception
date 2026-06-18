
# first is the base image 
# definition of image it represents the template for the container we want to create
# why the docker file keywords are in uppercase?
# the keywords in a Dockerfile are typically written in uppercase to distinguish them from other text and to improve readability.
FROM debian:bookworm



# then we have the maintainer of the image
# RUN vs CMD vs ENTRYPOINT
# RUN is used to execute commands during the build process of the Docker image. It is typically
# used to install software packages, set up the environment, or perform any necessary configuration.
# The commands specified in a RUN instruction are executed in 
# a new layer on top of the base image, and the resulting changes are committed to the image.
# CMD is used to specify the default command that will be executed when a container is started from the image.
# It provides a default command and arguments that can be overridden when running the container. If
# no command is specified when running the container, the CMD instruction will be executed.
# ENTRYPOINT is used to specify the command that will be executed when a container is started from the image.
# It is similar to CMD, but it is not overridden when running the container. The
# command specified in an ENTRYPOINT instruction will always be executed, 
#regardless of any command-line arguments provided when running the container. 
#This makes ENTRYPOINT useful for defining the main process of a container that should always run.

RUN apt-get update && apt-get install -y mariadb-server mariadb-client

# the dependency that we install is mariadb-server and mariadb-client
# mariadb-server is the server software that allows us to run a MariaDB database
# while mariadb-client is the client software that allows us to interact with the database from the command line.

COPY tools/DataBase.sh /usr/local/bin/setup.sh
# the copy command is used to copy files from the host machine to the container.

RUN chmod +x /usr/local/bin/setup.sh


EXPOSE 3306
# the expose command is used to specify that the container will listen on a specific port at runtime

ENTRYPOINT ["/usr/local/bin/setup.sh"]




#here is how to creat volume for this data base container
# docker volume create --driver local --opt type=none --opt device=/home/$USER/data/mariadb --opt o=bind dataBase  
# the above command creates a Docker volume named "dataBase" 
# that is bound to the local directory "/home/$USER/data/mariadb" on the host machine. 
# This allows the container to access and persist data in that directory.


# same  for the wordpress container
# docker volume create --driver local --opt type=none --opt device=/home/$USER/data/mariadb --opt o=bind dataBase  
# docker volums ls  to list all the volumes that we have created


# docker volume inspect dataBase to see the details of the volume that we have created


#now we need to creat network for our containers to communicate with each other
# docker network create --driver bridge my_network
# the above command creates a Docker network named "my_network" using the bridge driver.
# the type of network is bridge which is the default network driver in Docker.
# other types of network drivers include host, overlay, and macvlan, each with its own use cases and configurations.



# docker run -d --name mariadb --network inceptionNetwork  -v mariadb_volume:/var/lib/mysql   mary