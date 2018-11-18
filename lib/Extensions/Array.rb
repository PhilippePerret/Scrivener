class Array


  def pretty_join options = nil
    options ||= Hash.new
    options.key?(:before_each)  || options.merge!(before_each:  '')
    options.key?(:after_each)   || options.merge!(after_each:   '')
    if self.count > 1
      l = self
      dernier = options[:before_each] + l.pop + options[:after_each]
      l = l.collect{|i| options[:before_each] + i + options[:after_each]}.join(', ')
      return l + ' et ' + dernier
    else
      return options[:before_each] + self.first + options[:after_each]
    end
  end

end #/Array
