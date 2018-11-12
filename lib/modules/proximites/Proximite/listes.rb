class Proximites

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
    # Liste des mots dont on supporte une proximité de plus de 100 signes
    100 => [
      'lui',
      'par',
      'que'
    ],
    # Liste construite à l'initiation, qui va comporter en clé le mot
    # canonique et en valeur la distance de proximité
    mots: Hash.new
  }


  def self.traite_listes_rectifiees
    h = PROXIMITES_MAX
    hash_mots = Hash.new
    h.each do |k_distance, liste_mots|
      liste_mots.each {|mot| hash_mots.merge!(mot => k_distance)}
    end
    PROXIMITES_MAX[:mots] = hash_mots
    #/fin de boucle sur toutes les distances rectifiées
  end


end
