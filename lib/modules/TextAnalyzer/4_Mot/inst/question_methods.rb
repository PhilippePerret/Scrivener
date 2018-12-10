class TextAnalyzer
class File
class Text
class Mot

  def real_mot?
    @is_real_mot ||= !!downcase.match(/[a-zA-Zçàô]/)
  end

end #/Mot
end #/Text
end #/File
end #/TextAnalyzer
