class Scrivener
  class Project

    # Assemble dans +path+ les textes des binder-items consignés dans
    # +arr_bitems+
    def assemble_texte arr_bitems, path
      File.unlink(path) if File.exists?(path)
      File.open(path,'wb') do |rf|
        arr_bitems.each do |bitem|
          rf.write((bitem.texte||'') + String::RC)
        end
      end
      return true
    end

  end #/Projet
end #/Scrivener
