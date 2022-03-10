default_container_name="of2112-py1.10.2-cpu"
container_name="${1:-$default_container_name}"
docker start $container_name
docker exec -it $container_name /bin/bash
