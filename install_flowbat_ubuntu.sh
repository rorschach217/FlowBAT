#!/bin/bash

#Make sure you're not installing as root.
if [[ $EUID -eq 0 ]]; then
   echo "You'll want to run this as the user by which FlowBATLight will run. Do not use root."
   exit 1
fi
# Setup install vars
workingDir=$PWD
flowbatUser=$USER

## Update and Upgrade
sudo apt-get update
if [[ $(sudo fuser /var/lib/dpkg/lock) ]]; then
    echo "There is apt-get lock keeping things from installing. Exiting"
    exit
fi

# Install Pre-reqs
sudo apt-get install -y curl build-essential git unzip

# Clone the FlowBATLight repo
git clone https://github.com/rorschach217/FlowBATLight

(cd $workingDir/FlowBATLight/bundle/programs/server && npm install)

xenialinstall() {
# Install NVM and Node 8.9.3
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
 nvm install v8.11.4

## Install mongodb
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list

sudo apt-get update

sudo apt-get install -y mongodb-org

sudo service mongod start

#Generating systemd configuration for FlowBATLight
cat <<EOF > $workingDir/flowbat.service
[Service]
Type=simple
ExecStart=/home/$flowbatUser/.nvm/versions/node/v8.11.4/bin/node $workingDir/FlowBATLight/bundle/main.js
Restart=on-failure
RestartSec=10 5
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=flowbat
User=$flowbatUser
Environment=NODE_ENV=production
Environment=PWD=$workingDir/FlowBATLight/bundle/
Environment=PORT=1800
Environment=HTTP_FORWARDED_COUNT=1
Environment=MONGO_URL=mongodb://localhost:27017/flowbat
Environment=ROOT_URL=https://127.0.0.1
Environment='METEOR_SETTINGS={ "baseUrl": "http://127.0.0.1:1800", "mailUrl": "", "isLoadingFixtures": false, "apm": { "appId": "", "secret": "" }, "public": { "version": "FlowBATLight v1.5.3", "isDebug": false, "googleAnalytics": { "property": "", "disabled": true }, "mixpanel": { "token": "", "disabled": false } } }'

[Install]
WantedBy=default.target
EOF
sudo mv $workingDir/flowbat.service /lib/systemd/system/flowbat.service

#Configuring autostart
sudo systemctl daemon-reload
sudo systemctl start flowbat
sudo systemctl enable flowbat
}

xenialinstall
