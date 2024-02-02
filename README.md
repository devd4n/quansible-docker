# quansible-docker

### Setup Docker
docker swarm init
docker build -t quansible_v0 . [--no-cache]       # use --no-cache to rebuild completely

### Create Secrets
docker secret create authorized_keys <<path to authorized_keys_file | or id_rsa.pub file of Host>>
docker secret create qu_git_tokens <<path to token file>>

docker secret create qu_master_priv <<path to ssh-key file>>
docker secret create qu_master_pub <<path to ssh-key file>>

### Create Service
docker service create --name quansible --publish mode=host,target=22,published=2225 \
--mount type=bind,src=C:\Users\<<USERNAME>>\quansible-local,dst=/srv/quansible-local[,readonly] \
--secret authorized_keys \
--secret q_public_token \
--secret source=q_qu_git_tokens,target=/run/secrets/qu_git_tokens \
--secret source=qu_master_priv,target=/run/secrets/ssh_keys/qu_master_priv \
--secret source=qu_master_pub,target=/run/secrets/ssh_keys/qu_master_pub \
quansible_v0

### Clear up Docker
docker service rm quansible
docker secret rm <<secret name>>

### Restart Service
docker service update quansible --force
-> without force parameter have to be added like with create command!!!

### Debug / View
docker service ls
docker service ps quansible
docker service inspect --pretty quansible

### Some Docs
https://earthly.dev/blog/docker-secrets/


### ToDos-Bugs

- currently nothing documented


# HELP
### Run Docker Desktop on Windows as non Admin User
https://stackoverflow.com/questions/61530874/docker-how-do-i-add-myself-to-the-docker-users-group-on-windows
net localgroup docker-users "your-user-id" /ADD