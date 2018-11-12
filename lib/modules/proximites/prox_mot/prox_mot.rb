class ProxMot

  # L'expression réelle, telle que fournie par le texte
  attr_accessor :real
  attr_accessor :offset
  attr_accessor :binder_item_uuid # UUID du binder-item contenant le mot

  # Identifiant de la proximité du mot avec un mot avant ou après
  # La propriété volatile `proximite_avant|apres` permet de la retrouver
  # `proximite_avant` désigne la proximité qu'entretient le mot avec un
  # mot avant dans le texte. `proximite_apres` désigne la proximité qu'entre-
  # tient le mot avec un mot après dans le texte.
  attr_accessor :proximite_avant_id, :proximite_apres_id

  # Lorsqu'il est corrigé, le mot est remplacé par son nouveau mot, dans `real`
  # On conserve toujours le mot initial
  attr_accessor :init_real

  def initialize real_mot, offset, binder_item_uuid
    self.offset     = offset
    self.real       = real_mot
    self.init_real  = real_mot.freeze
    self.binder_item_uuid = binder_item_uuid
  end

  def downcase
    @downcase ||= real.downcase # pour le moment
  end

  # Forme canonique du mot (lemmatisé). Par exemple, "marcherions" aura
  # comme forme canonique "marcher"
  def canonique
    @canonique ||= (TABLE_LEMMATISATION[downcase] || real).downcase
  end

  # ---------------------------------------------------------------------

  # Procédure de remplacement du mot par +new_mot
  # Cela va consister à :
  #   * traiter le nouveau mot (downcase)
  #   * changer le downcase
  #   * changer le real
  #   * changer le canonique (ou pas)
  #   * retirer de la liste du mot
  #   * ajouter dans la liste du nouveau mot
  #
  # Question : faut-il voir si ça supprime une proximité, ou alors est-ce
  # qu'on change forcément par le biais des proximités.
  # Cf. N0001 et oui, on ne procède que par proximités, donc il est inutile,
  # ici, de voir si ça corrigera une proximité.
  def remplace_par new_mot
    self.real = new_mot
    # Si le mot a changé de mot canonique, on doit le retirer de
    # sa liste et la mettre dans la nouvelle
    # Sinon, il n'y a rien à faire
    new_mot_canonique = (TABLE_LEMMATISATION[new_mot] || new_mot).downcase
    if canonique != new_mot_canonique
      tableau = project.tableau_proximites
      # Retirer le mot de :
      # tableau[:mots][canonique][:items]
      # … et le mettre dans
      # tableau[:mots][new_mot_canonique][:items]
      # En vérifiant dans les deux cas comment ça modifie les proximités
      # des anciens mots avant/après s'ils existent et les nouveaux mots
      # avant/après s'ils existent
      old_index = tableau[:mots][canonique][:items].index(self)
      old_mot_avant = tableau[:mots][canonique][:items][old_index - 1]
      old_mot_apres = tableau[:mots][canonique][:items][old_index + 1]
      # Rien à faire si un des deux n'existe pas
      if old_mot_avant.nil? && old_mot_apres.nil?
        # Rien à faire, normalement, ça ne devrait pas pouvoir arriver
      elsif !old_mot_avant.nil? && !old_mot_apres.nil?
        # <= Les deux existent
        # => Il faut vérifier leur proximité
        # Noter que deux proximités existent, celle du mot avant et le
        # mot courant et celle du mot courant et du mot après.
        # Dans tous les cas, une des proximités doit être détruite (la seconde).
        # Les deux sont détruites si le mot avant et le mot après ne sont
        # pas en proximité, sinon, on garde la première en moditifant le
        # mot après.
        prox_apres_mot_avant = old_mot_avant.proximite_apres
        prox_avant_mot_apres = old_mot_apres.proximite_avant
        prox_avant_mot_apres.destroy # supprime la donnée proximite_apre|avant
        # des deux mots concernés
        if old_mot_avant.trop_proche_de?(old_mot_apres)
          old_mot_apres.proximite_avant   = prox_apres_mot_avant
          prox_apres_mot_avant.mot_apres  = old_mot_apres
          project.tableau_proximites[:nombre_proximites_added] += 1
        end
      elsif old_mot_avant
        # => Il faut supprimer la proximité
        # Supprimer le proximite_avant de old_mot_avant
        old_mot_avant.proximite_apres.destroy
      elsif old_mot_apres
        # => Il faut supprimer la proximité
        # Supprimer la proximite_apres de old_mot_apres
        old_mot_apres.proximite_avant.destroy
      end
    else
      @canonique = nil
    end
    # Pour forcer l'initialisation
    @length             = nil
    @downcase           = nil
    @is_treatable       = nil
    @distance_minimale  = nil

    # On l'ajoute dans sa nouvelle liste de canonique
    

    return true # si la proximité a été fixée (TODO C'est encore à étudier)
  end

  # Retourne true si le mot est traitable
  # Pour le moment, pour qu'un mot soit traitable, il faut :
  #   - que ce soit vraiment un mot
  #   - que sa longueur soit de au moins 2 caractères
  def treatable?
    @is_treatable ||= !real.start_with?('T_') && real_mot? && canonique.length > 2
  end

  def real_mot?
    @is_real_mot ||= !!downcase.match(/[a-zA-Zçàô]/)
  end

  def length
    @length ||= real.length
  end

  def proximite_avant
    @proximite_avant ||= begin
      project.tableau_proximites[:proximites][proximite_avant_id]
    end
  end
  def proximite_apres
    @proximite_apres ||= begin
      project.tableau_proximites[:proximites][proximite_apres_id]
    end
  end
  def proximite_avant= iprox
    self.proximite_avant_id =
      if iprox.nil?
        nil
      else
        iprox.id
      end
  end
  def proximite_apres= iprox
    self.proximite_apres_id =
      if iprox.nil?
        nil
      else
        iprox.id
      end
  end

  # Retourne TRUE si le mot courant est trop proche du mot +imot+ {ProxMot} qui
  # se trouve (toujours pour le moment) avant le mot.
  def trop_proche_de? imot
    self.offset - imot.offset < distance_minimale
  end

  def distance_minimale
    @distance_minimale ||= begin
      if Proximites::PROXIMITES_MAX[:mots].key?(canonique)
        Proximites::PROXIMITES_MAX[:mots][canonique]
      else
        DISTANCE_MINIMALE
      end
    end
  end

end
