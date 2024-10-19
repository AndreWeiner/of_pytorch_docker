default_container_name="of2406-py2.5.0-cpu"
container_name="${1:-$default_container_name}"
docker start $container_name
docker exec -it $container_name /bin/bash
