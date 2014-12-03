#! /bin/sh

autoinstall() {
  sudo wget https://github.com/unixfox/Minecraft-Server-Linux-service/releases/download/2.0/minecraft.sh -P /tmp
  sudo mv /tmp/minecraft.sh /etc/init.d/minecraft
  sudo chmod a+x /etc/init.d/minecraft
}

case "$1" in
  startup)
    autoinstall
    sleep 1
		sudo update-rc.d minecraft defaults
		;;
  *)
		autoinstall
		exit 1
esac
