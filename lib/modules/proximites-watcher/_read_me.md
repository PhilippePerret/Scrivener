
Ce module permet de gérer le watcher qui surveille en direct le travail de correction des proximités dans le projet Scrivener.

Il s'utilise quand on active la commande `scriv watch-prox[ path/to/projet.scriv][ options]`

# Synopsis
(du plus général au plus détaillé)

## Pitch

* L'auteur lance la commande `scriv watch-prox -doc="Mon document"` dans le dossier de son projet,
* la commande lui demande s'il doit ouvrir le projet. Oui => elle l'ouvre
* l'auteur modifie son texte
* la commande tient à jour, dans une fenêtre `Curses`, la liste des proximités

## Synopsis général

* L'auteur lance la commande (ci-dessus)
  * la commande relève tous les documents du projet
  * si aucun document n'est précisé en réponse, la commande prend tout le projet
* La commande demande si elle doit ouvrir le projet.
  * Si oui, elle l'ouvre, sinon, elle ne fait rien.

## Synopsis détaillé

* L'auteur lance la commande (ci-dessus)
  * la commande relève tous les documents du projet
  * si aucun document n'est précisé la commande le demande
    * il prend la réponse et peut la compléter en trouvant le nom
    * si aucun document, la commande prend tout le projet.
* La commande demande si elle doit ouvrir le projet.
  * Si oui, elle l'ouvre, sinon, elle ne fait rien.
* [A] Ensuite commence le cycle de vérifications
  * La commande vérifie la date de dernière modification du fichier content.rtf
  * Si elle n'a pas changé, elle passe
  * Si elle a changé, elle recommence le calcul
    * Elle mémorise la date de dernière modification
    * Elle relève tous les mots en les lemmatisant
    * Elle fait le check des proximités
    * Elle vérifie ce check avec le dernier check
    * Elle affiche les différences
    * Elle retourne à [A]
