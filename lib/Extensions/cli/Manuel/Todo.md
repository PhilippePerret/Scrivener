## Commande spéciale `<app> todo`

La commande spéciale `todo` permet de gérer une liste des todos pour chaque application en ligne de commande. On l'invoque avec :

        $ myapp todo # => affiche la liste

Note : il faut penser à mettre `CLI.analyse_command_line || return` pour interrompre le programme normal. Ou capter la commande `todo` dans une voie de garage.

### Aide de la commande `todo`

```

  $ myapp todo --help # ou -h

```

### Ajout d'une tâche

```

  $ myapp todo + "La nouvelle tâche entre \"guillemets\"."

```

### Retrait d'une tâche

```

  $ myapp todo - "Début de la t"

```

On peut aussi spécifier la tâche par son numéro dans la liste d'affichage :

```

  $ myapp todo - 5 # supprime la 5ème

```

Après confirmation de la tâche à supprimer, on la retire de la liste.

### Mettre une tâche tout au-dessus

```

  $ monapp todo top "Mon début de tâc"

```

### Mettre une tâche tout en bas

```

  $ monapp todo bottom "Mon début de tâc"

```

### Remonter une tâche (avant une autre)

Pour faire remonter d'un cran une tâche :

```

  $ monapp todo up "Mon début de t"

```

Pour placer la tâche avant une autre :

```

  $ monapp todo before "Mon début" "Avant celle-ci"
  # ou par indice
  $ monapp todo before 4 2

```

Ci-dessus, la tâche `#4` — commençant par "Mon début" — sera placée avant la tâche `#2` commençant par "Avant celle-ci".

### Descendre une tâche (après une autre)

```

  $ monapp todo down "Mon début de t"
  # ou
  $ monapp todo down 2

```

Pour placer la tâche après une autre :

```

  $ monapp todo after "Mon début" "Début de l'autre"
  # ou
  $ monapp todo after 2 3

```

Ci-dessus, la tâche `#2` — commençant par "Mon début" — sera placée après la tâche `#3` — commençant par "Début de l'autre".
