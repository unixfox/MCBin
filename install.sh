#! /bin/sh

#Script d'installation automatique du service Minecraft

sudo wget https://github.com/unixfox/Minecraft-Server-Linux-service/releases/download/2.0/minecraft -P /etc/init.d/
sudo chmod a+x /etc/init.d/minecraft
sudo nano /etc/init.d/minecraft
sudo update-rc.d minecraft defaults