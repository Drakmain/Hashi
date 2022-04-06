load 'RubyApp.rb'
load 'Chrono.rb'

##
# La classe Jeu....
#
# ==== Variables d'instance
# * @ratio => 
# * @fenetre => 
# * @mode => 
# * @difficulte => 
# * @map => 
# * @niveau => 
#
class Jeu < Gtk::Builder

  # Methode d'initialisation de la classe
  #
  # ==== Attributs
  #
  # * +fenetre+ - 
  # * +ratio+ - 
  # * +mode+ - 
  # * +difficulte+ - 
  # * +map+ - 
  # * +niveau+ - 
  #
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

    @map.lancerChrono(@timer_label)

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
    @fini_dialog.set_title('Gagné !')
    @fini_label.set_text("Bravo !\nVous avez fini le niveau #{niveau} en mode #{mode} et en difficulte #{difficulte}")

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

  # Méthode activée lorque le bouton "Retour" est cliquée
  # Sauvegarde la partie et retourne à la page de sélection de map
  def on_retour_button_clicked
    @map.desactiverHypothese
    @map.sauvegarder(@mode)

    @fenetre.remove(@jeu_box)
    @fenetre.resize(1280 * @ratio, 720 * @ratio)
    SelectionMap.new(@fenetre, @ratio, @mode, @difficulte)
  end

  # Méthode activée lorque le bouton "Annuler" est cliquée
  # Annule le coup effectué
  def on_annuler_button_clicked
    @grille.annuler
  end

  # Méthode activée lorque le bouton "Pause" est cliquée
  # 
  def on_pause_button_clicked
    puts 'on_pause_button_clicked'
  end

  # Méthode activée lorque le bouton "Refaire" est cliquée
  # Refait le coup qu'on a annulé précédemment
  def on_refaire_button_clicked
    @grille.refaire
  end

  # Méthode activée lorque le bouton "Suggerer un coup" est cliquée
  # Suggère un coup à l'utilisateur en affichant un popup au niveau du coup à effectuer
  def on_suggerer_un_coup_button_clicked
    suggerer = @map.suggestion
    @suggestion_label.set_text(suggerer[0])

    @grille.each do |i|
      img = i.child.name.split('_')
      x = img[1].to_i
      y = img[2].to_i
      if x == suggerer[1].pont.x && y == suggerer[1].pont.y
        @suggestion_popover.set_relative_to(i)
      end
    end
    @suggestion_popover.popup
  end

  # Méthode activée lorque le bouton "Nombre d'erreur(s)" est cliquée
  # Affiche le nombre d'erreur
  def on_nb_erreur_button_clicked
    nb_erreur = @map.nombreErreurs.to_s
    if '0' == nb_erreur
      @nb_erreur_label.set_text('Vous n\'avez pas d\'erreur.')
    else
      @nb_erreur_label.set_text("Vous #{nb_erreur} erreur(s).")
    end
    @nb_erreur_popover.popup
  end

  # Méthode activée lorque le bouton "Corriger erreur(s)" est cliquée
  # Corrige toutes les erreurs du joueur directement
  def on_corriger_erreur_button_clicked
    @grille.corrigerErreur
  end

  # Méthode activée lorque le bouton "Afficher erreur(s)" est cliquée
  # Affiche toutes les erreurs du joueur en les surlignant en rouge
  def on_afficher_erreur_button_clicked
    @grille.afficherErreur
  end

  # Méthode activée lorque le bouton "Mode autocorrecteur" est activé
  # Corrige directement une erreur du joueur si le joueur pose un mauvais pont
  def on_autocorrecteur_switch_state_set(switch, state)
    switch.set_state(state)
    if state
      @hypothese_switch.set_sensitive(false)
      @map.activerAutoCorrecteur
      @grille.actualiserAffichage
    else
      @hypothese_switch.set_sensitive(true)
      @map.desactiverAutoCorrecteur
    end
  end

  # Méthode activée lorque le bouton "Mode hypothèse" est activé
  # Surligne en bleu les coups du joueur, les effacent si le joueur désactive ce bouton
  def on_hypothese_switch_state_set(switch, state)
    switch.set_state(state)
    if state
      @autocorrecteur_switch.set_sensitive(false)
      @annuler_button.set_sensitive(false)
      @refaire_button.set_sensitive(false)
      @map.activerHypothese
    else
      @autocorrecteur_switch.set_sensitive(true)
      @annuler_button.set_sensitive(true)
      @refaire_button.set_sensitive(true)
      @map.desactiverHypothese
      @grille.actualiserAffichage
    end
  end

  # Méthode activée lorque le bouton "Vertical" est cliquée lors d'un coup
  # Met un pont en vertical
  def on_vertical_button_clicked
    @grille.set_sens('vertical')
  end

  # Méthode activée lorque le bouton "Horizontal" est cliquée lors d'un coup
  # Met un pont en horizontal
  def on_horizontal_button_clicked
    @grille.set_sens('horizontal')
  end

  # Méthode activée lorque le bouton "Menu principal" est cliquée
  # Retourne à la fenêtre du menu principal
  def on_menu_principal_button_clicked
    @fini_dialog.response(1)

    @fenetre.remove(@jeu_box)
    @fenetre.resize(1280 * @ratio, 720 * @ratio)
    MenuPrincipal.new(@fenetre, @ratio)
  end

  # Méthode activée lorque le bouton "Selection map" est cliquée
  # Retourne à la fenêtre de la sélection des maps
  def on_selection_button_clicked
    @fini_dialog.response(2)

    @fenetre.remove(@jeu_box)
    @fenetre.resize(1280 * @ratio, 720 * @ratio)
    SelectionMap.new(@fenetre, @ratio, @mode, @difficulte)
  end

  # Méthode activée lorque le bouton "Recommencer" est cliquée
  # Relance la même map vide
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

  # Méthode activée lorque le bouton pour fermer le popup "Fini" est cliquée
  # Ferme le popup
  def on_fini_dialog_response(widget, response)
    widget.close
  end

end
