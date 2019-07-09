# CLI Scrivener
# Manuel de développement

* [Point d'entrée](#point_dentree)
* [Fichiers de localisation](#localisation_files)

## Point d'entrée {#point_dentree}

Le point d'entrée de `Scriv` en ligne de commande est le fichier `bin/scriv.rb`. C'est l'exécutable qui va traiter la ligne de commande.

Ce fichier initialise la commande (`Scrivener.init`) puis lance le traitement (`Scrivener.run`).

Les commandes `init` et `run` sont définies dans `Scrivener/1_Scrivener/main.rb`.

Après avoir analysé la ligne de commande et initialisé l'application (`init`), la méthode `run` se place dans le dossier du projet choisir pour appeler la commande en requiérant les fichiers du dossier qui porte le nom de la commande dans `lib/modules/`.

Par exemple, si c'est la commande `open` qui est invoqué à l'aide de la commande en ligne `scriv open`, c'est le dossier `lib/modules/open` que la méthode `run` va requérir.


## Fichiers de localisation {#localisation_files}

Les fichiers de localisaton — pour les différentes langues — se trouvent dans `config/locales`.

C'est la méthode `t`, dans `lib/Extensions/Handyi18n.rb` qui permet d'utiliser ces textes.

Schématiquement, on écrit `t(path.to.file.de.langue)` et la méthode `t` va chercher le fichier `config.locales.<LANGUE COURANTE>.path.to.file.de.langue.yaml` pour lire son contenu, donc le texte à afficher.

> la méthode `wt` (`write translation`) permet d'écrire le message localisé directement à l'écran.
> La méthode `rt` (`raise translation`) permet de produire une erreur avec un message localisé.
