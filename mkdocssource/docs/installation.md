# Installation du service

### 1. Téléchargez le script
    sudo wget https://github.com/unixfox/MCBin/releases/download/2.0/minecraft -P /etc/init.d

### 2. Rendez-le exécutable :
    sudo chmod a+x /etc/init.d/minecraft

### 3. Éditez le plugin :
    sudo nano /etc/init.d/minecraft
### 4. Changez les lignes des options à votre convenance.
>(ctrl + x & Yes & Enter pour nano)
### 5. Ajoutons-le aux services du système :
    sudo update-rc.d minecraft defaults

**Et voilà** ! Il vous reste plus qu'à entrer *service minecraft* dans le terminal pour voir les actions que vous pouvez faire !