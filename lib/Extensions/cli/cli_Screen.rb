# encoding: UTF-8
=begin



=end
class CLI
class Screen
class << self

  def clear
    puts "\033c"
  end

  def write_slowly str, line = :current
    print '  '
    str.split('').each do |let|
      print let
      sleep 0.04
    end
  end


end #/<< self
end #/Screen
end #/CLI
