=begin
  Module principal pour l'affichage des proximités d'un seul mot
=end
class Scrivener
  class Project

    # Le mot dont il faut voir la proximité
    attr_accessor :mot
    # Instance ProxMot du mot
    attr_accessor :proxmot

    def exec_proximites_one_word

      init_prox_one_word
      define_self_data # mot, document, etc.
      puts RC + ('Proximité du mot %s dans %s' % [mot.inspect, self.watched_document_title.inspect]).bleu

      # On cherche les proximités dans les binder-items concernés
      self.tableau_proximites = check_proximites_in_watched_binder_items

      # Pour pouvoir traiter le mot, il faut qu'on en trouve la valeur
      # canonique
      self.tableau_proximites || return
      self.proxmot = ProxMot.new(mot)
      if self.tableau_proximites[:mots].key?(proxmot.canon)
        affiche_texte_avec_proximites
      else
        puts "Impossible de trouver le mot #{mot} (#{proxmot.canon})"
      end


    rescue Exception => e
      raise_by_mode(e, Scrivener.mode)
    end
    # /exec_proximites_one_word


    def affiche_texte_avec_proximites

      data_mot = tableau_proximites[:mots][proxmot.canon]

      # Si aucune proximité n'a été trouvée, on peut s'en retourner
      data_mot[:proximites].count > 0 || begin
        puts "Ce mot ne possède aucune proximité.".bleu
        return
      end
      puts "Nombre de proximités du mot : #{data_mot[:proximites].count}"

      # On ajoute les couleurs aux segments
      define_word_colors_in_segments(data_mot[:proximites], {color_format: :console})

      segments.each do |data_segment|

        # Changement de titre => nouveau document => retourn chariot
        if data_segment[:new_document_title]
          puts  String::RC + ('--- %s' % data_segment[:new_document_title]).rgb([40,40,40])
        end

        # On écrit le segment, en le traitant si c'est le mot qu'on
        # veut voir.
        case data_segment[:type]
        when :inter
          print data_segment[:seg]
        when :mot
          # puts "data_segment: #{data_segment.inspect}"
          print(code_pour_mot_segment(data_segment))
        # else
        #   print data_segment[:seg]
        end
      end
      print String::RC
    end

    def code_pour_mot_segment dsegment
      dsegment[:has_color] || (return dsegment[:seg])
      seg = dsegment[:seg]
      ecol = "\033[0m"
      if dsegment[:prev_color] && dsegment[:next_color]
        # Avec une proximité avant et une après
        '%s%s%s|%s%s%s' % [dsegment[:prev_color], seg, ecol, dsegment[:next_color], seg, ecol]
      elsif dsegment[:prev_color]
        '%s%s%s' % [dsegment[:prev_color], seg, ecol]
      else
        '%s%s%s' % [dsegment[:next_color], seg, ecol]
      end
    end

    # Initialisation de la commande
    def init_prox_one_word
      Scrivener.require_module('lib_proximites')
      Debug.init
    end

    # Définition des données utiles
    # À commencer par le mot dont il faut voir les proximités et
    # les documents concernés.
    def define_self_data
      self.mot = CLI.params[:mot]
      # Note : le mot existe forcément puisque c'est lorsqu'il est défini
      # qu'on vient dans ce module.
      self.watched_document_title = CLI.params[:doc] || CLI.options[:document] || raise_no_document
      self.watched_binder_items = get_binder_items_around(watched_document_title)
    end

    def raise_no_document
      raise('Le titre du document du mot doit être donné (en paramètre : `doc="<début titre>"` ou en option : `-doc="<début titre>"`)')
    end

  end #/Project
end #/Scrivener
