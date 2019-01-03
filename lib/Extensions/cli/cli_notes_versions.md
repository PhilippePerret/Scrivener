# Notes sur les versions de CLI

** Version courante : 1.8.1 **

## Version 1.8.1

  Ajout des options (troisième argument) à run_command, pour débugger
  facile la sortie de console avec {debug: true}.

## Version 1.8.0

  Ajout de la classe `CLI::Screen` qui permet de gérer l'écran, sans
  la lourdeur de Curves.

## Version 1.7.5

  Ajout de la constante application APP_CORRESPONDANCES pour pouvoir
  faire des conversions autant au niveau des options que des comman-
  des ou des paramètres.

## Version 1.7.4

  Todo: texte mis en bleu quand il commence par "[TUTORIEL]"

## Version 1.7.3

  Possibilité de définir une commande qui soit transformée en une
  autre commande avec ajout d'options.
  Par exemple, si…
    `DIM_CMD_TO_REAL_CMD[:update] = [:build, {update: true}]`
  … alors l'appel de…
    `monapp update machin`
  … produira en réalité :
    `monapp build machin --update`

## Version 1.7.2

  Ajout de la table `LANG_OPT_TO_REAL_OPT` qui permet de traduire
  certaines options. Par exemple, dans une application, l'option
  `--profondeur` peut être traduite par `--depth` si :
    `LANG_OPT_TO_REAL_OPT['profondeur'] = 'depth'`

## Version 1.7.1

  Amélioration des tests pour pouvoir les lancer depuis la console
  même lorsqu'on fait appel à `CLI::Test.run_command`.

## Version 1.7.0

  Ajout de la méthode `CLI::Test.run` qui permet de jouer les tests
  avec Rake.

## Version 1.6.5

  Ajout de la propriété `command_init` qui conserve une trace de la
  commande initiale telle qu'elle a été envoyée en console.

## Version 1.6.4

  Ajout de la possibilité d'ajouter "[BUG]" dans `todo` pour afficher
  un bug qui sera affiché en rouge dans la liste des tâches.

## Version 1.6.3

  Ajout de l'opérateur todo 'n[ext]' pour afficher les prochaines
  tâches à faire sur l'application.

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
