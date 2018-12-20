# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class TableResultats
class Output

  attr_accessor :all_resultats_path

  def set_filepath_current_format fmt
    self.all_resultats_path = File.join(analyse.hidden_folder, 'all_resultats.%s' % fmt.to_s)
  end
  # = main =
  # Méthode principale qui sort tous les nombres et tous les listings
  def all opts = nil
    CLI.debug_entry
    defaultize_options(opts)
    set_filepath_current_format(options[:output_format])
    if CLI.options[:update] || !File.exist?(all_resultats_path)
      puts "J'actualise le fichier résultat. Merci de patienter…"
      sleep 1
      prepare_fichier_resultats
      table_nombres
      # = Proxmités =
      proximites(sorted_by: :distance, limit: 50)
      proximites(sorted_by: :alpha, limit: 50)
      # = Canons =
      canons(sorted_by: :alpha, limit: 50)
      canons(sorted_by: :prox_count, limit: 50)
      canons(sorted_by: :mots_count, limit: 50)
      # = Mots =
      mots(sorted_by: :alpha, limit: 100)
      # mots(sorted_by: :prox_count, limit: 50) # NON : c'est le canon
      mots(sorted_by: :count, limit: 100)
      message_footer
      stdoutput.close
    end

    case options[:output_format]
    when :text
      puts File.read(all_resultats_path)
      # File.open(all_resultats_path,'rb').each do |line|
      #   puts line
      # end
    else
      raise 'Je ne sais pas encore faire ça.'
    end
    CLI.debug_exit
  end

  # Méthode qui prépare le fichier de resultat en fonction du format
  def prepare_fichier_resultats
    File.unlink(all_resultats_path) if File.exist?(all_resultats_path)
    @stdoutput = File.open(all_resultats_path,'ab')
  end

  # La sortie vers laquelle on dirige le code construit
  def stdoutput
    @stdoutput
  end

  def message_footer
    ecrit String::RC * 3 + '(pour actualiser l’affichage, ajouter l’option -u/--update)' + String::RC
  end

end #/Output
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
