* Dans la surveillance des proximités en direct, il faut déterminer l'offset des binder-item pour pouvoir calculer l'offset relatif des mots (relative_offset alias de offset_in_document). Je pense que ça doit être fait dans la recherche des binder_items concernés et être mis dans le tableau des proximités.

* Relever dans le texte long de PSS les mots qui peuvent avoir un niveau de proximité plus grand ('son', 'pour', etc.) et les ajouter aux listes.
* Pouvoir obtenir, pendant la correction, la proximité d'un nouveau mot (cf. ci-dessous)
