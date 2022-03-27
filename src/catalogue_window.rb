require 'gtk3'

load 'window.rb'

# class CatalogueWindow
# @catalogue
# @regle
class CatalogueWindow < Window

  def initialize
    super('../data/glade/catalogue.glade')
    @catalogue = File.open('../data/catalogue/catalogue.txt')
    @regle = File.open('../data/catalogue/regles_du_jeu.txt')
  end

  def set_window
    window = @builder.get_object('catalogue')

    comment_jouer_scrolled = @builder.get_object('comment_jouer_scrolled')
    comment_jouer_scrolled.set_min_content_width(1280)
    comment_jouer_scrolled.set_min_content_height(720)

    techniques_scrolled = @builder.get_object('techniques_scrolled')
    techniques_scrolled.set_min_content_width(1280)
    techniques_scrolled.set_min_content_height(720)

    comment_jouer_buffer = Gtk::TextBuffer.new
    comment_jouer_buffer.set_text(@catalogue.read)

    comment_jouer_text_view = @builder.get_object('comment_jouer_text_view')
    comment_jouer_text_view.set_buffer(comment_jouer_buffer)

    techniques_jouer_buffer = Gtk::TextBuffer.new
    techniques_jouer_buffer.set_text(@regle.read)

    techniques_text_view = @builder.get_object('techniques_text_view')
    techniques_text_view.set_buffer(techniques_jouer_buffer)

    window.set_title('Hashi - Catalogue')
    window.set_resizable(false)
    window.set_default_size(1280, 720)
    window.set_window_position(Gtk::WindowPosition::CENTER_ALWAYS)
    window.show
  end

end
