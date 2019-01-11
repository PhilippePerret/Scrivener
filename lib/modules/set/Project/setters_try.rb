# encoding: UTF-8
=begin
=end
require_relative '../setters_before'

class Scrivener
class Project


  # ---------------------------------------------------------------------
  # Méthodes de modification des données

  # POUR FAIRE DES ESSAIS AVEC LA COMMANDE `scriv set essai`
  def set_essai value = nil
    # puts "La valeur de value est #{value.inspect}"
    # dproximites = project.binder_item('B6C40A17-4527-4481-9547-64252E551B0D')

    second_chapitre   = project.binder_item('76E56CA6-F25A-41E6-A513-44309432382F')
    premier_chapitre  = project.binder_item('0F81282D-A49B-43E4-8EDB-31E192CBF90A')
    chapitre_trois    = project.binder_item('8A0B3C46-465A-452B-992E-FF90FC4267F9')

    # # ui_common.binder.unselect_all
    # ui_common.save

    # puts '--' + ui_common.editor1.view_node.count.inspect
    # puts '-- view_node 12' + ui_common.editor1.view_node.elements['ShowHeader'].text.inspect

    # ui_common.editor1.header_visible(false)
    # ui_common.editor2.header_visible(true)
    # ui_common.editor1.footer_visible(true)
    # ui_common.editor2.footer_visible(false)
    # ui_common.save
    # puts 'Je rends l’header visible ou invisible'

    # puts '--- second_chapitre : %s::{%s}' % [second_chapitre.title, second_chapitre.class.to_s]
    # puts '--- premier_chapitre: %s::{%s}' % [premier_chapitre.title, premier_chapitre.class.to_s]
    # ui_common.editor1.content= chapitre_trois
    # # ui_common.editor1.content= [premier_chapitre, second_chapitre]
    # ui_common.editor2.content= second_chapitre

    # ui_common.editor1.reset_historique
    # ui_common.editor1.add_historique([premier_chapitre, second_chapitre, chapitre_trois], {last_is_current: true})
    ui_common.editor1.reset_historique
    ui_common.editor1.add_historique([chapitre_trois, second_chapitre, premier_chapitre], {last_is_current: true})

    ui_common.save
  end

end #/Project
end #/Scrivener
