#!/bin/bash --
#check if user $user exists, if not, create one
user="nexus"
if id "$user" >/dev/null 2>&1; 
then
  echo "User "$user" exists."

  # Check if the current UID and GID are already set to the target values
  target_uid="200"
  target_gid="200"
  current_uid=$(id -u "$user")
  current_gid=$(id -g "$user")
  if [ "$current_uid" -eq "$target_uid" ] && [ "$current_gid" -eq "$target_gid" ]; 
  then
    echo "User $user already has UID:GID $target_uid:$target_gid."
  else
    # Change the UID and GID to the target values
    sudo usermod -u "$target_uid" -g "$target_gid" "$username"
    echo "UID and GID for user $user changed to $target_uid:$target_gid."
  fi
else
    sudo groupadd -g "$target_gid" "$user"
    sudo useradd -u "$target_uid" -g "$target_gid" -s /bin/bash "$user"
fi

# check if nexus volume exists
if [ ! -d "./nexus-volume" ]; 
then
  mkdir "nexus-volume"
else
  echo "nexus volume already exists"
fi

# set correct ownership for nexus volume
if [[ $(stat -c "%U" ./nexus-volume) == "$user" ]]; 
then
    echo "nexus-volume ownership is set correctly"
else
    sudo chown "$user":"$user" "nexus-volume"
fi

# Run nginx and nexus containers
docker-compose up -d