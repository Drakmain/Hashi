class Catalogue < Gtk::Builder

  def initialize(fenetre)
    super()
    add_from_file('../data/glade/Catalogue.glade')

    objects.each do |p|
      unless p.builder_name.start_with?('___object')
        instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
      end
    end

    @fenetre = fenetre
    @fenetre.add(@catalogue_box)

    @catalogue = File.open('../data/catalogue/catalogue.txt').read
    @regle = File.open('../data/catalogue/regles_du_jeu.txt').read

    comment_jouer_scrolled = get_object('comment_jouer_scrolled')
    comment_jouer_scrolled.set_min_content_width(1280)
    comment_jouer_scrolled.set_min_content_height(600)

    techniques_scrolled = get_object('techniques_scrolled')
    techniques_scrolled.set_min_content_width(1280)
    techniques_scrolled.set_min_content_height(600)

    comment_jouer_buffer = Gtk::TextBuffer.new
    comment_jouer_buffer.set_text(@catalogue)

    comment_jouer_text_view = get_object('comment_jouer_text_view')
    comment_jouer_text_view.set_buffer(comment_jouer_buffer)

    techniques_jouer_buffer = Gtk::TextBuffer.new
    techniques_jouer_buffer.set_text(@regle)

    techniques_text_view = get_object('techniques_text_view')
    techniques_text_view.set_buffer(techniques_jouer_buffer)

    @fenetre.set_title('Hashi - Catalogue')

    connect_signals do |handler|
      method(handler)
    rescue StandardError
      puts "#{handler} n'est pas encore implementer !"
    end
  end

  def on_retour_button_clicked
    @fenetre.remove(@catalogue_box)
    MenuPrincipal.new(@fenetre)
  end

end