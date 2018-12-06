# encoding: UTF-8
=begin
  Command 'help' ou quand on fait simplement `scriv`

  C'est l'aide générale du site
=end
Scrivener.require_module('set') # même pour l'aide

if CLI.options[:help]
  aide = <<-EOT
  #{'  COMMANDE `scriv set`  '.underlined('-').gras}

    #{'scriv set[ path/to/proj.scriv][ <options>] <param>[="<valeur>"]'.jaune}

    #{'Description'.underlined('-', '  ')}

        La commande `scriv set` permet de définir un grand nombre de
        données du projet Scrivener courant (*).

        (*) « courant » signifie, dans l'ordre :
        - le projet dont le chemin d'accès est spécifié dans la
          commande. Par exemple : `scriv data ~/projets/proj.scriv`
        - le projet contenu par le dossier dans lequel on se
          trouve en ce moment.
        - le dernier projet utilisé par la commande `scriv`.

        Par exemple, on remarquera que définir le titre ou l'auteur
        d'un projet Scrivener est assez malaisé et bizarre : il faut
        passer par la compilation, ouvrir l'onglet des métadonnées et
        définir ces données dans cette partie. Et encore, si on fait
        « Annuler », les données seront perdues…

        La commande `scriv set auteur="Prénom Nom" titre="Le titre"`
        permet de remédier à ce problème.

    ATTENTION
    ---------

    Pour utiliser cette commande, il faut impérativement que le pro-
    jet soit fermé. S'il est ouvert, tous les réglages seront perdus
    pour la plupart. Cela tient au fait que Scrivener réenregistre
    toutes ses données en quittant le projet et que la commande `set`
    travaille sur les fichiers du projet (sur le disque), pas dans
    l'application ouverte elle-même.

  EOT
  Scrivener.help(aide)
  Scrivener::Project.aide_commande_set

else
  Scrivener.require_module('Scrivener')
  Scrivener::Project.exec_set
end
