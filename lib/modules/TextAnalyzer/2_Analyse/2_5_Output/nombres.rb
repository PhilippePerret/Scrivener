# encoding: UTF-8
=begin
  Pour sortir les résultats numéraires
=end
class TextAnalyzer
class Analyse
class TableResultats
class Output

  AIDES = {
    proximites:     'Le premier nombre comptabilise toutes les proximités. Le second présente le pourcentage de proximités par rapport au nombre total de mots.',
    tranches_proxs: 'Les proximités sont présentées par tranches de nombre de signes avec deux nombres. Le premier comptabilise seulement les proximités « communes », c’est-à-dire inférieures à 1500 signes. Le second chiffre comptabilise toutes les proximités.',
    eloignement:    'La moyenne d’éloignement entre deux mots identiques (ou similaires) ne concerne que les proximités',
    canons:         'Les "canons" sont les formes canoniques ("prendre" est le canon de "prends" et "pris").'
  }

  # Construit et retourne la table de tous les nombres
  #
  # Noter la différence entre la propriété :mots de texte_entier qui contient
  # tous les mots du texte et la propriété :mots de la table_resultats qui
  # contient les mots différents du texte.
  #
  def table_nombres opts = nil
    defaultize_options(opts)

    # Les deux données importantes
    wtx   = analyse.texte_entier
    tbr   = analyse.table_resultats

    liste_nombres = [
      ['N de caractères',         wtx.length, {u: 'signe%{s}'}],
      ['N total de mots',         wtx.mots.count, {u: 'mot%{s}'}],
      ['R1 sans proximités',      wtx.mots.hors_proximites.count, {after: wtx.mots.hors_proximites.pct, color: :bleu}],
      ['R1 en proximités',        wtx.mots.en_proximites.count, {after: wtx.mots.en_proximites.pct, color: :rouge}],
      ['N de pages estimé',       wtx.pages_count, {u: 'page%{s}'}],
      ['R1 suivant signes (1500/p.)', wtx.pages_count(:signes), {u: 'page%{s}'}],
      ['R1 suivant mots   (250/p.)',  wtx.pages_count(:mots), {u: 'page%{s}'}],
      ['N de mots différents',    tbr.mots.differents.count, {color: :bleu, after: tbr.mots.differents.pct}],
      # ['N de mots similaires',    tbr.mots.similaires.count],
      ['N de mots uniques',       tbr.mots.uniques.count, {after: tbr.mots.uniques.pct}],
      ['N de canons',             tbr.canons.nombre, {after: tbr.canons.pourcentage, aide: :canons}],
      ['R1 avec proximités',     tbr.canons.en_proximites.count,   {after: tbr.canons.en_proximites.pct}],
      ['R1 sans proximités',     tbr.canons.hors_proximites.count, {after: tbr.canons.hors_proximites.pct}],
      ['N de proximités',         tbr.proximites.count, {color: :rouge, after: tbr.proximites.pourcentage, aide: :proximites}],
    ]
    tbr.proximites_par_tranches.each do |tranche, dtranche|
      liste_nombres << ['R1 < %i' % tranche, dtranche[:common], {after: (' %i' % dtranche[:all]), aide: (tranche == 250 ? :tranches_proxs : nil)}]
    end
    liste_nombres += [
      ['R1 Éloignement moyen (signes)',         tbr.moyenne_eloignements_common, {after: ' %i' % tbr.moyenne_eloignements, aide: :eloignement}],
    ]

    # L'entête
    ecrit entete_table_nombres
    # Chaque nombre est affiché
    liste_nombres.each do |lib, nombre, opts|
      case lib[0..1]
      when 'N ' then lib = '  Nombre%s' % [lib[1..-1]]
      when 'M ' then lib = '  Moyenne%s' % [lib[1..-1]]
      when '% ' then lib = '  Pourcentage%s' % [lib[1..-1]]
      when 'R1' then lib = ' ' * 6 + lib[3..-1]
      end
      ecrit line_nombre('  %s' % lib, nombre, opts || Hash.new)
    end
    ecrit CLI.separator(return: false)

    # On finit par écrire l'aide
    ecrit messages_aide

  end
  # /table_nombres

  def messages_aide
    '

AIDE
====
%s
    ' % [@aide.join(String::RC)]
  end
  def line_nombre label, valeur, options = nil
    @indice_aide ||= 0
    @aide ||= Array.new
    if options[:aide]
      @indice_aide += 1
      label.concat(' ' + @indice_aide.to_expo)
      @aide << '(%i) %s' % [@indice_aide, AIDES[options[:aide]]]
    end
    valeur_init = valeur.to_i
    valeur = valeur.to_s.rjust(7)
    options.key?(:u) && valeur.concat(' ' + options[:u] % {s: valeur_init > 1 ? 's' : ''})
    options[:after] && valeur.concat(' | ' + options[:after])
    options.key?(:color) && valeur = valeur.send(options[:color])
    '%s : %s' % [label.ljust(40), valeur]
  end
  # /line_nombre


end #/Output
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
