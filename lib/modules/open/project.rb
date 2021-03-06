class Scrivener
class Project
  class << self

    # = main =
    #
    # Méthode principale pour afficher le maximum de données sur
    # le projet.
    #
    def exec_open_chose what
      project.open(what)
    end
    # /exec_open_chose

  end #/<< self

  # Tous les textes d'aide en fonction du fichier/dossier à ouvrir, dans
  # le cas d'une ouverture OK ou d'une absence du dossier/fichier
  AIDES_OPEN = {
    prox:   { creatable:    true },
    scriv:  { no_vim:       true },
    scrivx: { with_confirm: true }

  }
  # ---------------------------------------------------------------------
  #   MÉTHODES D'INSTANCE

  def open what = nil
    opts = Hash.new
    CLI.options[:vim] && opts.merge!(vim: '% vim' % [t('with.min')])
    case what
    when nil
      opts.merge!(tip: :projet)
      open_if_exists(path, t('scriv.project_file.min'), opts)
    when 'scrivx', 'xfile'
      opts.merge!(tip: :scrivx, with_confirm: true)
      open_if_exists(xfile_path, t('scriv.scrivx_file.min'), opts)
    when 'folder' # le dossier contenant le projet
      opts.merge!(tip: :folder)
      open_if_exists(folder, t('scriv.project_folder.min'), opts)
    when 'config', 'config-file'
      opts.merge!(tip: :config)
      open_if_exists(get_config_path, t('scriv.config_file.min'), opts)
    when 'folder-scriv'
      opts.merge!(tip: :scriv)
      open_if_exists(hidden_folder, t('scriv.hidden_folder.min'), opts)
    when 'lemma', 'lemmatisation'
      opts.merge!(tip: :lemma)
      open_if_exists(lemma_data_path, t('scriv.lemma_file.min'), opts)
    when 'proximites', 'prox'
      opts.merge!(tip: :prox)
      open_if_exists(custom_proximites_file_path, t('scriv.prox_prefs_file.min'), opts)
    when 'abbr', 'abbrs', 'abbreviations'
      opts.merge!(tip: :abbr)
      open_if_exists(TREE_TAGGER_ABBREVIATES, t('scriv.abbreviations_file.min'), opts)
    when 'tdm', 'toc'
      opts.merge!(tip: :tdm)
      open_if_exists(tdm_file_path(CLI.options[:format]), t('scriv.tdm_file.min'), opts)
    else
      puts t('commands.open.errors.unknown_object', {what: what}).rouge
    end
  end
  # /open

  # +options+ Permettra de définir par exemple :
  #   :application    L'application à utiliser pour ouvrir le fichier
  #   :vim            Si true, on propose aussi la commande vim
  def open_if_exists chemin, msg = nil, options

    if !File.exists?(chemin) && CLI.options[:create]
      if AIDES_OPEN[options[:tip]][:creatable]
        write_in_file(t('commands.open.%s.default_contents' % [options[:tip]]), chemin)
      else
        puts (t('commands.open.errors.not_creatable', {what: msg})).rouge
      end
    end

    if File.exists?(chemin)
      options ||= Hash.new
      if options[:with_confirm]
        yesOrNo( t('commands.open.questions.want_open', {what: msg})) || return
      end
      datawt = {what: msg, with_vim: (options[:vim] || ''), pth: chemin}
      wt('commands.open.notices.opening', datawt, {color: :bleu})
      if options[:tip] == :scrivx
        # Ouverture du fichier scrivx
        open_with_an_editor(chemin)
      elsif options[:vim] && !File.directory?(chemin)
        `vim -es "#{chemin}"`
      else
        `open "#{chemin}"`
        unless (AIDES_OPEN[options[:tip]] && AIDES_OPEN[options[:tip]][:no_vim]) || options[:vim]
          wt('commands.open.notices.add_vim_option')
        end
      end
      tip = t('commands.open.help.%s.found' % options[:tip])
      puts tip unless tip.nil?
    else
      # Quand le fichier n'existe pas ou est introuvable
      wt('commands.open.errors.file_unfound', {what: msg, pth: chemin}, {color: :rouge})
      tip = t('commands.open.help.%s.unfound' % options[:tip])
      puts tip.rouge unless tip.nil?
    end
  end
  # /open_if_exists

  EDITORS = {
    'TextMate'  => 'mate',
    'Atom'      => 'atom',
    'Vim'       => 'vim'
  }
  def open_with_an_editor(chemin)
    editors = Array.new
    # res = `if type mate 2>/dev/null; then return 1; fi`

    EDITORS.each do |name, cmd|
      if `if type #{cmd} 2>/dev/null; then exit 0; fi`.match(/#{cmd} is/)
        editors << name
      end
    end
    editors << 'TextEdit'
    if editors.count > 1
      wt('questions.which_editor', {pth: chemin.relative_path})
      expected_keys = Array.new
      editors.each.with_index do |e, idx|
        puts '    %i : %s' % [idx + 1, e]
        expected_keys << (idx+1).to_s
      end
      puts '    q : %s' % [t('cancel.min')]
      choix = getc(t('choose.tit the_editor.min') + '…', {expected_keys: expected_keys << 'q'})
      choix != 'q' || return
      editor_index = choix.to_i - 1
    else
      editor_index = 0
    end
    case editors[editor_index]
    when 'TextMate'
      `mate "#{chemin}"`
    when 'Atom'
      `atom "#{chemin}"`
    when 'TextEdit'
      `open -a "TextEdit" "#{chemin}"`
    when 'Vim'
      `vim -es "#{chemin}"`
    end
  end

  # Retourne le chemin d'accès au fichier config par défaut ou défini par
  # les options --name ou --nom
  def get_config_path
    return File.join(
      folder,
      (CLI.options[:name] || CLI.options[:nom] || 'config').with_extension('yaml')
    )
  end
  # /get_config_path
  private :get_config_path

end #/Project
end #/Scrivener
