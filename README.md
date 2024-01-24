# quansible-docker

# Setup Docker
docker swarm init
docker build -t quansible_v0 . [--no-cache]       # use --no-cache to rebuild completely
docker secret create authorized_keys <<path to authorized_keys_file | or id_rsa.pub file of Host>>
docker secret create public_repo_priv_key <<>>
docker secret create private_repo_priv_key <<>>

docker service create --name quansible --secret authorized_keys --publish mode=host,target=22,published=2225 quansible_v0

## docker service with bind mount of (quansible-local) read-only
docker service create --name quansible --secret authorized_keys --publish mode=host,target=22,published=2225 --mount type=bind,src=C:\Users\<<USERNAME>>\quansible-local,dst=/srv/quansible-local[,readonly] quansible_v0

# Clear up Docker
docker secret rm authorized_keys
docker service rm quansible

# Debug / View
docker service ls
docker service ps quansible
docker service inspect --pretty quansible


# Some Docs
https://earthly.dev/blog/docker-secrets/


# ToDos-Bugs

TODOs:
- (ongoing) Update quansible Repo to match this project
- create volume which maps to /srv -> shouldn't be deleted by shutdown container
- (open) Test passing multiple secrets:
  docker service create --name quansible --secret authorized_keys --secret public_repo_priv_key --publish mode=host,target=22,published=2225
- (open) documentation - service controlling -> how to restart service

