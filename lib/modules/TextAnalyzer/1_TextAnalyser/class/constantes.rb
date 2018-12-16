# encoding: UTF-8
class TextAnalyzer

  DISTANCE_MINIMALE = 1500.0

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
  
end #/TextAnalyzer