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

    @fichier_options = File.read('../data/options.json')
    @hashOptions = JSON.parse(@fichier_options)
    @user = @hashOptions['username']

    objects.each do |p|
      unless p.builder_name.start_with?('___object')
        instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
      end
    end

    @fenetre.set_title('Hashi - Selection de la map')

    @titre_label.set_text("Choix de la map en mode #{@mode}, difficulté #{@difficulte}")

    @jouer_button.set_sensitive(false)
    @recommencer_button.set_sensitive(false)

    @selection_map_scrolled.set_min_content_height(500)

    @retour_button.set_size_request(-1, 50 * @ratio)
    @jouer_button.set_size_request(-1, 25 * @ratio)
    @recommencer_button.set_size_request(-1, 25 * @ratio)

    dir = "../data/map/#{@difficulte}/demarrage"
    nb_niv = Dir[File.join(dir, '**', '*')].count { |file| File.file?(file) }

    model = Gtk::TreeStore.new(String, String, String)

    p = Plateau.creer()

    (1..nb_niv).each do |i|
      root_iter = model.append(nil)

      p.generateMatrice("#{dir}/#{i}.txt")

      root_iter[0] = "Niveau #{i}"
      root_iter[1] = "#{p.x} * #{p.y}"

      begin
        f = File.open(File.expand_path("../data/sauvegarde/" + @user + "_" + @mode + "_" + @difficulte + "_" + i.to_s + ".bn"), "r")
        root_iter[2] = "Sauvegarde disponible"
        f.close
      rescue StandardError => e
        root_iter[2] = "Sauvegarde non disponible"
      end

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

    renderer = Gtk::CellRendererText.new
    column = Gtk::TreeViewColumn.new('Sauvegarde', renderer, {
      :text => 2
    })

    tv.append_column(column)

    tv.activate_on_single_click = true

    @selection_map_scrolled.add(tv)

    tv.signal_connect('row-activated') do |widget, niveau|
      @jouer_button.set_sensitive(true)
      @niveau = niveau.to_s.to_i + 1

      begin
        f = File.open(File.expand_path("../data/sauvegarde/" + @user + "_" + @mode + "_" + @difficulte + "_" + @niveau.to_s + ".bn"), "r")
        @recommencer_button.set_sensitive(true)
        f.close
      rescue StandardError
        @recommencer_button.set_sensitive(false)
      end
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

    case @mode
    when 'genie'
      map = Genie.creer(Plateau.creer, @niveau.to_s, @user, @difficulte)
    when 'normal'
      map = Normal.creer(Plateau.creer, @niveau.to_s, @user, @difficulte)
    when 'contre la montre'
      map = ContreLaMontre.creer(Plateau.creer, @niveau.to_s, @user, @difficulte)
    end

    map.initialiserJeu

    begin
      f = File.open(File.expand_path("../data/sauvegarde/" + @user + "_" + @mode + "_" + @difficulte + "_" + @niveau.to_s + ".bn"), "r")
      map = map.load
      f.close
    rescue StandardError
    end

    @fenetre.remove(@selection_map_box)
    Jeu.new(@fenetre, @ratio, @mode, @difficulte, map, @niveau.to_s)
  end

  def on_recommencer_button_clicked
    case @mode
    when 'genie'
      map = Genie.creer(Plateau.creer, @niveau.to_s, @user, @difficulte)
    when 'normal'
      map = Normal.creer(Plateau.creer, @niveau.to_s, @user, @difficulte)
    when 'contre la montre'
      map = ContreLaMontre.creer(Plateau.creer, @niveau.to_s, @user, @difficulte)
    end

    @fenetre.remove(@selection_map_box)

    map.initialiserJeu
    Jeu.new(@fenetre, @ratio, @mode, @difficulte, map, @niveau.to_s)
  end

end
