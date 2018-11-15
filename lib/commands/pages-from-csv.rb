# encoding: UTF-8
=begin

  TODO
    * vérifier que le fichier CSV soit conforme aux attentes
    * construire aussi la hiérarchie des dossiers (premières et secondes
      colonne) si elle existe.

=end
if CLI.options[:help]
  aide = <<-EOT
#{'Commande pages-from-csv'.underlined}

  #{'Usage'.underlined('-', '  ')}

      #{'scriv pages-from-csv <path/to/projet.scriv> <vers/feuille.csv>'.jaune}

  #{'Description'.underlined('-', '  ')}

      La commande `pages-from-csv` permet de partir d'un fichier CSV
      correctement formaté pour Scrivener (*) qui va définir les fi-
      chiers du manuscrit, en réglant leur objectif en nombre de mots
      tels que définis dans le fichier.

      (*) On trouvera des liens pour télécharger les modèles de ces
          fichiers dans la description des deux tutoriels suggérés
          ci-dessous.

  #{'Options'.underlined('-', '  ')}

      -vd/--version-definitive

          Par défaut, c'est le nombre de mots du premier jet (*) qui
          est utilisé pour régler les objectifs des scènes. Avec cette
          option, c'est le nombre de mots de la version définitive qui
          sera utilisé.

          (*) Pour comprendre cette notion de nombre de mots du pre-
              mier jet et nombre de mots de la version définitive, cf.
              les deux tutoriels suggérés ci-dessous.

  #{'Tutoriels'.underlined('-', '  ')}

      TODO Mettre ici des liens vers les deux tutoriels :
      Définir la longueur de ses scènes
      Le piège des objectifs (et comment l'éviter)

  EOT
  Scrivener::help(aide)
  exit 0
end
require 'csv'


class Scene

  # Quand le document est contenu dans un dossier, cette propriété
  # définit l'UUID du conteneur, qu'il soit un dossier ou un sous-
  # dossier
  attr_accessor :container_uuid

  attr_reader :csv_row
  def initialize csv_row
    @csv_row = csv_row
    # Pour créer le dossier et/ou le sous-dossier éventuel
    main_folder
    sub_folder
  end
  def main_folder
    @main_folder ||= begin
      if csv_row[0].to_s.strip != ''
        # <= Un dossier principal est défini
        # => Il faut le fabriquer pour pouvoir mettre les
        #    éléments dedans.
        # On doit construire ce dossier dans le projet
        mfolder = csv_row[0].strip
        attrs = {:type   => 'Folder'}
        data  = {:title  => mfolder}
        bitem = project.create_binder_item(attrs, data)
        self.container_uuid = bitem.attributes['UUID']
        # Cela définit aussi le dossier courant (qui sera
        # remplacé par le sous-dossier s'il est défini aussi)
        project.current_folder = self.container_uuid
        # puts "project.current_folder est mis à #{project.current_folder}"
      end
    end
  end
  def sub_folder
    @sub_folder ||= begin
      if csv_row[1].to_s.strip != ''
        # <= Un sous-dossier est défini
        # => Il faut le créer et le mettre en dossier courant
        # On doit construire ce dossier dans le projet
        sfolder = csv_row[1].strip
        # Il faut créer ce sous-dossier (dans le dossier principal
        # s'il existe ou à la racine)
        attrs = {:type  => 'Folder'}
        data  = {:title => sfolder}
        bitem = project.create_binder_item(attrs, data)
        self.container_uuid = bitem.attributes['UUID']
        # Cela définit aussi le sous-dossier courant
        project.current_folder = self.container_uuid
      end
    end
  end


  def resume
    @resume ||= csv_row[2]
  end
  def pages_count
    @pages_count ||= csv_row[3].sub(/,/,'.').to_f
  end
  def pagination
    @pagination ||= csv_row[5]
  end
  def mots_count
    @mots_count ||= csv_row[6].to_i
  end
  def firstdraft_mots_count
    @firstdraft_mots_count ||= csv_row[7].to_i
  end
end
# /Class Scene

# Le path du fichier CSV
csv_path = ARGV[2] #'../init/test.csv'
# On doit vérifier que le path est fourni et qu'il s'agit bien d'un fichier
# CSV correctement formaté.
csv_path || raise("Il faut fournir le chemin du fichier CSV en argument (après le projet)")
File.exist?(csv_path) || raise("Le fichier `#{csv_path}` est introuvable. Merci de vérifier son adresse.")
File.extname(csv_path) == '.csv' || raise("L’extension du fichier CSV devrait être « .csv ».")

# Si l'opération n'est pas confirmée
puts "\n\nATTENTION !"
demande = <<-EOT
Cette opération va détruire le contenu de votre dossier Manuscrit.
(Le mieux est de partir d'un projet vierge).
Voulez-vous vraiment poursuivre ? (O/Y/N, Oui/Yes/No/Non)
EOT
print demande.strip + ' : '
choix = STDIN.gets.strip

unless ['Y', 'YES', 'O', 'OUI'].include?(choix.upcase)
  exit 0
end

print "Le projet est-il bien fermé ? (tapez 'o' ou 'y' s’il n’est pas ouvert dans Scrivener) : "
choix = STDIN.gets.strip
unless ['Y', 'YES', 'O', 'OUI'].include?(choix.upcase)
  exit 0
end


# On vide le classeur éventuel
project.empty_draft_folder

# On crée un nouveau document
def ajoute_document datanewdoc
  bi_newdoc = project.create_binder_item(nil, datanewdoc)
  VERBOSE && puts("Nouveau document #%s créé avec succès" % bi_newdoc.attributes['UUID'].strip)
end


csv = CSV.read(csv_path, {col_sep: ';', headers: true, converters: :numeric, header_converters: :symbol})

csv.each_with_index do |row, index|
  # puts '%i : %s' % [index, row.inspect]
  sc = Scene.new(row)
  dnewdoc = {
    title:          sc.resume,
    container:      project.current_folder,
    text_settings: {
      target: {type: 'Words', notify: 'No', value: sc.firstdraft_mots_count}
    }
  }
  # puts dnewdoc.inspect
  ajoute_document(dnewdoc)
end

# ON ENREGISTRE LE DOCUMENT
project.xfile.save

puts "\n=> La feuille de calcul a été importée dans le projet Scrivener.\n=== Opération exécutée avec succès ===".bleu
