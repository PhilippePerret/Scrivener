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
    projet: {
      found:    nil,
      unfound:  'Vous avez dû détruire votre projet depuis votre dernière utilisation de la commande scriv.',
      no_vim:   true
    },
    folder: {
      found:    nil,
      unfound:  'Ça ne devrait pas pouvoir se produire. Vous avez dû détruire le projet depuis votre dernière utilisation de commande scriv.',
      no_vim:   true
    },
    lemma: {
      found:    'Ce fichier contient la lémmatisation du texte principal du projet.',
      unfound:  'Ce fichier ne peut qu’exister après une analyse du texte.'
    },
    prox: {
      found:    nil,
      unfound:  'Pour créer ce fichier, ajouter l’option `--create` à cette commande.',
      default_contents: '100%{rc}%{tb}PROTAGONISTE%{rc}%{tb}ANTAGONISTE' % {rc: String::RC, tb: "\t"}
    },
    abbrs: {
      found:    'Pour modifier ce fichier, utilisez plutôt la commande `scriv lemma` (qui produira une copie du fichier original).',
      unfound:  'Ce fichier devrait absolument exister, puisqu’il fait partie de TreeTagger… Son absence produira une erreur fatale.'
    },
    scriv: {
      found:    'Ce dossier contient tous les fichiers créés lors de l’analyse (de proximités) du projet.',
      unfound:  'Il faut lancer la recherche de proximité au moins une fois pour que ce dossier existe.',
      no_vim:   true
    },
    tdm: {
      found:    'Cette table des matières est exportée avec la commande `pagination` (`scriv pagination --output=csv`). Si c’est un fichier .csv, il permet de redéfinir les objectifs et la table des matières du projet. On peut utiliser le format `numbers` pour travailler avec l’application de même nom puis exporter en CSV.',
      unfound:  'Pour qu’il existe, il faut exporter au format .csv une table des matières depuis Calc, Excel ou autre tableur. On peut également exporter la table des matières du projet courant à l’aide de la commande `scriv pagination --output=csv`.'
    },
    scrivx: {
      found:    'C’est le fichier caché principal du projet. %s' % ['Vous ne devez le modifier que si vous savez parfaitement ce que vous faites.'.rouge],
      unfound:  'Bizarrement, ce fichier indispensable est introuvable.'
    }
  }
  # ---------------------------------------------------------------------
  #   MÉTHODES D'INSTANCE

  def open what = nil
    opts = Hash.new
    CLI.options[:vim] && opts.merge!(vim: true)
    case what
    when nil
      opts.merge!(tip: :projet)
      open_if_exists(path, 'fichier du projet', opts)
    when 'scrivx', 'xfile'
      opts.merge!(tip: :scrivx, with_confirm: true)
      open_if_exists(xfile_path, 'fichier scrivx', opts)
    when 'folder' # le dossier contenant le projet
      opts.merge!(tip: :folder)
      open_if_exists(folder, 'dossier du projet', opts)
    when 'folder-scriv'
      opts.merge!(tip: :scriv)
      open_if_exists(hidden_folder, 'dossier du projet', opts)
    when 'lemma', 'lemmatisation'
      opts.merge!(tip: :lemma)
      open_if_exists(lemma_data_path, 'fichier de lemmatisation', opts)
    when 'proximites', 'prox'
      opts.merge!(tip: :prox)
      open_if_exists(custom_proximites_file_path, 'fichier des proximités propres au projet', opts)
    when 'abbr', 'abbrs', 'abbreviations'
      opts.merge!(tip: :abbr)
      open_if_exists(TREE_TAGGER_ABBREVIATES, 'fichier des abbréviations', opts)
    when 'tdm', 'toc'
      opts.merge!(tip: :tdm)
      open_if_exists(tdm_file_path(CLI.options[:format]), 'fichier table des matières', opts)
    else
      puts "L'objet à ouvrir `#{what}` est inconnu…".rouge
    end
  end
  # /open

  # +options+ Permettra de définir par exemple :
  #   :application    L'application à utiliser pour ouvrir le fichier
  #   :vim            Si true, on propose aussi la commande vim
  def open_if_exists chemin, msg = nil, options

    if !File.exists?(chemin) && CLI.options[:create]
      if AIDES_OPEN[options[:tip]][:default_contents]
        File.open(chemin,'wb'){|f| f.write(AIDES_OPEN[options[:tip]][:default_contents])}
      else
        puts ('Le %s ne peut pas être créé avec l’option --create…' % msg).rouge
      end
    end

    if File.exists?(chemin)
      options ||= Hash.new
      if options[:with_confirm]
        yesOrNo('Êtes-vous certain de vouloir ouvrir le %s ?' % msg) || return
      end
      puts ('* Ouverture du %s%s… (%s)' % [msg, options[:vim] ? ' avec Vim' : '', chemin]).bleu
      if options[:tip] == :scrivx
        # Ouverture du fichier scrivx
        open_with_an_editor(chemin)
      elsif options[:vim] && !File.directory?(chemin)
        `vim -es "#{chemin}"`
      else
        `open "#{chemin}"`
        unless AIDES_OPEN[options[:tip]][:no_vim] || options[:vim]
          puts "(ajouter l'option `--vim` pour ouvrir le fichier avec Vim)"
        end
      end
      puts AIDES_OPEN[options[:tip]][:found]
    else
      # Quand le fichier n'existe pas ou est introuvable
      puts ('Il n’existe pas de %s pour ce projet (%s).' % [msg, chemin]).rouge
      unless AIDES_OPEN[options[:tip]][:unfound].nil?
        puts AIDES_OPEN[options[:tip]][:unfound].rouge
      end
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
      puts "Avec quel éditeur dois-je ouvrir le fichier ?"
      expected_keys = Array.new
      editors.each.with_index do |e, idx|
        puts '    %i : %s' % [idx + 1, e]
        expected_keys << (idx+1).to_s
      end
      puts '    q : abandonner'
      choix = getc('Choisir l’éditeur…', {expected_keys: expected_keys << 'q'})
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
end #/Project
end #/Scrivener
