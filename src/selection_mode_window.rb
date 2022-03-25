load 'selection_difficulte_window.rb'

# class SelectionModeWindow
# @window
class SelectionModeWindow < Window

  def initialize
    super('../data/glade/selection_mode.glade')
  end

  def set_window
    @window = @builder.get_object('selection_mode')

    @window.set_title('Hashi - Mode')
    @window.set_resizable(false)
    @window.set_default_size(1280, 720)
    @window.set_window_position(Gtk::WindowPosition::CENTER_ALWAYS)
    @window.show
  end

  def on_normal_clicked
    puts "on_normal_clicked"
    @selection_difficulte = SelectionDifficulteWindow.new('normal')

    signal(@selection_difficulte)

    @window.hide
    @selection_difficulte.set_window
  end

  def on_contre_la_montre_clicked
    puts "on_contre_la_montre_clicked"
    @selection_difficulte = SelectionDifficulteWindow.new('contre la montre')

    signal(@selection_difficulte)

    @window.hide
    @selection_difficulte.set_window
  end

  def on_génie_clicked
    puts "on_génie_clicked"
    @selection_difficulte = SelectionDifficulteWindow.new('genie')

    signal(@selection_difficulte)

    @window.hide
    @selection_difficulte.set_window
  end

  def on_tutoriel_clicked
    puts "on_tutoriel_clicked"
    @selection_difficulte = SelectionDifficulteWindow.new('tutoriel')

    signal

    @window.hide
    @selection_difficulte.set_window
  end

end
