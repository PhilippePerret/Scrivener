# encoding: UTF-8
=begin

RÉFLEXION
Est-ce qu'il ne serait pas plus intéressant, pour le découpage, de remplacer
les éléments qu'on trouvera au fur et à mesure de leur remplacement.

Par exemple, on cherche tous les "Chapitres XXXX" en même temps que tous
les "PARTIE XXXX" OU "XXXXX PARTIES" et on les remplace par une marque
de découpage qui contiendra le titre envisagé.

Donc : on prend le texte entier, on le parcours

=end
class FileAlreadyTreated < StandardError; end

RC = String::RC

Scrivener.require_module('Scrivener')
Scrivener.require_module('set')

# Dans un fichier ABU, le balisage
ABU_START_LICENCE = /^(.*?)CONSERVEZ CETTE LICENCE(.*?)$/
ABU_END_LICENCE   = /^(.*?)---- FIN DE LA LICENCE (.*?)$/
ABU_START_ENTETE  = /^(.*?)--- ATTENTION : CONSERVEZ CET EN-TETE (.*?)$/
ABU_END_ENTETE    = /^(.*?)--- FIN DE L\'EN-TETE(.*?)$/
ABU_START_TEXTE   = /------------------------- DEBUT DU FICHIER ([^ ]+) --------------------------------/
ABU_END_TEXTE     = '------------------------- FIN DU FICHIER %{titre_texte} --------------------------------'

LONGUEUR_PORTION = 1500 * 20 # signes (± 20 pages)

# Les marques qui peuvent servir à découper le texte
# NOTE : maintenant, il faut retirer tous les retours chariot en fin de
# ligne avant de procéder à l'opération de découpage.
TEXT_SPLITTERS = [
  /^(ACTE|SC[EÈ]NE)(.*)$/i,
  /^LIVRE(.*)$/i,
  /^((?:CHAPITRE )?[ILXVC]{1,5})$/i,
  /^((?:CHAPITRE )?[0-9]{1,5})$/i,
  /^([\-\* ]+)?[ILXVC]{1,5}([\-\* ]+)?$/i,
  /^([\-\* ]+)?[0-9]{1,5}([\-\* ]+)?$/i,
  /^([0-9]+)(?: (.*))?$/,
  /^(\*{3,7})/,
  /^(.*) PARTIE ?$/
]

# = Dossier contenant les fichiers =
FOLDER_TEXTES = File.join(Dir.home,'Documents','Ecriture','Analyses')
FOLDER_CLASSIQUES = File.join(Dir.home,'Documents','Ecriture','Analyses','Classiques')
FOLDER_TEXTES_CONNUS = File.join(Dir.home,'Documents','Ecriture','Analyses','Textes_reputes')


class String
  # Prépare le contenu (la portion) pour le contenu du fichier
  def prepare_pour_content
    str = self.strip
    [
      [/^ +/, ''], # espaces en début de ligne
      [/ +$/m, ''], # les espaces à la fin des lignes
      [/^-- "(.*)"$/, '– \1'],
      [/#{RC*2}#{RC}+/m, RC*2], # refait aussi à la fin
      [/\n[—\-_ ]+\n/m, "\n"],
      [/(\n)?[\* ]+\n/m, '\1'], # ligne d'astérisques et d'espaces
      [/([a-zA-Zéàâ])([\!\?;:])/, '\1 \2'],
      [/\n\-\- /m, "\n– "],
      [/\-\-/, '–'],
      [/"(.*?)"/m, '« \1 »'],
      [/\.\.\./, '…'],
      [/ [  \t]+/,' '], # les espaces multiples
      [/ ([\.\,])/, '\1'], # espace avant point et virgule
      [/^\-+$/, ''],
      [/^ ?«  /, '« '], # deux espaces après guillemet ouvrant
      [/  » ?$/, ' »'], # deux espaces avant guillemet fermant
      [/^A /, 'À '],      # Majuscule avec accent, aujourd'hui
      [/#{RC*2}#{RC}+/, RC * 2] # Les triples retours chariot
    ].each do |bad, bon|
      str.gsub!(bad, bon)
    end

    return str.strip
  end
  # /prepare_pour_content
end#/String



# On recherche le titre et l'auteur

class Livre
  attr_accessor :projet
  attr_accessor :texte_entier
  def initialize iprojet
    self.projet = iprojet
  end

  # Crée un binder-item avec le texte +content+ et le titre de
  # document +titre+
  def create_document_with content, titre
    content = content.prepare_pour_content
    titre ||= content[0..30].strip + '…'
    datas = {content: content, title: titre}
    attrs = {type: 'Text'}
    project.draft_folder.create_binder_item(attrs, datas)
  end

  # Grand découpage du texte en fragment, en chapitre, en scène, etc.
  #
  # Fonctionnement :
  #   On enregistre le texte initial dans un fichier qu'on va lire
  #   ligne après ligne. Dès qu'on trouve une balise qui peut s'apparenter
  #   à un élément de découpage, on le remplace en l'indexant.
  #
  #   Quand on l'a trouvé, on crée aussi le fichier
  #
  def decoupe_texte_initial_en_fichiers
    if marqueur_decoupage?
      decoupe_texte_initial_with_markers_split
    else
      decoupe_texte_initial_by_portion
    end
  end
  # /decoupe_texte_initial_en_fichiers

  def decoupe_texte_initial_with_markers_split
    File.open(projet.whole_text_path,'wb'){|f| f.write texte_initial}

    buffer          = Array.new
    titre_document  = nil
    indice_section  = 0 # dans le sens
    File.open(projet.whole_text_path,'rb').each do |line|
      line = line.force_encoding('utf-8').strip
      line_for_test = line.gsub(/[\-\*\.\–]/,'').strip
      line_for_test.length > 24 || line.empty? || begin
        # Si c'est une simple ligne de séparation, on la passe
        if line.strip.gsub(/[\-\=]/,'').empty?
          next
        end
        line_for_test.empty? && begin
          titre_document = 'Section %i' % [indice_section += 1]
          # On ne prend pas cette ligne dans le texte
          next
        end
        TEXT_SPLITTERS.each do |splitter|
          line_for_test.match(splitter) || next
          buffer.empty? || begin
            create_document_with(buffer.join(RC), titre_document)
            buffer = Array.new
          end
          titre_document = line_for_test
          break
        end
        # Si la ligne ne contient qu'un nombre (romain ou arabe),
        # on ne l'ajoute pas au texte
        line_for_test.match(/^[0-9]+$/)    && next
        line_for_test.match(/^[IVXLC]+$/)  && next
      end
      buffer << line
    end
    buffer.empty? || begin
      create_document_with(buffer.join(RC), titre_document)
      buffer = Array.new
    end
  end
  # /decoupe_texte_initial_with_markers_split

  def decoupe_texte_initial_by_portion
    current_index = 0
    i_portion     = 0
    while current_index + 1 < texte_initial_length
      index = texte_initial.index("\n", current_index + LONGUEUR_PORTION) || (texte_initial_length - 1)

      # ---------------------------------------------------------------------
      # On va créer la portion avec le texte
      portion = texte_initial[current_index...index]
      portion = portion.prepare_pour_content
      titre_document = portion[0..30].strip + '…'
      datas = {content: portion, title: titre_document}
      attrs = {type: 'Text'}
      project.draft_folder.create_binder_item(attrs, datas)
      # ---------------------------------------------------------------------
      current_index = index
    end
  end
  # /decoupe_texte_initial_by_portion


  # # === LICENCE ===
  #
  def create_fichier_licence
    datas = {content: texte_licence, title: 'Licence'}
    attrs = {type: 'Text'}
    project.research_folder.create_binder_item(attrs, datas)
  end
  # Retourne le texte de la licence
  def texte_licence
    @texte_licence ||= begin
      texte_entier[index_start_licence...index_end_licence].strip
    end
  end
  def index_start_licence
    @index_start_licence ||= begin
      texte_entier.index("\n", texte_entier.index(ABU_START_LICENCE))
    end
  end
  def index_end_licence
    @index_end_licence ||= texte_entier.index(ABU_END_LICENCE)
  end


  # === ENTETE ===
  #
  def create_fichier_entete
    # Création du fichier d'entête
    datas = {content: texte_entete, title: 'Entête'}
    attrs = {type: 'Text'}
    project.research_folder.create_binder_item(attrs, datas)
  end
  def texte_entete
    @texte_entete ||= begin
      texte_entier[index_start_entete...index_end_entete].strip
    end
  end
  def index_start_entete
    @index_start_entete ||= begin
      texte_entier.index("\n", texte_entier.index(ABU_START_ENTETE, index_end_licence))
    end
  end
  def index_end_entete
    @index_end_entete ||= texte_entier.index(ABU_END_ENTETE, index_start_entete)
  end


  # === TEXTE INITIAL ===
  # Note : ce n'est pas le texte entier.

  # Le texte épuré (donc sans entête et sans licence)
  # Note : dans ce texte initial, on corrige quand même les espaces laissées
  # à la fin et au début des lignes
  def texte_initial
    @texte_initial ||= begin
      t = texte_entier[index_start_texte...index_end_texte].strip
      t.gsub(/ +$/, '').gsub(/^ +/,'')
    end
  end
  def texte_initial_length
    @texte_initial_length ||= texte_initial.length
  end

  def index_start_texte
    @index_start_texte ||= begin
      texte_entier.index("\n", texte_entier.index(ABU_START_TEXTE, index_end_entete))
    end
  end
  def index_end_texte
    @index_end_texte ||= texte_entier.index(mark_end_texte)
  end

  # === DATA ===
  def titre
    @titre ||= begin
      tea = texte_entier.match(/<TITRE(.*?)(?: \((.+)\))?>/).to_a
      @annee = tea[2] ? tea[2].strip.to_i : nil
      String.french_titleize(tea[1].strip)
    end
  end
  # utile quand le fichier a déjà été traité
  def titre= value ; @titre = value end
  def auteur
    @auteur ||= begin
      aea = texte_entier.match(/<AUTEUR (.*?)(?: \(([0-9]+)\-([0-9]+)?\))?>/).to_a
      @auteur_naissance = aea[2] ? aea[2].strip.to_i : nil
      @auteur_mort = aea[3].to_s != '' ? aea[3].strip : nil
      @auteur_mort = @auteur_mort ? nil : @auteur_mort.to_i
      aea[1].strip
    end
  end
  def auteur_naissance  ; @auteur_naissance   end
  def auteur_mort       ; @auteur_mort        end

  # Retourne true si on a toutes les balises dans le texte
  # Sinon, raise l'erreur de la balise manquante
  def balisage_abu_ok?
    [
      ABU_START_LICENCE,
      ABU_START_ENTETE, ABU_END_ENTETE,
      ABU_START_TEXTE
    ].each do |balise|
      texte_entier.match(balise) || raise('Impossible de trouver la balise « %s » dans le texte… Je dois renoncer.' % balise)
    end
    # Parce qu'il faut que la marque de début de texte existe.
    texte_entier.match(mark_end_texte) || raise('Impossible de trouver la balise de fin de texte. Je dois renoncer.')
  end

  # Retourne true si le texte contient au moins un marqueur de
  # découpage
  def marqueur_decoupage?
    if @has_marqueur_decoupage === nil
      @has_marqueur_decoupage = false
      texte_tested = texte_initial.gsub(/\-\-+/,'').gsub(/\./,'')
      TEXT_SPLITTERS.each do |marker|
        texte_tested.match(marker) || next
        @has_marqueur_decoupage = true
        break
      end
    end
    return @has_marqueur_decoupage
  end
  # /split_marker

  def formated_auteur
    @formated_auteur ||= begin
      nom, prenom = auteur.split(',')
      ('%s %s' % [(prenom||'').strip, nom.strip]).strip
    end
  end

  def mark_end_texte
    @mark_end_texte ||= ABU_END_TEXTE % {titre_texte: title_marker}
  end
  def title_marker
    @title_marker ||= texte_entier.match(%r{#{ABU_START_TEXTE}})[1]
  end
end #/Livre


# ---------------------------------------------------------------------

# Méthode principale pour traiter le livre
def formate_livre_of_path ppath
  puts RC*2 + ('*** Traitement de : %s' % ppath)
  Scrivener::Project.current= Scrivener::Project.new(ppath)
  livre = Livre.new(project)

  project.draft_folder.children.count == 1 || begin
    if project.research_folder.title == 'Divers'
      livre.titre= project.draft_folder.title
      raise(FileAlreadyTreated.new('Le livre « %s » a déjà été traité' % livre.titre))
    else
      raise('Il semble que le projet « %s » soit déjà traité. Il possède plus d’un fichier.' % livre.titre)
    end
  end
  # On prend le premier binder-item pour mettre le texte dans le livre
  bitem_texte_entier  = project.draft_folder.children.first
  livre.texte_entier  = bitem_texte_entier.texte
  # Le texte doit contenir les bonnes balises
  livre.balisage_abu_ok?

  # Il faut pouvoir trouver un marqueur de découpage ou avoir l'option
  # `--split`
  livre.marqueur_decoupage? || CLI.options[:split] || raise('Impossible de trouver un marqueur de découpage dans le texte (chapitre, ACTE, etc.). Je dois renoncer.'+RC+'Utiliser l’option `--split` pour faire un découpage par portion. Placer des marqueurs de pages, par exemple des numéros seuls sur des lignes, puis recommencez.')


  # ---------------------------------------------------------------------
  # On peut commencer les opérations

  # Enregistrer les données titre et auteur dans le projet
  project.set_title   livre.titre
  project.set_title_abbreviate livre.titre
  project.set_author  livre.formated_auteur
  project.set_authors livre.formated_auteur
  project.compile_xml.save

  # Appliquer le titre au dossier manuscrit
  project.draft_folder.title= livre.titre
  project.research_folder.title= 'Divers'

  # LICENCE
  livre.create_fichier_licence
  # ENTETE
  livre.create_fichier_entete
  # TEXTE DÉCOUPÉ
  livre.decoupe_texte_initial_en_fichiers

  # Pour finir, il faut mettre le fichier complet à la poubelle (dans la
  # poubelle du projet)
  bitem_texte_entier.throw_in_the_trash

  # Le fichier xfile (.xscriv) doit être sauvé
  project.xfile.save

rescue FileAlreadyTreated => e
  puts e.message.bleu
  false
rescue Exception => e
  puts e.message.rouge
  puts e.backtrace[0...5].join(RC)
  raise
else
  puts "Projet « #{livre.titre} » de #{livre.formated_auteur} traité avec succès (en tout cas j'espère).".bleu
  true
end
# /formate_livre_of_path


Dir["#{FOLDER_TEXTES_CONNUS}/**/*.scriv"].each_with_index do |ppath, index_path|
  if formate_livre_of_path(ppath)
    # index_path < 5 || break
    break # s'arrêter au premier
  end
end
