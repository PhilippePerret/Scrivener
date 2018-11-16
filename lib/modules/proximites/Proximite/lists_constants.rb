class Proximite

  # Distance minimale pour ne pas être en proximité, pour
  # des mots quelconques
  DISTANCE_MINIMALE = String::PAGE_WIDTH

  # Dans ce tableau de remplacement, on peut imaginer aussi avoir les mots
  # similaires comme "peut-être" et "sans doute"
  # TODO Avec une option, ces mots ne seront pas traités
  TABLEAU_SIMILAIRES = {
    'peut-être' => 'sans doute'
  }

  PROXIMITES_MAX = {
    # Liste des mots dont on supporte une proximité de 10 lettre ou plus
    10 => [
      'avoir',
      'être'
    ],
    # Liste des mots dont on supporte une proximité de plus de 50 signes
    50 => [
      'dans',
      'elle',
      'il',
      'nous',
      'pas',
      'plus',
      'sur',
      'vous'
    ],
    # Liste des mots dont on supporte une proximité de plus de 100 signes
    100 => [
      'lui',
      'par',
      'pour',
      'que',
      'qui',
      'son'
    ],
    # Liste construite à l'initiation, qui va comporter en clé le mot
    # canonique et en valeur la distance de proximité maximale
    mots: Hash.new
  }

end
