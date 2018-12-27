require 'rake/testtask'

# Pour lancer les tests :
#   $ rake test:textanalyzer
Rake::TestTask.new do |t|
  # t.libs = ["lib"]|
  t.name = 'test:textanalyzer'
  t.warning     = true
  t.verbose     = true
  t.test_files  = FileList['test/text_analyzer/**/ts_*.rb']
end
