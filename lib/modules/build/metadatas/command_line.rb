# encoding: UTF-8
=begin

  Quand on utilise (la ligne de) commande pour définir les données
  de la métadonnée à construire.

=end
module BuildMetadatasModule

  # = main =
  #
  # méthode principale appelée pour construire une métadonnée unique en
  # ligne de commande.
  # Toutes les valeurs doivent être définies par options
  def build_metadatas_from_command
    CLI::Screen.clear
    md_key  = ask_for_md_title
    md_data = Hash.new
    md_data.merge!('Name' => md_key)
    md_data.merge!('Type' => ask_for_md_type)
    case md_data['Type']
    when 'Text'
      md_data.merge!('Align' => ask_for_md_align)
      md_data.merge!('Wraps' => ask_for_md_wraps)
    when 'List'
      md_data.merge!('Options' => ask_for_md_options)
      md_data.merge!('Default' => ask_for_md_default(md_data['Options']))
    when 'Checkbox'
      md_data.merge!('Default' => ask_for_md_checked)
    when 'Date'
      date_type, date_format = ask_for_md_date_type
      md_data.merge!('DateType' => date_type)
      date_format && md_data.merge!('DateFormat' => date_format)
    end

    confirm_data_metadata(md_data) || return
    MetaData.new(self, md_key, md_data).create
    xfile.save
  end

  # ---------------------------------------------------------------------
  #   Méthodes confirmation

  def confirm_data_metadata(mdata)
    CLI::Screen.clear
    CLI::Screen.write_slowly('Confirmation des données')
    puts String::RC + '  ------------------------'
    mdata.each do |k, v|
      puts '    %s : %s' % [k.ljust(20), v]
    end
    puts ''
    CLI::Screen.write_slowly('Créer cette métadonnée ?')
    yesOrNo('')
  end
  # /confirm_data_metadata

  # ---------------------------------------------------------------------
  #   Méthodes de demande

  def ask_for_md_title
    CLI::Screen.clear
    name = nil
    [:name, :nom, :title, :title].each do |prop|
      CLI.options[prop] || next
      name = CLI.options[prop] and break
    end
    CLI::Screen.write_slowly('Nom de la métadonnée (titre)')
    name ||= askFor('')
  end


  TYPES = {'t' => ['[T]exte', 'Text'], 'l' => ['[L]iste', 'List'], 'c' => ['[C]ase à cocher', 'Checkbox'], 'd' => ['[D]ate', 'Date']}
  def ask_for_md_type
    CLI::Screen.clear
    type = CLI.options[:type]
    type || begin
      CLI::Screen.write_slowly('Types métadonnée' + String::RC)
      puts '  ----------------'
      TYPES.values.each do |ty|
        puts '   %s' % ty.first
      end
      puts String::RC
      # expected_keys = %w{t l c d q}
      CLI::Screen.write_slowly('Type de la métadonnée (première lettre)')
      expected_keys = ['t', 'l', 'c', 'd', 'q']
      choix = getc('', {expected_keys: expected_keys})
      # choix = getc('')
      choix != 'q' || raise('Abandon')
      type = TYPES[choix].last
      type || raise('Abandon')
    end
    return type
  end
  # /ask_for_md_type

  def ask_for_md_align
    # CLI::Screen.clear
    align = CLI.options[:align]
    align || begin
      CLI::Screen.write_slowly('Alignement du texte ("d" pour "à droite", "g" pour "à gauche")')
      choix = getc('', expected_keys: ['d', 'g', 'q'])
      choix != 'q' || raise('Abandon')
      align = choix == 'd' ? 'Right' : 'Left'
    end
    return align
  end

  def ask_for_md_wraps
    # CLI::Screen.clear
    wraps = CLI.options[:wraps]
    CLI::Screen.write_slowly('Le texte doit-il être enroulé ?')
    wraps ||= yesOrNo('') ? 'Yes' : 'No'
  end
  # /ask_for_md_wraps

  # Doit renvoyer les items de listes à utiliser
  def ask_for_md_options
    options = CLI.options[:options]
    if options
      options.split(';')
    else
      CLI::Screen.write_slowly('Liste des choix possibles (séparés par des ";")')
      askFor('').split(';').collect{|e|e.strip}
    end
  end

  def ask_for_md_default(liste)
    expected_keys = Array.new
    liste.each_with_index do |item, idx|
      puts '   %i : %s' % [idx + 1, item]
      expected_keys << (idx + 1).to_s
    end
    CLI::Screen.write_slowly('Valeur par défaut (son index)')
    choix = getc('', expected_keys: expected_keys).to_i
    return liste[choix - 1]
  end
  # ask_for_md_default

  # Pour savoir si la case à cocher doit être checkée par défaut
  def ask_for_md_checked
    checked = CLI.options[:checked]
    checked != nil || begin
      CLI::Screen.write_slowly('La case est-elle cochée par défaut ?')
      checked = yesOrNo('')
    end
    return checked ? 'Yes' : 'No'
  end


  def ask_for_md_date_type
    date_type = CLI.options[:date_type]
    date_type || begin
      keys = Array.new
      puts '    0 : format personnalisé (à définir)'
      keys << '0'
      MetaData::DATE_TYPES.values.each.with_index do |ddate, idx|
        idx < 9 || break
        puts '    %i : %s' % [idx + 1, ddate[:ex]]
        keys << (idx + 1).to_s
      end
      CLI::Screen.write_slowly('Format de date')
      choix = getc('', {expected_keys: keys}).to_i
      if choix == 0
        ['Custom', ask_for_md_format_date]
      else
        [MetaData::DATE_TYPES.values[choix - 1][:real], nil]
      end
    end
  end
  # /ask_for_md_date_type

  # On demande le format
  def ask_for_md_format_date
    CLI::Screen.write_slowly('Formate de date (unicode — attention, ne sera pas vérifié)')
    askFor('')
  end
  # /ask_for_md_format_date

end #/module
