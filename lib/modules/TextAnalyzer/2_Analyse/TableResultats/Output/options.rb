# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class TableResultats
class Output

  attr_accessor :options

  def defaultize_options opts
    opts ||= Hash.new
    # Par défaut la sortir se fait en ligne de commande
    opts.key?(:output) || opts.merge!(output: :cli)

    self.options = opts
  end


end #/Output
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
