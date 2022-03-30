load 'Catalogue.rb'
load 'SelectionMode.rb'
load 'Options.rb'

# class MenuTerminal
#
# la classe MenuTerminal permet d'afficher la fenetre du menu principal.
#
# le menu est composé de 5 choix :
#
#   - Jouer
#   - Catalogue
#   - Classement
#   - Options
#   - Quitter
#
# On peut cliquer sur un des choix
#
class MenuPrincipal < Gtk::Builder

  # initialize
  #
  # permet d'initialiser la fenetre du menu
  #
  # ===== ATTRIBUT
  #
  # fenetre => une fenetre
  def initialize(fenetre, ratio)
    super()
    add_from_file('../data/glade/MenuPrincipal.glade')
    @ratio = ratio
    @fenetre = fenetre

    objects.each do |p|
      unless p.builder_name.start_with?('___object')
        instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
      end
    end

    @fenetre.set_title('Hashi - Menu Principal')
    @classement.set_sensitive(false)

    connect_signals do |handler|
      method(handler)
    rescue StandardError
      puts "#{handler} n'est pas encore implementer !"
    end

    @fenetre.add(@menu_principale_box)
  end

  # on_jouer_clicked
  #
  # Action qui s'execute lorsque l'on clique sur le bouton jouer
  #
  # ferme la box des menus et affiche une nouvelle box
  def on_jouer_clicked
    @fenetre.remove(@menu_principale_box)
    SelectionMode.new(@fenetre, @ratio)
  end

  # on_jouer_clicked
  #
  # Action qui s'execute lorsque l'on clique sur le bouton catalogue
  #
  # ferme la box des menus et affiche une nouvelle box
  def on_catalogue_clicked
    @fenetre.remove(@menu_principale_box)
    Catalogue.new(@fenetre, @ratio)
  end

  # on_classement_clicked
  #
  # Action qui s'execute lorsque l'on clique sur le bouton classement
  #
  # ferme la box des menus et affiche une nouvelle box
  def on_classement_clicked
    @fenetre.remove(@menu_principale_box)
  end

  # on_options_clicked
  #
  # Action qui s'execute lorsque l'on clique sur le bouton option
  #
  # ferme la box des menus et affiche une nouvelle box
  def on_options_clicked
    @fenetre.remove(@menu_principale_box)
    Options.new(@fenetre)
  end

  # on_quitter_clicked
  #
  # Action qui s'execute lorsque l'on clique sur le bouton quitter
  #
  # ferme l'application
  def on_quitter_clicked
    puts 'Gtk.main_quit'
    Gtk.main_quit
  end

end
