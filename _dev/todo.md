* Relever dans le texte long de PSS les mots qui peuvent avoir un niveau de proximité plus grand ('son', 'pour', etc.) et les ajouter aux listes.
* Pouvoir obtenir, pendant la correction, la proximité d'un nouveau mot (cf. ci-dessous)





# Obtenir la proximité d'un nouveau mot

Ce qui serait "marrant", ce serait de pouvoir faire tourner un truc en background qui vérifierait en permanence la proximité des mots qu'on écrit.

Synopsis :

* On lance le "watcher" (`scriv watch-prox`)
* Il analyse le texte pour relever les mots (comme maintenant)
* Régulièrement, il relit le texte pour relever les mots et faire l'analyse de proximité
* S'il trouve une nouvelle proximité (comment savoir qu'elle est nouvelle ?), il la signale à l'auteur.

Autres questions :
* Comment tenir compte des mots supprimés ?

Note : le plus simple, c'est sûr, serait qu'on mette en route cet outil dès le départ.

En fait, le contrôle pourrait se faire sur le nombre de proximités. S'il y a en a 5 au temps T1 et 6 au temps T2, une alerte.
Le problème : si une proximité a été supprimée et une autre ajoutée (ce qui peut arriver souvent), aucune erreur n'est signalée.
Solution : suivre vraiment les proximités avec leur identifiant, etc.

Donc :
* On lance le watcher
* Il contrôle les trois pages concernées (précédente, courante et suivante)
* Il tient à jour la liste des proximités (affichées en direct, dans un Curses, dans une fenêtre Terminale qu'on met en dessous de Scrivener ou sur un autre écran)
Le programme signale les proximités corrigées (vert) et les proximités ajoutées (rouge)
