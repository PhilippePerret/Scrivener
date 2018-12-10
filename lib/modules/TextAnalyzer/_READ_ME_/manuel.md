# Manuel de TextAnalyzer

Cet analyseur de texte permet d'analyser n'importe quel texte.

Il prend un texte dans un fichier et produit un ensemble de fichiers analytiques du texte, notamment les proximités, les fréquences de mots, etc.

## Intance `TextAnalyzer::Analyse`

C'est une analyse, de n'importe quel texte, qu'il provienne d'un projet Scrivener et soit constitué de plusieurs binder-items ou qu'il vienne d'un simple texte.

## Instance `TextAnalyzer::File`

C'est la base. Le texte doit être contenu dans un fichier sur le disque dur.

    f = TextAnalyzer::File.new(<path>)

## Instance `TextAnalyzer::File::Text`

Elle contient et gère le texte du fichier.
