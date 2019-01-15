# frozen_string_literal: true
# encoding: UTF-8

DATA_CHECK_INSTALL = {
  scrivener_app: {
    success_msg:  'Scrivener installed in Applications folder',
    failure_msg:  'Scrivener application should be found in Applications folder',
    value:        'File.exist?(File.join(scrivener_app_path))',
    evaluate:     'value == expected',
    expected:     'true',
    solve:        'Download Scrivener application'
  },
  scrivener_version: {
    success_msg:  'Scrivener version ok (%{value}, minimum: %{expected})',
    failure_msg:  'Bad version of Scrivener (minimum: %{expected}, current: %{value})',
    evaluate:     'value >= expected',
    value:        'scrivener_app_version',
    expected:     '3.1',
    solve:        'Update your Scrivener application'
  },
  scriv_app: {
    success_msg:  '`scriv` CLI application found',
    failure_msg:  '`scriv` CLI application unfound…',
    value:        'File.exist?(Scrivener.fpath(\'bin\',\'scriv.rb\'))',
    expected:     'true',
    evaluate:     'value == expected',
    solve:        'Download the last stable version at: https://github.com/PhilippePerret/Scrivener'
  },
  scriv_builder_command: {
    success_msg:  'The builder of the `scriv` command exists.',
    failure_msg:  'The builder of the `scriv` command is unfound…',
    value:        'File.exist?(Scrivener.fpath(\'bin\',\'build_command.rb\'))',
    expected:     'true',
    evaluate:     'value == expected',
    solve:        'Download a stable version of `scriv` at: https://github.com/PhilippePerret/Scrivener'
  },
  scriv_alias: {
    success_msg:  'The symbolic link to launch the `scriv` command exist?',
    failure_msg:  'The symbolic link to launch the `scriv` command doesn’t exist.',
    value:        'joue_commande_scriv_simple',
    expected:     'true',
    evaluate:     'value == expected',
    solve:        [
      'Go to Applications folder with: `cd "%s"`)' % [APPFOLDER],
      'Run the install script: `ruby ./bin/build_command.rb`'
    ]
  },
  ruby_version: {
    success_msg:  'Ruby version ok (%{value}, required: %{expected}).',
    failure_msg:  'Ruby version not ok (required: %{expected}, current: %{value}).',
    value:        'RUBY_VERSION.to_f',
    evaluate:     'value >= expected',
    expected:     '2.3', # version ruby
    solve:        'Update your ruby distribution.'
  },
  required_gems: {
    success_msg:  'All of the ruby gems are installed and up to date.',
    failure_msg:  'Gem list isn’t valid (cf. ci-dessous)',
    value:        'all_gems_valid?',
    expected:     'true',
    evaluate:     'value === expected',
    solve:        [
      'Go to scriv command folder:  `cd "%s"`' % [APPFOLDER],
      'Run `bundle install` (to install all the required gems)'
    ]
  },
  tree_grabber: {
    success_msg:  'Tree-Tagger (for lemmatization) is installed.',
    failure_msg:  'Tree-Tagger (for lemmatization) is unfound…',
    value:        'File.exist?(File.join("/","usr","local","TreeTagger"))',
    expected:     'true',
    evaluate:     'value == expected',
    solve:        [
      'Download the tree-tagger command at: http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/#parfiles',
      'Put the downloaded folder in your "/usr/local" folder (run "open /usr/local" in Terminal app to open it)',
      'Make an "alias" with Terminal app : `ln -s /usr/local/TreeTagger/cmd/tree-tagger-english /usr/local/bin`'
                  ]
  }
}
