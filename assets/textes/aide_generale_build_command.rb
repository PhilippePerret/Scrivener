module AideGeneraleBuildCommand
AIDE = <<-MARKDOWN
  #{'AIDE DE LA COMMANDE `scriv build`  '.underlined('-','  ').gras}

    Note préliminaire
    -----------------

    La commande `update` correspond à `scriv build --update`. Elle per-
    met d'actualiser des données construites avec `scriv build`.
    Avec l'option `-i/--interactive`, on peut confirmer chaque modifi-
    cation. Dans le cas contraire, toutes les modifications sont
    opérées sans demande.

    #{'Description'.underlined('-', '  ')}

    La commande `scriv build` permet de construire des éléments
    dans le projet scrivener courant. Cette commande ne peut pas
    s'appeler seule. Il lui faut obligatoirement un premier para-
    mètre en argument pour indiquer ce qui doit être construit :

    `documents`   Construit la hiérarchie des documents à partir
                  d'un fichier CSV (fichier tableur). Peut définir
                  toutes les données telles que les objectifs à at-
                  teindre ou autres métadonnées.

    `metadatas`   Construit des métadonnées pour le projet, en ligne de
                  commande (interactive ou explicite) ou à partir de
                  fichiers YAML.

MARKDOWN
end #/module
