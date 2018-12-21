#!/usr/bin/env ruby
# encoding: UTF-8
#
# CLI : Helpers
#
# CLI.separator
#
class CLI
class << self

  # Un séparateur qui couvre toute la console actuelle
  # +options+
  #     :return     Si false, pas de retour chariot à la fin
  #     :char       Si défini, le caractère à utiliser pour la séparation
  #                 Par défaut : un tiret
  #     :tab        Si défini, ce qu'il faut mettre avant le caractère
  def separator options = nil
    options ||= Hash.new
    char = options[:char] || '-'
    sep = "#{options[:tab]}#{char}".ljust(`tput cols`.to_i - 4, char) + String::RC
    options[:return] === false && sep = sep.rstrip
    return sep
  end

  # La vraie valeur de l'option, qui est exprimée forcément en
  # string.
  # Noter que nil retourne true
  def real_val_of val
    case val
    when 'false'        then false
    when 'true'         then true
    when 'null', 'nil'  then nil
    when /^[0-9]+$/       then val.to_i
    when /^[0-9\.]+$/     then val.to_f
    when nil            then true
    else
      val
    end
  end

end #/<< self
end #/CLI
