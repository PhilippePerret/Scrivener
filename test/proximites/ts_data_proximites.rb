require './test/test_helper'


class TestDataProximite < Test::Unit::TestCase

  def setup
    Scrivener.require_module('proximites')
    @projet_folder = File.join('.','test','assets','marion')
    @scriv_file    = File.join(@projet_folder, 'marion.scriv')
    @hidden_folder = File.join(@projet_folder, '.ScrivCmd')
    @proximites_file = File.join(@hidden_folder, 'tableau_proximites.msh')
  end

  def data_proximites
    @data_proximites ||= begin
      File.open(@proximites_file,'rb'){|f| Marshal.load(f)}
    end
  end

  test '`scriv prox ./test/assets/marion/marion.scriv` produit des données proximités correctes' do
    FileUtils.rm_rf(@hidden_folder) if File.exists?(@hidden_folder)
    assert_false @hidden_folder.folder?
    run_commande('scriv prox ./test/assets/marion/marion.scriv', 'q')
    # On vérifie les données proxmités
    dp = data_proximites
    assert data_proximites.key?(:mots)
    assert data_proximites.key?(:binder_items)
    assert data_proximites.key?(:current_offset)
    assert data_proximites.key?(:project_path)
    assert data_proximites.key?(:proximites)
    assert data_proximites.key?(:created_at)

    assert_equal File.expand_path(@scriv_file), dp[:project_path]

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
