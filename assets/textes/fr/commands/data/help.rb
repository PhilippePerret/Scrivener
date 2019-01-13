# encoding: UTF-8
module AideCommandGeneralData
MANUEL = <<-EOT
#{'AIDE DE LA COMMANDE `scriv data`'.gras}
================================

  Description
  -----------

      La commande #{'`scriv data`'.jaune} permet d’obtenir les données du
      projet Scrivener courant. C'est cette commande qui
      affiche la liste de tous les mots et leur utilisation
      dans le texte.

   Alias
  -------

    On peut utiliser aussi l'alias #{'`scriv stats[ <options>]`'.jaune}.

Limiter le nombre de mots
-------------------------

  On peut limiter le nombre de mots affichés avec le paramètre `mots`
  en lui donnant en valeur le nombre de mots à obtenir ou `all`.
  Par exemple :

    #{'`scriv data mots=20`'.jaune} => Affichera seulement 20 mots.

EOT
end #/module
