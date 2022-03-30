require 'gtk3'

load 'MenuPrincipal.rb'

class Fenetre < Gtk::Builder

  attr_reader :ratio

  def initialize
    super()
    add_from_file('../data/glade/Fenetre.glade')

    objects.each { |p|
      unless p.builder_name.start_with?('___object')
        instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
      end
    }

    begin
      @fichierOptions = File.read('../data/settings/options.json')
    rescue
      @fichierOptions = File.open('../data/settings/options.json', 'w')
      @fichierOptions.write('{"username": "Invité","resolution_ratio": 1,"theme": "clair","langue": "Francais"}')
      @fichierOptions.close
      @fichierOptions = File.read('../data/settings/options.json')
    end

    @hashOptions = JSON.parse(@fichierOptions)
    @ratio = @hashOptions['resolution_ratio']

    @fenetre.set_resizable(false)
    @fenetre.set_default_size(1280 * @ratio, 720 * @ratio)
    @fenetre.show_all
    @fenetre.set_window_position Gtk::WindowPosition::CENTER_ALWAYS

    @fenetre.set_name(@ratio.to_s)

    @fenetre.signal_connect('destroy') do
      puts 'Gtk.main_quit'
      Gtk.main_quit
    end

    MenuPrincipal.new(@fenetre, @ratio)
  end

end
