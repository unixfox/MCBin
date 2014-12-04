Minecraft-Server-Linux-service [![Build Status](https://travis-ci.org/unixfox/Minecraft-Server-Linux-service.svg?branch=master)](https://travis-ci.org/unixfox/Minecraft-Server-Linux-service)
==============================

A Linux service for your Minecraft server.

-------------------------

Un service Linux pour votre serveur Minecraft. [Version française ici](https://github.com/unixfox/Minecraft-Server-Linux-service).

# How to install the service ?

1. Download the script : `https://github.com/unixfox/Minecraft-Server-Linux-service-en/releases/download/2.0/minecraft -P /etc/init.d`
2. Make it executable : `sudo chmod a+x /etc/init.d/minecraft`
3. Edit the service and change the lines of the options : `sudo nano /etc/init.d/minecraft`
4. Save it (ctrl + x)
5. Add it to system services : `sudo update-rc.d minecraft defaults`

# How to use the service ?

Just type the command : `service minecraft` and see the possibilities.
