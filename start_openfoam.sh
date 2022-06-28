default_container_name="of2206-py1.11.0-cpu"
container_name="${1:-$default_container_name}"
docker start $container_name
docker exec -it $container_name /bin/bash
