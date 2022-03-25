require 'gtk3'

load 'window.rb'
load 'options_window.rb'
load 'catalogue_window.rb'

# class MainMenuWindow
# @window
class MainMenuWindow < Window

  attr_reader :builder

  def initialize
    super('../data/glade/main_menu.glade')
  end

  def on_options_cliked
    options = OptionsWindow.new
    options_builder = options.builder

    options_builder.connect_signals do |handler|
      options.method(handler)
    rescue StandardError
      puts "#{handler} not yet implemented!"
      options.method('not_yet_implemented')
    end

    options.set_window
    @window.hide
  end

  def on_catalogue_cliked
    catalogue = CatalogueWindow.new
    catalogue_builder = catalogue.builder

    catalogue_builder.connect_signals do |handler|
      catalogue.method(handler)
    rescue StandardError
      puts "#{handler} not yet implemented!"
      catalogue.method('not_yet_implemented')
    end

    catalogue.set_window
    @window.hide
  end

  def set_window
    @window = @builder.get_object('main_menu')

    @window.set_title('Hashi - Menu Principal')
    @window.set_resizable(false)
    @window.set_default_size(1280, 720)
    @window.set_window_position(Gtk::WindowPosition::CENTER_ALWAYS)
    @window.show
  end

end
