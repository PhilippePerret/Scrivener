# encoding: UTF-8
=begin

=end
class Scrivener
  ERRORS_MSGS.merge!({
    imported_file_unfound:    'Impossible de trouver le fichier à importer « %s ».',
    label_objectif_required:  'Le label (colonne) "Objectif" (ou "Target") doit être défini dans le fichier pour pouvoir être importé.',
    label_titre_required:     'Le label (colonne) "Titre" (ou "Title") est requis dans le fichier à importer.'
    })
class Project

  # Return true
  def get_objectifs_and_fichiers_from_file
    input_file_exist_or_raise
    labels_are_ok_or_raise
    liste_modifications = get_targets_to_modify
    if confirme_modifications(liste_modifications)
      proceed_target_modifications(liste_modifications)
    else
      puts 'Abandon des modifications.'.rouge
    end
  end

  # Pour procéder aux modifications d'objectif
  # +arr+ Liste Array d'élément paire contenant le binder-item et
  # la nouvelle cible à lui appliquer.
  def proceed_target_modifications arr
    arr.each do |bitem, new_target|
      bitem.target.define new_target
    end
    self.xfile.save
  end

  # Pour confirmer les modifications à opérer
  def confirme_modifications arr
    puts String::RC * 3
    puts "Merci de confirmer la liste des modifications suivantes :".bleu
    puts "Assurez-vous que le projet soit bien fermé dans Scrivener.".rouge
    puts ''
    arr.each do |bitem, target|
      s = SWP.new(target)
      s = '%s signes (%s mots, %s pages)' % [" #{s.signs}".rjust(7,'.'), s.mots, s.pages_real_round]
      puts '  Document %s%s' % [bitem.title[0..50].inspect.ljust(50,'.'), s]
    end
    return yesOrNo('Procéder à ces changements (%s)' % ['le projet doit être fermé'.rouge])
  end

  def get_targets_to_modify
    arr = Array.new # liste des binder-item/target à modifier
    input_file.each_row do |row|
      titre  = row.to_a[index_label_title].value
      target = row.to_a[index_label_target].value.strip
      target = nil if target.empty? || target == '-' || target == '0'
      catch :no_traitement do
        if titre.start_with?('> ')
          titre = titre[2..-1].strip
          CLI.dbg('DOSSIER=>NON TRAITÉ : je ne traite pas «%s»' % [titre])
          throw(:no_traitement)
        elsif target.nil?
          CLI.dbg('NON DEFINED TARGET: pas d’objectif défini pour «%s»' % [titre])
          throw(:no_traitement)
        end
        bitem = self.binder_item_by_title(titre) || begin
          CLI.dbg('UNFOUND BINDER-ITEM: «%s»' % [titre])
          throw :no_traitement
        end

        # La nouvelle cible à appliquer (si différente)
        new_target  = SWP.signs_from_human_value(target)

        if bitem.target.signs == new_target
          CLI.dbg('TARGET NOT MODIFIED: cible de «%s» (%s)' % [titre, bitem.target])
          throw :no_traitement
        end

        # Quand on arrive ici, c'est que l'objectif du document peut être
        # modifié.
        CLI.dbg "*** (#{input_file.linenum}: Mise du titre « #{titre} » à l'objectif #{new_target.inspect}"
        arr << [bitem, new_target]
        # target.define
      end
    end
    return arr
  end
  # /get_targets_to_modify



  def input_file
    @input_file ||= CSVFile.new(input_file_path, {no_labels: false})
  end

  # Vérifie que le fichier CSV existe ou produit une erreur
  def input_file_exist_or_raise
    input_file.exist? || raise(ERRORS_MSGS[:imported_file_unfound] % input_file_path)
  end

  def labels_are_ok_or_raise
    index_label_target || raise(ERRORS_MSGS[:label_objectif_required])
    index_label_title  || raise(ERRORS_MSGS[:label_titre_required])
  end

  # Index du label définissant l'objectif dans le fichier CSV
  # Note : il doit porter le titre 'objectif' ou 'target'
  def index_label_target
    @index_label_target ||= input_file_labels.index('objectif') || input_file_labels.index('target')
  end
  def index_label_title
    @index_label_title ||= input_file_labels.index('titre') || input_file_labels.index('title')
  end

  def input_file_labels
    @input_file_labels ||= input_file.labels.collect{|lab|lab.downcase}
  end

  def input_file_path
    @input_file_path ||= begin
      if CLI.options[:input] === true
        CLI.options[:input] = 'tdm.csv' # Nom par défaut
      end
      File.join(self.folder, CLI.options[:input])
    end
  end

end #/Project
end #/Scrivener
