load 'Catalogue.rb'
load 'SelectionMode.rb'
load 'Options.rb'

class MenuPrincipal < Gtk::Builder

  def initialize(fenetre)
    super()
    add_from_file('../data/glade/MenuPrincipal.glade')

    objects.each do |p|
      unless p.builder_name.start_with?('___object')
        instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
      end
    end

    @fenetre = fenetre
    @fenetre.add(@menu_principale_box)

    @classement.set_sensitive(false);

    connect_signals do |handler|
      method(handler)
    rescue StandardError
      puts "#{handler} n'est pas encore implementer !"
    end
  end

  def on_jouer_clicked
    @fenetre.remove(@menu_principale_box)
    SelectionMode.new(@fenetre)
  end

  def on_catalogue_clicked
    @fenetre.remove(@menu_principale_box)
    Catalogue.new(@fenetre)
  end

  def on_classement_clicked
    @fenetre.remove(@menu_principale_box)
  end

  def on_options_clicked
    @fenetre.remove(@menu_principale_box)
    Options.new(@fenetre)
  end

  def on_quitter_clicked
    puts 'Gtk.main_quit'
    Gtk.main_quit
  end

end
