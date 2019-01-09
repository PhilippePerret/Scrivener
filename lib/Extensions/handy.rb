# frozen_string_literal: true
# encoding: UTF-8
=begin
  Méthodes raccourcies pratiques
=end

# Raccourci pour 'write I18n translate'
# Permet d'écrire un message localisé à l'écran
def wt pth, template_values = nil
  puts INDENT + t(pth, template_values)
end

# Pour obtenir une traduction facilement avec la méthode `t`
# On peut envoyer une des paths séparées par des espaces, chaque
# path déduite sera évaluée et réunis par des espaces à nouveau.
# @usage:
#
#   t('ma.locale.test') # => 'Ceci est un test'
#   t('ma.la chose.table') => 'la table'
#
# On peut aussi transmettre des templates :
#
#   t('ma.la chose.table %s', ['est rouge'])
#   => "La table est rouge"
#
def t pth, template_values = nil
  if pth.match(/ /)
    pth.split(' ').collect do |e|
      if e.start_with?('%')
        e
      else
        translate_with_i18n_and_eval(e)
      end
    end.join(' ') % (template_values || [])
  else
    translate_with_i18n_and_eval(pth)
  end
end

def translate_with_i18n_and_eval(pth)
  str = I18n.translate(pth)
  str.match(/#\{/) ? eval("%Q{#{str}}") : str
end
