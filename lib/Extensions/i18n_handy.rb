# frozen_string_literal: true
# encoding: UTF-8
=begin
  Méthodes raccourcies pratiques pour l'utilisation des locales

Version 0.1.4

# Version 0.1.4
#   C'est `t` qui traite toutes les options possibles. Et ajout du
#   soulignement avec :underlined.
# 
# Version 0.1.3
#   Possibilité de mettre n'importe quel délimiteur entre plusieurs
#   path envoyées par t('path1<del>path2<del>path3')
#
=end
require 'i18n'

# Raccourci pour 'write I18n translate'
# Permet d'écrire un message localisé à l'écran
# +options+
#   :air          Si true, on ajoute de l'air autour du message
#   :indent       Si false, on ne met pas d'indentation (true par défaut)
#   :underlined   Si défini, c'est le soulignement à ajouter. La valeur peut
#                 être true ou le caractère à utiliser pour le soulignement.
def wt pth, template_values = nil, options = nil
  puts t(pth, template_values, options)
end

# Raccourci pour 'raise I18n translation'
#
def rt pth, template_values = nil, errClass = nil
  options ||= Hash.new
  msg = t(pth, template_values)
  errClass ||= StandardError
  raise errClass, msg
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
# +options+
#   :delimitor    Le délimiteur de mots lorsque plusieur path de locales
#                 sont transmises. Par défaut, c'est l'espace.
#
def t pth, template_values = nil, options = nil
  options ||= Hash.new
  options[:delimitor] || options.merge!(delimitor: ' ')
  msg = if pth.match(/#{Regexp.escape(options[:delimitor])}/)
          pth.split(options[:delimitor]).collect do |e|
            if e.start_with?('%')
              e
            else
              translate_with_i18n_and_eval(e)
            end
          end.join(options[:delimitor]) % (template_values || [])
        else
          translate_with_i18n_and_eval(pth, template_values)
        end
  #
  options[:underlined] && begin
    options[:underlined].is_a?(String) || options[:underlined] = '-'
    msg += String::RC + (options[:underlined] * msg.length)
  end
  options[:indent] === false || begin
    msg = msg.prepend(INDENT).gsub(/(\r?\n)/,  '\1' + INDENT)
  end
  options[:color] && msg = msg.send(options[:color])
  options[:air] && msg = String::RC * 2 + msg + String::RC * 3
  return msg
end

def translate_with_i18n_and_eval(pth, template_values = nil)
  str = String.new(I18n.translate(pth))
  str.match(/#\{/) && str = eval("%Q{#{str}}")
  str.match(/\%\{/) && str = str % template_values
  return str
end
