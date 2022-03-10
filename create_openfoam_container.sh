username="$USER"
user="$(id -u)"
default_image="andreweiner/of_pytorch:of2112-py1.10.2-cpu"
image="${1:-$default_image}"
default_container_name="of2112-py1.10.2-cpu"
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
