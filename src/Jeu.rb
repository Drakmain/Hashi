load 'RubyApp.rb'

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
    @afficher_erreur_button.set_size_request(-1, 50 * @ratio)
    @corriger_erreur_button.set_size_request(-1, 50 * @ratio)
    @mode_hypothese_button.set_size_request(-1, 50 * @ratio)
    @fini_dialog.set_window_position Gtk::WindowPosition::CENTER_ON_PARENT
    @fini_dialog.set_resizable(false)
    @fini_dialog.set_title("Gagné !")
    @fini_label.set_text("Bravo !\nVous avez fini le niveau " + niveau + " en mode " + mode + " et en difficulte " + difficulte)

    @grille = RubyApp.new(@fenetre, @map, @sens_popover, @fini_dialog)

    @plateau_box.add(@grille)

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
    @grille.annuller
  end

  def on_pause_button_clicked
    puts 'on_pause_button_clicked'
  end

  def on_refaire_button_clicked
    @grille.refaire
  end

  def on_suggerer_un_coup_button_clicked
    puts 'on_suggerer_un_coup_button_clicked'
  end

  def on_corriger_erreur_button_clicked
    puts 'on_corriger_erreur_button_clicked'
  end

  def on_afficher_erreur_button_clicked
    puts 'on_afficher_erreur_button_clicked'
  end

  def on_mode_hypothese_button_clicked
    puts 'on_mode_hypothese_button_clicked'
  end

  def on_vertical_button_clicked
    @grille.set_sens('vertical')
  end

  def on_horizontal_button_clicked
    @grille.set_sens('horizontal')
  end

  def on_menu_principal_button_clicked
    @fini_dialog.response(1)

    @fenetre.remove(@jeu_box)
    @fenetre.resize(1280 * @ratio, 720 * @ratio)
    MenuPrincipal.new(@fenetre, @ratio)
  end

  def on_selection_button_clicked
    @fini_dialog.response(2)

    @fenetre.remove(@jeu_box)
    @fenetre.resize(1280 * @ratio, 720 * @ratio)
    SelectionMap.new(@fenetre, @ratio, @mode, @difficulte)
  end

  def on_recommencer_button_clicked
    @fini_dialog.response(3)
    @fenetre.remove(@jeu_box)

    case @mode
    when 'genie'
      map = Genie.creer(Plateau.creer, @niveau.to_s, @user, @difficulte)
    when 'normal'
      map = Normal.creer(Plateau.creer, @niveau.to_s, @user, @difficulte)
    when 'contre la montre'
      map = ContreLaMontre.creer(Plateau.creer, @niveau.to_s, @user, @difficulte)
    end

    Jeu.new(@fenetre, @ratio, @mode, @difficulte, map, @niveau.to_s)
  end

  def on_fini_dialog_response(widget, response)
    widget.close
  end

end
