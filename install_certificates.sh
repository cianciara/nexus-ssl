#!/bin/bash --

# check if user has sudo privileges
if sudo -v >/dev/null 2>&1; 
then

  # check if libnss3-tool package is already installed
  if dpkg -l libnss3-tools >/dev/null; 
  then 
    echo -e "\n --- certutil already installed ---"
  else
    echo -e "\n --- installing certutil library ---"
    sudo apt install -y libnss3-tools
  fi

  # install mkcert binary from https://dl.filippo.io/mkcert/latest?for=linux/amd64 if its not installed
  FILE="/usr/local/bin/mkcert"     
  if [ -f $FILE ]; 
  then
    echo -e " --- mkcert already installed ---"
  else
    echo -e " --- installing mkcert ---"
    curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64"
    chmod +x mkcert-v*-linux-amd64
    sudo cp mkcert-v*-linux-amd64 /usr/local/bin/mkcert 
  fi

  # check if CA is installed
  CAKEY="$HOME/.local/share/mkcert/rootCA-key.pem"
  CA="$HOME/.local/share/mkcert/rootCA.pem"
  if [ -f "$CAKEY" ]; 
  then
    echo -e " --- root CA installed ---"
  elif [ ! -e "$CAKEY" ] && [ -f "$CA" ];
  then
    echo "--- key install failed: remove old rootCA.pem from CAROOT folder ---"
  else
    echo -e " --- creating root CA ---"
    mkcert -install
  fi

  # check if nginx certificates exist, if not, create, copy them to nginx folder and rename them
  NGINXCA="nginx/nginx-cert.pem"
  NGINXKEY="nginx/nginx-key.pem"     
  if [ ! -e "$NGINXCA" ] || [ ! -e "$NGINXKEY" ]; 
  then
    if [ -d "./oldCA" ]; 
    then
    echo 
    else
      mkdir oldCA
    fi
    if [ -f "*.pem" ];
    then
        cp -i *.pem ./oldCA && rm *.pem
    else
    echo -e " --- no old certificates found ---"
    fi
    read -p "Enter names for certificate, separated by spaces: " NAME
    echo -e " --- generating certificates for $NAME... ---"
    mkcert $NAME
    cp *.pem nginx/
    cd ./nginx
    FILES=*.pem
    for f in $FILES
    do
      if 
        grep -q "CERTIFICATE" "$f";
      then
        mv "$f" nginx-cert.pem
      else
        mv "$f" nginx-key.pem
      fi
    done
  else
    echo -e " --- nginx certificate exists ---"  
  fi

sudo -K
else
    echo "--- this script must be run by user with sudo privileges ---"
fi