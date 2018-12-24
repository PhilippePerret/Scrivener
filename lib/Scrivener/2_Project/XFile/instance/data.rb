# encoding: UTF-8
=begin
  Instance Scrivener::Project::XFile
  ----------------------------------
  Pour la gestion du fichier .scrivx du projet

=end
class Scrivener
class Project
class XFile

  # Pour définir l'objectif général du projet
  def objectif= hdata
    cibles = XML.get_or_add(root, 'ProjectTargets')
    drafttarget = XML.get_or_add(cibles, 'DraftTarget')
    drafttarget.attributes['Type'] = hdata.delete(:type)
    drafttarget.text = hdata.delete(:nombre)
    deadline = hdata.delete(:deadline)
    deadline && begin
      drafttarget.attributes['Deadline'] = deadline
    end
    # Les attributs restants, en ajoutant les valeurs par défaut si c'est
    # une création de cible
    hdata.key?(:count_included_only) || drafttarget.attributes['CountIncludedOnly'] || hdata.merge!(count_included_only: true)
    hdata.key?(:current_compile_group_only) || drafttarget.attributes['CurrentCompileGroupOnly']  ||hdata.merge!(current_compile_group_only: false)
    hdata.key?(:ignore_deadline) || drafttarget.attributes['IgnoreDeadline']  || hdata.merge!(ignore_deadline: deadline.nil?)
    hdata.each do |prop, val|
      drafttarget.attributes[prop.camelize] = val ? 'Yes' : 'No'
    end
    set_modified
  end

end #/XFile
end #/Project
end #/Scrivener
