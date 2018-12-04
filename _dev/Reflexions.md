#

Si on fait tomber la proximité à 1000, le nombre de proximités passe à
Si on fait tomber à la moitié de sa valeur, le nombre de proximité passe à

C'est dans le nombre total de proximités :

  Nombre à moins de 500
    1000
    1500
    2000

# Meilleure évaluation des proximités

Pour le moment, les résultats ne tiennent aucun compte de la distance entre les mots quand ils sont en promixité. Par exemple, si un texte présente dix mots en proximité, mais que cette proximité est à à peine moins d'une page et un autre texte possède aussi dix mots en proximité, mais qu'ils sont à quelques mots l'un de l'autre, le résultat est le même.

La première choses dont on peut tenir compte, c'est la proximité moyenne : c'est le nombre de proximité qui divise la somme des éloignements.
