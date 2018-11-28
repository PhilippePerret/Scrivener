* Trouver un affichage qui permette de voir les proximités courantes dans le texte, comme dans une page, pour un mot donné. Cf. scénario ci-dessous
* Pouvoir récupérer le titre du projet dans le fichier xml du projet
* Relever dans le texte long de PSS les mots qui peuvent avoir un niveau de proximité plus petit ('son', 'pour', etc.) et les ajouter aux listes.




## Synopsis de l'affichage d'une proximité donnée dans sa page

Scénario :
* On donne un mot (peut-être en cours de watch-prox, peut-être en donnant le mot dans les paramètres),
* le programme affiche ses proximités dans la page spécifiée (le document)

Par exemple :

```
> scriv prox [path] mot="Momo" doc="Titre du document"

```

```
> scriv prox <mot>
```

Si on ne donne pas le titre du document, le programme pourrait retrouver partout où le mot se trouve.
