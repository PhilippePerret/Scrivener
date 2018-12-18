# encoding: UTF-8
class Scrivener
  class Project
    class XFile

      # Pour créer un dossier principal, au niveau supérieur (comme le
      # dossier Manuscrit ou la poubelle)
      # TODO Documenter cette méthode (et son raccourci projet.create_main_folder)
      # avec +data+ qui peut contenir ':title' (le titre du dossier),
      # ':after' ou ':before' (:draft_folder, :research_folder, :trash_folder)
      # pour savoir où placer le dossier
      # @return le {Scrivener::Project::BinderItem} créé.
      def create_main_folder data
        attrs = Hash.new
        attrs.merge!('UUID' => `uuidgen`.strip)
        attrs.merge!(
          created:    Time.now,
          modified:   Time.now,
          type:       'Folder'
        )
        new_folder = binder.add_element('BinderItem', attrs.symbol_to_camel)

        if data.key?(:after)
          # Pour mettre le dossier après
          previous_sibling =
            case data[:after]
            when :draft_folder    then  draftfolder
            when :trash_folder    then  trashfolder
            when :research_folder then  researchfolder
            else nil
            end
          previous_sibling && previous_sibling.next_sibling = new_folder
        end

        if data.key?(:before)
          # Pour mettre le dossier avant
          next_sibling =
            case data[:before]
            when :draft_folder    then  draftfolder
            when :trash_folder    then  trashfolder
            when :research_folder then researchfolder
            else nil
            end
          next_sibling && next_sibling.previous_sibling = new_folder
        end

        if data.key?(:title)
          new_folder.add_element('Title').text = data[:title]
        end

        self.save

        return Scrivener::Project::BinderItem.new(projet, new_folder)
      end

    end
  end #/Project
end #/Scrivener
