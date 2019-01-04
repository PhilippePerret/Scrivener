# SCRIVENER EN LIGNE DE COMMANDE [MAC ONLY - POUR MAC SEULEMENT]

Ce programme permet d'interagir avec les projets Scrivener pour étendre de façon infinie les fonctionnalités.

Parmi ces fonctionnalités remarquables, on peut noter :

* l'analyse de proximité, qui permet de tester la proximité trop grande des mots dans ses projets,
* le suivi de longueur, qui permet de connaitre la pagination de chaque fichier,
* la création automatique de structures de romans d'après un fichier CVS (Excel ou autre feuille de calcul) avec définition des objectifs (nombre de pages),
* la création assistée et simplifiée de métadonnées (à partir de fichiers ou non),
* le réglage simplifié de nombreux paramètres de l'application, en ligne de commande (zoom, styles, labels, etc.).

## INSTALLATION

### Pré-requis

  * Une version récente de Ruby (>= 2.3),
  * La version 3 (au moins) de l'application Scrivener.

### Installation

* Clone le présent dossier `Scrivener` sur ton ordinateur (dans le dossier téléchargement, par exemple),
* Place le dossier à l'endroit voulu (⛔️ sauf le dossier `/Applications`),
* Ouvre l’application Terminal 💻 (qui se trouve dans ton dossier `/Applications/Utilitaires/`)
* Rejoins ton dossier en tapant dans le Terminal ✏️ `cd ~/vers/dossier/Scrivener`,
* Joue la commande ✏️ `ruby ./bin/build_command` dans le Terminal pour installer la commande,
* Joue la commande ✏️ `bundle install` pour installer les gems manquants,
* Ouvre une nouvelle console de Terminal (CMD N),
* Joue dans cette nouvelle console la commande ✏️ `scriv help`,
* Si l'aide de la commande `scriv` s'affiche, c'est que tout est OK.

### Première utilisation

* Ouvre une nouvelle console Terminal,
* Tape ✏️ `scriv infos ""` (⛔️ NE TERMINE PAS par un retour-chario)
* Prends un de tes projets Scrivener (extension `.scriv`) contenant du texte dans le dossier manuscrit et glisse-le entre les guillemets de la commande ci-dessus.
* Tu devrais obtenir quelque chose comme ✏️ `scriv info "/Users/chezmoi/Documents/typographie.scriv"`,
* Joue la touche Entrée.
* Tu devrais obtenir les informations sur ce projet, notamment le titre et les auteurs s'ils sont définis,
* Lance la commande ✏️ `scriv prox` (lance => presse la touche entrée pour lancer la commande),
* Si tout se passe bien, tu devrais voir une analyse textuelle de ton projet avec notamment les fréquences et les proximités,
* Tape ✏️ `scriv prox -h` pour obtenir l'aide de cette commande,
* Ou tape ✏️ `scriv commands` pour voir la liste de toutes les commandes que tu peux utiliser.
