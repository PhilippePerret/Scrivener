# SCRIVENER EN LIGNE DE COMMANDE

Ce programme permet d'interagir avec les projets Scrivener pour étendre de façon infinie les fonctionnalités.

Parmi ces fonctionnalités remarquables, on peut noter :

* l'analyse de proximité, qui permet de tester la proximité des mots dans l'application,
* le suivi de longueur, qui permet de connaitre la pagination de chaque fichier,
* la création automatique d'une structure de roman d'après un fichier CVS (Excel ou autre feuille de calcul) avec définition des objectifs (nombre de pages).

## POUR COMMENCER

Pour commencer à utiliser la commande `scriv`, il y a un certain nombre d'opérations à faire, qui peuvent paraitre difficiles si vous n'êtes pas habitués à la ligne de commande. Cependant, si vous suivez scrupuleusement les étapes ci-dessus, tout devrait bien se passer.

Pour créer la commande `scriv` qui va permet d'interagir :

* dans le Terminal (\*), se rendre dans le dossier `exe`,

```bash
> cd ~/chemin/vers/dossier/Scrivener
```

* Jouer le script `build_scriv_command.rb` du dossier `bin`,

    Note : pour ne pas vous tromper avec le nom, avec un chemin d'accès dans le Terminal, il suffit d'écire le début du nom puis de jouer la touche Tabulation (->). Par exemple, ici, il suffit d'écrire « cd », espace, balance (« / »), « bin », balance, « b », tabulation, et le nom « build_scriv_command.rb » s'écrira automatiquement et… sans erreur.

```bash
> ruby ./bin/build_scriv_command.rb
```

(\*) L'application Terminal se trouve dans le dossier `/Applications/utilitaires/`

* S'assurer que les gems ruby soient en jouant la commande `bundle install`

```bash
> bundle install
```
