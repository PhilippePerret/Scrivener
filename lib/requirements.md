
-- Pour la recherche de proximité (lemmatisation)

* Charger la ligne de commande [TreeTagger](http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/#parfiles) (et les fichiers utiles) dans le dossier `/usr/local/`

Procéder en deux étapes :

1. Charger les fichiers requis dans un dossier `TreeTagger` dans le dossier téléchargement,
2. Déplacement ce dossier `TreeTagger` dans le dossier `/usr/local`

Pour ouvrir le dossier `usr/local` :

```bash
> open /usr/local
```

* Faire un alias de commande avec :

```bash
> ln -s /usr/local/TreeTagger/cmd/tree-tagger-french /usr/local/bin
```
