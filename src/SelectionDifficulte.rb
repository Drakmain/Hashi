load 'SelectionMap.rb'

class SelectionDifficulte < Gtk::Builder

  def initialize(fenetre, mode)
    super()
    add_from_file('../data/glade/SelectionDifficulte.glade')

    objects.each do |p|
      unless p.builder_name.start_with?('___object')
        instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
      end
    end

    @mode = mode
    @fenetre = fenetre
    @fenetre.add(@selection_difficulte_box)

    @fenetre.set_title('Hashi - Selection de la difficulté')

    connect_signals do |handler|
      method(handler)
    rescue StandardError
      puts "#{handler} n'est pas encore implementer !"
    end
  end

  def on_retour_button_clicked
    @fenetre.remove(@selection_difficulte_box)
    SelectionMode.new(@fenetre)
  end

  def on_facile_clicked
    @fenetre.remove(@selection_difficulte_box)
    SelectionMap.new(@fenetre, @mode, 'facile')
  end

  def on_moyen_clicked
    @fenetre.remove(@selection_difficulte_box)
    SelectionMap.new(@fenetre, @mode, 'moyen')
  end

  def on_difficile_clicked
    @fenetre.remove(@selection_difficulte_box)
    SelectionMap.new(@fenetre, @mode, 'difficile')
  end

end
