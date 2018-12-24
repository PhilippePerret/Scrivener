# encoding: UTF-8
=begin
  Command 'help' ou quand on fait simplement `scriv`

  C'est l'aide générale du site
=end
if CLI.options[:help]
  aide = <<-EOT
  #{'  COMMANDE `scriv data`  '.underlined('-', '  ').gras}

    #{'Description'.underlined('-', '    ')}

        La commande #{'`scriv data`'.jaune} permet d’obtenir les données du
        projet Scrivener courant (*). C'est cette commande qui
        affiche la liste de tous les mots et leur utilisation
        dans le texte.

        (*) « courant » signifie, dans l'ordre :
        - le projet dont le chemin d'accès est spécifié dans la
          commande. Par exemple : `scriv data ~/projets/proj.scriv`
        - le projet contenu par le dossier dans lequel on se
          trouve en ce moment.
        - le dernier projet utilisé par la commande `scriv`.

    #{'Alias'.underlined('-', '    ')}

      On peut utiliser aussi l'alias #{'`scriv stats[ <options>]`'.jaune}.

  #{'Limiter le nombre de mots'.underlined('-', '  ')}

    On peut limiter le nombre de mots affichés avec le paramètre `mots`
    en lui donnant en valeur le nombre de mots à obtenir ou `all`.
    Par exemple :

      #{'`scriv data mots=20`'.jaune} => Affichera seulement 20 mots



  EOT
  Scrivener.help(aide)

else
  Scrivener.require_module('Scrivener')
  Scrivener.require_module('data')
  Scrivener::Project.exec_data_projet(project)
end
