require 'yaml'
class Proximite
  class << self

    # = main =
    #
    # Méthode de classe qui compare deux tables de proximité
    def compare table1, table2

      puts "--- table1 : #{table1[:proximites].keys}"
      puts "--- table2 : #{table2[:proximites].keys}"
      table1[:proximites].count == table2[:proximites].count || raise('count.differ')

    rescue Exception => e
      msg = {
        'count.differ' => 'Le compte de proximité n’est pas le même.'
      }[e.message]
      puts msg.rouge
    end
    # /compare

  end #/<<self
end #/Proximite
