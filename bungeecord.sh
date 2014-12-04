#!/bin/bash
#Création par unixfox (Emilien) - Created by unixfox
#Merci Julien008 pour les suggestions et report de bugs. Et son petit code sur les boucles !

#Descriptions du service
DESC="Script permettant de gérer plusieurs serveurs Minecraft à partir d'un service."
SERVICE_NAME=minecraft

#Options
MC_PATH='/le/répertoire/où/se/trouve/vos/serveurs' #Répertoire général où se trouve vos serveurs Minecraft /!\ Ne pas mettre de / à la fin du dernier répertoire !
NOM_JAR='minecraft_server.jar' #Nom du fichier .jar de votre serveur minecraft
MEMALOC=512 #Mémoire à allouer pour chacun de vos serveurs minecraft
MEMALOCPROXY=512 #Mémoire à allouer pour Bungeecord
TPSWARN=10 #Temps après le quel bungeecord va s'arrêter.
SCREEN_NAME='minecraft' #Nom de la fenêtre.
NBRSERV=2 #Nombre de serveurs

#Variables
server_stop() {
        echo -n "Arrêt du proxy..."
        screen -S proxy -p 0 -X stuff "`printf "broadcast Arrêt du serveur dans $TPSWARN SECONDES.\r"`"
        sleep ${TPSWARN}
        screen -S proxy -p 0 -X stuff "`printf "end\r"`"
        sleep 7
        echo " [OK]"
        for NBRSERVMIN in `seq 1 $NBRSERV`;
	    do
	    	echo -n "Arrêt du serveur ${NBRSERVMIN}..."
       		screen -S $SCREEN_NAME"${NBRSERVMIN}" -p 0 -X stuff "`printf "save-all\r"`"
        	screen -S $SCREEN_NAME"${NBRSERVMIN}" -p 0 -X stuff "`printf "stop\r"`"
        	sleep 3
        	echo " [OK]"
	    done
}

server_stop_set() {
          echo -n "Arrêt du serveur ${2}..."
          screen -S $SCREEN_NAME"${2}" -p 0 -X stuff "`printf "save-all\r"`"
          screen -S $SCREEN_NAME"${2}" -p 0 -X stuff "`printf "stop\r"`"
          sleep 3
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

server_start_set() {
  echo -n "Lancement du serveur ${2}..."
      cd $MC_PATH/server"${2}" && screen -h 1024 -dmS $SCREEN_NAME"${2}" java -jar -Xmx${MEMALOC}M -Xms512M -XX:MaxPermSize=128M -Dfile.encoding=UTF8 $NOM_JAR nogui
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

# Corps du script
case "$1" in
  start)
      if [[ "$2" == "" ]]
      then
      server_start
      else
        server_start_set
        fi;;
  stop)
        if [[ "$2" == "" ]]
      then
      server_stop
    else
        server_stop_set
        fi;;
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
        echo "Utilisation: service minecraft {start <server> <numéro>|stop|exec <commande>|console}"
        exit 0
        ;;
esac

exit 0
