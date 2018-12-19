require './test/test_helper'

class TestSimpleHelp < Test::Unit::TestCase

  class << self
    attr_accessor :reponse
    def startup
      self.reponse = run_command('scriv')
    end
  end #<< self

  def reponse
    @reponse ||= self.class.reponse
  end


  test 'Sans argument, c’est la page d’aide qui est affichée' do
    assert_match('MANUEL', reponse, 'Sans argument, c’est le manuel qui devrait s’afficher.')
  end

  test 'la page d’aide est correcte' do
    assert_match('MANUEL DU PROGRAMME `scriv`', reponse, 'Le manuel devrait contenir « MANUEL DU PROGRAMME `scriv` »')
    assert_match('Description', reponse)
  end

end
