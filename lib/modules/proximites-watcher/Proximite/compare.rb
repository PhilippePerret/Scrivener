class Proximite

  # TEMP_PROX_FIXED = 'Fixée : proximité entre « %s » et « %s »'.vert
  TEMP_PROX_FIXED = 'Fixée : proximité entre « %s » et « %s »'
  # TEMP_PROX_ADDED = 'Trop grande proximité entre « %s » et « %s » (%s)'.rouge
  TEMP_PROX_ADDED = 'Trop grande proximité entre « %s » et « %s » (%s)'

  class << self

    # = main =
    #
    # Méthode de classe qui compare deux tables de proximité
    def compare_tables new_table, old_table
      CLI.dbg("-> Scrivener::Project#compare_tables (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      old_table.nil? && return

      new_proximites = Array.new
      old_proximites = Array.new

      # En prenant la nouvelle liste
      new_table[:mots].each do |canon, data_canon|

        # Si le mot est déjà absent de l'ancienne table,
        # c'est un ajout, il suffit de compter le nombre
        # de nouvelles proximités
        if old_table[:mots].key?(canon)
          # <= L'ancienne table connait ce mot canonique
          # => On doit vérifier si le nombre de proximités
          #    est identique. Noter qu'une erreur peut se
          #    glisser ici, si on a retiré une proximité et
          #    qu'on en a ajoutée une en même temps avec des.
          #    mots strictement identiques
          old_nombre_prox = old_table[:mots][canon][:proximites].count
          new_nombre_prox = data_canon[:proximites].count
          # On cherche les nouveaux couples mot-avant/mot-après
          # On commence par faire la liste des couples de l'ancienne table
          old_hash_paire = Hash.new
          old_table[:mots][canon][:proximites].each do |prox_id|
            iprox = old_table[:proximites][prox_id]
            paire = '%s-%s' % [iprox.mot_avant.real, iprox.mot_apres.real]
            old_hash_paire.merge!(paire => iprox)
          end
          new_table[:mots][canon][:proximites].each do |prox_id|
            iprox = new_table[:proximites][prox_id]
            paire = '%s-%s' % [iprox.mot_avant.real, iprox.mot_apres.real]
            if old_hash_paire.key?(paire)
              # <= L'ancienne table connait cette paire
              # => On la retire puisqu'elle est commune, pour qu'il ne
              #    reste plus que les paire retirées dans la table.
              old_hash_paire.delete(paire)
            else
              # <= L'ancienne table ne connait pas cette paire
              # => C'est une nouvelle paire, qu'on enregistre
              new_proximites << iprox
            end
          end
          # /fin de boucle sur les proximités du mot canon de la new liste

          # Ici, s'il reste des éléments dans old_has_paire, ce sont des
          # proximités qui ont été détruites
          old_hash_paire.empty? || begin
            old_hash_paire.each do |paire, iprox|
              old_proximites << iprox
            end
          end
        else
          # <= L'ancienne table ne connait pas ce mot canonique,
          #    c'est donc forcément une ou plusieurs proximités
          #    nouvelles.
          data_canon[:proximites].each do |prox_id|
            iprox = new_table[:proximites][prox_id]
            new_proximites << iprox
          end
        end
      end
      # /fin de boucle sur tous les mots de la nouvelle table

      # On boucle maintenant sur tous les mots de
      # l'ancienne table pour voir si certains ont été supprimés
      old_table[:mots].each do |canon, data_canon|

        # Si le mot canonique est connu de la nouvelle table, rien à faire
        # puisque le mot a été traité dans la boucle précédente
        if new_table[:mots].key?(canon)
          # <= Mot canonique connu de la nouvelle table
          # => Rien à faire, il a été traité dans la boucle ci-dessus
          next
        else
          # <= Mot canonique inconnu de la nouvelle table
          # => Il faut indiquer que toutes ses proximités ont été
          #    corrigées.
          data_canon[:proximites].each do |prox_id|
            iprox = old_table[:proximites][prox_id]
            old_proximites << iprox
          end
        end
      end

      # On peut s'arrêter là si aucune proximité n'a changé
      old_proximites.empty? && new_proximites.empty? && return

      msgs_output = Array.new

      old_proximites.each do |iprox|
        msgs_output << [TEMP_PROX_FIXED % [iprox.mot_avant.real, iprox.mot_apres.real], :vert]
      end
      new_proximites.each do |iprox|
        distance = (iprox.mot_apres.offset - iprox.mot_avant.offset) - iprox.mot_avant.real.length
        distance = "#{distance} / ~ #{distance / 6} mots"
        msgs_output << [TEMP_PROX_ADDED % [iprox.mot_avant.real, iprox.mot_apres.real, distance], :rouge]
      end

      # Retourner les messages de modifications
      return msgs_output

      CLI.dbg("<--- Scrivener::Project#compare_tables (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
    rescue Exception => e
      raise_by_mode(e, Scrivener.mode)
    end
    # /compare_tables

  end #/<<self
end #/Proximite
