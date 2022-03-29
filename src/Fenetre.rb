require 'gtk3'

load 'MenuPrincipal.rb'

class Fenetre < Gtk::Builder

  def initialize
    super()
    add_from_file('../data/glade/Fenetre.glade')

    objects.each { |p|
      unless p.builder_name.start_with?('___object')
        instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
      end
    }

    begin
      @fichierOptions = File.read('../data/settings/settings.json')
    rescue
      @fichierOptions = File.open('../data/settings/settings.json', 'w')
      @fichierOptions.write('{"username": "Oue","resolutionratio": 1,"theme": "clair","langue": "Francais"}')
      @fichierOptions.close
      @fichierOptions = File.read('../data/settings/settings.json')
    end

    @hashOptions = JSON.parse(@fichierOptions)
    @ratio = @hashOptions['resolutionratio']

    @fenetre.set_resizable(false)
    @fenetre.set_default_size(1280 * @ratio, 720 * @ratio)
    @fenetre.set_title('Hashi')
    @fenetre.show_all
    @fenetre.set_window_position Gtk::WindowPosition::CENTER_ALWAYS
    @fenetre.signal_connect('destroy') do
      puts 'Gtk.main_quit'
      Gtk.main_quit
    end

    MenuPrincipal.new(@fenetre)
  end

end
