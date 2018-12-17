# Les listes

On trouve ici un détail des listes qui sont utilisées pour

## WhoteText#all_mots

C'est la liste qui contient les mots, sans aucune rectification de lemmatisation. Dans cette liste, le mot "évident" est considéré comme différent du mot "évidents".

## WholeText#mots



## TextAnalyzer::Analyse::TableResultats#mots

La propriété `mots` de la table de résultat (`TextAnalyzer::Analyse::TableResultats`) comporte les mots simplifiés au niveau des singuliers/pluriels et masculins/féminins, mais sont conservés toutes les formes des verbes.

On a par exemple :

                        Dans la liste           Dans la liste
      Dans le texte       TableResultats#mots     TableResultats#canons
    ---------------------------------------------------------------------
      mot.real =>            mot.lemma =>            mot.canon =>

        évidente              évident                 évident
        évident               évident                 évident
        mots                  mot                     mot
        prendrait             prendrait               prendre
        pris                  pris                    prendre


Cette liste est un `Hash` étendu avec en clé la forme minuscule du mot et en clé la liste de ses index.
