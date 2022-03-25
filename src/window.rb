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

  def signal(window_instance)
    window_builder = window_instance.builder

    window_builder.connect_signals do |handler|
      window_instance.method(handler)
    rescue StandardError
      puts "#{handler} not yet implemented!"
      window_instance.method('not_yet_implemented')
    end
  end

  def on_destroy
    puts 'Gtk main_quit'
    Gtk.main_quit
  end

  def not_yet_implemented(_object)
    puts "#{object.class.name} sent a signal!"
  end

end
