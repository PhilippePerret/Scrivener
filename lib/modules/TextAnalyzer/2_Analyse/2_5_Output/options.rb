# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class TableResultats
class Output

  attr_accessor :options
  attr_accessor :options_have_been_defaultized

  def defaultize_options opts
    # options_have_been_defaultized && return
    opts ||= Hash.new
    # Par défaut la sortir se fait en ligne de commande
    opts.key?(:output)        || opts.merge!(output: :cli)
    opts.key?(:output_format) || opts.merge!(output_format: :text)
    opts.key?(:sorted_by)     || opts.merge!(sorted_by: :alpha)

    opts.merge!(analyse: self.analyse)

    l, lm =
      case CLI.params[:mots]
      when nil    then [50, 100]
      when 'all'  then [Float::INFINITY, Float::INFINITY]
      else [CLI.params[:mots].to_i, CLI.params[:mots].to_i]
      end
    opts.merge!(limit: l, limit_mots: lm)

    self.options = opts

    # On charge les modules en fonction des options
    load_output_modules

    self.options_have_been_defaultized = true

  end


end #/Output
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
