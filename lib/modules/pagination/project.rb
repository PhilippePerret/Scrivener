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

  # = main =
  #
  # Méthode principale qui calcule et affiche la pagination du projet. C'est
  # la méthode appelée par la commande `scriv pagination`
  #
  def exec_pagination
    # On crée une table pour faire apparaitre la pagination
    tdm.output = CLI.options[:output] || :console
    # On peut maintenant construire chaque ligne de la table des matières
    tdm.build_table_of_content
    tdm.output_table_of_content
  end
  #/exec_pagination


end #/Project
end #/Scrivener
