require 'gtk3'

# class Window
# @builder
# @window
class Window < Gtk::Window

  attr_reader :builder

  def initialize(glade_file)
    @builder = Gtk::Builder.new
    @builder.add_from_file(glade_file)
    @window = nil
  end

  def on_destroy
    puts 'Gtk main_quit'
    Gtk.main_quit
  end

  def not_yet_implemented(_object)
    puts "#{object.class.name} sent a signal!"
  end

end
