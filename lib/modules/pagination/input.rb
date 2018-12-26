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


  def get_objectifs_and_fichiers_from_file
    input_file_exist_or_raise
    labels = File.new(file_path).each.first.downcase.split(';')
    index_target  = labels.index('objectif') || labels.index('target')
    index_target || raise(ERRORS_MSGS[:label_objectif_required])
    index_titre   = labels.index('titre') || labels.index('title')
    index_titre  || raise(ERRORS_MSGS[:label_titre_required])
    File.new(file_path).each_with_index do |line, index_line|
      index_line > 0 || next
      dline = line.split(';')
      titre   = dline[index_titre].strip
      titre.start_with?('> ') && titre = titre[2..-1].strip
      target  = SWP.signs_from_human_value(dline[index_target])
      puts "-- Mise du titre «#{titre}» à l'objectif #{target.inspect}"
    end

    return false # pour s'arrêter là pour le moment
  end

  def input_file
    @input_file ||= CSVFile.new(input_file_path)
  end

  def input_file_exist_or_raise
    input_file.exist? || raise(ERRORS_MSGS[:imported_file_unfound] % input_file_path)
  end

  def input_file_path
    @input_file_path ||= begin
      if CLI.options[:input] === true
        CLI.options[:input] = 'tdm.csv' # Nom par défaut
      end
      File.join(self.folder, CLI.options[:input])
    end
  end

  class CSVFile
    attr_accessor :path
    def initialize path, options = nil
      self.path = path
    end
    def exist?
      File.exist?(path)
    end
    def labels
      @labels ||= begin
        IO.readlines(path,1)[0].split(separator)
      end
    end
    def separator
      @separator ||= ';'
    end
  end

end #/Project
end #/Scrivener