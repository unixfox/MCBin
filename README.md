![ComputerCraft](http://www.computercraft.info/wiki/images/d/da/Ccblink.gif)
[MCBin](http://mcbin.unixfox.eu/) [![Build Status](https://travis-ci.org/unixfox/MCBin.svg?branch=master)](https://travis-ci.org/unixfox/MCBin)
==============================

Bash script to easily and simply manage your (your) server (s) Minecraft [English version here](https://github.com/unixfox/Minecraft-Server-Linux-service/tree/master-en).

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
=======
