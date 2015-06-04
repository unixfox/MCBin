#! /bin/bash
#By Julien00859 & unixfox
MC_PATH=~/Minecraft #Racine du serveur
MC_JAR=$(ls $MC_PATH | grep minecraft_server) #Nom du jar à exécuter
SCREEN_NAME=Minecraft #Le nom du screen sur lequel le serveur tournera
MEMALOC=2048 #La RAM maximale allouée au serveur en MO

SERVER_NOT_FOUND() {
	echo "Le serveur n'est pas allumé. Opération annulée"
}

SERVER_START() {
	echo -en "[..] Lancement du serveur\r"
	cd ${MC_PATH}/
	screen -dmS $SCREEN_NAME java -jar -Xmx${MEMALOC}M -Xms512M -XX:MaxPermSize=128M -Dfile.encoding=UTF8 $MC_JAR nogui
	while [ -z "$(grep Done $MC_PATH/logs/latest.log)" ]
	do
		sleep 0.1
	done
	echo "[Ok]"
}

SERVER_STOP() {
	for i in `seq 5 -1 1`
	do
		echo -en "[0$i] Arrêt du serveur Minecraft\r"
		screen -S $SCREEN_NAME -p 0 -X stuff "`printf "say Arrêt dans $i secondes\r\n"`"
		sleep 1
	done
	screen -S $SCREEN_NAME -p 0 -X stuff "`printf "stop\r\n"`"
	while [ -n "$(screen -ls | grep $SCREEN_NAME)" ]
	do
		sleep 0.1
	done
	echo "[Ok]"
}

case "$1" in
  start)
	if [ -z "$(screen -ls | grep $SCREEN_NAME)"  ]
	then
		SERVER_START
	else
		echo "Le serveur est déjà lancer. Opération annulée"
		screen -ls | grep $SCREEN_NAME
	fi
        ;;
  stop)
	if [ -n "$(screen -ls | grep $SCREEN_NAME)" ]
	then
		SERVER_STOP
	else
		SERVER_NOT_FOUND
	fi
        ;;
  retart)
	if [ -n "$(screen -ls | grep $SCREEN_NAME)" ]
	then
		SERVER_STOP
		SERVER_START
	else
		SERVER_NOT_FOUND
	fi
	;;
  exec)
	if [ -n "$(screen -ls | grep $SCREEN_NAME)" ]
	then
		if [ -z $2 ]; then
			echo "Utilisation: $0 $1 <command>"
		else
			msg=${@#exec}
			exec_time="$(date "+%H:%M:%S")"
			screen -S $SCREEN_NAME -p 0 -X stuff "`printf "$msg\r\n"`"
			sleep 0.1
			tail ${MC_PATH}/logs/latest.log -n 20 | grep $exec_time | grep -v "@" | tail -n 3
		fi
	else
		SERVER_NOT_FOUND
	fi
	;;
  log)
	tail ${@#log} ${MC_PATH}/logs/latest.log | grep -v "@"
	;;
  status)
	if [ -n "$(screen -ls | grep $SCREEN_NAME)" ]
	then
		scrn=$(screen -ls | grep $SCREEN_NAME)
		echo "Serveur [On]/Off ${scrn%(*}"
	else
		echo "Serveur On/[Off]"
	fi
	;;
  backup)
	if [ -n "$(screen -ls | grep $SCREEN_NAME)" ]
	then
		screen -S $SCREEN_NAME -p 0 -X stuff "`printf "say Initiation d'une sauvegarde.\r\n"`"
		restart=1
		SERVER_STOP
	else
		restart=0
	fi
	if [ ! -d ${MC_PATH}/Backup ]
	then
		echo -en "[..] Création d'un répértoire de backup\r"
		mkdir ${MC_PATH}/Backup
		echo "[Ok]"
	fi
	cd ${MC_PATH}/
	echo -en "[..] Archivage et compréssion du dossier $(ls | grep -i world)\r"
	name="$(date "+%F_%H-%M-%S")"
	tar -cf Backup/$name.tar "$(ls | grep -i world )"
	gzip Backup/$name.tar
	echo "[Ok]"
	if [ $restart == 1 ]
	then
		SERVER_START
		screen -S $SCREEN_NAME -p 0 -X stuff "`printf "say Sauvegarde effectuée\r\n"`"
	fi
	;;
  console)
	if [ -n "$(screen -ls | grep $SCREEN_NAME)" ]
	then
		screen -dr $SCREEN_NAME
	else
		SERVER_NOT_FOUND
	fi
	;;
  *)
        echo -e "Utilisation:\nstart\t\tLance le serveur\nstop\t\tArrête le serveur\nrestart\t\tRelance le serveur\nexec <cmd>\tExécute la commande <cmd> et affiche le retour\nlog <tail args>\t\tAffiche les logs du serveur\nstatus\t\tAffiche l'état du serveur\nbackup\t\tEffectue une sauvegarde de la map\nconsole\t\tRejoint la console du serveur (CTRL A + D pour quitter)\n"
        exit 1
esac
