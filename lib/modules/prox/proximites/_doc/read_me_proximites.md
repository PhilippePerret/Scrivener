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
  = Ne serait-il pas possible, dans segments, d'enregistrer que le mot a été modifié, pour pouvoir le mettre dans un autre style
* Pouvoir afficher les informations
  - les proximités rectifiées propres (mot => distance minimale)
  - les mots exclus
* Données sur les corrections des proximités (le nombre corrigé, etc.)
  Le faire de façon générale et pour chaque mot.
* Pouvoir sortir des graphiques avec les mots.

## Information

Du site [Suristat](http://www.suristat.org/article199.html)

- le lexique brut : toutes les formes textuelles,
- le lexique réduit : il exclut les "mots-outils" du langage:  les articles : le, la, les, un, ...; les pronoms : je, tu, me, ce, celui, ça, ...; les adverbes : non, ne, plus, trop, ...,  les prépositions : dans, pour, avec, de, ... et les conjonctions : mais, ou, et, etc.
- le lexique lemmatisé : regroupe les formes textuelles selon leur "racine grammaticale". Par ce procédé de lemmatisation, on va simplifier le texte en ramenant le singulier et le pluriel d’un nom à son singulier, toutes les formes d’un adjectif à son masculin singulier, toutes les formes conjuguées d’un verbe à son infinitif.
- le lexique relié : on identifie les segments fréquemment évoquées dans le texte afin de repérer les expressions du corpus, comme « pomme de terre », ou « fruits de mer » par exemple,

Voir aussi :

* [Lemmatisation sur wikipédia](https://fr.wikipedia.org/wiki/Lemmatisation)
