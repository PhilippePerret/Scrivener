# encoding: utf-8
#
# ask
# v. 1.3.3
#
# Note version 1.3.3
#     Ajout du mode test pour askFor
#
# Voir aussi le module ask_for_test.rb qui fonctionne en parallèle de celui-ci
#
require 'io/console'

ASK_TABULATION = ' '

ASK_ON_ONE_LINE   = ASK_TABULATION+'%s %s'
ASK_ON_TWO_LINES  = ASK_TABULATION+'%s'+(String::RC*2)+ASK_TABULATION+'%s %s'
def getc message, options = nil
  options ||= Hash.new
  # puts "-- options : #{options.inspect}::#{options.class}"
  expected_keys = options[:expected_keys]
  if options[:invite]
    deux_points = [':','?'].include?(options[:invite].strip[-1]) ? '' : ': '
    print ASK_ON_TWO_LINES % [message, options[:invite], deux_points]
  else
    deux_points = [':','?', '>'].include?(message.strip[-1]) ? '' : ': '
    print ASK_ON_ONE_LINE % [message, deux_points]
  end
  while
    if CLI.mode_interactif?
      touche = get_full_caractere
    else
      touche = CLI.next_key_mode_test
    end
    if expected_keys.nil? || expected_keys.include?(touche)
      puts ''
      return touche
    end
  end
end

TABLE_GETCH = {
  '\e[' => {
    'A' => :up_arrow,
    'B' => :down_arrow,
    'C' => :right_arrow,
    'D' => :left_arrow,
  }
}
def get_full_caractere
  first_is_033      = false
  second_is_crochet = false
  while
    str = STDIN.getch
    # puts "str: #{str.inspect}"
    # Si c'est \e, c'est un caractère spécial
    if str == "\e"
      first_is_033 = true
      # Note : de cette manière là, on ne pourra jamais capter l'escape
      # seul qui s'arrêtera toujours ici.
    elsif str == "[" && first_is_033
        # Alors on doit attendre le suivant
        second_is_crochet = true
    elsif first_is_033 && second_is_crochet
      return TABLE_GETCH['\e['][str] || str
    else
      # Dans tous les autres cas, on retourne le caractère
      return str
    end
  end
end

# Pose la +question+ est retourne TRUE si la réponse est oui (dans tous les
# formats possible) ou FALSE dans le cas contraire.
#
# Attention, en mode test, ces méthodes sont surclassées par les méthodes
# de test
#
def yesOrNo question, options = nil
  options ||= Hash.new
  options.merge!(expected_keys: ['y','o','n'])
  if options.key?(:invite)
    options[:invite] = INDENT + options[:invite] + ' (y/o = oui / n = non)'
  else
    question += ' (y/o = oui / n = non)'
  end
  puts String::RC * 2
  r = getc(INDENT+question, options)
  return r.upcase != 'N'
end

# Pose la +question+ qui attend forcément une valeur non nulle et raise
# l'exception +msg_error+ dans le cas contraire.
def askForOrRaise(question, msg_error = 'Cette donnée est obligatoire')
  print "#{question} : "
  r = STDIN.gets.strip
  r != '' || raise(msg_error)
  return r
end

# Pose la +question+ et retourne la réponse, même vide.
def askFor(question, default = nil)

  # Mode test
  unless CLI.mode_interactif?
    return CLI.next_key_mode_test
  end

  expected_keys = nil
  if default.is_a?(Hash)
    defo = default.delete(:default)
    expected_keys = default.delete(:expected_keys)
    default = defo
  end
  default && question << " (défaut : #{default}) "

  begin
    print "#{question} : "
    retour = STDIN.gets.strip
    retour == '' && retour = default
    if expected_keys && !expected_keys.include?(retour)
      puts 'La valeur %s n’est pas correcte.'.rouge % [retour.inspect]
    else
      break
    end
  end while true
  return retour
end
# /askFor



# @param {Hash} params
#               :default    Valeur par défaut à mettre dans le fichier
#               Si c'est un string, c'est le message à afficher avant
def askForText params = Hash.new
  case params
  when String then params = {message: params}
  end

  params[:message] && (puts params[:message])
  q = 'Êtes-vous prêt ?'
  q << (params[:required] ? ' (donnée requise)' : " (choisissez `n` ou `Entrée` pour passer cette propriété)")
  if yesOrNo(q)
    fp = './.te.txt'
    File.unlink(fp) if File.exist?(fp)
    File.open(fp,'wb'){|f| f.write "#{params[:default]}\n"}
    `mate "#{File.expand_path(fp)}"`
    if yesOrNo 'Puis-je prendre le contenu du fichier ?'
      begin
        yesOrNo('Le fichier est-il bien enregistré et fermé ?') || raise
      rescue
        retry
      end
      contenu = File.read(fp).force_encoding('utf-8').nil_if_empty
      contenu.nil? && params[:required] && raise('Cette donnée est obligatoire. Je dois m’arrêter là.')
      #File.exist?(fp) && File.unlink(fp)
      puts "CONTENU :\n#{contenu}"
      return contenu
    end#/Si ruby peut prendre le code de la signature
  end#/En attendant que l'utilisateur soit prêt
  params[:required] &&  raise('Cette donnée est obligatoire. Je dois m’arrêter là.')
  return nil
end
