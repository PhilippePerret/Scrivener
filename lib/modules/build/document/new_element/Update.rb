# encoding: UTF-8
=begin
  Class Scrivener::Project::Update
  --------------------------------
  Pour la gestion des actualisations

=end
module BuildDocumentsModule
class Update

  # {NewElement}
  attr_accessor :element
  attr_accessor :binder_item
  attr_accessor :data
  attr_accessor :update_ok # mis à true si l'actualisation a pu se faire
  # {String} En cas d'erreur rencontrée
  attr_accessor :error

  def initialize el, bitem, data
    self.element      = el
    self.binder_item  = bitem
    self.data = data
    # dispatch
    self.old_value = data[:old_value] || binder_item.send(property).dup
    self.new_value = data[:new_value]
  end

  # ---------------------------------------------------------------------
  #   DATA

  attr_accessor :old_value, :new_value

  HPROPERTIES = {
    title:    {fr: 'titre',     en: 'title'},
    target:   {fr: 'objectif',  en: 'target'}
  }

  # Type de la modification
  def type
    @type ||= data[:type]
  end
  def property
    @property ||= (data[:property] || type).to_sym
  end
  def hproperty
    @hproperty ||= HPROPERTIES[property][lang]
  end
  def lang
    @lang ||= :fr
  end

  # ---------------------------------------------------------------------
  #   Méthodes opérationnelles

  # Actualise la valeur suivant son type.
  def update_value_by_type
    equal_method  = "#{property}=".to_sym
    prop_method   =
    if binder_item.respond_to?(equal_method)
      binder_item.send(equal_method, new_value)
    elsif binder_item.respond_to?(property) && binder_item.send(property).respond_to?(:define)
      # <= Lorsque c'est un objet complexe, comme par exemple une target
      binder_item.send(property).define(new_value)
    else
      raise_unknown_type_for_update(type)
    end
  rescue Exception => e
    self.error = e.message
    return false
  else
    return true
  end

  def proceed
    if not_interactive? || yesOrNo(message_confirmation)
      self.update_ok = update_value_by_type
      element.projet.updates << self
    end
  end

  def message_confirmation
    @message_confirmation ||= case type
    when :title
      "Dois-je mettre le titre #{du_doc} à #{new_value.inspect} (titre actuel : #{old_value.inspect}) ?"
    when :target
      "Dois-je mettre l'objectif #{du_doc} à #{new_value} signes (contre #{old_value} actuellement) ?"
    else
      raise 'Je ne sais pas encore traiter la propriété %s' % property.inspect
    end
  end

  def du_doc
    @du_doc ||= 'du %s' % refdoc
  end
  def refdoc
    @refdoc ||= 'document "%s" (#%i)' % [binder_item.title, element.id]
  end

  # ---------------------------------------------------------------------
  # Méthodes d'helper

  LINE_TO_STR = '%{indent}%{refdoc} %{prop} %{oldv} -> %{newv}%{iferror}'
  def to_s args = nil
    args ||= Hash.new
    args[:indent] ||= ''
    args.merge!(
      refdoc:   refdoc.capitalize.ljust(41)[0..40],
      prop:     hproperty.upcase.ljust(16),
      oldv:     old_value.inspect,
      newv:     new_value.inspect,
      iferror:  if_error(args[:indent])
    )
    LINE_TO_STR % args
  end

  def if_error(indent)
    if update_ok
      ''
    else
      String::RC + indent*3 + ('ERREUR RENCONTRÉE: %s' % error)
    end
  end

  def raise_unknown_type_for_update(type)
    raise(ERRORS[:update][:unenable_to_update_value] % [type])
  end
  # ---------------------------------------------------------------------
  #   Méthodes utilisataires

  def not_interactive?
    element.not_interactive?
  end

end#/Update
end #/module
