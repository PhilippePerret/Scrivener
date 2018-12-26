# encoding: UTF-8
=begin

  Class CSVFile
  version 1.0.0

  Gestion pratique des fichiers CSV. Fonctionne parfaitement avec des
  fichiers de grande taille.

  @usage
  ------

    csvfile = CSVFile.new(<path>[, <options>])
    # Dans les options, on peut définir :
    #   separator:      Le séparateur de cellule (';' par défaut)
    #   :no_labels      Mettre à true si c'est un fichier sans première ligne
    #                   définissant les labels.

    # Ensuite, on peut atteindre les cellules de cette manière :
    csvfile.cell(<ligne>, <colonne ou label>)
    # avec <ligne> et <colonne> qui commencent toujours à 1.
    # Par exemple, pour obtenir la cellule placée sur la 4e rangée et la
    # 3e colonne :
    # cellule = csvfile.cell(4, 3).value
    # Si le fichier a des labels, on peut aussi obtenir la cellule par
    # cellule = csvfile.cell(4, 'monLabel').value

    # Pour obtenir toute une rangée
    rangee = csvfile.row(<indice rangée>)
    # Par exemple pour obtenir la 3e rangée :
    rangee3 = csvfile.row(3)

    # Pour modifier les cellules on fait :
    csvfile.cell(<ligne>, <colonne ou label>).value = <nouvelle valeur>
    csvfile.save

=end
require 'tempfile'
class CSVFile
  attr_accessor :path, :options
  # {Array} les labels, s'ils sont définis
  attr_accessor :labels
  # {Hash} Toutes les rangées chargées, avec en clé leur index (1-start)
  # et en valeur l'instance CSVLine correspondante.
  attr_accessor :loaded_rows

  def initialize path, opts = nil
    self.path         = path
    self.options      = opts || Hash.new
    self.loaded_rows  = Hash.new
    make_temporary_file
  end

  def line_separator; String::RC end

  # On fabrique une fichier temporaire qui ne contiendra que les
  # lignes sans labels si c'est un fichier avec labels et toutes les
  # lignes dans le cas contraire (pour ne pas abîmer le premier fichier)
  def make_temporary_file
    exist? || return
    if labels?
      rf = File.new(path)
      rf.each_line do |lig|
        if rf.lineno > 1
          iotemp.write lig
        else
          define_labels_from(lig)
        end
      end
    else
      self.labels = Hash.new # On en a besoin pour CSVLine
      File.new(path).each_line do |lig|
        iotemp.write lig
      end
    end
  end
  def iotemp
    @iotemp ||= Tempfile.new(basename)
  end
  # Pour boucler sur chaque ligne (sauf la ligne de label si elle
  # existe)
  def each_row &block
    iotemp.rewind
    iotemp.each_line do |line|
      yield treate_line(line, iotemp.lineno)
    end
  end

  # {CSVCell} Retourne la cellule
  def cell lig, col_or_label
    c_row = self.loaded_rows[lig] ||= row(lig)
    c_row || raise('No line #%s' % [lig.inspect])
    c_row.cell(col_or_label)
  end
  # Retourne true si le fichier existe
  def exist?
    File.exist?(path)
  end
  # Sauve le fichier temporaire avec les nouvelles valeurs
  # Question : comment faire, en sachant qu'on a des rangées modifiées
  # dans les instances et des rangées qui n'ont pas été chargées ?
  # Solution : ici, il faut garder une liste des rangées chargées et
  # les enregistrer
  def save
    iosave = Tempfile.new('saving-csv')
    # On doit commencer par enregistrer la ligne de labels s'ils sont
    # définis
    if labels?
      iosave.write labels.join(separator) + line_separator
    end
    iotemp.rewind
    iotemp.each_line do |line|
      line_num = iotemp.lineno
      if self.loaded_rows.key?(line_num)
        iosave.write loaded_rows[line_num].to_line + line_separator
      else
        iosave.write line
      end
    end
    iosave.close
    # On peut maintenant copier le fichier
    FileUtils.cp iosave.path, path
  end
  def define_labels_from lig
    self.labels = splitted_line(lig)
  end
  def treate_line lig, lindex
    csvline = CSVLine.new(self, lig)
    self.loaded_rows.merge!(lindex => csvline)
    return csvline
  end

  def labels?     ; !no_labels?         end
  def no_labels?  ; options[:no_labels] end

  # {Array} Seulement la ligne splittée
  def line lindex
    splitted_line(row_line(lindex))
  end
  # {CSVLine} L'instance de la ligne
  def row lindex
    treate_line(row_line(lindex), lindex)
  end
  alias :hline :row

  def splitted_line lig
    lig.strip.split(separator)
  end

  # Retourne la ligne à l'index +lindex+ (1-start)
  def row_line(lindex)
    iotemp.rewind
    each_line.with_index do |lig, idx|
      (idx + 1) == lindex || next
      return lig
    end
    raise 'Impossible de trouver l’item.'
  end
  def each_line
    @each_line ||= iotemp.each
  end
  def separator
    @separator ||= options[:separator] || ';'
  end
  def basename
    @basename ||= File.basename(path)
  end

  class CSVLine
    # {CSVFile} Propriétaire de la ligne
    attr_accessor :file
    attr_accessor :row # {String} Ligne envoyée à l'instanciation
    def initialize csv_file, row_line
      self.file = csv_file
      self.row  = row_line
    end
    # +key+ {String (label) ou Fixnum (index)}
    def [] key
      if key.is_a?(Fixnum)
        to_a[key - 1].value
      else
        to_h[key].value
      end
    end
    def []= key, value
      to_h[key].value = value.to_s
    end
    # +simple+ permet d'obtenir un Hash avec en clé le label (ou l'index)
    # et en valeur la valeur de la cellule au lieu de l'instance CSVCell
    def to_h simple = false
      @to_h ||= define_as_hash
      if simple
        Hash[@to_h.collect{|k, c| [k, c.value]}]
      else
        @to_h
      end
    end
    # +simple+ permet de retourner un simple Array contenant les valeurs,
    # non pas des CSVCell
    def to_a simple = false
      @to_a ||= define_as_array
      simple ? @to_a.collect{|c| c.value} : @to_a
    end
    # Telle que la donnée doit être dans le fichier
    def to_l
      @to_l ||= to_h.values.collect{|cell|cell.value}.join(file.separator)
    end
    alias :to_line :to_l

    # Retourne la cellule d'index +ref+ ou de label +ref+
    # Attention : ne pas confondre cette méthode avec la méthode de CSVFile
    # qui attend une ligne et une colonne en argument.
    def cell ref
      if ref.is_a?(Fixnum)
        self.to_a[ref - 1]
      else
        self.to_h[ref]
      end
    end
    def define_as_array
      row.strip.split(file.separator).collect do |item|
        CSVCell.new(self, item)
      end
    end
    def define_as_hash
      Hash[
        self.to_a.collect.with_index do |csv_cell,idx|
          k = file.labels[idx] || (idx + 1)
          [k, csv_cell]
        end
      ]
    end
  end

  # ---------------------------------------------------------------------
  class CSVCell
    attr_accessor :value # {String} La valeur de la cellule
    attr_accessor :row
    def initialize irow, valeur = nil
      self.row    = irow
      self.value  = valeur
    end
  end
end #/CSVFile

if $0 == __FILE__
  require 'test/unit'
  require 'tempfile'
  require_relative 'String'
  class TestCSVFile < Test::Unit::TestCase
    class << self
      def startup
        @paths = Array.new
      end
      def shutdown
        @paths.each do |tfile|
          # tfile.unlink if File.exist?(tfile)
        end
      end
      def make_a_file foo, contenu = nil, ext = 'csv'
        tf = Tempfile.new('%s.%s' % [foo, ext])
        @paths << tf
        if contenu
          tf.write(contenu)
          tf.close
        end
        return @paths.last
      end
    end
    def make_a_file(foo, ext = nil) ; self.class.make_a_file(foo, ext) end
    test 'On peut instancier un fichier avec son path' do
      f = nil
      assert_nothing_raised { f = CSVFile.new('mon/path') }
      assert f.is_a?(CSVFile)
    end
    test 'La méthode exist? retourne la bonne valeur' do
      f = CSVFile.new('/un/fichier/inexistant')
      assert f.respond_to?(:exist?)
      assert_false f.exist?
      f = CSVFile.new(make_a_file('essai').path)
      assert f.is_a?(CSVFile)
      assert f.exist?
    end
    test 'Essai' do
      csv = make_a_file('avec_labels')
      csv.write("premier;deuxième;troisième\n1;2;3\nUn;Deux;Trois\nOne;Two;Three")
      csv.close
      f = CSVFile.new(csv.path)
      assert f.respond_to?(:labels)
      assert_equal ['premier', 'deuxième', 'troisième'], f.labels
    end
    test 'La méthode labels retourne la première ligne de labels' do
      csv = make_a_file('avec_labels', "premier;deuxième;troisième\n1;2;3\nUn;Deux;Trois\nOne;Two;Three")
      f = CSVFile.new(csv.path)
      assert f.respond_to?(:labels)
      assert_equal ['premier', 'deuxième', 'troisième'], f.labels
    end
    test 'La méthode labels retourne nil si fichier sans label' do
      csv = make_a_file('sanslabels', "premier;deuxième;troisième\n1;2;3\nUn;Deux;Trois")
      f = CSVFile.new(csv.path, {no_labels: true})
      assert_empty f.labels
    end
    test 'La méthode `line` permet de récupérer une ligne par son index' do
      csv_avec = make_a_file('avec_labels', "premier;deuxième;troisième\n1;2;3\nUn;Deux;Trois\nOne;Two;Three")
      f_avec = CSVFile.new(csv_avec.path)
      assert_equal ['Un', 'Deux', 'Trois'], f_avec.line(2)
      hdata = {'premier' => 'Un', 'deuxième' => 'Deux', 'troisième' => 'Trois'}
      assert_equal hdata, f_avec.hline(2).to_h(true)
      csv_sans = make_a_file('sanslabels', "premier;deuxième;troisième\n1;2;3\nUn;Deux;Trois")
      f_sans = CSVFile.new(csv_sans.path, {no_labels: true})
      assert_equal ['Un', 'Deux', 'Trois'], f_sans.line(3)
      hdata = {1 => 'Un', 2 => 'Deux', 3 => 'Trois'}
      assert_equal hdata, f_sans.hline(3).to_h(true)
    end
    test 'La méthode `each_row` permet de boucler sur toutes les lignes (hors labels)' do
      contenu = "premier;deuxième;troisième\n1;2;3\nUn;Deux;Trois\nOne;Two;Three"
      csv_avec = make_a_file('avec_labels', contenu)
      f_avec = CSVFile.new(csv_avec.path)
      res = Array.new
      f_avec.each_row do |hrow|
        res << hrow.to_h(true).values
      end
      assert res.count == 3
      assert res[0] == ['1', '2', '3']
      assert res[1] == ['Un', 'Deux', 'Trois']
      assert res[2] == ['One', 'Two', 'Three']
    end
    test 'La méthode `each_row` permet de boucler sur toutes les lignes (même la première si pas de labels)' do
      contenu = "premier;deuxième;troisième\n1;2;3\nUn;Deux;Trois\nOne;Two;Three"
      csv_avec = make_a_file('avec_labels', contenu)
      f_avec = CSVFile.new(csv_avec.path, {no_labels: true})
      res = Array.new
      f_avec.each_row do |hrow|
        res << hrow.to_a(true)
      end
      assert res.count == 4
      assert res[0] == ['premier', 'deuxième', 'troisième']
      assert res[1] == ['1', '2', '3']
      assert res[2] == ['Un', 'Deux', 'Trois']
      assert res[3] == ['One', 'Two', 'Three']
    end
    test 'La méthode `row(<index>)[:label]` permet de récupérer une cellule' do
      contenu = "premier;deuxième;troisième\n1;2;3\nUn;Deux;Trois\nOne;Two;Three"
      csv_avec = make_a_file('avec_labels', contenu)
      favec = CSVFile.new(csv_avec.path)
      assert_equal '3', favec.row(1)['troisième']
    end
    test 'La méthode `row(<index>)[<index>]` permet de récupérer une cellule' do
      contenu = "premier;deuxième;troisième\n1;2;3\nUn;Deux;Trois\nOne;Two;Three"
      csv_avec = make_a_file('avec_labels', contenu)
      favec = CSVFile.new(csv_avec.path)
      assert_equal 'Deux', favec.row(2)[2]
    end
    test 'La méthode `row(<index>)[:label]=` permet de redéfinir la valeur d’une cellule' do
      contenu = "premier;deuxième;troisième\n1;2;3\nUn;Deux;Trois\nOne;Two;Three"
      csv_avec = make_a_file('avec_labels', contenu)
      favec = CSVFile.new(csv_avec.path)
      favec.row(1)['deuxième'] = 4
      favec.save
      favec2 = CSVFile.new(csv_avec.path, no_labels: true)
      assert_equal ['1','4','3'], favec2.row(2).to_a.collect{|c| c.value}
    end
    test 'La méthode `cell(<ligne>, <colonne>)` permet de récupérer une cellule' do
      contenu = "premier;deuxième;troisième\n1;2;3\nUn;Deux;Trois\nOne;Two;Three"
      csv_avec = make_a_file('avec_labels', contenu)
      favec = CSVFile.new(csv_avec.path)
      assert_equal '3', favec.cell(1,3).value
    end
    test 'La méthode `cell(<ligne>, <:label>)` permet de récupérer une cellule par le label' do
      contenu = "premier;deuxième;troisième\n1;2;3\nUn;Deux;Trois\nOne;Two;Three"
      csv_avec = make_a_file('avec_labels', contenu)
      favec = CSVFile.new(csv_avec.path)
      assert_equal '3', favec.cell(1, 'troisième').value
    end
    test 'La méthode `cell(<ligne>, <:label>)=` permet de redéfinir une cellule' do
      contenu = "premier;deuxième;troisième\n1;2;3\nUn;Deux;Trois\nOne;Two;Three"
      csv_avec = make_a_file('avec_labels', contenu)
      favec = CSVFile.new(csv_avec.path)
      assert_equal ['1','2','3'], favec.row(1).to_a(true)
      favec.cell(1, 'deuxième').value = 4
      favec.save
      favec2 = CSVFile.new(csv_avec.path, no_labels: true)
      assert_equal ['1','4','3'], favec2.row(2).to_a(true)
    end
    test 'La méthode `cell(<ligne>, <colonne>)=` permet de redéfinir une cellule' do
      contenu = "premier;deuxième;troisième\n1;2;3\nUn;Deux;Trois\nOne;Two;Three"
      csv_avec = make_a_file('avec_labels', contenu)
      favec = CSVFile.new(csv_avec.path)
      assert_equal ['1','2','3'], favec.row(1).to_a(true)
      favec.cell(1,2).value = 4
      favec.save
      favec2 = CSVFile.new(csv_avec.path, no_labels: true)
      assert_equal ['1','4','3'], favec2.row(2).to_a(true)
    end
  end
end
