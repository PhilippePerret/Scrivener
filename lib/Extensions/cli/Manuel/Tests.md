# CLI.mode_test?

Pour que `CLI.mode_test?` retourne `true`, il faut mettre quelque part, par exemple dans le fichier `test_helper.rb` :

```ruby

    ENV['CLI_MODE_TEST'] = 'true'

```

Cela peut notamment avoir une influence sur `raise_by_mode` qui n'affiche que le message d'erreur quand on est en mode test, et pas de backtrace.

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

# Méthodes avant et après tous les tests

Pour jouer un code avant et après la suite totale de tests, il suffit de définir les méthodes `CLI::Test.before_all` et `CLI::Test.after_all` dans le fichier `test_helper.rb`. Par exemple :

```ruby
class CLI
  class Test
    class << self
      def before_all
        File.exist?(lasts_path) && FileUtils.move(lasts_path, lasts_path_copie)
      end
      def after_all
        File.exist?(lasts_path_copie) && FileUtils.move(lasts_path_copie, lasts_path)
      end
      def lasts_path
        @lasts_path ||= Scrivener.last_projects_path_file
      end
      def lasts_path_copie
        @lasts_path_copie ||= "#{Scrivener.last_projects_path_file}-COPIE"
      end
    end #/<< self
  end #/Test
end #/CLI
```
