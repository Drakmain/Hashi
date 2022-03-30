load 'SelectionMap.rb'

class SelectionDifficulte < Gtk::Builder

  def initialize(fenetre, ratio, mode)
    super()
    add_from_file('../data/glade/SelectionDifficulte.glade')
    @ratio = ratio
    @mode = mode
    @fenetre = fenetre

    objects.each do |p|
      unless p.builder_name.start_with?('___object')
        instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
      end
    end

    @retour_button.set_size_request(-1, 50 * @ratio)

    @fenetre.set_title('Hashi - Selection de la difficulté')

    connect_signals do |handler|
      method(handler)
    rescue StandardError
      puts "#{handler} n'est pas encore implementer !"
    end

    @fenetre.add(@selection_difficulte_box)
  end

  def on_retour_button_clicked
    @fenetre.remove(@selection_difficulte_box)
    @fenetre.resize(1280 * @ratio, 720 * @ratio)
    SelectionMode.new(@fenetre, @ratio)
  end

  def on_facile_clicked
    @fenetre.remove(@selection_difficulte_box)
    SelectionMap.new(@fenetre, @ratio, @mode, 'facile')
  end

  def on_moyen_clicked
    @fenetre.remove(@selection_difficulte_box)
    SelectionMap.new(@fenetre, @ratio, @mode, 'moyen')
  end

  def on_difficile_clicked
    @fenetre.remove(@selection_difficulte_box)
    SelectionMap.new(@fenetre, @ratio, @mode, 'difficile')
  end

end
