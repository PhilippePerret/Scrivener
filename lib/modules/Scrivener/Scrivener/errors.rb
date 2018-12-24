class Scrivener

  ERRORS.merge!(
    binder_item_required:         'Cette méthode attend un Binder-item en premier argument.',
    unable_to_find_factor_with:   'Impossible de trouver le facteur avec la valeur %s. Il faut soit le facteur lui-même (p.e. `1.5`), soit un pourcentage (p.e. `130%s`), soit un pourcentage sans unité (p.e. `400`).',
    valeurs_possibles:            'Les seules valeurs possibles pour %s sont %s.',
    bad_objectif_value:           'La valeur pour l’objectif est invalides (bon : "6p", "6pages", "3m", "3mots", "12w", "12words", "126", "126c", "126chars")'
  )

end #/Scrivener
