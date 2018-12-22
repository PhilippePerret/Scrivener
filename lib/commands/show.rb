# encoding: UTF-8
=begin
  Command 'help' ou quand on fait simplement `scriv`

  C'est l'aide générale du site
=end
if CLI.options[:help]
  aide = <<-EOT
  #{'  COMMANDE `scriv show <choses:clé classement>`  '.underlined('-', '  ').jaune.gras}

  #{'Description'.underlined('-', '  ')}

    La commande #{'`scriv show`'.jaune} permet d’afficher les
    les données voulues du projet Scrivener courant (*). C'est
    cette commande qui peut afficher par exemple les mots et
    leur forme dans l’analyse.

    (*) « courant » signifie, dans l'ordre :
    - le projet dont le chemin d'accès est spécifié dans la
      commande. Par exemple : `scriv data ~/projets/proj.scriv`
    - le projet contenu par le dossier dans lequel on se
      trouve en ce moment.
    - le dernier projet utilisé par la commande `scriv`.

  #{'Clés de classement'.underlined('-', '  ')}

    Les clés de classement se placent après les éléments à voir et
    deux points. Par exemple `mots:alpha`.

    On peut utiliser :

      * alpha     Classement alphabétique
      * -alpha    Classement alphabétique inverse
      * count     Classement par nombre d'occurences
      * prox      Classement par nombre de proximités
      * dist      Classement par distance (proximités). De la plus
                  proche à la plus éloignée.
      * -dist     Inverse de précédente, des proximités les plus
                  éloignées aux proximités les plus proches.

  #{'Exemple'.underlined('-', '  ')}

      #{'`scriv show mots:alpha mots:prox`'.jaune}

      La commande ci-dessus va afficher la liste de tous les mots,
      d'abord en classement alphabétique, puis ensuite en classement
      par nombre de proximités.

  #{'Éléments affichages'.underlined('-', '  ')}

    mots, words  (p.e. : #{'scriv show mots'.jaune})

      Affichage des mots du texte, avec leur forme canonique, minus-
      cule, lemmatique, etc.

    prox, proximites  (p.e. : #{'scriv show prox:count'.jaune})

      Affichage de toutes les proximités, dans l'ordre voulu.

  EOT
  Scrivener.help(aide)

else
  Scrivener.require_module('Scrivener')
  Scrivener.require_module('show')
  Scrivener::Project.exec_show(project)
end
