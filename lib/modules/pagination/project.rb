# encoding: UTF-8
=begin

  Commande/module permettant de calculer la pagination du roman actuellement
  édité en fonction des objectifs définis.

  TODO
    * pouvoir donner le coefficient de premier jet (fdc — first-draft-coeff)
      qui va permettre de ramener les nombres au projet final. Cette valeur
      doit être le coefficient employé, 1.5 par défaut
      pagination mon/projet.scriv -fdc=1.5
      Produire une nouvelle colonne avec les valeurs.

=end
class Scrivener
class Project

  # = main =
  #
  # Méthode principale qui calcule et affiche la pagination du projet. C'est
  # la méthode appelée par la commande `scriv pagination`
  #
  def exec_pagination
    # On crée une table pour faire apparaitre la pagination
    tdm.output = CLI.options[:output] || :console
    # Si l'option --input a été spécifiée, c'est une utilisation spéciale
    # de la commande qui permet de définir les objectifs des fichiers d'après
    # un fichier de données fournies
    if CLI.options[:input]
      get_objectifs_and_fichiers_from_file || return
    else
      Scrivener.require_module('output_by_type/%s/pagination' % [tdm.output])
      extend ModuleFormatageTdm
      # On peut maintenant construire chaque ligne de la table des matières
      tdm.build_table_of_content
      tdm.output_table_of_content
      if CLI.options[:open] && tdm.respond_to?(:open)
        tdm.open
      elsif tdm.tdm_file_path
        wt('build.notices.tdm_build', {filename: File.basename(tdm.tdm_file_path)}, {color: :bleu})
      else
        wt('helps.tdm.may_be_in_file', nil, {air: true})
      end
    end
  end
  #/exec_pagination


end #/Project
end #/Scrivener
