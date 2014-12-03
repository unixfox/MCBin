#! /bin/sh
#Création par unixfox (Emilien) - Created by unixfox
#Merci Julien008 pour les suggestions et report de bugs.

DESC="Script permettant de gérer un serveur Minecraft à partir d'un service."
SERVICE_NAME=minecraft

MC_PATH='/le/répertoire/où/se/trouve/votre/serveur/' #Répertoire de votre serveur minecraft - Directory of your Minecraft server
NOM_JAR='minecraft_server.jar' # Nom du fichier .jar de votre serveur minecraft - Name of the .jar file of your Minecraft server
MEMALOC=512 # Mémoire à allouer à votre serveur minecraft - Memory of your Minecraft Server
TPSWARN=10 #Temps après le quel le serveur va s'éteindre ou redémarrer. Argument warn à ajouter à la commande stop ou restart.
SCREEN_NAME='minecraft' #Nom de la fenêtre.

server_stop() {
        echo -n "Arrêt du serveur Minecraft..."
        screen -S $SCREEN_NAME -p 0 -X stuff "`printf "say Arrêt du serveur dans $TPSWARN SECONDES.\r"`"
        screen -S $SCREEN_NAME -p 0 -X stuff "`printf "save-all\r"`"
        sleep ${TPSWARN}
        screen -S $SCREEN_NAME -p 0 -X stuff "`printf "stop\r"`"
        sleep 7
        echo " [OK]"
}

server_start() {
  echo -n "Lancement du serveur minecraft..."
        cd $MC_PATH && screen -h 1024 -dmS $SCREEN_NAME java -jar -Xmx${MEMALOC}M -Xms512M -XX:MaxPermSize=128M -Dfile.encoding=UTF8 $NOM_JAR nogui; 
        sleep 1
        echo " [OK]"
}

commande() {
     exec="$1";
     echo "Exécution de la commande..."
     screen -S $SCREEN_NAME -p 0 -X stuff "`printf "$exec\r"`"
     sleep .1
     echo " [OK]"
}

console() {
  screen -r $SCREEN_NAME
}

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
        echo "Vous devez spécifier une commande (exemple : 'help')."
  fi
  ;;
  console)
    console
    ;;
  *)
        echo "Utilisation: service minecraft {start|stop|exec <commande>|console}"
        exit 1
        ;;
esac

exit 0