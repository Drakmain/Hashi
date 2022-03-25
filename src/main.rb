#!/usr/bin/env ruby

require 'gtk3'

load 'main_menu_window.rb'

main_menu = MainMenuWindow.new
main_menu_builder = main_menu.builder

# Attach signals handlers of main_menu
main_menu_builder.connect_signals do |handler|
  main_menu.method(handler)
rescue StandardError
  puts "#{handler} not yet implemented!"
  main_menu.method('not_yet_implemented')
end

main_menu.set_window

Gtk.main
