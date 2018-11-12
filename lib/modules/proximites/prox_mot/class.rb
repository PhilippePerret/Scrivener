class ProxMot

  TABLEAU_REMPLACEMENTS = {
    'j' => 'je',
    'l' => 'le'
  }

  # Dans ce tableau de remplacement, on peut imaginer aussi avoir les mots
  # similaires comme "peut-être" et "sans doute"
  # TODO Avec une option, ces mots ne seront pas traités
  TABLEAU_SIMILAIRES = {
    'peut-être' => 'sans doute'
  }
  
end
