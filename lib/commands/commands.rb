# encoding: UTF-8
=begin

  Commande qui liste toutes les commandes

=end
thisfolder = File.expand_path(File.dirname(__FILE__))

with_short_description = CLI.options[:help]
indentation = ' ' * 12
width_short = 60
dtruncate   = {indent: indentation}.freeze

MANUEL = Array.new
MANUEL << t('commands.titles.command_list.cap', nil, {underlined: '='})
MANUEL << ''
Dir["#{thisfolder}/*.rb"].sort.each do |cmd|
  cmd = cmd.affixe
  MANUEL << INDENT_TIRET + cmd
  if with_short_description
    short_description = t('commands.overviews.%s' % cmd)
    unless short_description.nil?
      MANUEL << indentation + String.truncate(short_description, width_short, dtruncate).join(String::RC) + String::RC*2
    end
  end
end
MANUEL << String::RC * 2
CLI.options[:help] || begin
  MANUEL << '(%s)' % t('commands.notices.h_for_resumes')
end
MANUEL << '(%s)' % t('commands.notices.h_for_command_help')

Scrivener.help(MANUEL.join(String::RC))
