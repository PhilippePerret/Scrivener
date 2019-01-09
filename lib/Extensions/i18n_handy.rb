# frozen_string_literal: true
# encoding: UTF-8
=begin
  Méthodes raccourcies pratiques
=end

# Raccourci pour 'write I18n translate'
# Permet d'écrire un message localisé à l'écran
# +options+
#   :air      Si true, on ajoute de l'air autour du message
def wt pth, template_values = nil, options = nil
  options ||= Hash.new
  msg = t(pth, template_values)
  options[:color] && msg = msg.send(options[:color])
  options[:air] && msg = String::RC * 2 + INDENT + msg + String::RC * 3
  puts INDENT + msg
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
    translate_with_i18n_and_eval(pth, template_values)
  end
end

def translate_with_i18n_and_eval(pth, template_values = nil)
  str = String.new(I18n.translate(pth))
  str.match(/#\{/) && str = eval("%Q{#{str}}")
  str.match(/\%\{/) && str = str % template_values
  return str
end
