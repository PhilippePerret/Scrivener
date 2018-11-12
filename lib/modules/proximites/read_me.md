# Module Proximités

Ce module permet de faire l'analyse de proximité du texte du projet.

## TODO

* Pouvoir ne recalculer qu'une seule page
* Pouvoir ajouter des proximités rectifiées (dans PROXIMITES_MAX[:mots])
* Pouvoir afficher les informations
  - les proximités rectifiées propres (mot => distance minimale)
  - les mots exclus
* Données sur les corrections des proximités (le nombre corrigé, etc.)
  Le faire de façon générale et pour chaque mot.
* Pouvoir sortir des graphiques avec les mots.
* Procédure de remplacement
  * avec test des nouvelles proximités :
    * celle du nouveau mot (avant remplacement)
    * celle des mots autour du nouveau mot
  * ajouter une propriété "new_mot" qui contiendra le mot remplacé (mais comment l'utiliser quand c'est un autre mot qui est testé/affiché) ?
* Sortir des statistiques sur la proximité, à commencer par le nombre de proximités relevées
  * le nombre de mots en proximité
  * le nombre de proximités
  * si possible un test de densité en fonction de l'endroit (par tranche de 1000 mots ? Pouvoir régler la largeur de la tranche ?)
* Développer la question (ask) pour passer d'une proximité à l'autre, avec la possibilité de passer au mot suivant (et autres ? peut-être un moyen de basculer dans une entrée plus interactive qui permet de régler certaines préférences)
  * pouvoir revenir en arrière
* Définir la liste des mots de plus de 2 lettres à passer ('des', 'les', etc.).
* Possibilité de définir une liste de mots à passer, dans le projet lui-même. Ce serait un document, en dehors du manuscrit, qui définirait les paramètres à utiliser pour le traitement des proximités.
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

Ce tableau est enregistré dans le fichier `.proximites` qui se trouve au même niveau que le projet Scrivener lui-même, pour rechargement éventuel.



## Information

Du site [Suristat](http://www.suristat.org/article199.html)

- le lexique brut : toutes les formes textuelles,
- le lexique réduit : il exclut les "mots-outils" du langage:  les articles : le, la, les, un, ...; les pronoms : je, tu, me, ce, celui, ça, ...; les adverbes : non, ne, plus, trop, ...,  les prépositions : dans, pour, avec, de, ... et les conjonctions : mais, ou, et, etc.
- le lexique lemmatisé : regroupe les formes textuelles selon leur "racine grammaticale". Par ce procédé de lemmatisation, on va simplifier le texte en ramenant le singulier et le pluriel d’un nom à son singulier, toutes les formes d’un adjectif à son masculin singulier, toutes les formes conjuguées d’un verbe à son infinitif.
- le lexique relié : on identifie les segments fréquemment évoquées dans le texte afin de repérer les expressions du corpus, comme « pomme de terre », ou « fruits de mer » par exemple,

Voir aussi :

* [Lemmatisation sur wikipédia](https://fr.wikipedia.org/wiki/Lemmatisation)
