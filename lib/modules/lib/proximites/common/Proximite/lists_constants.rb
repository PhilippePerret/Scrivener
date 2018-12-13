
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

  # Pour construire la liste des proximités spécifiques, il faut appeler
  # la méthode  `Proximite.init`
  PROXIMITES_MAX = {
    # Liste des mots dont on supporte une proximité de 10 lettre ou plus
    10 => [
      'avoir',
      'être'
    ],
    20 => [
      'elle',
      'il',
      'lui',
      'nous',
      'son',
      'vous'
    ],
    # Liste des mots dont on supporte une proximité de plus de 50 signes
    50 => [
      'dans',
      'pas',
      'plus',
      'sur'
    ],
    # Liste des mots dont on supporte une proximité de plus de 100 signes
    100 => [
      'avec',
      'mais',
      'par',
      'pour',
      'que',
      'qui',

    ],
    200 => [
      'cinq',
      'deux',
      'dix',
      'douze',
      'huit',
      'neuf',
      'onze',
      'quatre',
      'sept',
      'six',
      'trois'
    ],
    # Liste construite à l'initiation, qui va comporter en clé le mot
    # canonique et en valeur la distance de proximité maximale
    mots: Hash.new
  }

end
