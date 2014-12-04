#!/bin/bash
#Created by unixfox
#Thanks Julien008 for the suggestions and the bugs report.

#Descriptions du service
DESC="Script to manage a Minecraft server from a service."
SERVICE_NAME=minecraft

#Options
MC_PATH='/directory/of/your/server/' #Directory of your Minecraft server.
NOM_JAR='minecraft_server.jar' #Name of the .jar file of your Minecraft server.
MEMALOC=512 #Memory of your Minecraft Server.
TPSWARN=10 #Time after that the server shutting down or restart.
SCREEN_NAME='minecraft' #Name of the screen.

#Variables
server_stop() {
        echo -n "Shutting down the Minecraft server..."
        screen -S $SCREEN_NAME -p 0 -X stuff "`printf "say The server will shutting down in $TPSWARN SECONDS.\r"`"
        screen -S $SCREEN_NAME -p 0 -X stuff "`printf "save-all\r"`"
        sleep ${TPSWARN}
        screen -S $SCREEN_NAME -p 0 -X stuff "`printf "stop\r"`"
        sleep 7
        echo " [OK]"
}

server_start() {
        echo -n "Starting Minecraft server..."
        cd $MC_PATH && screen -h 1024 -dmS $SCREEN_NAME java -jar -Xmx${MEMALOC}M -Xms512M -XX:MaxPermSize=128M -Dfile.encoding=UTF8 $NOM_JAR nogui; 
        sleep 1
        echo " [OK]"
}

commande() {
     exec="$1";
     echo "Executing command..."
     screen -S $SCREEN_NAME -p 0 -X stuff "`printf "$exec\r"`"
     sleep .1
     echo " [OK]"
}

console() {
     screen -r $SCREEN_NAME
}

# Corps du script
case "$1" in
  start)
        server_start
        ;;
  stop)
        server_stop
        ;;
  restart)
    server_stop
    server_start
    ;;
  exec)
        if [ $# -gt 1 ]; then
        shift
        commande "$*"
        else
        echo "You must specify the command (exemple : 'help')."
  fi
  ;;
  console)
    console
    ;;
  *)
        echo "Utilisation: service minecraft {start|stop|exec <command>|console}"
        exit 1
        ;;
esac

exit 0
