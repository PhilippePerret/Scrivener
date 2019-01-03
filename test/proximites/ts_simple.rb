require './test/test_helper'
Scrivener.require_module('TextAnalyzer')

class TestProximiteSimple < Test::Unit::TestCase

  # test '`scriv prox --help` retourne l’aide de la commande' do
  #   run_command('scriv prox --help')
  #   assert_match('Aide à la commande `proximites`', CLI::Test.output)
  # end

  # test '`scriv prox` lancé sur un projet vide produit une erreur normale' do
  #   assert_nothing_raised {
  #     run_command('scriv prox ./test/assets/vide/vide.scriv')
  #   }
  #   assert_erreur(TextAnalyzer::ERRORS[:proximites][:no_text]) {
  #     run_command('scriv prox ./test/assets/vide/vide.scriv')
  #   }
  # end

  test '`scriv prox ./test/assets/ajout` produit le dossier .scriv correct' do
    hidden_folder     = './test/assets/ajout/.scriv'
    proximites_file    = File.join(hidden_folder, 'table_resultats.msh')
    lemmatisation_data_file = File.join(hidden_folder, 'lemmatisation_all_data')
    lemmatisation_file = File.join(hidden_folder, 'table_lemmatisation.msh')
    whole_texte_file    = File.join(hidden_folder, 'whole_texte.txt')
    FileUtils.rm_rf(hidden_folder) if File.exists?(hidden_folder)

    run_command('scriv prox ./test/assets/ajout/test.scriv')

    # débug
    puts CLI::Test.output

    assert hidden_folder.folder?
    assert proximites_file.file?
    assert lemmatisation_file.file?
    assert lemmatisation_data_file.file?
    assert whole_texte_file.file?

  end
end
