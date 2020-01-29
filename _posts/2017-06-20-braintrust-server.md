---
layout: post
section-type: post
title: Setting up the BrainTrust Server
category: Category
tags: [ 'research', 'fsharp', 'braintrust' ]
---
I've been following various guides for setting up this server, but it got to the point where I thought
I'd better make some notes in case I have to redo everything from scratch.

[Digital Ocean](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04) has some fantastic guides than I've leaned on heavily.

Let's install some stuff on the 16.04 base image. Some of this might be cruft (and I've excluded presumed cruft):

```
sudo apt-get install openssh-server libappindicator1  openjdk-8-jdk xfce4 xfce4-goodies tightvncserver bash-completion dotnet-dev-1.0.4 gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal git maven
```

Proceed to [set up ssh and ufw](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04)

Install [mono and fsharp from specific repo](https://fsharp.org/use/linux/)

```
 278  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
  279  echo "deb https://download.mono-project.com/repo/ubuntu xenial main" | sudo tee /etc/apt/sources.list.d/mono-official.list
  280  sudo apt-get update
  281  sudo apt-get install mono-complete fsharp
```

Install [node from specific repo](https://nodesource.com/blog/installing-node-js-tutorial-ubuntu/)

```
   57  curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
   58  sudo apt-get install -y nodejs
```

Set up various node utilities

```
sudo npm install --global yarn
```

Install [mongodb from a specific repo](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/)

```
   92  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
   93  cat /etc/apt/sources.list
   94  echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
   95  sudo apt-get update
   96  sudo apt-get install -y mongodb-org
   97  sudo service mongod start
   98  cat /var/log/mongodb/mongod.log 
```
[Set up mongodb](https://www.digitalocean.com/community/tutorials/how-to-install-mongodb-on-ubuntu-16-04)

[Set up mongo authentication and bt access](https://docs.mongodb.com/manual/tutorial/enable-authentication/)

Install Craig's MATE; requires [setting java_home](https://stackoverflow.com/questions/14183934/how-to-properly-set-java-home-in-etc-environment)

```
git clone https://github.com/CraigKelly/mateplus-poc.git
cd mateplus-poc/
./script/deps.sh 
cd sample && mvn test
```

[Set up VNC](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-vnc-on-ubuntu-16-04)

[Fix autocomplete in xfce](https://www.smork.info/blog/2015/06/10/fixing_bash_tab_completion_in_xfce.html)

[Install Caddy](https://www.digitalocean.com/community/tutorials/how-to-host-a-website-with-caddy-on-ubuntu-16-04)

[Set up node app with forever](https://www.digitalocean.com/community/tutorials/how-to-host-multiple-node-js-applications-on-a-single-vps-with-nginx-forever-and-crontab)

Install VSCode and Chrome

