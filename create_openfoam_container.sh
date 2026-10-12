username="$USER"
user="$(id -u)"
default_image="of_pytorch:of2606-py2.14.1-cpu"
image="${1:-$default_image}"
default_container_name="of2606-py2.14.1-cpu"
container_name="${2:-$default_container_name}"

docker container run -it -d --name $container_name        \
  --user=${user}                                          \
  -e USER=${username}                                     \
  -v="$PWD/test":"/home/$username"                        \
  --workdir="/home/$username"                             \
  --volume="/etc/group:/etc/group:ro"                     \
  --volume="/etc/passwd:/etc/passwd:ro"                   \
  --volume="/etc/shadow:/etc/shadow:ro"                   \
  --volume="/etc/sudoers.d:/etc/sudoers.d:ro"             \
    $image
