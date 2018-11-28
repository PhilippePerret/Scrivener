# Notes sur les versions de CLI

**Version courante : 1.4.0**

## Note version 1.4.0

Cette version marque un changement dans l'utililsation de CLI.params
Avant, c'est un simple Array contenant la liste des paramètres. Maintenant
c'est une table (Hash) qui permet de distinguer les paramètres qui sont
fournis avec des signes '='. Le premier élément de la paire devient la
clé.

Quand il n'y a pas de '=', la clé est l'indice courant du paramètre. De
cette manière, la compatibilité descendante est conservée : quand on invoque
`CLI.params[3]`, on aura toujours le troisième paramètre (rappel : le 1er
paramètre est toujours `nil`)

## Note version 1.2.1
   Les '-' dans le nom des options sont remplacés par des traits plats.
   'in-file' => 'in_file'
