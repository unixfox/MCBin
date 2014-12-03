#! /bin/sh

autoinstall() {
  sudo wget url -p /etc/init.d/
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
