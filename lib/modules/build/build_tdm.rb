# encoding: UTF-8
=begin
  Module pour la commande 'build'
=end
module BuildTdmModule
  # Construction des documents du projet
  def exec_building
    CLI.debug_entry
    documents_params_are_valid_or_raise
    confirmation_operation_build_documents || return
    self.class.simulation || proceed_build_documents
    CLI.debug_exit
  end

  # Vérifie qu'on ait bien toutes les données pour procéder à l'opération
  def documents_params_are_valid_or_raise
    # TODO On doit savoir de quel document on part
    # TODO Le document dont on part est-il valide?
  end

  # Demande la confirmation de l'opération
  # Return true si on doit procéder, false otherwise
  def confirmation_operation_build_documents
    return true
  end

  # On procède vraiment à l'opération
  def proceed_build_documents

  end
end#/module
