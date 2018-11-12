=begin
  Pour sortir le résultat en console

  0
  31
  42
  43

  Marion devrait être à 51 et c'est 45
=end
class Scrivener
class Project

  def output_data_proximites
    get_data_proximites || return
    puts "\n\n==== DATA DE PROXIMITES ==="
    # puts tableau_proximites.inspect

    tableau_proximites[:mots].each do |mot_canonique, data_mot|
      puts "--- mot générique : #{mot_canonique}"
      data_mot[:items].each do |imot|
        puts "   - #{imot.real} :: #{imot.offset}"
      end
    end
  end

end #/Project
end #/Scriver
