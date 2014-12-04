Installation du service
=======================

.. note::

	Si vous êtes novice en système Linux, ce tutoriel vous sera utile.


Dans un premier cas, vous allons créer un fichier bash qui nous permettra d'y insérer une commande pour démarrer le serveur.

1. Téléchargez le script :

.. code:: bash

	$ sudo wget https://github.com/unixfox/Minecraft-Server-Linux-service/releases/download/2.0/minecraft -P /etc/init.d


2. Rendez-le exécutable :

.. code:: bash

	$ sudo chmod a+x /etc/init.d/minecraft


3. Éditez le plugin :

.. code:: bash

	$ sudo nano /etc/init.d/minecraft

4. Changez les lignes des options à votre convenance.
5. Une fois ceci fini enregistrez le tout !

.. tip::

	(ctrl + x & Yes & Enter pour nano)


6. Ajoutons-le aux services du système :

.. code:: bash

	$ sudo update-rc.d minecraft defaults


Et voilà ! Il vous reste plus qu'à entrer *service minecraft* dans le terminal pour voir les actions que vous pouvez faire !