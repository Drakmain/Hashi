require 'gtk3'

load 'Fenetre.rb'

provider = Gtk::CssProvider.new
provider.load(:path => "assets/style.css")
Gdk::Screen.default.add_style_provider(provider, 1000000000)
Fenetre.new
Gtk.main
