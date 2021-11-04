#!/usr/bin/env bash

if ! command -v git &> /dev/null
then
    sudo yum install -y git
fi
echo "git -->" && git --version

if ! command -v go &> /dev/null
then
    wget -c https://golang.org/dl/go1.17.2.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf go1.17.2.linux-amd64.tar.gz
    sudo sh -c "echo export PATH=$PATH:/usr/local/go/bin >> /etc/profile"
    source /etc/profile
fi
echo "go -->" && go version

if ! command -v node &> /dev/null
then
    curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
    sudo yum install -y nodejs
    sudo npm install -g npm@latest
fi
echo "node -->" && node -v
echo "npm -->" && npm -v

if ! command -v vue &> /dev/null
then
    sudo npm install -g @vue/cli
fi
echo "vue -->" && vue --version

rm -f /shared/vuego-demoapp
rm -f /shared/dist.tar.gz

cd
git clone https://github.com/jdmendozaa/vuego-demoapp.git
cd ~/vuego-demoapp/server/ 
/usr/local/go/bin/go build
mv vuego-demoapp /shared

cd
echo 'VUE_APP_API_ENDPOINT="http://10.0.0.8:4001/api"' > ~/vuego-demoapp/spa/.env.production.local
cd ~/vuego-demoapp/spa/
sudo npm install
sudo npm run build
tar -czf dist.tar.gz dist
mv dist.tar.gz /shared