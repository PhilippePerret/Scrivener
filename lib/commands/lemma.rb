# encoding: UTF-8
class Scrivener

  if help?

    require_texte('commands.lemma.help')
    help(AideGeneraleCommandeLemma::MANUEL)

  else

    require_module('lemmatisation')
    Proximite.exec_lemmatisation

  end

end #/Scrivener
