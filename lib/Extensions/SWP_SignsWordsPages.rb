# encoding: UTF-8
#
# SignsWordsPages
# Version 1.0.0
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
  attr_accessor :signs

  def initialize nombre, is = :signs
    self.send("#{is}=".to_sym, nombre)
  end
  def pages
    @pages ||= pages_real.ceil
  end
  def words
    @words ||= (signs.to_f / SIGNS_PER_WORD).round
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

  def pages_real
    @pages_real ||= (signs.to_f / SIGNS_PER_PAGE).round(2)
  end

  # ---------------------------------------------------------------------
  #   Méthodes d'helper
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
      assert_equal 1, SWP.new(1500 + 1).pages
      assert_equal 2, SWP.new(1500 + 300).pages
      assert_equal 2, SWP.new(1500 + 750).pages
    end
    test 'Le nombre de page flottant est bien calculé' do
      assert_equal 1, SWP.new(1500).pages_real
      assert_equal 1, SWP.new(1500 + 1).pages_real
      assert_equal 1.33, SWP.new(1500 + 500).pages_real
      assert_equal 1.5, SWP.new(1500 + 750).pages_real
    end
    test 'Le retour humain du nombre de pages est correct' do
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
  end
end
