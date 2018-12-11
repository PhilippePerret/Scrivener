# Questions

Vaut-il mieux assember tous les textes avant de lemmatiser ou lemmatiser tous les texte petit à petit ?

L'avantage de lemmatiser tout d'un coup, c'est de travailler chaque fois sur un seul texte. On se fiche de la provenant des éléments, on travaille toujours sur un seul texte pour tirer les résultats. Sinon, on est obligé de gérer tous les textes.

Donc, l'instance `TextAnalyzer::Analyse` doit avoir une propriété `texte` qui contient l'intégralité du texte à analyser. Cette propriété est de type `TextAnalyzer::Analyse::WholeTexte`.
