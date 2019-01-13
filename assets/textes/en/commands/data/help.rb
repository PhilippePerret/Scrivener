# encoding: UTF-8
module AideCommandGeneralData
MANUEL = <<-EOT
#{'`scriv data` COMMAND HELP'.gras}
=========================

  Description
  -----------

      With the #{'`scriv data`'.jaune} command, you can get
      all data from the current Scrivener project. For ins-
      tance, it can display all the words occurences.

   Alias
  -------

    #{'`scriv stats[ <options>]`'.jaune} can be used as an
    alias.

Limit words count
-----------------

  One can limit displayed words count with `words` parameter
  provided with the expected count of words (or "all" for all
  of the words). For instance :

    #{'`scriv data words=20`'.jaune}
    # => Display only 20 words

EOT
end #/module
