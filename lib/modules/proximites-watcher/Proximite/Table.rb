class Proximite
  class Table

    # Les données de la table des proximités
    attr_reader :data

    # Les mots (canons) qui n'appartiennent qu'à la table courante
    attr_accessor :mots_propres
    # Les proximités propres à la table courante
    attr_accessor :proximites_propres

    # La table de comparaison (instance {Proximite::Table}). Celle qui sera
    # comparée à la table courante
    attr_reader :table_comparaison

    def initialize data
      @data = data
    end
    def compare_with_table table_comp
      @table_comparaison = table_comp

      # Mots qui n'appartiennent qu'à la table courante
      self.mots_propres = Array.new
      # Proximités qui n'appartiennent qu'à la table courante
      self.proximites_propres = Array.new

      # Boucle sur chaque mot (canon) de la table
      canons.each do |canon, data_canon|
        if canon_is_known_of_table_comparaison?(canon)
          # Canon connu de la table de comparaison
          compare_proximites_of(canon)
        else
          add_canon_and_proximites_propres(canon)
        end
      end
    end
    # ---------------------------------------------------------------------
    #   Méthodes utiles

    # Méthode qui ajoute un mot connu seulement par la table courante. Il faut
    # ajouter ce mot et toutes ses proximités.
    #
    # Noter qu'il peut très bien n'y avoir aucun proximité pour le mot
    # donné.
    #
    def add_canon_and_proximites_propres canon
      mots_propres << canon
      canons[canon][:proximites].each do |prox_id|
        self.proximites_propres << proximite(prox_id)
      end
    end

    # ---------------------------------------------------------------------
    # Méthodes de comparaison utiles

    # Méthode qui compare les proximités du mot +canon+ dans les deux
    # tables comparées, qui possède toutes les deux le mots.
    # Il ne suffit pas de voir si les deux tables comportent les mêmes paires,
    # il faut aussi que ce nombre de paires soit identique.
    def compare_proximites_of canon
      hash_proximites_par_paire_of(canon).each do |kpaire, arr_iprox|
        curr_nombre_proxs = arr_iprox.count
        unless table_comparaison_a_autant_de_proximites(canon, kpaire)
          # Ici, il faut chercher la ou les proximités ajoutées, qui ne sont
          # pas forcément les dernières.
          self.proximites_propres += ote_proximites_of_from(
            self.proximities_for_paire(canon, kpaire),
            table_comparaison.proximities_for_paire(canon, kpaire) || Array.new
          )
          # /boucle pour trouver toutes les proximités
        end
      end
    end


    # Retourne la liste Array des proximités qui n'appartiennent qu'à +prox_liste+
    # +prox_liste+ est une liste de proximités (instance Proximite)
    def ote_proximites_of_from prox_liste, comp_prox_liste
      # CLI.verbose(true)
      curr_liste = prox_liste.collect{|iprox| [iprox.mot_avant.offset, iprox.id, iprox.mot_apres.offset]}
      comp_liste = comp_prox_liste.collect{|iprox| [iprox.mot_avant.offset, iprox.id, iprox.mot_apres.offset]}

      # CLI.dbg('--- curr_liste: %s' % [curr_liste.to_yaml])
      # CLI.dbg('--- comp_liste: %s' % [comp_liste.to_yaml])
      only_in_curr = ote_comp_items_from_curr_items(curr_liste, comp_liste)
      # CLI.dbg('--- only_in_curr : %s' % [only_in_curr.to_yaml])
      # On prend seulement l'instance Proximite de la triade
      proxs = only_in_curr.collect do |triade|
        proximite(triade[1]) # => l'instance proximité
      end
      # CLI.verbose(false)
      return proxs
    end

    # Cette méthode retourne les éléments de curr_liste qui n'appartiennent pas
    # à +comp_liste+ en faisant une vérification souple, c'est-à-dire en trouvant
    # les éléments les plus proches. Ce qui signifie que si +comp_liste+ contient
    # x éléments, x éléments seront forcément retirés de curr_liste.
    #
    # Chaque élément de +curr_liste+ et de +comp_liste+ est un trio :
    #   [offset du mot avant, instance proximité, offset du mot après]
    #
    def ote_comp_items_from_curr_items curr_liste, comp_liste
      curr_liste_finale = curr_liste.dup

      # On doit prendre chaque élément de la comp_liste et trouver l'élément le
      # plus proche dans curr_liste, pour le retirer. Il sera mis à nil dans la
      # liste finale (curr_liste_finale) qui sera ensuite compactée et renvoyée
      comp_liste.each do |offavant, prox_id, offapres|

        # Trouver l'élément le plus proche dans curr_liste
        cur_distance_min = 1000000
        cur_index_triade = nil
        curr_liste.each_with_index do |triade, index_triade|

          # On calcule la distance entre la triade de comp_liste et la triade de
          # curr_liste. Cette distance est la moyenne entre les distances absolues
          # des deux mots.
          distmoy = (triade.first - offavant).abs + (triade.last - offapres).abs
          distmoy = (distmoy.to_f / 2).round(2)

          if distmoy < cur_distance_min
            # <= Cette paire est la plus proche pour la moment
            cur_distance_min = distmoy
            cur_index_triade = index_triade
            # Si la distance est nulle, on peut s'arrêter tout de suite, on
            # ne trouvera pas mieux
            if distmoy.to_i == 0
              break
            end
          end
          #/ fin de si la distance est la plus courte pour le moment
        end
        #/ fin de boucle sur toutes les paires courantes pour trouver celle la
        #  plus proche de la paire de comparaison. On retirera la plus proche
        #  des paires nouvelles.
        curr_liste_finale[cur_index_triade] = nil
      end
      return curr_liste_finale.compact
    end

    # Return TRUE si la table de comparaison connait le mot +canon+
    def canon_is_known_of_table_comparaison? canon
      table_comparaison.canons.key?(canon)
    end

    def table_comparaison_a_autant_de_proximites canon, kpaire
      proximity_count_for(canon, kpaire) == table_comparaison.proximity_count_for(canon, kpaire)
    end

    # Retourne le nombre de proximités pour la paire de mot kpaire
    #
    def proximity_count_for(canon, kpaire)
      if hash_proximites_par_paire_of(canon).key?(kpaire)
        proximities_for_paire(canon, kpaire).count
      else
        0
      end
    end

    def proximities_for_paire(canon, kpaire)
      hash_proximites_par_paire_of(canon)[kpaire]
    end

    # ---------------------------------------------------------------------
    # Data de la table

    def hash_proximites_par_paire_of canon
      @proximites_par_paire ||= Hash.new
      @proximites_par_paire[canon] ||= begin
        h = Hash.new
        canons[canon][:proximites].each do |prox_id|
          iprox   = proximite(prox_id)
          kpaire  = '%s-%s' % [iprox.mot_avant.real, iprox.mot_apres.real]
          h.key?(kpaire) || h.merge!(kpaire => Array.new)
          h[kpaire] << iprox
        end
        h
      end
    end

    # Retourne la table des canons, donc la table des mots canonisés
    def canons
      @canons ||= data[:mots]
    end
    # Retourne l'instance proximité d'identifiant +prox_id+ de la table
    def proximite(prox_id)
      data[:proximites][prox_id]
    end


  end #/class Table
end #/Proximite
