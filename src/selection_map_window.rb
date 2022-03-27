load 'Plateau.rb'

# class SelectionDifficulteWindow
# @window
# @mode
# @difficulte
# @builder
class SelectionMapWindow < Window

  def initialize(mode, difficulte)
    super('../data/glade/selection_map.glade')
    @mode = mode
    @difficulte = difficulte
  end

  def set_window
    @window = @builder.get_object('selection_map')

    selection_map_scrolled = @builder.get_object('selection_map_scrolled')
    selection_map_scrolled.set_min_content_height(600)

    selection_map_box = @builder.get_object('selection_map_box')

    selection_map_scrolled = @builder.get_object('selection_map_scrolled')

    titre_label = @builder.get_object('titre_label')
    titre_label.set_text("Choix de la map en #{@mode}, Difficulté #{@difficulte}")

    dir = "../data/map/#{@difficulte}/demarrage"
    nb_niv = Dir[File.join(dir, '**', '*')].count { |file| File.file?(file) }

    model = Gtk::TreeStore.new(String, String)

    p = Plateau.creer()

    (1..nb_niv).each do |i|
      root_iter = model.append(nil)

      p.generateMatrice("#{dir}/#{i}.txt")

      root_iter[0] = "Niveau #{i}"
      root_iter[1] = "#{p.x} * #{p.y}"
    end

    tv = Gtk::TreeView.new(model)

    renderer = Gtk::CellRendererText.new
    column = Gtk::TreeViewColumn.new("Niveau", renderer, {
      :text => 0,
    })

    tv.append_column(column)

    # column 2
    renderer = Gtk::CellRendererText.new
    column = Gtk::TreeViewColumn.new("Taille", renderer, {
      :text => 1
    })

    tv.append_column(column)

    selection_map_scrolled.add(tv)

    @window.set_title("Hashi - Mode #{@mode.capitalize} : Difficulté #{@difficulte.capitalize}")
    @window.set_resizable(false)
    @window.set_default_size(1280, 720)
    @window.set_window_position(Gtk::WindowPosition::CENTER_ALWAYS)
    @window.show_all
  end

end
