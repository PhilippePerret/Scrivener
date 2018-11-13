# Aide pour l'implémentation de la commande `scriv`

## Proximités

En ajoutant l'option `--only_calculs` à la ligne de commande `scriv prox`, on ne passe pas par la console, on affiche simplement les données envoyées par 'puts'.

Il faut ensuite ajouter `--segments` pour voir la liste des segments relevés et/ou `--proximites` pour voir la table des proximités.

## Segments

La propriété `project.segments` est un `Array` qui conserve l'intégralité du texte sous forme de segments dont chaque élément contient :

        {id: <index du mot>, seg: "<contenu>", type: :mot|:inter}

Si le segment est de type `:mot`, c'est que c'est un `ProxMot`, donc un vrai mot. Si le type est `:inter`, c'est que le segment est un "inter-mot", qui peut être constitué de plusieurs espaces, ponctuation et/ou autres signes comme des retours chariots.

Cette table permet deux choses principales :

* de proposer toujours un texte complet et à jour dans les extraits des proximités
* de recomposer un texte à jour pour un nouveau fichier par exemple.

## Tests

### Partie interactive

On peut utiliser l'option `-k=/--keys_mode_test=` pour fournir à l'application une liste de touches qui devront être jouées à la place des touches clavier, donc pour simuler l'action de l'utilisateur.

Pour en donner plusieurs, les séparer par ';;;'. Par exemple : 'm;;;q'.
