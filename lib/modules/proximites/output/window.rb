class Scrivener
class Project
class Console
class Window


  # ---------------------------------------------------------------------

  # La fenêtre Curses
  attr_accessor :cwindow

  def initialize nombre_lignes, options = nil
    options ||= Hash.new
    top   = options[:top] || 0
    left  = options[:left] || options[:col] || 0
    self.cwindow = Curses::Window.new(nombre_lignes, Curses.cols - left, top, left)
    options[:background] && self.cwindow.bkgdset(options[:background])
    self.cwindow.clear
    self.cwindow.refresh
  end

  def clear_line num_line
    self.cwindow.setpos(num_line, 0)
    self.cwindow.deleteln
  end

  def puts str, options = nil
    affiche(str + String::RC, options)
  end
  # Écrit en ajoutant un retour chariot devant
  def sput str, options = nil
    affiche(String::RC + str, options)
  end
  # Affiche le texte +str+ dans la fenêtre.
  # Options peut contenir :
  #   :line   Numéro de la ligne
  #   :col    Colonne
  #   :style    Le style ou les styles (par exemple :rouge, :gras, etc.)
  def affiche str, options = nil
    options ||= Hash.new
    line = options[:line]
    col  = options[:col]
    if options[:position]
      line, col = options[:position]
    end

    col ||= 2
    line && self.cwindow.setpos(line, col)
    if options.key?(:style)
      str = str.to_s
      self.cwindow.attron(Curses.disp_attributes(options[:style])) do
        ecrire_lignes(str, col)
      end
    else
      ecrire_lignes(str, col)
    end

    self.cwindow.refresh
  end
  # /affiche

  def ecrire_lignes(str, col)
    if str.index("\n")
      arr = str.split("\n")
      str = arr.first
      arr[1..-1].nil? || str += "\n" + arr[1..-1].collect{|s| "#{' '*col}#{s}"}.join("\n")
    end
    self.cwindow.addstr(str)
  end


  def clear
    cwindow.clear
  end

end #/Window
end #/Console
end #/Project
end #/Scrivener
