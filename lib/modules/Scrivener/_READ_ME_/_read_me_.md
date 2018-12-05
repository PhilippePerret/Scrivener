# Module Scrivener

Pour gérer tous les aspects, si possible, d'un projet, aussi bien au niveau de l'interface qu'au niveau de ses fichiers.

# Liste des données modifiables

## ÉDITEUR PRINCIPAL

### Définir le zoom dans l'éditeur principal (\*)

(\*) qui porte bizarrement le préfixe 'supporting' et non pas 'main'.

        project.ui.supporting_document_editor.text_scale_factor=<valeur>

          Si <valeur> est x alors le pourcentage est  y
                          1                           100%
                          2                           200%
                          2.5                         250%
                          etc.

### Définir comme éditeur actif/inactif

        project.ui.supporting_document_editor.set_current
        # => active

        project.ui.supporting_document_editor.unset_current
        # => Inactive

## ÉDITEUR SECONDAIRE

### Définir le zoom dans l'éditeur secondaire (\*)

(\*) qui porte bizarrement le préfixe 'main')

        project.ui.main_document_editor.text_scale_factor=<valeur>

## PLEIN ÉCRAN

### Définir le zoom en plein écran

        project.ui.full_screen.text_scale_factor = <valeur>

## INSPECTEUR

### Définir la taille des notes (dans l'inspecteur)

        project.ui.notes_scale_factor = <valeur>
