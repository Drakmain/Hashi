require 'gtk3'

load 'window.rb'
load 'Options.rb'

# class OptionsWindow
# @option
class OptionsWindow < Window

  def initialize
    super('../data/glade/options.glade')
    @option = Options.new
  end

  def on_changed_reso(resolution)
    puts "Resolution updated to #{resolution.active_text}"
    @option.updateResolutionratio(resolution.active_text)
  end

  def on_changed_lang(langue)
    puts "Language updated to #{langue.active_text}"
    @option.updateLangue(langue.active_text)
  end

  def on_changed_theme(theme)
    puts "Theme updated to #{theme.active_text}"
    @option.updateTheme(theme.active_text)
  end

  def on_changed_username(username)
    puts "Username updated to \"#{username.text}\""
    @option.updateUser(username.text)
  end

  def on_theme_switch_state_set(switch, state)
    if state == true
      switch.set_state(true)
      puts 'Theme updated to dark'
      @option.updateTheme('dark')
    else
      switch.set_state(false)
      puts 'Theme updated to light'
      @option.updateTheme('light')
    end
  end

  def on_cliked_enregistre
    puts 'Settings saved'
    @option.enregistrer
  end

  def set_window
    window = @builder.get_object('options')

    nom_utilisateur_entry = @builder.get_object('nom_utilisateur_entry')
    nom_utilisateur_entry.set_text(@option.user)

    resolution_comboboxtext = @builder.get_object('resolution_comboboxtext')

    case @option.ratio
    when '720p'
      resolution_comboboxtext.set_active(0)
    when '900p'
      resolution_comboboxtext.set_active(1)
    when '1080p'
      resolution_comboboxtext.set_active(2)
    end

    langue_comboboxtext = @builder.get_object('langue_comboboxtext')
    case @option.langue
    when 'Francais'
      langue_comboboxtext.set_active(0)
    when 'Anglais'
      langue_comboboxtext.set_active(1)
    when 'Espagnol'
      langue_comboboxtext.set_active(2)
    end

    theme_switch = @builder.get_object('theme_switch')
    if (@option.theme == 'dark')
      theme_switch.set_active(true)
    else
      theme_switch.set_active(false)
    end

    window.set_title('Hashi - Options')
    window.set_resizable(false)
    window.set_default_size(1280, 720)
    window.set_window_position(Gtk::WindowPosition::CENTER_ALWAYS)
    window.show
  end

end

# resolutions 1920 1080/ 1600 900/ 1280 720
# theme clair/sombre
# langue francais anglais espag
# nom utilisateur
# button save
