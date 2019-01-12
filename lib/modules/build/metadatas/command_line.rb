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
    puts String::RC
    wt('metadata.create.success', {name: md_data['Name']}, {color: :bleu})
  end

  # ---------------------------------------------------------------------
  #   Méthodes confirmation

  def confirm_data_metadata(mdata)
    CLI::Screen.clear
    CLI::Screen.write_slowly(t('metadata.create.confirm_data'), {underlined: '-'})
    mdata.each do |k, v|
      puts '    %s : %s' % [k.ljust(20), v]
    end
    puts ''
    CLI::Screen.write_slowly(t('metadata.create.questions.confirm'), {newline: false})
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
    name ||= begin
      CLI::Screen.write_slowly(t('metadata.create.questions.title'), {newline: false})
      askFor('')
    end
  end


  TYPES = {'t' => ['[T]exte', 'Text'], 'l' => ['[L]iste', 'List'], 'c' => ['[C]ase à cocher', 'Checkbox'], 'd' => ['[D]ate', 'Date']}
  def ask_for_md_type
    CLI::Screen.clear
    type = CLI.options[:type]
    type || begin
      CLI::Screen.write_slowly(t('metadata.titles.types'), {underlined: '-'})
      TYPES.values.each do |ty|
        puts DBLINDENT + ty.first
      end
      puts String::RC
      # expected_keys = %w{t l c d q}
      CLI::Screen.write_slowly(t('metadata.create.questions.type'), {newline: false})
      expected_keys = ['t', 'l', 'c', 'd', 'q']
      choix = getc('', {expected_keys: expected_keys})
      # choix = getc('')
      choix != 'q' || rt('notices.abort_')
      type = TYPES[choix].last
      type || rt('notices.abort_')
    end
    return type
  end
  # /ask_for_md_type

  def ask_for_md_align
    # CLI::Screen.clear
    align = CLI.options[:align]
    align || begin
      CLI::Screen.write_slowly(t('metadata.create.questions.align'), {newline: false})
      choix = getc('', expected_keys: ['r', 'd', 'l', 'g', 'q'])
      choix != 'q' || rt('notices.abort_')
      return ['d', 'r'].include?(choix) ? 'Right' : 'Left'
    end
    return align
  end

  def ask_for_md_wraps
    # CLI::Screen.clear
    wraps = CLI.options[:wraps]
    CLI::Screen.write_slowly(t('metadata.create.questions.wrap'), {newline: false})
    wraps ||= yesOrNo('') ? 'Yes' : 'No'
  end
  # /ask_for_md_wraps

  # Doit renvoyer les items de listes à utiliser
  def ask_for_md_options
    options = CLI.options[:options]
    if options
      options.split(';')
    else
      CLI::Screen.write_slowly(t('metadata.create.questions.choices'))
      askFor('').split(';').collect{|e|e.strip}
    end
  end

  def ask_for_md_default(liste)
    expected_keys = Array.new
    liste.each_with_index do |item, idx|
      puts '   %i : %s' % [idx + 1, item]
      expected_keys << (idx + 1).to_s
    end
    CLI::Screen.write_slowly(t('metadata.create.questions.default'), {newline: false})
    choix = getc('', expected_keys: expected_keys).to_i
    return liste[choix - 1]
  end
  # ask_for_md_default

  # Pour savoir si la case à cocher doit être checkée par défaut
  def ask_for_md_checked
    checked = CLI.options[:checked]
    checked != nil || begin
      CLI::Screen.write_slowly(t('metadata.create.questions.checked'), {newline: false})
      checked = yesOrNo('')
    end
    return checked ? 'Yes' : 'No'
  end


  def ask_for_md_date_type
    date_type = CLI.options[:date_type]
    date_type || begin
      keys = Array.new
      puts str_custom_format_to_define
      keys << '0'
      MetaData::DATE_TYPES.values.each.with_index do |ddate, idx|
        idx < 9 || break
        puts DBLINDENT+'%i : %s' % [idx + 1, example_date_per_type(ddate[:key])]
        keys << (idx + 1).to_s
      end
      CLI::Screen.write_slowly(t('metadata.create.questions.date_format'), {newline: false})
      choix = getc('', {expected_keys: keys}).to_i
      if choix == 0
        ['Custom', ask_for_md_format_date]
      else
        [MetaData::DATE_TYPES.values[choix - 1][:real], nil]
      end
    end
  end
  # /ask_for_md_date_type

  def example_date_per_type ty
    t('dates.formats.%s' % ty.sub(/\+/,'_n_'))
  end


  # Simple helper for clarity
  def str_custom_format_to_define
    DBLINDENT+'0'+FRENCH_SPACE+': '+t('metadata.create.custom_format')
  end
  # On demande le format
  def ask_for_md_format_date
    CLI::Screen.write_slowly('%s (%s)' % [t('metadata.create.questions.date_format'), t('metadata.create.date_warning')], {newline: false})
    askFor('')
  end
  # /ask_for_md_format_date

end #/module
