# encoding: UTF-8
=begin
  Pour sortir les résultats numéraires
=end
class TextAnalyzer
class Analyse
class TableResultats
class Output

  # Construit et retourne la table de tous les nombres
  def table_nombres opts = nil
    wholetext = analyse.texte_entier
    tableres  = analyse.table_resultats
    defaultize_options(opts)
    liste_nombres = [
      ['N de caractères',         wholetext.length, {u: 'signes'}],
      ['N total de mots',         wholetext.mots.count, {u: 'mots'}],
      ['N de pages (/signes)',    wholetext.pages_count(:signes), {u: 'pages'}],
      ['N de pages (/mots)',      wholetext.pages_count(:mots), {u: 'pages'}],
      ['N de pages estimé',       wholetext.pages_count, {u: 'pages'}],
      ['N de mots différents',    tableres.mots.differents.count, {color: :bleu}],
      ['N de mots uniques',       tableres.mots.uniques.count],
      ['N de canons',             tableres.canons.count],
      ['    avec proximités',     tableres.canons.avec_proximites.count],
      ['    sans proximités',     tableres.canons.sans_proximites.count],
      ['N de proximités',         tableres.proximites.count, {color: :rouge}],
      ['% de canons en proximité',  tableres.canons.pourcentage_en_proximite]
    ]
    tableres.proximites_par_tranches.each do |tranche, dtranche|
      liste_nombres << [' '*12 + '< %i' % tranche, dtranche[:common], {after: (' (all: %i)' % dtranche[:all])}]
    end
    liste_nombres += [
      ['M d’éloignement (en signes)',         tableres.moyenne_eloignements_common, {after: ' (all: %i)' % tableres.moyenne_eloignements}],
    ]

    liste_nombres.each do |lib, nombre, opts|
      case lib[0..1]
      when 'N ' then lib = '  Nombre%s' % [lib[1..-1]]
      when 'M ' then lib = '  Moyenne%s' % [lib[1..-1]]
      when '% ' then lib = '  Pourcentage%s' % [lib[1..-1]]
      end
      ecrit line_nombre('  %s' % lib, nombre, opts || Hash.new)
    end
  end

  def line_nombre label, valeur, options = nil
    valeur = valeur.to_s.rjust(7)
    options.key?(:color) && valeur = valeur.send(options[:color])
    '%s : %s %s %s' % [label.ljust(40), valeur, options[:u] || '', options[:after] || '']
  end

  # Pour sortir tous les nombres
  def nombres opts = nil
    defaultize_options(opts)
    case options[:output]
    when :cli
      puts "Nombre de mots         : #{data.mots.count}"
      puts "Nombre de mots uniques : #{data.nombre_mots_uniques}"
    when :file
    end
  end

end #/Output
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
