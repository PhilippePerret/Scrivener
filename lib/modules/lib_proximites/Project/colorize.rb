=begin

=end
class Scrivener
  class Project

    # Méthode qui va définir la couleur des mots dans les segments, pour
    # la liste des proximites données +proximites+ (par défaut, toutes les
    # proximités)
    #
    # Définit dans chaque élément de self.segments les propriétés :
    #   :has_color    True si le mot doit être colorisé
    #   :prev_color   La couleur partagée avec le mot précédent (dans le
    #                 format défini)
    #   :next_color   La couleur partagée avec le mot suivant (idem)
    #
    # Il suffit ensuite de boucler dans segment pour afficher le texte avec
    # les proximités mises en couleur.
    #
    # +param proximites+  Liste d'instance {Proximite}
    # +param options+     Hash des options :
    #   :color_format     Le format de couleur (RTF par défaut)
    #                     Mettre :console pour la console.
    #   :in_color_list    La liste dans laquelle prendre les couleurs.
    #                     :dark_colors par défaut.
    #
    def define_word_colors_in_segments proximites = nil, options = nil

      proximites ||= tableau_proximites[:proximites]

      options ||= Hash.new
      # Valeurs par défaut
      options.key?(:color_format) || options.merge!(color_format: :rtf)
      options.key?(:in_color_list)|| options.merge!(in_color_list: :dark_colors)

      # Pour créer un cycle de couleurs (avec la librairie COLORS)
      color_cycle = Colors::Cycle.new(
        in:       options[:in_color_list],
        format:   options[:color_format]
        )

      nombre_couleurs = color_cycle.nombre_couleurs

      # Pour procéder efficacement :
      # On passe en revue toutes les proximités (non écartées ou corrigées),
      # et on ajoute à la donnée segment de leurs deux mots une couleur.
      #
      # Note : on regarde l'offset du mot après pour savoir si un indice de
      # couleur peut à nouveau être utilisé
      #
      i_color       = I_COLOR_START - 1
      current_bitem = nil
      proximites.each do |prox_id, iprox|

        # Si c'est seulement une liste d'identifiants qui a été
        # fournie
        iprox ||= tableau_proximites[:proximites][prox_id]

        iprox.erased? || iprox.ignored? || iprox.fixed? && next

        mavant = iprox.mot_avant
        mapres = iprox.mot_apres

        i_color += 1
        if i_color > nombre_couleurs
          i_color = I_COLOR_START
        end

        c = color_cycle.next

        segments[mavant.index].merge!(next_color: c, has_color: true)
        segments[mapres.index].merge!(prev_color: c, has_color: true)

      end
    end
    # /define_word_colors_in_segments

  end#/Project
end #/Scrivener
