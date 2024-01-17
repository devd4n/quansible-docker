# quansible-docker

# Setup Docker
docker swarm init
docker build -t quansible-3 . 
docker secret create authorized_keys <<path to authorized_keys_file | or id_rsa.pub file of Host>>
docker secret create public_repo_priv_key <<>>
docker secret create private_repo_priv_key <<>>

docker service create --name quansible --secret authorized_keys --publish mode=host,target=22,published=2225 quansible-3 

# Clear up Docker
docker secret rm authorized_keys
docker service rm quansible

# Debug / View
docker service ls
docker service ps quansible
docker service inspect --pretty quansible


# Some Docs
https://earthly.dev/blog/docker-secrets/


# Next Steps

- Update quansible Repo to match this project

- Test passing multiple secrets:
  docker service create --name quansible --secret authorized_keys --secret public_repo_priv_key --publish mode=host,target=22,published=2225
- service controlling -> how to restart service


