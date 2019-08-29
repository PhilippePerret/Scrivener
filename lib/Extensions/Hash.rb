# encoding: UTF-8
class Hash

  # Retourne le hash où les clés symboliques ont été remplacées par des
  # clés Camélisée : :title_prov => TitleProv
  def symbol_to_camel
    h = {}
    self.each do |k, v|
      if k.is_a?(String)
        h.merge!(k => v)
      else
        h.merge!(k.camelize => v)
      end
    end
    return h
  end

  def symbolize_keys
    hsymb = {}
    self.each do |k, v|
      v = v.symbolize_keys if v.respond_to?(:symbolize_keys)
      hsymb.merge!(k.to_sym => v)
    end
    hsymb
  end

end #/Hash
