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
      tdm:                        ["  #{self.title}"],
      cur_objectif_signs_count:   0,
      cur_docs_signs_count:       SWP.new(0), # ajouté pour pagination d'après texte
      tabulation:                 '  '
    }

    # Dans un premier temps, on recherche le titre+indentation le plus
    # long pour maximiser l'affichage
    calcule_title_max_length

    # On peut maintenant construire chaque ligne de la table des matières
    build_table_of_content

    # Et pour le moment, on l'affichage comme ça
    puts  String::RC * 3 +
          @pdata[:tdm].join(RET) +
          String::RC * 3
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
    cur_objectif_signs_count = 0
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
      all_binder_items_of(:draft_folder).each do |bitem|
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
