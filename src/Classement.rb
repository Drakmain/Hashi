class Classement < Gtk::Builder

  def initialize(fenetre, ratio)
    super()
    add_from_file('../data/glade/Classement.glade')
    @ratio = ratio
    @fenetre = fenetre

    objects.each do |p|
      unless p.builder_name.start_with?('___object')
        instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
      end
    end

    @mode_comboxbox.set_size_request(-1, 50 * @ratio)
    @retour_button.set_size_request(-1, 50 * @ratio)
    @difficulte_comboxbox.set_size_request(-1, 50 * @ratio)
    @niveau_comboxbox.set_size_request(-1, 50 * @ratio)
    @chercher_button.set_size_request(-1, 50 * @ratio)
    @difficulte_comboxbox.set_sensitive(false)
    @niveau_comboxbox.set_sensitive(false)
    @chercher_button.set_sensitive(false)

    (0...10).each do |i|
      @niveau_comboxbox.append_text((1 + i).to_s)
    end

    connect_signals do |handler|
      method(handler)
    rescue StandardError
      puts "#{handler} n'est pas encore implementer !"
    end

    @fenetre.add(@classement_box)
    @fenetre.show_all
  end

  def on_retour_button_clicked
    @fenetre.remove(@classement_box)
    @fenetre.resize(1280 * @ratio, 720 * @ratio)
    MenuPrincipal.new(@fenetre, @ratio)
  end

  def on_mode_comboxbox_changed(widget)
    @mode = widget.active_text.downcase
    @difficulte_comboxbox.set_sensitive(true)
  end

  def on_difficulte_comboxbox_changed(widget)
    @difficulte = widget.active_text.downcase
    @niveau_comboxbox.set_sensitive(true)
  end

  def on_niveau_comboxbox_changed(widget)
    @niveau = widget.active_text
    @chercher_button.set_sensitive(true)
  end

  def on_chercher_button_clicked
    if @classement_scrolled.child != nil
      if @classement_scrolled.child.name == 'GtkTreeView'
        @classement_scrolled.remove(@tv)
      end
    end

    begin
      @score = File.read("../data/map/#{@difficulte}/score/#{@niveau}#{@mode}.txt")
    rescue StandardError
      @pas_score_popover.popup
      return false
    end

    @score = @score.split("\n")

    (0..@score.length - 1).each do |i|
      @score[i] = @score[i].split('_')
    end

    model = Gtk::TreeStore.new(String, String, String)

    (0..@score.length - 1).each do |i|
      root_iter = model.append(nil)
      root_iter[0] = @score[i][0]
      root_iter[1] = @score[i][1]
      root_iter[2] = @score[i][2]
    end

    @tv = Gtk::TreeView.new(model)

    renderer = Gtk::CellRendererText.new
    column = Gtk::TreeViewColumn.new('Utilisateur', renderer, {
      :text => 0
    })

    @tv.append_column(column)

    renderer = Gtk::CellRendererText.new
    column = Gtk::TreeViewColumn.new('Score', renderer, {
      :text => 1
    })

    @tv.append_column(column)

    renderer = Gtk::CellRendererText.new
    column = Gtk::TreeViewColumn.new('Temps', renderer, {
      :text => 2
    })

    @tv.append_column(column)

    @classement_scrolled.add(@tv)

    @fenetre.show_all
  end

  def on_trie_score_button_clicked
    if @classement_scrolled.child != nil
      if @classement_scrolled.child.name == 'GtkTreeView'
        @classement_scrolled.remove(@tv)
      end
    end

    @score = @score.sort_by { |obj| obj[1] }

    model = Gtk::TreeStore.new(String, String, String)

    (0..@score.length - 1).each do |i|
      root_iter = model.append(nil)
      root_iter[0] = @score[i][0]
      root_iter[1] = @score[i][1]
      root_iter[2] = @score[i][2]
    end

    @tv = Gtk::TreeView.new(model)

    renderer = Gtk::CellRendererText.new
    column = Gtk::TreeViewColumn.new('Utilisateur', renderer, {
      :text => 0
    })

    @tv.append_column(column)

    renderer = Gtk::CellRendererText.new
    column = Gtk::TreeViewColumn.new('Score', renderer, {
      :text => 1
    })

    @tv.append_column(column)

    renderer = Gtk::CellRendererText.new
    column = Gtk::TreeViewColumn.new('Temps', renderer, {
      :text => 2
    })

    @tv.append_column(column)

    @classement_scrolled.add(@tv)

    @fenetre.show_all
  end

  def on_trie_temps_button_clicked
    if @classement_scrolled.child != nil
      if @classement_scrolled.child.name == 'GtkTreeView'
        @classement_scrolled.remove(@tv)
      end
    end

    @score = @score.sort_by { |obj| obj[2] }

    model = Gtk::TreeStore.new(String, String, String)

    (0..@score.length - 1).each do |i|
      root_iter = model.append(nil)
      root_iter[0] = @score[i][0]
      root_iter[1] = @score[i][1]
      root_iter[2] = @score[i][2]
    end

    @tv = Gtk::TreeView.new(model)

    renderer = Gtk::CellRendererText.new
    column = Gtk::TreeViewColumn.new('Utilisateur', renderer, {
      :text => 0
    })

    @tv.append_column(column)

    renderer = Gtk::CellRendererText.new
    column = Gtk::TreeViewColumn.new('Score', renderer, {
      :text => 1
    })

    @tv.append_column(column)

    renderer = Gtk::CellRendererText.new
    column = Gtk::TreeViewColumn.new('Temps', renderer, {
      :text => 2
    })

    @tv.append_column(column)

    @classement_scrolled.add(@tv)

    @fenetre.show_all
  end

end
