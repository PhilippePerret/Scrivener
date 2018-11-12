# encoding: UTF-8
=begin

  Commande/module permettant de calculer la pagination du roman actuellement
  édité en fonction des objectifs définis.

  TODO
    * pouvoir fournir l'option -N qui va dire de ne pas afficher les nombres
    * pouvoir donner le coefficient de premier jet (fdc — first-draft-coeff)
      qui va permettre de ramener les nombres au projet final. Cette valeur
      doit être le coefficient employé, 1.5 par défaut
      pagination mon/projet.scriv -fdc=1.5
      Produire une nouvelle colonne avec les valeurs.

=end
if CLI.options[:help]
  aide = <<-EOT
#{' Aide à la commande `pagination` '.underlined.gras}

Usage :    #{'scriv pagination[ vers/mon/projet.scriv][ <options>]'.jaune}

#{'Description'.underlined}

    Permet de calculer la pagination du projet en s'appuyant sur les
    objectifs définis pour chaque fichier du manuscrit à compiler.
    Produit une table des matières qui s'affiche dans le terminal.

    Si on se trouve dans le dossier contenant le projet Scrivener,
    on n'a pas besoin de préciser son path (sauf s'il y a plusieurs
    projets Scrivener).

#{'Options'.underlined}

    -N    Par défaut, le nombre de caractères, de mots et de pages est
          indiqué au bout de chaque titre de fichier dans la table des
          matière produite. Avec cette option, ces nombres ne sont pas
          indiqués

          Exemple : #{'scriv pagination mon_projet.scriv -N'.jaune}

    -fdc/--final-draft-coefficient=<nombre>

          Indique à la commande que les objectifs définis sont des
          objectifs de premier jet (c'est-à-dire des nombres supé-
          rieurs aux nombres finaux).
          On peut indiquer à la place de <nombre> le coefficient uti-
          lisé. Par défaut, c'est 1.5.
          Noter qu’il faut mettre un point pour la virgule.

          Si ce coefficient est fourni, la pagination définitive sera
          ajoutée à la table des matières produite.

          Exemple : #{'scriv pagination mon_projet.scriv -fdc=1.2'.jaune}
  EOT

  Scrivener::help(aide)
  exit 0
end

class Scrivener
  class Project

    NOMBRE_SIGNES_PER_PAGE  = 1750
    TITLE_IDENTATION        = '  '

    # Pour que l'affichage de la table des matières avec pagination soit
    # optimisée.
    attr_accessor :title_max_length

    def options
      @options ||= {
        # with_nombres. Si true, on affiche au bout du titre (avant les points)
        # les nombres de caractères, de mots et de pages correspondants à
        # l'objectif.
        with_nombres: true
      }
    end

    # = main =
    #
    # Méthode principale qui calcule et affiche la pagination du projet
    def display_pagination
      # On crée une table pour faire apparaitre la pagination
      @pdata = {
        tdm:                    ["MANUSCRIT"],
        current_nombre_signes:  0,
        tabulation:             '  '
      }

      # Dans un premier temps, on recherche le titre+indentation le plus
      # long pour maximiser l'affichage
      calcule_title_max_length

      # On peut maintenant construire chaque ligne de la table des matières
      build_table_of_content

      # Et pour le moment, on l'affichage comme ça
      puts @pdata[:tdm].join(RET)
    end
    #/display_pagination

    # Calcule le titre le plus long, en les formatant
    def calcule_title_max_length
      @title_max_length = 0
      table_objectifs[:elements].each do |item|
        bitem = item[:binder_item]
        bitem.build_formated_title(indentation = 1)
      end
      @title_max_length >= 42 || @title_max_length = 42
    end
    #/calcule_title_max_length

    def build_table_of_content
      current_nombre_signes = 0
      table_objectifs[:elements].each do |item|
        bitem = item[:binder_item]
        bitem.add_ligne_pagination(@pdata)
      end
    end
    #/build_table_of_content

    def table_objectifs
      @table_objectifs ||= begin
        # On fait un tableau qui contiendra tous les éléments du dossier manuscrit,
        # avec leur objectifs respectifs, on fouillant dans les dossiers et sous-
        # dossiers.
        tableau = {elements: Array.new, objectif: 0}
        # self.xfile.draftfolder.elements.each('Children/BinderItem') do |data_item|
        self.binder_items do |bitem|
          bitem = treate_binder_item(bitem, tableau)
          tableau[:objectif] += bitem.objectif.to_i
        end
        # On peut définir le nombre maximum de pages (qui permettra de mettre
        # en forme en ne laissant pas trop de place entre les nombres)
        last_page = (tableau[:objectif] / NOMBRE_SIGNES_PER_PAGE) + 1
        tableau.merge!({
          last_page:          last_page,
          page_number_width:  last_page.to_s.length
        })
        tableau
      end
    end
    #/table_objectifs

    # Largeur maximale que prend le numéro de page en fonction du nombre
    # total de pages dans le projet actuel
    def page_number_width
      @page_number_width ||= table_objectifs[:page_number_width]
    end

    # Méthode de traitement d'un binderitem
    # Retourne l'instance {Scrivener::Project::BinderItem} de l'item du
    # classeur
    def treate_binder_item bitem, tableau
      bitem.treate_objectif(tableau)
      return bitem
    end

  end #/Project
end #/Scrivener

class Scrivener
  class Project
    class BinderItem
      # Main méthode qui traite le noeud
      #
      # Pour le moment, on ne prend que les éléments sans enfants
      def treate_objectif(tableau)
        self.compiled? || (return tableau)
        data = {
          binder_item:  self,
          title:        title,
          objectif:     objectif,
          elements:     Array.new
        }
        # On met l'élément dans le tableau
        tableau[:elements] << data
        if parent?
          # <= Il a des enfants
          # => On doit traiter ses enfants
          nombre = 0
          children.each do |child|
            child.treate_objectif(tableau[:elements].last)
            child.objectif && nombre += child.objectif
          end
          @objectif ||= nombre
          tableau[:elements].last[:objectif] = self.objectif
        else
          tableau[:elements].last.delete(:elements)
        end
      end
      #/treate_objectif

      # Construit le titre formaté, en fonction de l'identantion, en
      # définit la longueur max pour un titre si ce titre est le plus
      # long actuellement
      def build_formated_title identation = 1
        mots_et_signes = if project.options[:with_nombres]
          target.mots ? (' [%i c. ≃ %i m. ≃ %s p.]' % [target.signes, target.mots, target.pages]) : ''
        else '' end
        @formated_title = '%s%s%s ' % [(TITLE_IDENTATION * identation), title, mots_et_signes]
        if formated_title.length > project.title_max_length
          project.title_max_length = formated_title.length
        end
        if parent?
          children.each do |child|
            child.build_formated_title(identation + 1)
          end
        end
      end
      # Le titre formaté, c'est-à-dire avec l'identation (mais pas les
      # points qui vont rejoindre le numéro)
      def formated_title ; @formated_title end

      # Ajoute à +ligne+ la ligne de mise en forme de l'élément, en traitant
      # aussi ses parents.
      #
      def add_ligne_pagination(pdata, identation = 1)
        nombre_signes_init  = 0 + pdata[:current_nombre_signes]
        nombre_signes_after = nombre_signes_init + objectif.to_i
        pagination      = (nombre_signes_init.to_f / NOMBRE_SIGNES_PER_PAGE).floor + 1
        str_indent      = '  ' * identation
        substr_indent   = '  ' * (identation - 1)
        title_length    = 60 - str_indent.length
        formated_title_line = "#{formated_title} ".ljust(project.title_max_length + 5, '.')
        formated_page   = substr_indent + pagination.to_s.rjust(project.page_number_width + 1)
        pdata[:tdm] << '%s%s' % [formated_title_line, formated_page]
        parent? && begin
          children.each do |sitem|
            sitem.add_ligne_pagination(pdata, identation + 1)
          end
        end
        pdata[:current_nombre_signes] = nombre_signes_after
      end


    end #/BinderItem
  end #/Project
end #/Scrivener


project.display_pagination
