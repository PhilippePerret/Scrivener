# encoding: UTF-8
=begin
  Extension de la classe Mot pour la gestion des proximités
  d'un projet Scrivener
=end
class TextAnalyzer
class Analyse
class WholeText
class Mot

  def binder_item
    @binder_item || get_binder_item_of_mot
  end

  def get_binder_item_of_mot
    # Note : c'est certainement par l'UUID qu'on va pouvoir le retrouver
    # D'après l'offset du mot, on déduit son document
    # D'après le document on prend l'UUID
    # D'après l'uuid on prend l'instance BinderItem du projet courant
    puts "-- Je cherche le binder_item du mot #{self.real}"
    sleep 5
  end

end #/Mot
end #/WholeText
end #/Analyse
end #/TextAnalyzer
