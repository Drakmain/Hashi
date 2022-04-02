load 'RubyApp.rb'
load 'Chrono.rb'

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

    if @map.instance_of?(Genie)
      @annuler_button.set_sensitive(false)
      @pause_button.set_sensitive(false)
      @refaire_button.set_sensitive(false)
      @droite_box.set_sensitive(false)
    end

    if @map.autoCorrecteur == true
      @autocorrecteur_switch.set_state(true)
      @hypothese_switch.set_sensitive(false)
    else
      @autocorrecteur_switch.set_state(false)
      @hypothese_switch.set_sensitive(true)
    end

    if @map.hypothese == true
      @hypothese_switch.set_state(true)
      @autocorrecteur_switch.set_sensitive(false)
    else
      @hypothese_switch.set_state(false)
      @autocorrecteur_switch.set_sensitive(true)
    end

    @fichier_options = File.read('../data/options.json')

    @hashOptions = JSON.parse(@fichier_options)
    @username = @hashOptions['username']

    @username_label.set_text(@username)

    @username_label.set_size_request(-1, 50 * @ratio)
    @suggerer_un_coup_button.set_size_request(-1, 50 * @ratio)
    @afficher_erreur_button.set_size_request(-1, 50 * @ratio)
    @corriger_erreur_button.set_size_request(-1, 50 * @ratio)
    @nb_erreur_button.set_size_request(-1, 50 * @ratio)
    @fini_dialog.set_window_position Gtk::WindowPosition::CENTER_ON_PARENT
    @fini_dialog.set_resizable(false)
    @fini_dialog.set_title("Gagné !")
    @fini_label.set_text("Bravo !\nVous avez fini le niveau #{niveau} en mode #{mode} et en difficulte #{difficulte}")

    @grille = RubyApp.new(@fenetre, @map, @sens_popover, @fini_dialog)

    #chrono = Chrono.new
    #chrono.lancerChrono
    #@timer_label.set_text("Timer : #{chrono.chrono}")

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
    @map.save(@mode)

    @fenetre.remove(@jeu_box)
    @fenetre.resize(1280 * @ratio, 720 * @ratio)
    SelectionMap.new(@fenetre, @ratio, @mode, @difficulte)
  end

  def on_annuler_button_clicked
    @grille.annuler
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

  def on_nb_erreur_button_clicked
    nb_erreur = @map.nombreErreurs.to_s
    if '0' == nb_erreur
      @nb_erreur_label.set_text('Vous n\'avez pas d\'erreur.')
    else
      @nb_erreur_label.set_text('Vous ' + nb_erreur + ' erreur(s).')
    end
    @nb_erreur_popover.popup
  end

  def on_corriger_erreur_button_clicked
    puts 'on_corriger_erreur_button_clicked'
    @grille.corrigerErreur
  end

  def on_afficher_erreur_button_clicked
    puts 'on_afficher_erreur_button_clicked'
    #@grille.afficherErreur
  end

  def on_autocorrecteur_switch_state_set(switch, state)
    switch.set_state(state)
    if state
      @hypothese_switch.set_sensitive(false)
      puts 'activerAutoCorrecteur'
      @map.activerAutoCorrecteur
      @grille.actualiserAffichage
    else
      @hypothese_switch.set_sensitive(true)
      puts 'desactiverAutoCorrecteur'
      @map.desactiverAutoCorrecteur
    end
  end

  def on_hypothese_switch_state_set(switch, state)
    switch.set_state(state)
    if state
      @autocorrecteur_switch.set_sensitive(false)
      puts 'activerHypothese'
      @map.activerHypothese
    else
      @autocorrecteur_switch.set_sensitive(true)
      puts 'desactiverHypothese'
      @map.desactiverHypothese
      @grille.actualiserAffichage
    end
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
