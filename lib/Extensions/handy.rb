# frozen_string_literal: true
# encoding: UTF-8
=begin
  Méthodes raccourcies pratiques
=end

# Pour obtenir une traduction facilement avec la méthode `t`
def t pth
  str = I18n.translate(pth)
  str.match(/#\{/) ? eval("%Q{#{str}}") : str
end
