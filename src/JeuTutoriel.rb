load 'RubyApp.rb'

class JeuTutoriel < Gtk::Builder

  def initialize(fenetre, ratio, mode, difficulte, map, niveau)
    super()
    add_from_file('../data/glade/JeuTutoriel.glade')
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

    nb_niv = Dir[File.join("../data/map/#{@difficulte}/demarrage", '**', '*')].count { |file| File.file?(file) }

    if nb_niv == @niveau.to_i
      @suivant_button.set_sensitive(false)
    end

    @grille = RubyApp.new(@fenetre, @map, @sens_popover, @fini_dialog)

    @plateau_box.add(@grille)

    @retour_button.set_size_request(-1, 50 * @ratio)
    @fini_label.set_text("Vous avez fini le tutoriel n°#{niveau}.")

    @fenetre.set_title("Hashi - Tutoriel n°#{niveau}")

    @tutoriel_label.set_text((File.read(File.expand_path("../data/catalogue/#{niveau}.txt"))))

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

  def on_suivant_button_clicked
    @fini_dialog.response(3)
    @fenetre.remove(@jeu_box)

    @niveau = @niveau.to_i
    @niveau += 1

    map = Genie.creer(Plateau.creer, @niveau.to_s, @user, @difficulte)

    map.initialiserJeu

    JeuTutoriel.new(@fenetre, @ratio, @mode, @difficulte, map, @niveau.to_s)
  end

  def on_fini_dialog_response(widget, response)
    widget.close
  end

end
