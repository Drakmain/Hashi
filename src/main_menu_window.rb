require 'gtk3'

load 'window.rb'
load 'options_window.rb'
load 'catalogue_window.rb'
load 'selection_mode_window.rb'

# class MainMenuWindow
# @window
class MainMenuWindow < Window

  attr_reader :builder

  def initialize
    super('../data/glade/main_menu.glade')
  end

  def on_options_clicked
    options = OptionsWindow.new

    signal(options)

    @window.hide
    options.set_window
  end

  def on_catalogue_clicked
    catalogue = CatalogueWindow.new

    signal(catalogue)

    @window.hide
    catalogue.set_window
  end

  def on_jouer_clicked
    selection_mode = SelectionModeWindow.new

    signal(selection_mode)

    @window.hide
    selection_mode.set_window
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
