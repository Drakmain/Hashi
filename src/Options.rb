##
# @userName = Nom de l'utilisateur courant
# @resolutionRatio = ratio par le quelle on multiplie le format de l'ecran. Exemple 16/9 * 120 = 1920*1080. 100 donne 1600*900, 80 donne 1280*720
class Options < Gtk::Builder
  attr_reader :user, :ratio, :langue

  ##
  # Methode qui charge les donnees de
  def initialize(fenetre)
    super()
    add_from_file('../data/glade/Options.glade')
    @fenetre = fenetre

    @fichier_options = File.read('../data/options.json')

    @hashOptions = JSON.parse(@fichier_options)
    @user = @hashOptions['username']
    @ratio = @hashOptions['resolution_ratio']
    @langue = @hashOptions['langue']

    objects.each do |p|
      unless p.builder_name.start_with?('___object')
        instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
      end
    end

    @retour_button.set_size_request(-1, 50 * @ratio)

    @nom_utilisateur_entry.set_text(@user)

    case @ratio
    when 1
      @resolution_comboboxtext.set_active(0)
    when 1.25
      @resolution_comboboxtext.set_active(1)
    when 1.5
      @resolution_comboboxtext.set_active(2)
    end

    case @langue
    when 'Francais'
      @langue_comboboxtext.set_active(0)
    when 'Anglais'
      @langue_comboboxtext.set_active(1)
    when 'Espagnol'
      @langue_comboboxtext.set_active(2)
    end

    @fenetre.set_title('Hashi - Options')

    connect_signals do |handler|
      method(handler)
    rescue StandardError
      puts "#{handler} n'est pas encore implementer !"
    end

    @fenetre.add(@options_box)
  end

  def on_retour_button_clicked
    @fenetre.remove(@options_box)
    @fenetre.resize(1280 * @ratio, 720 * @ratio)
    MenuPrincipal.new(@fenetre, @ratio)
  end

  def on_resolution_comboboxtext_changed(resolution)
    puts "Resolution mis a jour #{resolution.active_text}"
    case resolution.active_text
    when '720p'
      @hashOptions['resolution_ratio'] = 1
      @ratio = 1
    when '900p'
      @hashOptions['resolution_ratio'] = 1.25
      @ratio = 1.25
    when '1080p'
      @hashOptions['resolution_ratio'] = 1.5
      @ratio = 1.5
    end

  end

  def on_langue_comboboxtext_changed(langue)
    puts "Langue mis a jour #{langue.active_text}"
    @hashOptions['langue'] = langue.active_text
    @langue = langue.active_text
  end

  def on_nom_utilisateur_entry_changed(username)
    puts "Nom d'utilisateur mis a jour to \"#{username.text}\""
    @hashOptions['username'] = username.text
    @user = username.text
  end

  def on_enregistre_button_clicked
    puts 'Options sauvegarde'
    fichier = File.open('../data/settings/options.json', 'w')
    fichier.write(JSON.dump(@hashOptions))
    fichier.close
  end

  def to_s
    "Username : #{@user} \nResolution : #{(9 * @ratio.to_i())}p \nLangue : #{@langue}\n"
  end
end
