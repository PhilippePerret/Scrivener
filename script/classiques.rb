# encoding: UTF-8


Scrivener.require_module('Scrivener')


FOLDER_CLASSIQUES = File.join(Dir.home,'Documents','Ecriture','Analyses','Classiques')
ppath = File.join(FOLDER_CLASSIQUES,'Divers','Britannicus','Britannicus.scriv')

Scrivener::Project.current= Scrivener::Project.new(ppath)


DATA_LIVRE = {
  titre:            nil,
  annee:            nil,
  auteur:           nil,
  auteur_naissance: nil,
  auteur_mort:      nil
}

# '-------- FIN DU FICHIER '


# On recherche un marqueur de découpe dans le texte
def find_split_marker_in str
  [
    /^(ACTE|SC[EÈ]NE)(.*)$/i,
    /^livre (.*)$/i,
    /^Chapitre(.*)$/i,
    /^([0-9]+)(?: (.*))?$/,
    /^(\*{3,7})/,
    /^(.*) PARTIE ?$/
  ].each do |marker|
    if str.match(marker)
      # => Marker possible
      # nombre = t.scan(marker).to_a.count - 1
      nombre = str.gsub(marker).count - 1
      if nombre > 4
        # puts 'MARKER TROUVÉ %i FOIS : %s (%s)' %  [nombre, markers.inspect, marker.inspect]
        return marker
      end
    end
  end
  return nil
end

class String
  # Prépare le contenu (la portion) pour le contenu du fichier
  def prepare_pour_content
    str = self.strip
    [
      [/([a-zA-Zéàâ])([\!\?;:])/, '\1 \2'],
      [/\n\-\- /, "\n– "],
      [/\-\-/, '–'],
      [/"(.*?)"/, '« \1 »'],
      [/\.\.\./, '…'],
      [/^\-+ ?$/, ''],
      [/#{String::RC}#{String::RC}+/, String::RC * 2]
    ].each do |bad, bon|
      str.gsub!(bad, bon)
    end

    return str
  end
  # /prepare_pour_content
end#/String

# ---------------------------------------------------------------------
#
#   DÉBUT DU TRAVAIL
#

# TODO
# Renommer le dossier 'Ébauche' par le titre du livre
draftfolder     = project.draft_folder
researchfolder  = project.research_folder
# puts '%s' % draftfolder.children.first.texte[0..5000]
# Renommer le dossier 'Recherche' par 'Divers'

draftfolder.children.count == 1 || begin
  raise 'Il semble que ce projet soit déjà traité. Il possède plus d’un fichier'
end

# On prend le texte du fichier
BITEM_TEXTE_INIT  = draftfolder.children.first
TEXTE_ENTIER      = BITEM_TEXTE_INIT.texte

# On recherche le titre et l'auteur
titre_et_annee = TEXTE_ENTIER.match(/<TITRE(.*)\((.+)\)>/).to_a
DATA_LIVRE[:titre] = titre_et_annee[1].strip
DATA_LIVRE[:annee] = titre_et_annee[2].strip.to_i
auteur_et_annees = TEXTE_ENTIER.match(/<AUTEUR (.*)\(([0-9]+)\-([0-9]+)?\)>/).to_a

DATA_LIVRE[:auteur] = auteur_et_annees[1].strip
DATA_LIVRE[:auteur_naissance] = auteur_et_annees[2].strip.to_i
DATA_LIVRE[:auteur_mort] = auteur_et_annees[3].strip
DATA_LIVRE[:auteur_mort] = DATA_LIVRE[:auteur_mort] == '' ? nil : DATA_LIVRE[:auteur_mort].to_i

# puts DATA_LIVRE.inspect

# On va découper le fichier suivant sa licence, son entête et son texte dans
# un premier temps
# La licence doit faire un nouveau fichier dans le dossier
start_licence = /^(.*?)CONSERVEZ CETTE LICENCE(.*?)$/
end_licence   = /^(.*?)---- FIN DE LA LICENCE (.*?)$/
start_entete  = /^(.*?)--- ATTENTION : CONSERVEZ CET EN-TETE (.*?)$/
end_entete    = /^(.*?)--- FIN DE L\'EN-TETE(.*?)$/
start_texte   = /------------------------- DEBUT DU FICHIER ([^ ]+) --------------------------------/
# => titre_texte



# On cherche le titre, l'auteur, le marqueur de fichier
TEXTE_ENTIER.match(%r{#{start_texte}}) || raise('errors.no_start_texte')
MARQUEUR_FICHIER = TEXTE_ENTIER.match(%r{#{start_texte}})[1]
end_texte = '------------------------- FIN DU FICHIER %{titre_texte} --------------------------------' % {titre_texte: MARQUEUR_FICHIER}
TEXTE_ENTIER.match(end_texte) || raise('errors.no_end_texte')
# On doit trouver toutes les autres balises dans le texte
[
  start_licence,
  start_entete, end_entete,
  start_texte, end_texte
].each do |balise|
  TEXTE_ENTIER.match(balise) || raise(('Impossible de trouver la balise « %s » dans le texte… Je dois renoncer' % balise).rouge)
end

# ---------------------------------------------------------------------

# Appliquer le titre au dossier manuscrit
draftfolder.title= DATA_LIVRE[:titre]
researchfolder.title= 'Divers'

# ---------------------------------------------------------------------
#   DÉCOUPAGE DU TEXTE ET CRÉATION DES BINDER-ITEM

# # === LICENCE ===
#
index_start_licence = TEXTE_ENTIER.index(start_licence)
index_start_licence = TEXTE_ENTIER.index("\n", index_start_licence)
index_end_licence   = TEXTE_ENTIER.index(end_licence)
# LICENCE = TEXTE_ENTIER[index_start_licence...index_end_licence].strip
#
# # CRÉATION DE LA LICENCE (dans le dossier Divers — Research)
# datas = {content: LICENCE, title: 'Licence'}
# attrs = {type: 'Text'}
# researchfolder.create_binder_item(attrs, datas)

# === ENTÊTE ===
#
index_start_entete  = TEXTE_ENTIER.index(start_entete, index_end_licence)
index_start_entete  = TEXTE_ENTIER.index("\n", index_start_entete)
index_end_entete    = TEXTE_ENTIER.index(end_entete, index_end_licence)
# ENTETE = TEXTE_ENTIER[index_start_entete...index_end_entete].strip
# # puts "-- ENTETE: #{ENTETE}"
# # Création du fichier
# datas = {content: ENTETE, title: 'Entête'}
# attrs = {type: 'Text'}
# researchfolder.create_binder_item(attrs, datas)

# === TEXTE ===
index_start_texte = TEXTE_ENTIER.index(start_texte, index_end_entete)
index_start_texte = TEXTE_ENTIER.index("\n", index_start_texte)
index_end_texte   = TEXTE_ENTIER.index(end_texte)
TEXTE_INIT = TEXTE_ENTIER[index_start_texte...index_end_texte].strip

# puts '-- TEXTE_INIT : ' + TEXTE_INIT

# Il faut trouver le marqueur de découpage dans le texte. S'il n'existe pas,
# on découpe le texte en fragment de x pages.
split_marker = find_split_marker_in(TEXTE_INIT)
split_marker || CLI.options[:split] || raise('Impossible de trouver un marqueur de découpage dans le texte (chapitre, ACTE, etc.). Je dois renoncer. Utiliser l’option `--split` pour faire un découpage par portion. Placer des marqueurs de pages, par exemple des numéros seuls sur des lignes, puis recommencez.')

LONGUEUR_TEXTE = TEXTE_INIT.length
LONGUEUR_PORTION = 4500

current_index = 0
i_portion     = 0
while current_index + 1 < LONGUEUR_TEXTE
  if split_marker
    index = TEXTE_INIT.index(split_marker, current_index + 1) || (LONGUEUR_TEXTE - 1)
    # On va récupérer le titre, c'est la première ligne
    index_rc        = TEXTE_INIT.index("\n", current_index) || (LONGUEUR_TEXTE - 1)
    titre_document  = TEXTE_INIT[current_index...index_rc].strip
  else
    index = TEXTE_INIT.index("\n", current_index + LONGUEUR_PORTION) || (LONGUEUR_TEXTE - 1)
    titre_document  = "Portion #{i_portion += 1}"
  end

  # ---------------------------------------------------------------------

  # On va créer la portion avec le texte
  portion = TEXTE_INIT[current_index...index]
  portion = portion.prepare_pour_content
  # puts "\n\n\n\n---------\nPORTION de #{current_index} à #{index}"
  # puts "TITRE DOCUMENT : #{titre_document}"
  # puts portion.inspect
  # puts '----------'
  datas = {content: portion, title: titre_document}
  attrs = {type: 'Text'}
  draftfolder.create_binder_item(attrs, datas)

  # ---------------------------------------------------------------------

  current_index = index
end

# Pour finir, il faut mettre le fichier complet à la poubelle (dans la
# poubelle du projet)
BITEM_TEXTE_INIT.throw_in_the_trash

# Le fichier xfile (.xscriv) doit être sauvé
project.xfile.save

puts "Projet « #{DATA_LIVRE[:titre]} » traité avec succès (en tout cas j'espère)."
