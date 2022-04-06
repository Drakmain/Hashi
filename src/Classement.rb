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

    @retour_button.set_size_request(-1, 50 * @ratio)
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
    @mode = widget.active_text
    @difficulte_comboxbox.set_sensitive(true)
  end

  def on_difficulte_comboxbox_changed(widget)
    @difficulte = widget.active_text
    @niveau_comboxbox.set_sensitive(true)
  end

  def on_niveau_comboxbox_changed(widget)
    @niveau = widget.active_text
    @chercher_button.set_sensitive(true)
  end

  def on_chercher_button_clicked
    puts File.read("../data/map/#{@difficulte}/score/#{@niveau}")
  end

end
