#! /bin/bash
#By Julien00859 & unixfox
MC_PATH='/directory/of/your/server/'
MC_JAR=$(ls $MC_PATH | grep minecraft_server)
SCREEN_NAME=minecraft
MEMALOC=2048

#Check if screen is installed

if ! type "screen" > /dev/null; then
  sudo apt-get -y install screen
fi

SERVER_NOT_FOUND() {
	echo "The server isn't up. Operation canceled"
}

SERVER_START() {
	echo -en "[..] Starting up the server\r"
	cd ${MC_PATH}/
	screen -dmS $SCREEN_NAME java -jar -Xmx${MEMALOC}M -Xms512M -XX:MaxPermSize=128M -Dfile.encoding=UTF8 $MC_JAR
	while [ -z "$(grep Done $MC_PATH/logs/latest.log)" ]
	do
		sleep 0.1
	done
	echo "[Ok]"
}

SERVER_STOP() {
	for i in `seq 5 -1 1`
	do
		echo -en "[0$i] The Minecraft server will shutdown\r"
		screen -S $SCREEN_NAME -p 0 -X stuff "`printf "say Stop in $i seconds\r\n"`"
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
		echo "The server is already launched. Operation canceled"
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
  restart)
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
			echo "Use: $0 $1 <command>"
		else
			msg=${@#exec}
			screen -S $SCREEN_NAME -p 0 -X stuff "`printf "$msg\r\n"`"
			sleep 0.1
			tail ${MC_PATH}/logs/latest.log -n 1
		fi
	else
		SERVER_NOT_FOUND
	fi
	;;
  log)
	tail -f ${MC_PATH}/logs/latest.log
	;;
  status)
	if [ -n "$(screen -ls | grep $SCREEN_NAME)" ]
	then
		scrn=$(screen -ls | grep $SCREEN_NAME)
		echo "Server [On]/Off ${scrn%(*}"
	else
		echo "Server On/[Off]"
	fi
	;;
  backup)
	if [ -n "$(screen -ls | grep $SCREEN_NAME)" ]
	then
		screen -S $SCREEN_NAME -p 0 -X stuff "`printf "say Starting up the backup.\r\n"`"
		restart=1
		SERVER_STOP
	else
		restart=0
	fi
	if [ ! -d ${MC_PATH}/Backup ]
	then
		echo -en "[..] Creating the backup of the server\r"
		mkdir ${MC_PATH}/Backup
		echo "[Ok]"
	fi
	cd ${MC_PATH}/
	echo -en "[..] Archiving and compressing the folder $(ls | grep -i world)\r"
	name="$(date "+%F_%H-%M-%S")"
	tar -cf Backup/$name.tar "$(ls | grep -i world )"
	gzip Backup/$name.tar
	echo "[Ok]"
	if [ $restart == 1 ]
	then
		SERVER_START
		screen -S $SCREEN_NAME -p 0 -X stuff "`printf "say Backup done\r\n"`"
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
        echo -e "Use:\nstart\t\tStart the server\nstop\t\tStop the server\nrestart\t\tRestart the server\nexec <cmd>\tExecute a command <cmd> and return the output\nlog\t\tShow logs of the server (CTRL C to escape)\nstatus\t\tShow the status of the server backup\nbackup\t\tCreate a backup\nconsole\t\tShow the console (CTRL A + D to escape)\n"
        exit 1
esac