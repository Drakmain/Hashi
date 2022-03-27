load 'Plateau.rb'

class SelectionMap < Gtk::Builder

  def initialize(fenetre, mode, difficulte)
    super()
    add_from_file('../data/glade/SelectionMap.glade')

    objects.each do |p|
      unless p.builder_name.start_with?('___object')
        instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
      end
    end

    @difficulte = difficulte
    @mode = mode
    @fenetre = fenetre
    @fenetre.add(@selection_map_box)
    @fenetre.set_title('Hashi - Selection de la map')

    @titre_label.set_text("Choix de la map en #{@mode}, Difficulté #{@difficulte}")

    @jouer_button.set_sensitive(false);

    @selection_map_scrolled.set_min_content_height(500)

    dir = "../data/map/#{@difficulte}/demarrage"
    nb_niv = Dir[File.join(dir, '**', '*')].count { |file| File.file?(file) }

    model = Gtk::TreeStore.new(String, String)

    p = Plateau.creer(1)

    (1..nb_niv).each do |i|
      root_iter = model.append(nil)

      p.generateMatrice("#{dir}/#{i}.txt")

      root_iter[0] = "Niveau #{i}"
      root_iter[1] = "#{p.x} * #{p.y}"
    end

    tv = Gtk::TreeView.new(model)

    renderer = Gtk::CellRendererText.new
    column = Gtk::TreeViewColumn.new("Niveau", renderer, {
      :text => 0,
    })

    tv.append_column(column)

    # column 2
    renderer = Gtk::CellRendererText.new
    column = Gtk::TreeViewColumn.new("Taille", renderer, {
      :text => 1
    })

    tv.append_column(column)

    tv.activate_on_single_click = true

    @selection_map_scrolled.add(tv)

    @fenetre.show_all

    tv.signal_connect('row-activated') do
      @jouer_button.set_sensitive(true);
    end

    connect_signals do |handler|
      method(handler)
    rescue StandardError
      puts "#{handler} n'est pas encore implementer !"
    end
  end

  def on_retour_button_clicked
    @fenetre.remove(@selection_map_box)
    SelectionDifficulte.new(@fenetre, @mode)
  end

end
