# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
  class TableResultats
    class Output

      # Méthode appelée lors de la "défaultisation" des options, pour charger
      # le module de construction des textes en fonction du format de sortie.
      # Par exemple, si le format (:output_format) est :text, on va inclure le
      # module .../Output/modules/text.rb qui contient toutes les méthodes de
      # formatage pour le format texte.
      def load_output_modules
        TextAnalyzer::Analyse::TableResultats::Canon.include_output_module(options[:output_format])
        TextAnalyzer::Analyse::TableResultats::Proximite.include_output_module(options[:output_format])
        TextAnalyzer::Analyse::WholeText::Mot.include_output_module(options[:output_format])
      end
    end #/Output

    # ---------------------------------------------------------------------

    class Canon
      # Charge le module qui contient les méthodes pour sortir au format +fmt+
      # qui peut avoir la valeur :text, :html, etc.
      def self.include_output_module fmt
        include Object.const_get('TextAnalyzerOutputCanonFormat%s' % [fmt.to_s.upcase])
      end
    end #/Canon

    class Proximite
      def self.include_output_module fmt
        include Object.const_get('TextAnalyzerOutputProximiteFormat%s' % [fmt.to_s.upcase])
      end
    end #/Proximite

  end #/TableResultats

  class WholeText
    class Mot
      def self.include_output_module fmt
        include Object.const_get('TextAnalyzerOutputMotFormat%s' % [fmt.to_s.upcase])
      end
    end #/class Mot
  end #/class WholeText

end #/Analyse
end #/TextAnalyzer
