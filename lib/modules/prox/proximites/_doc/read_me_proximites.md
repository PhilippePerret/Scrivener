# Module Proximités

Ce module permet de faire l'analyse de proximité du texte du projet.

##

Un mot coloré, dans RTF, se présente de cette manière :


        \cf2•MOT\cf0•

(note : le « • » remplace une espace).

Ces valeurs correspondent à la ligne définissant les couleurs dans le document RTF en entête :

```rtf
{\colortbl;\red255\green255\blue255;\red251\green0\blue23;\red17\green128\blue64;\red16\green128\blue214;
}
```

* Chaque valeur est séparée par un point-virgule
* Chaque valeur définit une couleur RGB
* La première (cf1•) correspond au blanc (`\red255\green255\blue255`)
* Les couleurs customisées commencent avec la seconde : `\red251\green0\blue23`

Donc, pour reconstituer le texte, on va :

* entourer les mots proches avec ces balises :
* utiliser `textutil -convert rtf <fichier>` pour transformer en RTF le fichier, après avoir colorisé les mots avec ces balises.
* Les `\cfX ` ont été remplacés par des `\\cfX `, il faut donc lire le code brut du fichier RTF et le corriger en conséquence (note : ne pas changer les `\\` en `\`, ça pourrait être trop dangereux.),
* modifier l'entête du fichier RTF pour qu'il définisse toutes les couleurs dont on a besoin.

## TODO

* Pouvoir montrer tous les mots changés
  = Ne serait-il pas possible, dans segments, d'enregistrer que le mot a été modifié, pour pouvoir le mettre dans un autre style (l'affichage des extraits serait plus compliqué, mais plus parlant — qui favorise-t-on ? l'utilisateur ou le programmeur ?)
* Pouvoir ne recalculer qu'une seule page
* Pouvoir ajouter des proximités rectifiées (dans PROXIMITES_MAX[:mots])
* Pouvoir afficher les informations
  - les proximités rectifiées propres (mot => distance minimale)
  - les mots exclus
* Données sur les corrections des proximités (le nombre corrigé, etc.)
  Le faire de façon générale et pour chaque mot.
* Pouvoir sortir des graphiques avec les mots.
* Sortir des statistiques sur la proximité, à commencer par le nombre de proximités relevées
  * le nombre de mots en proximité
  * le nombre de proximités
  * si possible un test de densité en fonction de l'endroit (par tranche de 1000 mots ? Pouvoir régler la largeur de la tranche ?)
* Possibilité de définir une liste de mots à passer, dans le projet lui-même. Ce serait un document, en dehors du manuscrit, qui définirait les paramètres à utiliser pour le traitement des proximités.
  => Cette liste est à donner dans les informations du projet
* Pouvoir donner le nom d'un document (--binder-item ou --doc) et afficher la proximité de ses mots.
* Pouvoir donner un mot et afficher ses proximités (--mot="<le mot>")
* Pouvoir changer la distance min avec les options (--distance=<nombre>)
* Pouvoir utiliser un autre texte qu'un projet scriv. On crée de la même manière des "binder-item" avec le texte découpé.

## Fonctionnement

Pour le moment, et ça fonctionne assez bien même sur un gros fichier (le premier épisode de Passé sous silence), on récupère tous les mots du texte pour en faire des instances {ProxMot} et on tient à jour un tableau de résultats {Scrivener::Project.tableau_proximites} où les mots sont rassemblés (tous les "deux" ensemble, tous les "travail" ensemble, etc.).

    Scrivener::Project.tableau_proximites = {
      current_offset:   <offset courant au cours de la recherche>,
      mots:   {
        <mot générique>: [<liste des mots],
        <mot générique>: [<liste des mots]
      }
    }

Ce tableau est enregistré dans le fichier `data_proximites.msh` qui se trouve dans un dossier caché `.scriv` qui se situe au même niveau que le projet Scrivener lui-même, pour rechargement éventuel.

Voir le détail dans le fichier `table_proximites.md` qui lui est consacré.


## Information

Du site [Suristat](http://www.suristat.org/article199.html)

- le lexique brut : toutes les formes textuelles,
- le lexique réduit : il exclut les "mots-outils" du langage:  les articles : le, la, les, un, ...; les pronoms : je, tu, me, ce, celui, ça, ...; les adverbes : non, ne, plus, trop, ...,  les prépositions : dans, pour, avec, de, ... et les conjonctions : mais, ou, et, etc.
- le lexique lemmatisé : regroupe les formes textuelles selon leur "racine grammaticale". Par ce procédé de lemmatisation, on va simplifier le texte en ramenant le singulier et le pluriel d’un nom à son singulier, toutes les formes d’un adjectif à son masculin singulier, toutes les formes conjuguées d’un verbe à son infinitif.
- le lexique relié : on identifie les segments fréquemment évoquées dans le texte afin de repérer les expressions du corpus, comme « pomme de terre », ou « fruits de mer » par exemple,

Voir aussi :

* [Lemmatisation sur wikipédia](https://fr.wikipedia.org/wiki/Lemmatisation)
