# Notes sur les versions de CLI

**Version courante : 1.6.2**

## Version 1.6.2

  La commande CLI::Test.run écrit le résultat de la commande dans le
  fichier `./test/run_command_output.log`. Il suffit de le lire pour
  avoir l'intégralité des textes émis au cours de la commande jouée.
  Pour l'obtenir, il suffit de jouer `res = CLI::Test.output`

  Ajoute de CLI.separator[(character)] qui permet d'obtenir un sépa-
  rateur de fenêtre de la largeur de la console actuelle.

## Version 1.6.1

  Ajout de CLI.debug_entry pour noter l'entrée dans une fonction sans
  autre précision.

## Version 1.6.0

  Ajout de la classe `CLI::Test` qui permet de simuler le jeu d'une
  commande en ligne de commande et retourne le résultat.

## Version 1.5.1

  Ne pas considérer les "=" dans les paramètres, quand ils sont donnés
  entre des guillemets.

## Version 1.5.0

  Introduction de la gestion de la commande `todo` qui permet de gérer les
  listes de choses à faire dans n'importe quelle application. Dès que le
  second "mot" est `todo`, par exemple `scriv todo` ou `my todo`, CLI bascule
  vers la gestion des choses à faire.

## Version 1.4.0

Cette version marque un changement dans l'utililsation de CLI.params
Avant, c'est un simple Array contenant la liste des paramètres. Maintenant
c'est une table (Hash) qui permet de distinguer les paramètres qui sont
fournis avec des signes '='. Le premier élément de la paire devient la
clé.

Quand il n'y a pas de '=', la clé est l'indice courant du paramètre. De
cette manière, la compatibilité descendante est conservée : quand on invoque
`CLI.params[3]`, on aura toujours le troisième paramètre (rappel : le 1er
paramètre est toujours `nil`)

## Version 1.2.1
   Les '-' dans le nom des options sont remplacés par des traits plats.
   'in-file' => 'in_file'
