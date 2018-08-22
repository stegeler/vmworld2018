#!/bin/sh

# setup network
docker network create concourse-net

# start bostgres DB container
docker run \
  --name concourse-db \
  --net=concourse-net \
  -h concourse-postgres \
  -p 5432:5432 \
  -e POSTGRES_USER=postgresadmin \
  -e POSTGRES_PASSWORD='VMware1!' \
  -e POSTGRES_DB=atc \
  -d postgres

# start concourse container
docker run \
  --name concourse \
  -h concourse \
  -p 8080:8080 \
  --detach \
  --privileged \
  --net=concourse-net \
  concourse/concourse quickstart \
    --add-local-user='admin:VMware1!' \
	--main-team-local-user=concourseadmin \
	--external-url=http://10.40.14.6:8080 \
	--postgres-user=postgresadmin \
	--postgres-password='VMware1!' \
	--postgres-host=concourse-db \
	--worker-garden-dns-server 8.8.8.8

# concourse user = admin, password is VMware1!
# access via (for example): http://10.40.14.6:8080 

# get Fly CLI tool
wget https://github.com/concourse/concourse/releases/download/v4.0.0/fly_linux_amd64
mv fly_linux_amd64 fly
chmod +x fly

# you'll need to move the fly CLI tool or add to your path
mkdir -p ~/bin
mv fly ~/bin

# start the pipeline called "vsphereacct" 
~/bin/fly --target vsphereacct login -u admin -p 'VMware1!' --concourse-url http://10.40.14.6:8080 -n main

