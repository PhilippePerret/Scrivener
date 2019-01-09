# encoding: UTF-8
=begin
  Pour sortir les résultats numéraires
=end
class TextAnalyzer
class Analyse
class TableResultats
class Output

  # Grand retrait
  GRET = INDENT*3

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
    # tbr est analyse.table_resultats
    tbr   = self.data # passé à l'instanciation'

    # Employés plusieurs fois
    mots_count = wtx.mots.count
    pages_count_by_sign = wtx.pages_count(:signes)
    pages_count_by_word = wtx.pages_count(:mots)

    liste_nombres = [
      [t('count.signs'), wtx.length, {u: t('unit.sign', {s: wtx.length.s})}],
      [t('count.words.total'), mots_count, {u: t('unit.word', {s: mots_count.s})}],
      [GRET+t('without.min proximity.min.plur'), wtx.mots.hors_proximites.count, {after: wtx.mots.hors_proximites.pct, color: :bleu}],
      [GRET+t('with.min proximity.min.plur'), wtx.mots.en_proximites.count, {after: wtx.mots.en_proximites.pct, color: :rouge}],
      [t('count.pages'), wtx.pages_count, {u: t('unit.page', {s: wtx.pages_count.s})}],
      [GRET+t('with.min unit.signs.min')+' (1500/p.)', pages_count_by_sign, {u: t('unit.page', {s: pages_count_by_sign.s})}],
      [GRET+t('with.min unit.words.min')+' (250/p.)', pages_count_by_word, {u: t('unit.page', {s: pages_count_by_word.s})}],
      [t('count.words.different'), tbr.mots.differents.count, {color: :bleu, after: tbr.mots.differents.pct}],
      [t('count.words.uniq'), tbr.mots.uniques.count, {after: tbr.mots.uniques.pct}],
      [t('count.canons'), tbr.canons.nombre, {after: tbr.canons.pourcentage, aide: :canons}],
      [GRET+t('with.min proximity.min.plur'), tbr.canons.en_proximites.count,   {after: tbr.canons.en_proximites.pct}],
      [GRET+t('without.min proximity.min.plur'), tbr.canons.hors_proximites.count, {after: tbr.canons.hors_proximites.pct}],
      [t('count.proxs'), tbr.proximites.count, {color: :rouge, after: tbr.proximites.pourcentage, aide: :proximities}],
    ]
    tbr.proximites_par_tranches.each do |tranche, dtranche|
      liste_nombres << [GRET+'< %i' % tranche, dtranche[:common], {after: (' %i' % dtranche[:all]), aide: (tranche == 250 ? :tranches_proxs : nil)}]
    end
    liste_nombres += [
      [GRET+t('average.distance.tit'), tbr.moyenne_eloignements_common, {after: ' %i' % tbr.moyenne_eloignements, aide: :distance}],
    ]

    # L'entête
    ecrit entete_table_nombres
    # Chaque nombre est affiché
    liste_nombres.each do |lib, nombre, sopts|
      ecrit line_nombre('  %s' % lib, nombre, sopts || Hash.new)
    end
    ecrit CLI.separator(return: false, tab: '  ')

    # On finit par écrire l'aide
    ecrit messages_aide

  end
  # /table_nombres


  def messages_aide
    helpcap = t('help.cap')
    INDENT + [
      String::RC*3,
      helpcap,
      ('=' * helpcap.length),
      *@aide
    ].join(String::RC + INDENT)
  end

  def line_nombre label, valeur, options = nil
    @indice_aide ||= 0
    @aide ||= Array.new
    if options[:aide]
      @indice_aide += 1
      label.concat(' ' + @indice_aide.to_expo)
      @aide << INDENT+'(%i) %s' % [@indice_aide, t('helps.table_counts.%s' % options[:aide])]
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
