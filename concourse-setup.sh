docker run --name concourse-db   --net=concourse-net   -h concourse-postgres   -p 5432:5432   -e POSTGRES_USER=postgresadmin   -e POSTGRES_PASSWORD=VMware1!   -e POSTGRES_DB=atc   -d postgres

docker run  --name concourse   -h concourse   -p 8080:8080   --detach   --privileged   --net=concourse-net   concourse/concourse quickstart   --add-local-user=concourseadmin:VMware1!   --main-team-local-user=concourseadmin   --external-url=http://10.40.14.6:8080   --postgres-user=postgresadmin   --postgres-password=VMware1!   --postgres-host=concourse-db   --worker-garden-dns-server 8.8.8.8
