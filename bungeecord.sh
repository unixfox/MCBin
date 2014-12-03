#! /bin/sh
#Création par unixfox (Emilien) - Created by unixfox
#Merci Julien008 pour les suggestions et report de bugs.

#Descriptions du service
DESC="Script permettant de gérer plusieurs serveurs Minecraft à partir d'un service."
SERVICE_NAME=minecraft

#Options
MC_PATH='/le/répertoire/où/se/trouve/vos/serveurs/' #Répertoire général où se trouve vos serveurs Minecraft
NOM_JAR='minecraft_server.jar' #Nom du fichier .jar de votre serveur minecraft
MEMALOC=512 #Mémoire à allouer pour chacun de vos serveurs minecraft
MEMALOCPROXY=512 #Mémoire à allouer pour Bungeecord
TPSWARN=10 #Temps après le quel le serveur va s'éteindre ou redémarrer.
SCREEN_NAME='minecraft' #Nom de la fenêtre.
NBRSERV=2 #Nombre de serveurs

#Variables
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
	    echo -n "Lancement du proxy..."
        cd $MC_PATH/proxy && screen -h 1024 -dmS proxy java -jar -Xmx${MEMALOCPROXY}M -Xms128M -XX:MaxPermSize=128M -Dfile.encoding=UTF8 bungeecord.jar nogui;
        sleep 1
        echo " [OK]"
	    for NBRSERVMIN in `seq 1 $NBRSERV`;
	    do
	    	echo -n "Lancement du serveur ${NBRSERVMIN}..."
			cd $MC_PATH/server"${NBRSERVMIN}" && screen -h 1024 -dmS $SCREEN_NAME"${NBRSERVMIN}" java -jar -Xmx${MEMALOC}M -Xms512M -XX:MaxPermSize=128M -Dfile.encoding=UTF8 $NOM_JAR nogui;
			sleep 1
			echo " [OK]"
	    done
		echo -n "Tous les serveurs ont étés démarrés !"
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
