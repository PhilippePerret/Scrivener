# encoding: UTF-8
class Scrivener
ERRORS[:build] ||= Hash.new
ERRORS[:build].merge!(
custom_metadatas:{
  options_required: 'Les options (items de liste) sont obligatoires pour définir une donnée personnalisée de type liste. C’est une liste (Array) constituée de paires [valeur, titre].'
}
)

end #/Scrivener
