# encoding: UTF-8
=begin
  Command 'build' pour voir les infos générales du projet courant

  C'est l'aide générale du site
=end

if CLI.options[:help]
  aide = <<-EOT
  #{'AIDE DE LA COMMANDE `scriv build`  '.underlined('-','  ').gras}

    #{'Description'.underlined('-', '  ')}

        La commande `scriv build` permet de construire des éléments
        dans le projet scrivener courant. Cette commande ne peut pas
        s'appeler seule. Il lui faut forcément un premier paramètre
        en argument. Ces paramètres définissent ce qui doit être
        construit :

        `documents`   Construit les dossiers et documents à partir
                      d'un fichier csv défini avec l'option `--from`
                      ou `--depuis`
                      --delimitor=<...> permet de définir le délimi-
                      teur entre chaque cellule, dans une rangée.
                      Attention que ce délimiteur ne soit pas utili-
                      sé dans les textes.

                      --no-heading  Indique que la première ligne
                      n'est pas une ligne d'entête avec les noms.
                      Mais attention, dans ce cas, l'ordre des don-
                      nées doit être absolument respecté.

        Commande complète =

        #{'scriv build documents --from=tdm.csv --delimitor="\t" --no-heading'}

  #{'Aperçu d’un fichier CSV pour la création de documents'.undelined('-', '  ')}

    dossier[TAB]sous-dossier[TAB]document[TAB]cible[TAB]
    # Un commentaire possible, après un dièse

    Exposition[TAB][TAB][TAB][TAB]
    [TAB]     Préambule [TAB][TAB][TAB]
    [TAB]     [TAB]     Introduction de l'histoire en 4 pages[TAB]4p[TAB]
    [TAB]     [TAB]     Deuxième document de 100 mots [TAB]100m[TAB]
    [TAB]     Inc.Pert. [TAB][TAB][TAB]
    [TAB]     [TAB]     Incident pertubateur    [TAB] 1p  [TAB]
    [TAB]     [TAB]     Incident déclencheur    [TAB] 4p  [TAB]

    Développement[TAB][TAB][TAB][TAB]
    [TAB]     Première action[TAB][TAB][TAB]
    [TAB]     [TAB]     La toute première action [TAB]10000[TAB]
    #/ fin du document

    À noter
    -------
    * La première ligne définit les entêtes. Si elle n'est pas donnée
      il convient d'ajouter l'option `--no-heading`
    * On peut laisser des lignes vides. Elles ne seront pas traitées,
    * Chaque ligne contient le même nombre de délimiteurs, même si
      seule la première cellule est définie.
      Dans le cas contraire, une erreur sera générée.
    * L'imbrication ici est de trois niveaux :
        Exposition _____
                        | Préambule ________
                        |                   | Introduction de l'histoire
                        |                   | Deuxième document
                        | Inc.Pert. ________
                                            | Incident perturbateur
                                            | Incident déclencheur
        Développement __
                        | Première action __
                                            | La toute première action
      … il faudra donc ajouter l'option `--depth=3` ou
      `--profondeur=3` à la commande.
    * Les objectifs (cible) peuvent être définis en pages (avec "p"),
      en mot (avec "m") ou en nombre de signes (sans unité).
    * La commande a deux moyens de savoir qu'une colonne particulière
      définit les objectifs : soit elle porte le titre 'cible' ou
      'target' (cible en anglais), ou en 'objectif', soit elle est
      composée uniquement de valeurs nulles ou pouvant être des ob-
      jectifs.

  EOT
  Scrivener.help(aide)

else
  Scrivener.require_module('Scrivener')
  Scrivener.require_module('build')
  Scrivener::Project.exec_build
end
