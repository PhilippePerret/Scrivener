# SCRIVENER EN LIGNE DE COMMANDE

\[MAC ONLY - POUR MAC SEULEMENT\]

Ce programme permet d'interagir avec les projets Scrivener pour étendre de façon quasi infinie les fonctionnalités, pour produire des analyses et des suivis du texte et pour faciliter les réglages de l'application et des projets.

Parmi ces fonctionnalités, on peut notablement noter :

* l'analyse des proximités, qui permet de tester la proximité trop grande entre les mots de ses projets,
* le suivi de longueur, qui permet de connaitre la pagination de chaque fichier, ou de la fixer en fixant les objectifs de façon simple et rapide,
* la création automatique de structures de romans d'après un fichier CVS (Excel ou autre feuille de calcul) avec définition des objectifs (nombre de pages),
* la création assistée et simplifiée de métadonnées (à partir de fichiers ou non),
* le réglage simplifié de nombreux paramètres de l'application, en ligne de commande (zoom, styles, labels, etc.).

## INSTALLATION

### Pré-requis

  * Une version récente de Ruby (>= 2.3),
  * La version 3 (au moins) de l'application Scrivener.

### Installation

* Clone le présent dossier `Scrivener` sur ton ordinateur (dans le dossier téléchargement, par exemple).
* Place le dossier à l'endroit voulu (⛔️ sauf le dossier `/Applications`).
* Ouvre l’application Terminal 💻 (qui se trouve dans ton dossier `/Applications/Utilitaires/`).
* Rejoins ton dossier en tapant dans le Terminal ✏️ `cd ~/vers/dossier/Scrivener` (tu dois remplacer `vers/dossier/` par la liste des dossiers depuis ton bureau. Si, par exemple, tu as placé ce dossier `Scrivener` dans ton dossier `Documents`, la commande sera `cd ~/Documents/Scrivener`).
* Joue la commande ✏️ `pwd` pour t'assurer que tu es bien dans le bon dossier (la commande devrait retourner quelque chose comme `/Users/chezmoi/Documents/Scrivener`).
* Joue la commande ✏️ `ruby ./bin/build_command.rb` dans le Terminal pour installer la commande.
* Joue la commande ✏️ `bundle install` pour installer les "gems" manquants.
* Ouvre une nouvelle console de Terminal (CMD N).
* Joue dans cette nouvelle console la commande ✏️ `scriv help`.
* Si l'aide de la commande `scriv` s'affiche, c'est que tout est OK ! (ou presque…)

### Première utilisation

* Ouvre une nouvelle console Terminal.
* Tape ✏️ `scriv infos ""` (⛔️ NE TERMINE PAS par un retour-chariot).
* Prends un de tes projets Scrivener (extension `.scriv`) contenant du texte dans le dossier manuscrit et glisse-le entre les guillemets de la commande ci-dessus.
* Tu devrais obtenir quelque chose comme ✏️ `scriv info "/Users/chezmoi/Documents/typographie.scriv"`.
* Joue la touche Entrée.
* Tu devrais obtenir les informations sur ce projet, notamment le titre et les auteurs s'ils sont définis.

### Utilisation plus complète

Pour cette utilisation plus complète, il va falloir charger d'autres utilitaires, et notamment celui qui permet de « lemmatiser » un texte.

Pour savoir ce que tu dois encore installer, lance simplement le check de l'installation :

* ✏️ `scriv check install`

Consulter les messages d'erreurs et exécutes les opérations demandées.

Tu peux maintenant passer à la suite.

* Lance la commande ✏️ `scriv prox` (lance => presse la touche entrée pour lancer la commande),
* Si tout se passe bien, tu devrais voir une analyse textuelle de ton projet avec notamment les fréquences et les proximités,
* Tape ✏️ `scriv prox -h` pour obtenir l'aide de cette commande,
* Ou tape ✏️ `scriv commands` pour voir la liste de toutes les commandes que tu peux utiliser.
