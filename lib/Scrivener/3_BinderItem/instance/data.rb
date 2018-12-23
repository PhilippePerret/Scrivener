# encoding: UTF-8
require 'date'
class Scrivener
class Project
class BinderItem

  # Décalage obtenus à la volée du texte contenu par ce BinderItem
  # Il a été utilisé la première fois pour le calcul de proximité.
  attr_accessor :offset_start, :offset_end

  def type        ; @type       ||= attrs['Type']                 end
  def uuid        ; @uuid       ||= attrs['UUID']                 end
  def created_at  ; @created_at ||= Date.parse(attrs['Created'])  end
  def updated_at  ; @updated_at ||= Date.parse(attrs['Modified']) end

  # Les attributes du nœud
  def attrs ; @attrs ||= node.attributes end
  alias :attributes :attrs
    # Pour permettre d'atteindre les propriétés du nœud XML par le biais
    # de l'instance directement, en raccourci :
    #   binder_item.attributes => binder_item.node.attributes
    # Idem pour `elements` ci-dessous

  def elements
    @elements ||= node.elements
  end

  # Titre du document
  # Ce titre peut ne pas être explicitement défini. Dans ce cas,
  # on prend le début du texte et si ce début du texte n'est pas défini,
  # on prend l'UUID
  def title
    @title ||= define_title
  end

  # {SWP} Taille du texte du document
  # ATTENTION : C'est un objet SWP, donc il faut faire size.mots, size.pages,
  # etc. pour obtenir les valeurs
  def size
    @size ||= calc_text_size
  end

  # Méthode de calcul de la taille du texte.
  # Noter que cette méthode est approximative, elle ne calcule cette taille
  # que grossièrement.
  # La valeur renvoyée est une valeur CharMotsPages qui contient les propriétés
  # :chars, :mots et :pages qui donnent respectivement les nombres d'éléments
  def calc_text_size
    if File.exist?(markdown_text_path)
      # Si c'est un document markdown, on peut prendre simplement la taille
      # du fichier
      SWP.new(File.stat(markdown_text_path).size)
    elsif File.exist?(rtf_text_path)
      # Si c'est un fichier RTF, on doit passer par son texte en le transfor-
      # mant en simple texte (texte sans code RTF et épuré de tous ses styles
      # et notes)
      SWP.new(simple_text.length)
    else
      nil
    end
  end

  # On définit le titre, soit en prenant celui défini, soit en prenant
  # le début du texte, soit en prenant l'UUID du document.
  def define_title
    tit = nil
    if node.elements['Title']
      tit = node.elements['Title'].text.strip
    end
    tit ||= begin
      if texte.nil?
        self.uuid
      else
        # On fait un titre de moins de 30 lettres
        words = texte[0..50].split(' ')
        while words.join(' ').length > 30
          words.pop
        end
        words.join(' ')
      end
    end
  end

  def objectif
    @objectif ||= target.signes
  end

  # Instance de la cible de l'item
  def target
    @target ||= Target.new(self)
  end

  # Date de dernière modification du document content.rtf
  def current_mtime
    File.stat(rtf_text_path).mtime
  end

  def set_current_mtime
    self.last_mtime = current_mtime
  end

end #/BinderItem
end #/Project
end #/Scrivener
