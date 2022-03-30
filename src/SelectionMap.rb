load 'Plateau.rb'
load 'Genie.rb'
load 'ContreLaMontre.rb'
load 'Normal.rb'
load 'Jeu.rb'

class SelectionMap < Gtk::Builder

  def initialize(fenetre, ratio, mode, difficulte)
    super()
    add_from_file('../data/glade/SelectionMap.glade')
    @ratio = ratio
    @difficulte = difficulte
    @mode = mode
    @fenetre = fenetre

    objects.each do |p|
      unless p.builder_name.start_with?('___object')
        instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
      end
    end

    @fenetre.set_title('Hashi - Selection de la map')

    @titre_label.set_text("Choix de la map en mode #{@mode}, difficulté #{@difficulte}")

    @jouer_button.set_sensitive(false);

    @selection_map_scrolled.set_min_content_height(500)

    @retour_button.set_size_request(-1, 50 * @ratio)

    dir = "../data/map/#{@difficulte}/demarrage"
    nb_niv = Dir[File.join(dir, '**', '*')].count { |file| File.file?(file) }

    model = Gtk::TreeStore.new(String, String)

    p = Plateau.creer()

    (1..nb_niv).each do |i|
      root_iter = model.append(nil)

      p.generateMatrice("#{dir}/#{i}.txt")

      root_iter[0] = "Niveau #{i}"
      root_iter[1] = "#{p.x} * #{p.y}"
    end

    tv = Gtk::TreeView.new(model)

    renderer = Gtk::CellRendererText.new
    column = Gtk::TreeViewColumn.new('Niveau', renderer, {
      :text => 0
    })

    tv.append_column(column)

    renderer = Gtk::CellRendererText.new
    column = Gtk::TreeViewColumn.new('Taille', renderer, {
      :text => 1
    })

    tv.append_column(column)

    tv.activate_on_single_click = true

    @selection_map_scrolled.add(tv)

    tv.signal_connect('row-activated') do |handler, niveau|
      @jouer_button.set_sensitive(true)
      @niveau = niveau.to_s.to_i + 1
    end

    connect_signals do |handler|
      method(handler)
    rescue StandardError
      puts "#{handler} n'est pas encore implementer !"
    end

    @fenetre.add(@selection_map_box)
    @fenetre.show_all
  end

  def on_retour_button_clicked
    @fenetre.remove(@selection_map_box)
    @fenetre.resize(1280 * @ratio, 720 * @ratio)
    SelectionDifficulte.new(@fenetre, @ratio, @mode)
  end

  def on_jouer_button_clicked
    @fichierOptions = File.read('../data/settings/options.json')
    @hashOptions = JSON.parse(@fichierOptions)
    @user = @hashOptions['username']

    case @mode
    when 'genie'
      map = Genie.creer(Plateau.creer, @niveau.to_s, @user, @difficulte)
    when 'normal'
      map = Normal.creer(Plateau.creer, @niveau.to_s, @user, @difficulte)
    when 'contre la montre'
      map = ContreLaMontre.creer(Plateau.creer, @niveau.to_s, @user, @difficulte)
    end
    @fenetre.remove(@selection_map_box)
    Jeu.new(@fenetre, @ratio, @mode, @difficulte, map, @niveau.to_s)
  end

end
