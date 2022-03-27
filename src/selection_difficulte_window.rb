load 'selection_map_window.rb'

# class SelectionDifficulteWindow
# @mode
# @selection_map
# @window
class SelectionDifficulteWindow < Window

  def initialize(mode)
    super('../data/glade/selection_difficulte.glade')
    @mode = mode
  end

  def on_facile_clicked
    @selection_map = SelectionMapWindow.new(@mode, 'facile')

    signal(@selection_map)

    @window.hide
    @selection_map.set_window
  end

  def on_moyen_clicked
    @selection_map = SelectionMapWindow.new(@mode, 'moyen')

    signal(@selection_map)

    @window.hide
    @selection_map.set_window
  end

  def on_difficile_clicked
    @selection_map = SelectionMapWindow.new(@mode, 'difficile')

    signal(@selection_map)

    @window.hide
    @selection_map.set_window
  end

  def set_window
    @window = @builder.get_object('selection_difficulte')

    titre_label = @builder.get_object('titre_label')
    titre_label.set_text("Choix de difficulté en #{@mode}")

    @window.set_title("Hashi - Mode #{@mode.capitalize}")
    @window.set_resizable(false)
    @window.set_default_size(1280, 720)
    @window.set_window_position(Gtk::WindowPosition::CENTER_ALWAYS)
    @window.show
  end

end
