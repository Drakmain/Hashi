load 'test2.rb'

class Jeu < Gtk::Builder

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

    @fichierOptions = File.read('../data/settings/options.json')

    @hashOptions = JSON.parse(@fichierOptions)
    @username = @hashOptions['username']

    @username_label.set_text(@username)

    @username_label.set_size_request(-1, 50 * @ratio)
    @suggerer_un_coup_button.set_size_request(-1, 50 * @ratio)
    @verrifier_la_grille_button.set_size_request(-1, 50 * @ratio)
    @mode_hypothese_button.set_size_request(-1, 50 * @ratio)

    grille = RubyApp.new(@map)

    @plateau_box.add(grille)

    @fenetre.set_title("Hashi - Niveau n°#{niveau}")

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
    SelectionMap.new(@fenetre, @ratio, @mode, @difficulte)
  end

  def on_annuler_button_clicked
    puts 'on_annuler_button_clicked'
  end

  def on_pause_button_clicked
    puts 'on_pause_button_clicked'
  end

  def on_refaire_button_clicked
    puts 'on_refaire_button_clicked'
  end

  def on_suggerer_un_coup_button_clicked
    puts 'on_suggerer_un_coup_button_clicked'
  end

  def on_verrifier_la_grille_button_clicked
    puts 'on_verrifier_la_grille_button_clicked'
  end

  def on_mode_hypothese_button_clicked
    puts 'on_mode_hypothese_button_clicked'
  end

end
