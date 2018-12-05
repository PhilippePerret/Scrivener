# Manuel de l'extension CLI

CLI permet de gérer la ligne de commande. Il est donc idéal pour toutes les applications en ligne de commande.

## Utilisation

Au début du programme, implémenter :

```ruby

# Requérir tout le dossier
Dir["./cli/**/*.rb"].each{|m|require m}

class MonApplication
  def self.run
    # Analyse de la ligne de commande
    CLI.analyse_command_line || return # (1)
    ...
  end
end

MonApplication.run

```

À partir de là, toutes les options (valeurs suivant `-` ou `--`) sont consignées dans `CLI.options` et tous les paramètres (valeurs sans tirets) sont consignés dans `CLI.params`.

Le premier mot après la commande est consignée dans `CLI.command`. Par exemple, pour une application qui s'appellerait `my`, avec `my help`, `CLI.command` vaut "help".

Note (1) : le `|| return` est nécessaire pour traiter les commandes spéciales comme la commande todo `todo`. On peut aussi, suivant les programmes, utiliser `exit 0`

## Consignation des paramètres (CLI.params)

Lorsque les paramètres apparaissent seuls dans la ligne de commande (sans `=`) ils sont consignés dans leur ordre :

```

  myapp commande param1 param2 param3

```

Ci-dessus, on aura :

```

  CLI.command   # => "commande"
  CLI.params[1] # => "param1"
  CLI.params[2] # => "param2"
  CLI.params[3] # => "param3"

```

En revanche, si on a des signes `=`, ils sont enregistrés comme des clés :

```

    myapp commande param1 pam="Valeur de pam" param2

    =>

      CLI.command       # => "command"
      CLI.params[1]     # => "param1"
      CLI.params[:pam]  # => "Valeur de pam"
      CLI.params[3]     # => "param2" (2)

```

Note (2) : noter que même le paramètre avec `=` est compté dans l'indiçage des paramètres.

Note : quand on veut considérer un `=` comme un signe et non pas comme la délimitation d'une paire clé-valeur, il faut s'arranger pour mettre une espace avant ou après. Par exemple, si une application en ligne de commande évalue du code et qu'on veut faire `x=2`, il suffit d'utiliser : `monrun "x = 2"`.

## Commande spéciale `todo`

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
