# encoding: UTF-8
#
# Extension classe Fixnum
# Version: 2.0.3
#
# Note version 2.0.3
#   Possibilité d'envoyer des options à `as_human_date` notamment pour
#   préciser le délimiteur de temps ("à" ou "-")
# Note version 2.0.2
#   Ajout de la méthode `pct` pour retourner vraiment le pourcentage
#   d'un nombre par rapport à un total donné en argument.
# Note version 2.0.1
#   Ajout de l'argument with_time pour as_human_date, pour pouvoir
#   ajouter l'heure.
# Note version 2.0.0
#   Méthode `to_expo` pour écrire le chiffre en exposant
#   Requiert au moins la version 1.3.1 de String_CLI.rb
#
class Fixnum


  MOIS_LONG = ['','janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'août',
    'septembre', 'octobre', 'novembre', 'décembre']
  MOIS_COURT = ['','jan', 'fév', 'mars', 'avr', 'mai', 'juin', 'juil', 'août',
    'sept', 'oct', 'nov', 'déc']


  # 12.to_expo doit retourner ⁽¹²⁾
  def to_expo
    s = self.to_s.split('').collect{|l| String::CHIFFRE_HAUT[l.to_i]}.join('')
    '⁽%s⁾' % [s]
  end

  def as_human_date mois_long = true, with_time = false, options = nil
    options ||= Hash.new
    options.key?(:del_time) || options.merge!(del_time: '-')
    mois = mois_long ? MOIS_LONG[Time.at(self).month] : MOIS_COURT[Time.at(self).month]
    fmt = "%e #{mois} %Y#{with_time ? (' %s %%H:%%M' % [options[:del_time]]) : ''}"
    Time.at(self).strftime(fmt).strip
  end

  # Retourne la date correspondant au fixnum (quand c'est un timestamp)
  def as_date format = :dd_mm_yyyy
    format_str =
    case format
    when :dd_mm_yyyy  then "%d %m %Y"
    when :dd_mm_yy    then "%d %m %y"
    when :mm_yyyy     then "%m %Y"
    when :mm_yy       then "%m %y"
    when :d_mois_yyyy then return as_human_date
    when :d_mois_court_yyyy then return as_human_date false
    else
      nil
    end
    unless format_str.nil?
      Time.at(self).strftime(format_str)
    end
  end

  # Reçoit un nombre de secondes et retourne un string de la forme "h:mm:ss"
  def as_horloge
    hrs = self / 3600
    rest = self % 3600
    mns = (rest / 60).to_s.rjust(2,'0')
    scs = (rest % 60).to_s.rjust(2,'0')
    "#{hrs}:#{mns}:#{scs}"
  end

  # Formate le nombre en bons milliers
  def mille
    self > 9999 || (return self)
    case
    when self < 10000
      return self.to_s
    when self < 999999
      s = self.to_s.rjust(6,'0')
      return "#{s[0..2].to_i} #{s[3..5]}"
    when self < 999999999
      s = self.to_s.rjust(9,'0')
      return "#{s[0..2].to_i} #{s[3..5]} #{s[6..8]}"
    else
      return self.to_s
    end
  end

  # Retourne la durée en jours et en heure de travail en comptant +hours_per_day+
  # heures de travail par jour.
  def as_workdays hours_a_day = 10
    rest = self
    jrs  = rest / (hours_a_day * 3600)
    rest = rest - (jrs * hours_a_day * 3600)
    hrs  = rest / 3600
    jrs_str = jrs > 0 ? "#{jrs} jr#{jrs > 1 ? 's' : ''}" : ''
    "#{jrs_str} #{hrs} hr#{hrs > 1 ? 's' : ''} à raison de #{hours_a_day} hrs/jour".strip
  end

  # Retourne la durée d'après le nombre de secondes
  def as_duree
    secs = self % 60
    rest = self - secs
    str = "#{secs}”"
    rest > 0 || (return str)
    mins = (rest % 3600) / 60
    rest = rest - (mins * 60)
    str = "#{mins} m#{mins > 1 ? 's' : ''} #{str}"
    rest > 0 || (return str)
    hrs  = (rest % (24 * 3600)) / 3600
    rest = rest - (hrs * 3600)
    str = "#{hrs} h#{hrs > 1 ? 's' : ''} #{str}"
    rest > 0 || (return str)
    jrs = rest / (24 * 3600)
    return "#{jrs} j#{jrs > 1 ? 's' : ''} #{str}"
  end

  # Retourne le floatant sous forme de pourcentage ou de pourmillage
  # Note : la méthode existe aussi pour les flottants (plus précise)
  # Rappel : pour obtenir le pourcentage, on fait <nombre>/<nombre total>
  def pourcentage pour_mille = false
    "#{self * 100} #{pour_mille ? '‰' : '%'}"
  end

  # Retourne le pourcentage de self par rapport à +comp+. Par exemple,
  # si self = 4 et que comp = 8, la méthode retournera 50 (50%)
  def pct(comp, rounding = nil)
    (100 * ( self.to_f / comp )).round(rounding||1000)
  end

end #/Fixnum
