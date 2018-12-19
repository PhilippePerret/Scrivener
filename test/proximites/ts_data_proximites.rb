require './test/test_helper'


class TestDataProximite < Test::Unit::TestCase

  class << self

    attr_accessor :projet, :projet_folder

    def startup
      self.projet_folder = File.join('.','test','assets','marion')
      self.projet = TestedProject.new(File.join(projet_folder, 'marion.scriv'))
      projet.remove_hidden_folder_if_exist
      Scrivener.require_all

      res = run_command('scriv prox "%s"' % @projet)

      # Pour voir une erreur, par exemple
      # puts res

    end
    # /startup

    def data_analyse
      @data_analyse ||= File.open(projet.analyse_file,'rb'){|f| Marshal.load(f)}
    end
    # /data_analyse

  end #/<< self

  def projet ; self.class.projet end
  def data_analyse ; self.class.data_analyse end

  test 'le dossier hidden a été produit pour l’analyse et le projet' do
    assert projet.hidden_folder.folder?
    assert projet.analyse.hidden_folder.folder?
  end

  test 'le fichier des résulats de l’analyse a été produit (table_resultats.msh)' do
    assert projet.analyse_file.file?
  end

  test 'le fichier des résultats de l’analyse défini les paths étudiés' do
    assert data_analyse.respond_to?(:paths)
    d = './test/assets/marion/.scriv/files'
    Dir["#{d}/*.txt"].each do |file|
      assert_match file, data_analyse.paths
    end
  end

  test 'les données analyse (instance) répondent aux méthodes utiles' do
    # On vérifie les données proxmités
    da = data_analyse
    # puts "-- data_proximites : #{data_proximites.inspect}"
    assert da.respond_to?(:mots)
    assert da.respond_to?(:current_offset)
    assert da.respond_to?(:proximites)
    assert da.respond_to?(:created_at)
    assert da.respond_to?(:updated_at)
  end

  test '`scriv prox ./test/assets/marion/marion.scriv` produit des données de mots correctes' do


    dm = data_analyse.mots
    assert dm.key?('premier')

  end

  test 'l’analyse de proximité produit des données de canons correctes' do

    dm = data_analyse.canons

    assert dm.key?('premier')
    assert dm['premier'].respond_to?(:proximites)
    assert_empty dm['premier'].proximites # pas de proximité

    assert dm.key?('marion')
    assert dm['marion'].respond_to?(:proximites)
    assert_not_empty dm['marion'].proximites

    assert dm.key?('être')
    assert dm['être'].respond_to?(:proximites)
    assert_not_empty dm['être'].proximites
    #
    # assert dm['être'].key?(:items)
    #
    # items_etre = dm['être'][:items]
    # # puts "---- items_etre: #{items_etre.inspect}"
    # assert_equal 2, items_etre.count
    # assert_equal ProxMot, items_etre.first.class
    # assert_equal 'est', items_etre.first.real
    # assert items_etre.first.treatable?
    #
    # assert dm.key?('ici')
    # assert_false dm.key?('rien du tout')

  end

end
