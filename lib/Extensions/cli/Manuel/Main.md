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

## Commande spéciale `<app> todo`

Permet de consigner les choses à faire avec ou sur l'application.

Cf. le fichier [Todo.md](Todo.md)


## Commande spéciale `<app> test`

Permet de lancer les tests de la commande.

Cf. le fichier [Tests.md](Tests.md)
