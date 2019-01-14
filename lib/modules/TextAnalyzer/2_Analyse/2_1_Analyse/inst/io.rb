# encoding: UTF-8
class TextAnalyzer
class Analyse

  def save
    # write_in_file(self, data_path, {marshal: true})
    # Maintenant, on sauve dans le fichier YAML
    write_in_file(self.yaml_data, data_yaml_file, {yaml: true})
  end

  def save_all
    table_resultats.save
    texte_entier.save
    data.ended_at = Time.now
    data.save
    self.save
  end
  # /save_all

end #/Analyse
end #/TextAnalyzer
