
class Scrivener
  class Project

    class BinderItem

      BEFORE_TIRET_BADS_ARR = [
        'mi'
      ]
      BEFORE_TIRET_BADS = Hash.new

      AFTER_TIRET_BADS_ARR = [
        'ce', 'je', 'tu', 'il','on',
        'ils',
        'nous', 'vous', 'elle',
        'elles'
        ]
      AFTER_TIRET_BADS = Hash.new


      class << self

        attr_accessor :inited


        def prepare_listes_tirets
          BEFORE_TIRET_BADS_ARR.each do |item|
            BEFORE_TIRET_BADS.merge!(item => true)
          end
          AFTER_TIRET_BADS_ARR.each do |item|
            AFTER_TIRET_BADS.merge!(item => true)
          end
          self.inited = true
        end

      end #/<< self



      # Méthode qui traite le texte du binderitem et récupère tous
      # ses mots.
      #
      def releve_mots_in_texte tableau

        self.class.prepare_listes_tirets unless self.class.inited

        texte || @texte = ''

        # pour les ponctuations finales, qui ne seraient pas traitées
        # sans ça.
        texte << ' EOT'

        # On commence par remplacer tous les caractères non alphanumérique par
        # des espaces (ponctuations, retour chariot), car sinon ils ne seraient
        # pas considérés par le scan.
        t = texte.gsub(/\r/,'').gsub(/[\n\.\!\?\;\… ]/, ' ')
        # NE SURTOUT PAS METTRE '_' qui sert pour les tags retirés

        # # Remplacer les '-' (tirets) entre deux lettres par la marque
        # # XTIRETX pour pouvoir garder les mots entier, sauf si c'est la
        # # forme verbale 'y a-t-il ?'. Il faut qu'il y ait au moins 2
        # # lettre pour qu'on le garde
        # t = t.gsub(/([a-z]{2})\-([a-zêèîàç]{2})/, '\1XTIRETX\2')

        cur_offset = tableau[:current_offset]
        bdi_offset = 0 # l'offset dans ce document (pour segment)
        cur_index  = tableau[:current_index_mot] # commence à -1

        # Pour savoir dans quel segement on doit consigner le titre
        # du document courant.
        new_document_title_registered = false

        # On peut scanner le texte
        all_separated_words = t.scan(/\b(.+?)\b/)
        last_index_found = all_separated_words.count - 1

        # On en aura besoin pour traiter les mots avec tirets
        mot = nil

        index_found = -1 # pour commencer à 0 et avoir index_found += 1 au-dessus

        # all_separated_words.each_with_index do |found, index_found|
        while index_found < last_index_found
          index_found += 1

          found = all_separated_words[index_found]
          seg   = found[0]

          # Si c'est le dernier mot, on s'arrête
          seg != 'EOT' || break

          # Pour la gestion des tirets
          next_found = all_separated_words[index_found + 1] # peut être nil

          # Puisqu'on peut prendre le found suivant, on va vérifier si
          # le mot courant doit être lié au(x) suivant(s) par des tirets,
          # plutôt que de le contrôler quand le mot est déjà rentré. De
          # cette manière, l'ajout du mot canonique sera efficient.
          # Sinon: on ajoute par exemple 'contre' à la liste des mots
          # canoniques et ensuite on découvre que c'est 'contre-exemple'
          # et qu'il faut le traiter comme tel.

          while next_found && next_found[0] == '-'
            # Cas spécial du tiret. Comme il est difficile de faire
            # une distinction entre les tirets qui doivent être supprimés
            # par exemple dans les formes verbales "vois-tu ?" des tirets
            # (mauvais) qui débutent les phrases "-", des tirets qui sont
            # utilisés à tort à la place des tirets longs et des vrais
            # tirets entre deux mots, on fait le traitement ici.
            # Fonctionnement :
            #   On cherche si le tiret est valide en testant le segment
            #   précédent et le segment suivant.
            #   Si on trouve un tiret qui en est vraiment un, on ajoute
            #   le tiret et le mot suivant au mot courant.
            atiret = all_separated_words[index_found + 2][0] # pour Before-tiret
            if atiret.nil?
              # Pas de mot après => On doit poursuivre
              break
            elsif seg.length < 2 || atiret.length < 2
              # Un des deux mots trop court => On doit poursuivre
              break
            elsif BEFORE_TIRET_BADS[seg]
              # Le premier n'est pas valide => On doit poursuivre
              break
            elsif AFTER_TIRET_BADS[atiret]
              # Le second n'est pas valide => On doit poursuivre
              break
            else
              # puts "\n\nJe dois traiter le tiret entre #{seg.inspect} et #{atiret.inspect}."
              seg += '-' + atiret
              # puts "   seg actuel : #{seg.inspect}"
              index_found += 2 # pour sauter le tiret prochain et le mot prochain
              # Il faut faire une boucle pour voir s'il n'y a pas
              # encore de tiret comme dans "arrière-grand-mère"
              next_found = all_separated_words[index_found + 1]
            end
          end
          # /boucle tant qu'on trouve des tirets valides


          # L'index courant
          # Noter qu'il sert aussi d'ID au mot
          cur_index += 1

          # Si le mot commence par une espace, c'est qu'il s'agit d'un
          # "inter-mot", qui peut être constitué de plusieurs espaces et
          # ponctuation, retour chariot et consorts.
          # La première chose à faire est de récupérer les signes originaux
          type_seg = seg[0] == ' ' ? :inter : :mot

          if type_seg == :inter
            seg = mot = texte[bdi_offset...(bdi_offset + seg.length)]
          else # if type_seg == :mot
            mot = ProxMot.new(seg, cur_offset, cur_index, self.uuid)
            # On n'ajoute le mot au tableau que si c'est un vrai mot
            if mot.treatable?
              tableau = project.add_mot_in(mot, tableau)
            end
            # Dans tous les cas, on ajoute le mot aux 'real_mots' où la
            # clé est vraiment le mot lui-même, pas son canon. Par exemple,
            # dans ce Hash, 'prends' et 'pris' feront deux entrées différentes
            tableau = project.add_real_mot_in(mot, tableau)
          end

          data_seg = {id: cur_index, seg: seg, type: type_seg}
          unless new_document_title_registered
            data_seg.merge!(new_document_title: self.title)
            new_document_title_registered = true
          end

          # Dans tous les cas, on ajoute le segment à la liste de tous
          # les mots du projet (même si ça ne sert pas, comme dans la
          # méthode qui surveille la correction des proximités)
          project.segments << data_seg

          # Dans tous les cas on tient compte du décalage
          cur_offset += mot.length
          bdi_offset += mot.length
          # puts "--- current_offset après «#{mot.real}»:#{mot.length}:#{mot.offset}:('#{found[0]}'): #{tableau[:current_offset]}"
        end

        # Normalement, il faut ajouter 1 pour obtenir le vrai décalage dans
        # le fichier total, qui prend un retour de chariot en plus à la fin.
        cur_offset += 1

        tableau[:current_offset]    = cur_offset
        tableau[:current_index_mot] = cur_index

      end
      # /releve_mots_in_texte

    end #/BinderItem


    # ---------------------------------------------------------------------
    # Scrivener::Project

    # Ajoute le mot +imot+ au projet, en créant le record canonique au
    # besoin (s'il n'existe pas)
    # Attention : il ne suffit pas d'ajouter le mot, il faut aussi le placer
    # au bon endroit par rapport à son offset.
    def add_mot_in imot, tableau
      canon = imot.canonique
      tableau[:mots].key?(canon) || begin
        tableau[:mots].merge!(canon => {
          items:      Array.new,
          proximites: Array.new
        })
      end

      if tableau[:mots][canon][:items].empty? || tableau[:mots][canon][:items].last.offset < imot.offset
        # Si le nouveau mot est après le dernier, on l'ajoute
        # simplement au bout de la liste
        tableau[:mots][canon][:items] << imot
      else
        # Il faut placer le mot au bon endroit
        index_insertion = -1
        tableau[:mots][canon][:items].each_with_index do |mot, index_mot|
          if mot.offset > imot.offset
            index_insertion = index_mot
            break
          end
        end
        tableau[:mots][canon][:items].insert(index_insertion, imot)
      end
      return tableau
    end
    # /add_mot_in

    # Ajoute le mot à la real-list, où les clés vont vraiment les mots tels
    # qu'ils apparaissent dans le texte, pas leur forme canonique.
    def add_real_mot_in imot, tableau
      tableau[:real_mots].key?(imot.real) || begin
        tableau[:real_mots].merge!(imot.real => Array.new)
      end
      tableau[:real_mots][imot.real] << imot.index
      return tableau
    end
    # /add_real_mot_in

  end #/Project
end #/Scrivener
