=begin

  Extension de la classe Array

  Version 2.0.1

 # Note sur version 2.0.1
    Correction du bug dans pretty_join qui modifiait la liste elle-même

=end
class Array


  def pretty_join options = nil
    options ||= Hash.new
    options.key?(:before_each)  || options.merge!(before_each:  '')
    options.key?(:after_each)   || options.merge!(after_each:   '')
    if self.count > 1
      l = self.dup
      dernier = options[:before_each] + l.pop.inspect + options[:after_each]
      l = l.collect{|i| options[:before_each] + i.inspect + options[:after_each]}.join(', ')
      return l + ' et ' + dernier
    else
      return options[:before_each] + self.first.inspect + options[:after_each]
    end
  end

end #/Array
