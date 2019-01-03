require './test/test_helper'
Scrivener.require_module('TextAnalyzer')

class TestProximiteSimple < Test::Unit::TestCase

  test '`scriv prox --help` retourne l’aide de la commande' do
    run_command('scriv prox --help')
    assert_match('Aide à la commande `proximites`', CLI::Test.output)
  end

  test '`scriv prox` lancé sur un projet vide produit une erreur normale' do
    assert_nothing_raised {
      run_command('scriv prox ./test/assets/vide/vide.scriv')
    }
    assert_erreur(TextAnalyzer::ERRORS[:proximites][:no_text]) {
      run_command('scriv prox ./test/assets/vide/vide.scriv')
    }
  end

  test '`scriv prox ./test/assets/marion` produit le dossier .textanalyzer correct' do
    file_name_list = [
      'all_resultats.text', 'analyse.msh','data.msh', 'table_resultats.msh',
      'texte_entier_lemmatized.txt', 'texte_entier.txt', 'whole_text.msh'
    ]
    hidden_folder     = './test/assets/marion/.textanalyzer'
    scriv_hidden_folder = './test/assets/marion/.scriv'
    FileUtils.rm_rf(hidden_folder) if File.exists?(hidden_folder)
    FileUtils.rm_rf(scriv_hidden_folder) if File.exists?(scriv_hidden_folder)

    file_name_list.each do |fname|
      pth = File.join(hidden_folder, fname)
      assert_false( pth.file?, 'Le fichier "%s" ne devrait pas exister' % pth)
    end

    stop_mode_test # pour voir le backtrace
    run_command('scriv prox ./test/assets/marion/marion.scriv')

    # débug
    puts CLI::Test.output

    # Le dossier .textanalyzer doit contenir tous les éléments voulus
    file_name_list.each do |fname|
      pth = File.join(hidden_folder, fname)
      assert(pth.file?, 'Le fichier "%s" devrait exister' % pth)
    end

  end
end
