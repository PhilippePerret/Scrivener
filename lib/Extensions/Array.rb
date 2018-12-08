=begin

  Extension de la classe Array

  Version 2.0.2

 # Note sur version 2.0.2
    Options :inspect pour `pretty_join` pour ne pas .inspect les éléments
    de la liste avant de les joindre.
 # Note sur version 2.0.1
    Correction du bug dans pretty_join qui modifiait la liste elle-même

=end
class Array


  # +options+
  #   :inspect      Si false, l'élément de la liste n'est pas "inspecté"
  def pretty_join options = nil
    options ||= Hash.new
    options.key?(:before_each)  || options.merge!(before_each:  '')
    options.key?(:after_each)   || options.merge!(after_each:   '')
    meth = options[:inspect] == false ? :to_s : :inspect
    if self.count > 1
      l = self.dup
      dernier = options[:before_each] + l.pop.send(meth) + options[:after_each]
      l = l.collect{|i| options[:before_each] + i.send(meth) + options[:after_each]}.join(', ')
      return l + ' et ' + dernier
    else
      return options[:before_each] + self.first.send(meth) + options[:after_each]
    end
  end

end #/Array
