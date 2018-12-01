class ProxMot

  def binder_item
    @binder_item ||= project.binder_item(binder_item_uuid)
  end
  def text_around(pour = nil, color = :bleu)
    pour ||= 30
    texte_before(pour) + real.send(color) + texte_after(pour)
  end
  def texte_before(pour = 30)
    from = offset_in_document - pour
    from < 0 && from = 0
    to   = offset_in_document - 1
    return binder_item.texte[from..to]
  end
  def texte_after(pour = 30)
    from  = offset_in_document + real.length
    to    = from + pour
    return binder_item.texte[from..to]
  end

  def offset_in_document
    @offset_in_document ||= self.offset - binder_item.offset_start
  end
  alias :relative_offset :offset_in_document


  # Méthode qui permet de régler les offsets de départ et de fin du binder-item
  # contenant le mot, en sachant que ces décalages peuvent varier en fonction
  # de l'analyse.
  # +data_binder_items+ est la table définissant les binder-items lors de la
  # relève des mots.
  def set_offsets_bitem data_binder_items
    bi_data = data_binder_items[self.binder_item_uuid]
    self.binder_item.offset_start = bi_data[:offset_start]
    self.binder_item.offset_end   = bi_data[:offset_end]
  end

end #/ProxMot
