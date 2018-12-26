# encoding: UTF-8
#
# SignsWordsPages
# Version 1.0.4
#
# Note version 1.0.4
#   Renvoie de la valeur nil au lieu de zéro avec l'option :zero_if_nil
# Note version 1.0.3
#   Implémentation de la méthode de classe `signs_from_human_value`
#
# Note version 1.0.2
#   Explication de ce que fait la classe
#
# Note version 1.0.1
#   Ajout des comparaisons >, <, >=, <=
#
# Cette classe permet de gérer très facilement les nombres de signes, de
# mots et de pages. On définit un objet SWP à l'aide d'un nombre de signes,
# (swp = SWP.new(12)) de mots (swp = SWP.new(4, :mots)) ou de pages (swp =
# SWP.new(3, :pages)) puis on peut utiliser cet objet par exemple pour
# obtenir la page de l'objet (swp.page), un nombre de pages correspondant
# au nombre de mots (swp.mots) ou faire des comparaisons et des additions
# (swp > 4 # => true si swp a plus de 4 signes, swp += 12 pour ajouter
# 12 signes à swp, ou swp += swp pour doubler swp)
#
# @usage
#     taille = SWP.new(nombre_signes)
#     taille = SWP.new(12, :pages)
#     taille = SWP.new(24, :words)
#     taille = SWP.new(24, :signs)
#
#   taille.pages  => nombre de pages
#   taille.hpages => Version humaine du nombre de pages (1)
#   taille.mots   => nombre de mots
#   taille.hmots  => "<nombre> mot<s>"
#   taille.words  => nombre de mots
#   taille.signs
#   taille.chars
#   taille.cars   => nombre de signes/caractères
#
class SWP # Pour Signs-Words-Pages

  SIGNS_PER_PAGE  = 1500.0
  SIGNS_PER_WORD  = 6
  WORD_PER_PAGE   = 250
  DIVISIONS = {
    demie: 'demie', tiers: '1/3', deux_tiers: '2/3', quart: '1/4', trois_quarts: '3/4'
  }
  LANG = :fr
  WORD_BY_LANG = {
    fr: {mot: 'mot', page: 'page', sign: 'signe'},
    en: {mot: 'word', page: 'page', sign: 'sign'}
  }

  class << self
    # Reçoit une valeur humaine (comme "4p" ou "3.5 mots") et retourne
    # le nombre de caractères correspondants.
    def signs_from_human_value valeur, raise_if_not_value = false
      case valeur
      when /^([0-9\.]+) ?p(ages)?$/
        return ($1.to_f * SIGNS_PER_PAGE.to_i).to_i
      when /^([0-9\.]+) ?m(ots)?/, /^([0-9]+) ?w(ords)?/
        return ($1.to_f * 7).to_i
      when /^([0-9\.]+) ?c?(hars)?$/
        return $1.to_i
      else
        if raise_if_not_value
          raise(ERRORS[:bad_objectif_value])
        else
          return nil
        end
      end
    end
  end #/<< self

  # ---------------------------------------------------------------------
  attr_writer :signs
  attr_accessor :options

  # +options+
  #     :zero_if_nil      Si true, et que le nombre de signes est 0,
  #                       on retourne NIL à toute demande de valeur.
  #
  def initialize nombre, is = nil, opts = nil
    is ||= :signs
    self.options = opts || Hash.new
    self.send("#{is}=".to_sym, nombre)
  end

  # Avec l'option :zero_if_nil, les méthodes doivent retourner nil si
  # le nombre de signes est de zéro.
  def val_or_nil val
    options[:zero_if_nil] || (return val)
    signs.nil? ? nil : val
  end

  def signs
    options[:zero_if_nil] && @signs == 0 ? nil : @signs
  end
  def pages
    @pages ||= signs.nil? ? nil : pages_real.ceil
  end
  # La page sur laquelle on se trouve
  def page
    @page ||= signs.nil? ? nil : (pages_real.floor + 1)
  end
  def words
    @words ||= signs.nil? ? nil : ((signs.to_f / SIGNS_PER_WORD).round)
  end
  alias :mots :words

  def pages= valeur
    @pages = valeur
    self.words = valeur * WORD_PER_PAGE
    self.signs = valeur * SIGNS_PER_PAGE
  end
  def words= valeur
    @words = valeur
    self.signs = valeur * SIGNS_PER_WORD
  end
  alias :mots= :words=
  def chars= valeur; @signs = valeur end
  alias :cars= :chars=
  alias :cars :signs
  alias :chars :signs

  def pages_real_round
    @pages_real_round ||= val_or_nil((signs.to_f / SIGNS_PER_PAGE).round(2))
  end
  def pages_real
    @pages_real ||= val_or_nil((signs.to_f / SIGNS_PER_PAGE))
  end

  # ---------------------------------------------------------------------
  #   Méthodes d'opération
  def + nbsigns
    return SWP.new(self.signs + real_nbsigns(nbsigns))
  end

  def - nbsigns
    nb = real_nbsigns(nbsigns)
    nb < self.signs || raise('Impossible de retirer plus de signes que l’objet n’en contient.')
    return SWP.new(self.signs - nb)
  end

  def > nbsigns
    return self.signs > real_nbsigns(nbsigns)
  end
  def >= nbsigns
    return self.signs >= real_nbsigns(nbsigns)
  end
  def < nbsigns
    return self.signs < real_nbsigns(nbsigns)
  end
  def <= nbsigns
    return self.signs <= real_nbsigns(nbsigns)
  end

  # ---------------------------------------------------------------------
  #   Méthodes d'helper

  def hpage
    @hpage ||= '%i p.' % page
  end
  def hpages
    @hpages ||= begin
      u, d = pages_real.to_s.split('.')
      u = u.to_i
      d = d.to_i
      if d == 0
        '%{nb} page%{s}' % {nb: u, s: (u > 1 ? 's' : '')}
      else
        div = division_by_decimal(pages_real - u)
        if u == 0
          if div == :demie
            'une demie page'
          else
            '%s de page' % [DIVISIONS[div]]
          end
        else
          if div == :trois_quarts
            '%{nb} page%{s} 3/4' % {nb: u, s: (u > 1 ? 's' : '')}
          else
            '%{nb} page%{s} et %{div}' % {nb: u, s: (u > 1 ? 's' : ''), div: DIVISIONS[div]}
          end
        end
      end
    end
  end

  def hwords
    @hwords ||= '%i %s%s' % [words, WORD_BY_LANG[LANG][:mot], words > 1 ? 's' : '']
  end

  def hsigns
    @hwords ||= '%i %s%s' % [signs, WORD_BY_LANG[LANG][:sign], signs > 1 ? 's' : '']
  end
  alias :hsignes :hsigns


  # ---------------------------------------------------------------------
  #   Méthodes fonctionnelles

  # Pour les opérations, on peut envoyer soit un nombre soit un objet SWP
  # Dans les deux cas, on retourne un nombre (Fixnum)
  def real_nbsigns nb
    nb.is_a?(SWP) || nb.is_a?(Fixnum) || raise('On ne peut additionner que des SWP ou des nombres de signes.')
    nb.is_a?(SWP) && nb = nb.signs
    return nb
  end

  def division_by_decimal d
    if d > 0.1 && d < 0.3
      :quart
    elsif d > 0.3 && d < 0.45
      :tiers
    elsif d > 0.45 && d < 0.55
      :demie
    elsif d > 0.55 && d < 0.7
      :deux_tiers
    elsif d > 0.7
      :trois_quarts
    end
  end

end

if $0 == __FILE__
  require 'test/unit'
  class TestDeSWP < Test::Unit::TestCase
    test 'Le nombre de pages papier est bien calculé' do
      assert_equal 1, SWP.new(1500).pages
      assert_equal 2, SWP.new(1500 + 1).pages
      assert_equal 2, SWP.new(1500 + 300).pages
      assert_equal 2, SWP.new(1500 + 750).pages
    end
    test 'La page sur laquelle on se trouve est bien calculée' do
      [0, 100, 500, 1000, 1498].each do |val|
        assert_equal 1, SWP.new(val).page
      end
      [1500, 1600, 2000].each do |val|
        assert_equal 2, SWP.new(val).page
      end
    end
    test 'Le nombre de page flottant est bien calculé' do
      assert_equal 1, SWP.new(1500).pages_real_round
      assert_equal 1, SWP.new(1500 + 1).pages_real_round
      assert_equal 1.33, SWP.new(1500 + 500).pages_real_round
      assert_equal 1.5, SWP.new(1500 + 750).pages_real
    end
    test 'Le retour humain du nombre de pages est correct' do
      assert_equal '1/4 de page', SWP.new(1500 / 4).hpages
      assert_equal '2/3 de page', SWP.new(1000).hpages
      assert_equal '1 page', SWP.new(1500).hpages
      assert_equal '2 pages', SWP.new(3000).hpages
      assert_equal 'une demie page', SWP.new(700).hpages
      assert_equal '1 page et demie', SWP.new(1500 + 760).hpages
      assert_equal '2 pages 3/4', SWP.new(3000 + (3 * 1500 / 4)).hpages
      assert_equal '3 pages et 2/3', SWP.new(4500 + 1000).hpages
    end
    test 'Le nombre de mots d’après signes est bien calculé' do
      assert_equal 2, SWP.new(14).mots
    end
    test 'Le nombre de mots et signes d’après pages est bien calculé' do
      p = SWP.new(1, :pages)
      assert_equal 1, p.pages
      assert_equal 250, p.mots
      assert_equal 250, p.words
      assert_equal 1500, p.signs
      assert_equal 1500, p.chars
    end
    test 'On peut additionner correctement deux objets' do
      o1 = SWP.new(700)
      o2 = SWP.new(300)
      o3 = nil
      assert_nothing_raised { o3 = o1 + o2 }
      assert o3.is_a?(SWP)
      assert_equal 1000, o3.signs
      assert_equal '2/3 de page', o3.hpages
    end
    test 'On peut soustraire correctement deux objets' do
      o1 = SWP.new(1000)
      o2 = SWP.new(250)
      o3 = nil
      assert_nothing_raised { o3 = o1 - o2}
      assert o3.is_a?(SWP)
      assert_equal 750, o3.signs
      assert_equal 125, o3.words
      assert_equal 125, o3.mots
    end
    test 'On peut ajouter un nombre de signes à un objet' do
      o = SWP.new(1000)
      assert_equal '2/3 de page', o.hpages
      assert_nothing_raised { o = o + 500}
      assert_equal '1 page', o.hpages
      assert_equal 1500, o.signs
    end
    test 'On peut supprimer un nombre de signes à un objet' do
      o = SWP.new(1500)
      assert_equal '1 page', o.hpages
      assert_nothing_raised { o = o - 500 }
      assert_equal '2/3 de page', o.hpages
      assert_equal 1000, o.signs
    end
    test '+= permet d’ajouter des signes à l’instance elle-même' do
      o = SWP.new(0, :signs)
      assert_equal 0, o.signs
      assert_equal 0, o.mots
      assert_equal 0, o.pages_real
      assert_nothing_raised { o += 500 }
      assert_equal 500, o.signs
      assert_equal 500 / 6, o.mots
      assert_equal 0.33, o.pages_real_round
      assert_equal '1/3 de page', o.hpages
      o2 = SWP.new(1000)
      assert_nothing_raised { o += o2 }
      assert_equal 1500, o.signs
      assert_equal 250, o.mots
      assert_equal 1, o.pages_real
      assert_equal '1 page', o.hpages
    end
    test 'On peut comparer avec > < des SWP et des nombres' do
      o = SWP.new(4)
      assert_nothing_raised { o > 2 }
      assert_false o > 6
      assert o > 2
      assert_nothing_raised { o < 6 }
      assert_false o < 2
      assert o < 6
      assert_nothing_raised { o <= 4 }
      assert o <= 4
      assert o <= 5
      assert_false o <= 2
      assert_nothing_raised { o >= 4 }
      assert o >= 4
      assert o >= 3
      assert_false o >= 6
    end
    test 'On peut comparer avec > < des SWP entre eux' do
      o2 = SWP.new(2)
      o3 = SWP.new(3)
      o4 = SWP.new(4)
      o5 = SWP.new(5)
      o6 = SWP.new(6)
      assert_nothing_raised { o4 > o2 }
      assert_false o2 > o4
      assert o6 > o4
      assert_nothing_raised { o4 < o6 }
      assert_false o4 < o2
      assert o4 < o6
      assert_nothing_raised { o4 <= o4 }
      assert o4 <= o4
      assert o4 <= o5
      assert_false o4 <= o2
      assert_nothing_raised { o4 >= o4 }
      assert o4 >= o4
      assert o4 >= o3
      assert_false o4 >= o6
    end
    test 'La méthode `signs_from_human_value` retourne la bonne valeur' do
      [
        ['4p', 4 * 1500], ['5pages', 5 * 1500], ['6 pages', 6 * 1500],
        ['4m', 4 * 7], ['5mots', 5 * 7], ['6 words', 6 * 7],
        ['4c', 4], ['5', 5]
      ].each do |hv, sv|
        assert_equal sv, SWP.signs_from_human_value(hv)
      end
    end
    test 'La méthode `signs_from_human_value` raise si voulu avec mauvaise valeur' do
      assert_raises { SWP.signs_from_human_value('-', true)}

    end
    test 'La méthode `signs_from_human_value` ne raise pas si voulu avec mauvaise valeur' do
      assert_nothing_raised { SWP.signs_from_human_value('-', false)}
    end
    test 'Les méthodes retourne nil si l’option :zero_if_nil est à true' do
      o = SWP.new(0)
      assert_equal 0, o.signs
      assert_equal 0, o.mots
      assert_equal 0, o.pages
      assert_equal 1, o.page
      o = SWP.new(0, nil, {zero_if_nil: true})
      assert_nil o.signs
      assert_nil o.mots
      assert_nil o.pages
      assert_nil o.page
    end
  end
end
