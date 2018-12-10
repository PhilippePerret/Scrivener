require './test/test_helper'


class TestDataProximite < Test::Unit::TestCase

  def setup
    @projet_folder = File.join('.','test','assets','marion')
    @projet = TestedProject.new(File.join(@projet_folder, 'marion.scriv'))
    Scrivener.require_all
  end

  def data_proximites
    @data_proximites ||= begin
      File.open(@projet.proximites_file,'rb'){|f| Marshal.load(f)}
    end
  end

  test '`scriv prox ./test/assets/marion/marion.scriv` produit des données proximités correctes' do
    @projet.remove_hidden_folder_if_exist

    assert_false @projet.hidden_folder.folder?
    CLI::Test.run_command('scriv prox ./test/assets/marion/marion.scriv', 'q')
    CLI::Test.run_command('scriv open lemma')
    # 'q' pour jouer la touche 'q' et donc quitter la ligne de commande
    # Le fichier proximité doit avoir été produit
    assert @projet.proximites_file.file?

    # On vérifie les données proxmités
    dp = data_proximites
    # puts "-- data_proximites : #{data_proximites.inspect}"
    assert data_proximites.key?(:mots)
    assert data_proximites.key?(:binder_items)
    assert data_proximites.key?(:current_offset)
    assert data_proximites.key?(:project_path)
    assert data_proximites.key?(:proximites)
    assert data_proximites.key?(:created_at)

    assert_equal File.expand_path(@projet.path), dp[:project_path]

    dm = dp[:mots]
    # puts "--- data_proximites[:mots]: #{dm.keys.inspect}"
    assert dm.key?('premier')
    assert dm['premier'].key?(:proximites)
    assert_empty dm['premier'][:proximites] # pas de proximité
    assert dm.key?('marion')
    assert dm['marion'].key?(:proximites)
    assert_not_empty(dm['marion'][:proximites])
    assert dm.key?('être')
    assert dm['être'].key?(:proximites)

    # puts "-- dm['être'] : #{dm['être'].inspect}"
    assert_not_empty(dm['être'][:proximites])

    assert dm['être'].key?(:items)

    items_etre = dm['être'][:items]
    # puts "---- items_etre: #{items_etre.inspect}"
    assert_equal 2, items_etre.count
    assert_equal ProxMot, items_etre.first.class
    assert_equal 'est', items_etre.first.real
    assert items_etre.first.treatable?

    assert dm.key?('ici')
    assert_false dm.key?('rien du tout')

  end

end
