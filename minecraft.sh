#! /bin/sh
#Création par unixfox (Emilien) - Created by unixfox

MC_PATH=/le/répertoire/où/se/trouve/votre/serveur/ #Répertoire de votre serveur minecraft - Directory of your Minecraft server
NOM_JAR="minecraft_server.jar" # Nom du fichier .jar de votre serveur minecraft - Name of the .jar file of your Minecraft server
MEMALOC=512 # Mémoire à allouer à votre serveur minecraft - Memory of your Minecraft Server

server_stop() {
        screen -S minecraft -p 0 -X stuff "`printf "stop.\r"`"; sleep 5
}

case "$1" in
  start)
        echo -n "Lancement du serveur minecraft"
        cd $MC_SCRIPT; screen -S minecraft java -jar -Xmx${MEMALOC}M -Xms512M -XX:MaxPermSize=128M -Dfile.encoding=UTF8 $NOM_JAR
        echo "."
        ;;
  stop)
        echo -n "Arrêt du serveur Minecraft..."
        server_stop
        echo "."
        ;;

  *)
        echo "Utilisation: service minecraft {start|stop}"
        exit 1
esac
