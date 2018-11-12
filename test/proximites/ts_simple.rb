require './test/test_helper'

class TestProximiteSimple < Test::Unit::TestCase

  test '`scriv prox --help` retourne l’aide de la commande' do
    reponse = run_commande('scriv prox --help')
    assert_match('Aide à la commande `proximites`', reponse)
  end

  test '`scriv prox ./test/assets/ajout` produit le dossier .ScrivCmd correct' do
    hidden_folder     = './test/assets/ajout/.ScrivCmd'
    proximites_file    = File.join(hidden_folder, 'tableau_proximites.msh')
    lemmatisation_data_file = File.join(hidden_folder, 'lemmatisation_all_data')
    lemmatisation_file = File.join(hidden_folder, 'table_lemmatisation.msh')
    whole_texte_file    = File.join(hidden_folder, 'whole_texte.txt')
    FileUtils.rm_rf(hidden_folder) if File.exists?(hidden_folder)
    reponse = run_commande('scriv prox ./test/assets/ajout/test.scriv')
    # puts reponse
    assert hidden_folder.folder?
    assert proximites_file.file?
    assert lemmatisation_file.file?
    assert lemmatisation_data_file.file?
    assert whole_texte_file.file?

  end
end
