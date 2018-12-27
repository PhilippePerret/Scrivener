# CLI::Test

La classe `CLI::Test` permet de gérer les tests. Elle possède deux méthodes principales, l'une qu'on peut utiliser dans les feuilles de test (`CLI::Test.run_command`) et l'autre qu'on utilise dans un script, pour lancer des tests (`CLI::Test.run`).

# CLI::Test.run

Dans un script on peut jouer :

    CLI::Test.run

Cela lance les tests, avec `Rake`. Si le script est appelé en ligne de commande par la commande de l'application, il suffit d'indiquer en premier paramètre le fichier à jouer, le dossier ou l'expression régulière qui permettra de retrouver les fichiers. On pourra mettre en option les options voulues, à commencer par `-vb` pour indiquer la verbosité.

Hors ligne de commande, il faut indiquer en premier argument le fichier, le dossier ou l'expression régulière qui permettra de retrouver les fichiers et en second argument les options à utiliser. Par exemple :

    CLI::Test.run("^nom(.*?)\.rb$", ['-v'])                      #*
    # Jouera tous les tests contenant, dans leur chemin d'accès 'nom'
    # suivi de caractères indifférent puis se terminant par '.rb'
    # Le test sera verbeux.


# CLI::Test.run_command

Le plus simple est de faire un raccourci dans `test_helper.rb` :

def run_command(args)
  CLI::Test.run_command(args)
end
