load 'SelectionDifficulte.rb'

class SelectionMode < Gtk::Builder

  def initialize(fenetre, ratio)
    super()
    add_from_file('../data/glade/SelectionMode.glade')
    @ratio = ratio
    @fenetre = fenetre

    objects.each do |p|
      unless p.builder_name.start_with?('___object')
        instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
      end
    end

    @fenetre.set_title('Hashi - Selection du mode')
    @retour_button.set_size_request(-1, 50 * @ratio)

    connect_signals do |handler|
      method(handler)
    rescue StandardError
      puts "#{handler} n'est pas encore implementer !"
    end

    @fenetre.add(@selection_mode_box)
  end

  def on_retour_button_clicked
    @fenetre.remove(@selection_mode_box)
    @fenetre.resize(1280 * @ratio, 720 * @ratio)
    MenuPrincipal.new(@fenetre, @ratio)
  end

  def on_normal_clicked
    @fenetre.remove(@selection_mode_box)
    SelectionDifficulte.new(@fenetre, @ratio, 'normal')
  end

  def on_contre_la_montre_clicked
    @fenetre.remove(@selection_mode_box)
    SelectionDifficulte.new(@fenetre, @ratio, 'contre la montre')
  end

  def on_génie_clicked
    @fenetre.remove(@selection_mode_box)
    SelectionDifficulte.new(@fenetre, @ratio, 'genie')
  end

  def on_tutoriel_clicked
    puts "on_tutoriel_clicked"
  end

end
