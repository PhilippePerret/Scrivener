class Scrivener
class Project
  def ui
    @ui ||= UI.new(self)
  end
  class UI
    attr_accessor :projet
    def initialize projet
      self.projet = projet
    end

    # ---------------------------------------------------------------------
    #   Toutes les données qu'on récupère dans le fichier ui.plist

    # {Float} Facteur de grossissement des notes.
    # 1.0 par défaut.
    def notes_scale_factor
      @note_scale_factor ||= ui_plist['NotesScaleFactor']
    end

    # Découpage du classeur
    # Tailles de la ou des fenêtres
    # {Array} composé de points définissant des surfaces
    # Chaque élément de l'array est un string qui contient quelque chose
    # comme "{{x, y}, {z, a}}"
    # {x,y} définit un point en haut à gauche ({top, left})
    # {z,a} définit un point top-left en bas à droite
    def binder_split_frames
      @binder_split_frames ||= begin
        ui_plist['binderSplitFrames'].collect do |surface|
          Surface.new(surface)
        end
      end
    end

    # Découpage de l'éditeur
    # Contient une seule surface lorsque l'éditeur n'est pas découpé et
    # plusieurs lorsqu'il l'est. Penser que l'éditeur peut être coupé
    # aussi bien horizontalement que verticalement.
    def editor_split_frames
      @editor_split_frames ||= begin
        ui_plist['editorSplitFrames'].collect do |surface|
          Surface.new(surface)
        end
      end
    end
    # /editor_split_frames

    # Découpage de l'inspecteur
    # Contient une seule surface lorsque l'éditeur n'est pas découpé et
    # plusieurs lorsqu'il l'est. Penser que l'éditeur peut être coupé
    # aussi bien horizontalement que verticalement.
    def inspector_split_frames
      @inspector_split_frames ||= begin
        ui_plist['inspectorSplitFrames'].collect do |surface|
          Surface.new(surface)
        end
      end
    end
    # /inspector_split_frames

    def inspector_width
      @inspector_width ||= ui_plist['inspectorWidth']
    end

  end #/UI
end #/Project
end #/Scrivener

class Surface
  attr_accessor :point_TL, :point_BR
  def initialize data
    if data.is_a?(String)
      data = data.gsub(/\{/,'[').gsub(/\}/,']')
      data = eval(data)
    end
    self.point_TL = Point.new(data[0])
    self.point_BR = Point.new(data[1])
  end
  def to_plist
    @to_plist ||= '{%s, %s}' % [point_TL.to_plist, point_BR.to_plist]
  end
  class Point
    attr_accessor :top, :left
    def initialize data
      self.top  = data[0]
      self.left = data[1]
    end
    def to_plist
      @to_plist ||= "{#{top}, #{left}}"
    end
  end #/Point
end #/Point
