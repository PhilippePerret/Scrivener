=begin

  Extension de la classe Array

  Version 2.0.0

=end
class Array


  def pretty_join options = nil
    options ||= Hash.new
    options.key?(:before_each)  || options.merge!(before_each:  '')
    options.key?(:after_each)   || options.merge!(after_each:   '')
    if self.count > 1
      l = self
      dernier = options[:before_each] + l.pop.inspect + options[:after_each]
      l = l.collect{|i| options[:before_each] + i.inspect + options[:after_each]}.join(', ')
      return l + ' et ' + dernier
    else
      return options[:before_each] + self.first.inspect + options[:after_each]
    end
  end

end #/Array
