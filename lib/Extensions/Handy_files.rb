# frozen_string_literal: true
# encoding: UTF-8

# Pour écrire simplement dans un fichier
#
# +option+
#   :append     Si true, on doit ajouter au fichier
#   :marshal    Si true, on marshalise str pour l'enregistrer
#   :yaml       Si true, on yamelize la donnée pour l'enregistrer
#
def write_in_file(str, pth, options =nil)
  options ||= Hash.new
  spec = options[:append] ? 'a+' : 'wb'
  if options[:marshal]
    File.open(pth,spec) { |rf| Marshal.dump(str, rf) }
  elsif options[:yaml]
    File.open(pth,spec) { |rf| YAML.dump(str, rf) }
  else
    File.open(pth,spec) { |rf| rf.write(str) }
  end
end

# Mêmes options que pour write_in_file
# +
#   :symbolize_keys     Pour YAML
def read_from_file(pth, options = nil)
  options ||= Hash.new
  if options[:marshal]
    File.open(pth,'rb'){|rf| Marshal.load(rf)}
  elsif options[:yaml]
    YAML.load(File.read(pth), symbolize_keys: options[:symbolize_keys])
  else
    File.open(pth,'rb'){|f| rf.read}
  end
end
