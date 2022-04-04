load 'RubyApp.rb'

class JeuTutoriel < Gtk::Builder

  def initialize(fenetre, ratio, mode, difficulte, map, niveau)
    super()
    add_from_file('../data/glade/Jeu.glade')
    @ratio = ratio
    @fenetre = fenetre
    @mode = mode
    @difficulte = difficulte
    @map = map
    @niveau = niveau

    objects.each do |p|
      unless p.builder_name.start_with?('___object')
        instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
      end
    end

    @grille = RubyApp.new(@fenetre, @map, @sens_popover, @fini_dialog)

    @plateau_box.add(@grille)

    @fenetre.set_title("Hashi - Niveau n°#{niveau}")

    @gauche_box.remove(@timer_label)

    @jeu_box.remove(@droite_box)

    @action_button_box.each do |i|
      @action_button_box.remove(i)
    end

    @action_button_box.add(Gtk::Label.new(File.read(File.expand_path("../data/catalogue/#{niveau}.txt"))))

    @map.afficherPlateau

    connect_signals do |handler|
      method(handler)
    rescue StandardError
      puts "#{handler} n'est pas encore implementer !"
    end

    @fenetre.add(@jeu_box)
    @fenetre.show_all
  end

  def on_retour_button_clicked
    @fenetre.remove(@jeu_box)
    @fenetre.resize(1280 * @ratio, 720 * @ratio)
    SelectionMap.new(@fenetre, @ratio, 'tutoriel', 'tutoriel')
  end

end
