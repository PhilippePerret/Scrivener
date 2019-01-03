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
    if CLI.options[:update] || CLI.options[:force] || !File.exist?(all_resultats_path) || parametres_changeants?
      CLI::Screen.clear
      CLI::Screen.write_slowly('---> Actualisation du fichier résultat. Merci de patienter…')
      ecrit_date_analyse
      table_nombres
      # = Proxmités =
      proximites(sorted_by: :distance)
      proximites(sorted_by: :alpha)
      # = Canons =
      canons(sorted_by: :alpha)
      canons(sorted_by: :prox_count)
      canons(sorted_by: :mots_count)
      # = Mots =
      mots(sorted_by: :count)
      mots(sorted_by: :alpha)

      message_footer
      stdoutput.close
    end

    case options[:output_format]
    when :text
      File.open(all_resultats_path,'rb').each do |line|
        puts line
      end
    else
      raise 'Je ne sais pas encore faire ça.'
    end
    CLI.debug_exit
  end

  # Retourne true si un paramètre doit provoquer l'actualisation de la sortie
  # Par exemple le nombre de mots affichés
  def parametres_changeants?
    return !CLI.params[:mots].nil?
  end
  # parametres_changeant?

  # La sortie vers laquelle on dirige le code construit
  def stdoutput
    @stdoutput ||= prepare_fichier_resultats
  end

  # Méthode qui prépare le fichier de resultat en fonction du format
  def prepare_fichier_resultats
    set_filepath_current_format(options[:output_format])
    File.unlink(all_resultats_path) if File.exist?(all_resultats_path)
    File.open(all_resultats_path,'ab')
  end

  def message_footer
    ecrit String::RC * 3 + '(pour actualiser l’affichage, ajouter l’option -u/--update)' + String::RC
  end

end #/Output
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
