# Scriv intern méthodes

J'essaie de tenir ici une liste des méthodes internes qui permettent de contrôler l'application en coulisses.

## Module 'Scrivener'

Pour profiter de ces méthodes : `Scrivener.require_module('Scrivener')`

### Affiche un ou plusieurs documents dans l'éditeur principal ou secondaire

    # Éditeur principal
    project.ui_common.editor1.content= <binder-item> # dossier ou texte
    project.ui_common.editor1.content= [<binder-item>, ...]
    # Éditeur secondaire
    project.ui_common.editor2.content= <binder-item> # dossier ou texte
    project.ui_common.editor2.content= [<binder-item>, ...]

### Ferme le dossier <binder-item> dans le classeur

    project.ui_common.binder.close_folder(<binder-item>)

### Ouvre le dossier <binder-item> dans le classeur

    project.ui_common.binder.open_folder(<binder-item>)

### Ferme tous les dossiers du projet

    project.ui_common.binder.close_all_folder

### Sélectionne le dossier <binder-item> dans le classeur

    project.ui_common.binder.select(<binder-item>)

### Désélectionne le dossier <binder-item> dans le classeur

    project.ui_common.binder.unselect(<binder-item>)

---

### Visibilité de l'entête de l'éditeur 1 ou 2

    project.ui_common.editor1.header_visible(true|false)
    project.ui_common.editor2.header_visible(true|false)

### Visibilité du pied de page de l'éditeur 1 ou 2

    project.ui_common.editor1.footer_visible(true|false)
    project.ui_common.editor2.footer_visible(true|false)
