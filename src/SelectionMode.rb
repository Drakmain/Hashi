load 'SelectionDifficulte.rb'

class SelectionMode < Gtk::Builder

  def initialize(fenetre)
    super()
    add_from_file('../data/glade/SelectionMode.glade')

    objects.each do |p|
      unless p.builder_name.start_with?('___object')
        instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
      end
    end

    @fenetre = fenetre
    @fenetre.add(@selection_mode_box)

    @fenetre.set_title('Hashi - Selection du mode')

    connect_signals do |handler|
      method(handler)
    rescue StandardError
      puts "#{handler} n'est pas encore implementer !"
    end
  end

  def on_retour_button_clicked
    @fenetre.remove(@selection_mode_box)
    MenuPrincipal.new(@fenetre)
  end

  def on_normal_clicked
    @fenetre.remove(@selection_mode_box)
    SelectionDifficulte.new(@fenetre, 'normal')
  end

  def on_contre_la_montre_clicked
    @fenetre.remove(@selection_mode_box)
    SelectionDifficulte.new(@fenetre, 'contre la montre')
  end

  def on_génie_clicked
    @fenetre.remove(@selection_mode_box)
    SelectionDifficulte.new(@fenetre, 'genie')
  end

  def on_tutoriel_clicked
    puts "on_tutoriel_clicked"
  end

end
