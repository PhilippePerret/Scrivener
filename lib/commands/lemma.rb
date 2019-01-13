# encoding: UTF-8
=begin

  Commande/module permettant d'afficher la proximité des mots.


=end
class Scrivener

  if help?

    require_texte('commands.lemma.help')
    help(AideGeneraleCommandeLemma::MANUEL)

  else

    require_module('lemmatisation')
    Proximite.exec_lemmatisation

  end

end #/Scrivener
