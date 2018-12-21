=begin

=end
class TextAnalyzer
class Analyse
class TableResultats

class Segments < Array

    # TODO CETTE MÉTHODE EST À REPRENDRE
    # Méthode qui va définir la couleur des mots dans les segments, pour
    # la liste des proximites données +proximites+.
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
    # +param proximites+  Liste d'instance {Proximite} ou d'identifiants
    #                     OU
    #                     Liste de listes dont chacune doit avoir une couleur
    #                     unique (cyclique).
    #
    # +param options+     Hash des options :
    #     :color_format     Le format de couleur (RTF par défaut)
    #                       Mettre :console pour la console.
    #     :in_color_list    La liste dans laquelle prendre les couleurs.
    #                       :dark_colors par défaut.
    #
    def define_word_colors_in_segments proximites = nil, options = nil


      # puts "---- proximites: #{proximites.inspect}"

      # Pour simplifier les écritures
      table_proxs = analyse.table_resultats.proximites

      # Les instances comme list si non définies en argument
      proximites ||= table_proxs.values

      options ||= Hash.new
      # Valeurs par défaut
      options.key?(:color_format) || options.merge!(color_format: :rtf)
      options.key?(:in_color_list)|| options.merge!(in_color_list: :light_colors)

      # Pour créer un cycle de couleurs (avec la librairie COLORS)
      color_cycle = Colors::Cycle.new(
        in:       options[:in_color_list],
        format:   options[:color_format]
        )

      # Pour que la couleur soit répartie dans l'ordre des mots,
      # on va classer les listes envoyés
      if proximites.first.is_a?(Array)

        # puts "--- proximites (DÉPART) : #{proximites.inspect}"
        # On commence par mettre des instances Proximite au lieu des
        # identifiant
        proximites = proximites.collect do |arrprox|
          arrprox.map { |proxid| table_proxs[proxid] }
        end

        proximites = proximites.sort_by do |arrprox|
          sorted_arrprox = arrprox.sort_by do |iprox|
            iprox.mot_avant.offset
          end
          sorted_arrprox.first.mot_avant.offset
        end

        # puts "--- proximites (APRÈS CLASSEMENTS) : #{proximites.inspect}"
      end
      # /Seulement si une liste de listes a été envoyé en argument



      # Pour procéder efficacement :
      # On passe en revue toutes les proximités (non écartées ou corrigées),
      # et on ajoute à la donnée segment de leurs deux mots une couleur.
      #
      # Note : on regarde l'offset du mot après pour savoir si un indice de
      # couleur peut à nouveau être utilisé
      #
      # TODO Améliorer la colorisation qui pour le moment ne se fait pas
      # dans l'ordre des mots dans le texte mais par canon (tous les France,
      # tous les "Prénoms" etc.)
      # Il faudrait donc faire deux choses :
      #   - garder la même couleur pour les mêmes mots (mot canon)
      #   - procéder par offset
      # Question : est-ce qu'en fonctionnant comme ça, par canon, ça ne
      # fera pas fonctionner aussi par offset, entendu que les canons doivent
      # être mémorisés dans l'ordre du texte.
      #
      proximites.each do |proxorarr|
        # On prend la couleur suivante.
        nextc = color_cycle.next

        # +iprox+ peut être
        #   - un identifiant de proximité
        #   - une instance proximité
        #   - une liste de proximités qui doivent avoir la même couleur
        #
        case proxorarr
        when Proximite
          [proxorarr]
        when Fixnum
          [table_proxs[proxorarr]]
        when Array
          proxorarr
        end.each do |iprox|
          iprox.is_a?(Proximite) || iprox = table_proxs[iprox]
          iprox.erased? || iprox.ignored? || iprox.fixed? && next

          mavant = iprox.mot_avant
          mapres = iprox.mot_apres

          # puts "- Colorisation de proximité entre #{mavant.real} [#{mavant.offset}] et #{mapres.real}"

          # :has_color va être mis à 2 si le mot a deux couleurs
          mhascolor = segments[mavant.index][:has_color] == 1 ? 2 : 1
          segments[mavant.index].merge!(next_color: nextc, has_color: mhascolor)
          phascolor = segments[mapres.index][:has_color] == 1 ? 2 : 1
          segments[mapres.index].merge!(prev_color: nextc, has_color: phascolor)

        end
        # /fin de boucle sur chaque proximité
      end
      # /fin de boucle sur chaque liste de proximités
    end
    # /define_word_colors_in_segments

end #/Segments
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
