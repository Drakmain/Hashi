require 'gtk3'
load 'Donnees.rb'
load 'Plateau.rb'

class RubyApp < Gtk::Fixed

  def initialize(fenetre, map, sens_popover, fini_dialog,fini_label,mode,difficulte,niveau)
    super()
    @fenetre = fenetre
    @sens_popover = sens_popover
    @fini_dialog = fini_dialog
    @map = map
    @mode = mode
    @difficulte = difficulte
    @niveau = niveau
    @fini_label=fini_label

    @matrixPix = []
    @matrixImg = []
    @donnee = Donnees.new
    @events = []
    @tab_events = []

    @donnee.getMatrice(@map.fichierJeu)

    create_imgs
    put_img(@tab_events)

    if !@map.coups.empty?
      @map.coups.each do |i|
        if i.estHorizontal?
          afficher_pont('horizontal', i.pont.x, i.pont.y)
        else
          afficher_pont('vertical', i.pont.x, i.pont.y)
        end
      end
    end
  end

  def create_imgs
    numbers = []

    (0...@donnee.y).each do |i|
      (0...@donnee.x).each do |j|
        @matrixPix.push("Img_#{i}_#{j}")
        @events.push("eventImg_#{i}_#{j}")
        numbers.push(@donnee.matrix[i][j])
      end
    end

    @events.each do |name|
      @tab_events << instance_variable_set("@#{name}", Gtk::EventBox.new)
    end

    (0...@matrixPix.length).each do |i|
      pixbuf = GdkPixbuf::Pixbuf.new(file: "../data/img/#{numbers[i]}.png")
      image = Gtk::Image.new(pixbuf: pixbuf)
      image.set_name(@matrixPix[i])
      @tab_events[i].add(image)

      @tab_events[i].signal_connect 'button-press-event' do |widget, event|
        tmp = widget.child.name.split('_')
        @x = tmp[1].to_i
        @y = tmp[2].to_i

        case event.button
        when 1
          @click = true
        when 3
          @click = false
        end

        sens = @map.jouerCoupInterface(@x, @y, @click)

        @sens_popover.set_relative_to(widget)

        jouer_afficher_pont(sens, @x, @y, @click)
      end

      @tab_events[i].signal_connect "enter-notify-event" do |widget, event|
        tmp = widget.child.name.split('_')
        x = tmp[1].to_i
        y = tmp[2].to_i

        actualiserPontAjoutables(@map.plateau.getCase(x, y), x, y, true)
      end

      @tab_events[i].signal_connect "leave-notify-event" do |widget, event|
        tmp = widget.child.name.split('_')
        x = tmp[1].to_i
        y = tmp[2].to_i

        actualiserPontAjoutables(@map.plateau.getCase(x, y), x, y, false)
      end

    end

  end

  def put_img(coups)
    xl = 0
    yl = 0
    cpt = 0

    (0...@donnee.x * @donnee.y).each do |i|
      put coups[i], xl, yl
      xl += 50
      cpt += 1
      if cpt == @donnee.x
        yl += 50
        xl = 0
        cpt = 0
      end
    end
  end

  def set_sens(sens)
    jouer_afficher_pont(sens, @x, @y, @click)
    @sens_popover.popdown
  end

  def jouer_afficher_pont(sens, x, y, click)

    case sens
    when 'vertical'
      bool = @map.jouerCoupVerticaleInterface(x, y, click)

      if bool
        nb_ponts = @map.plateau.getCase(x, y).element.nb_ponts
        while @map.plateau.getCase(x, y).element.estPont?
          x += 1
        end

        afficher_ile_pleine(x, y)

        x -= 1

        while @map.plateau.getCase(x, y).element.estPont?
          changer_image(nb_ponts, 'V', x, y)

          x -= 1
        end

        afficher_ile_pleine(x, y)
      end

      @fenetre.show_all
      @map.afficherPlateau
    when 'horizontal'
      bool = @map.jouerCoupHorizontaleInterface(x, y, click)

      if bool
        nb_ponts = @map.plateau.getCase(x, y).element.nb_ponts
        while @map.plateau.getCase(x, y).element.estPont?
          y += 1
        end

        afficher_ile_pleine(x, y)

        y -= 1

        while @map.plateau.getCase(x, y).element.estPont?
          changer_image(nb_ponts, 'H', x, y)

          y -= 1
        end

        afficher_ile_pleine(x, y)

        @fenetre.show_all
        @map.afficherPlateau
      end
    when false
      @sens_popover.popup
    end

    if @map.plateau.partieFini?
      @fini_label.set_text("Bravo !\nVous avez fini le niveau #{@niveau} en mode #{@mode} en difficulte #{@difficulte} \nVotre temps est de #{@map.chrono.chrono} et votre score est de #{@map.score} ")
      @map.chrono.pauserChrono
      @fini_dialog.run
    end
  end

  def changer_image(nb_ponts, sens, x, y)
    if @map.hypothese == true
      sens = "H#{sens}"
    end

    if @map.plateau.getCase(x, y).element.erreur
      sens = "E#{sens}"
    end

    case nb_ponts
    when 0
      pixbuf = GdkPixbuf::Pixbuf.new(file: '../data/img/0.png')
      image = Gtk::Image.new(pixbuf: pixbuf)
      image.set_name("Img_#{x}_#{y}")
    when 1
      pixbuf = GdkPixbuf::Pixbuf.new(file: "../data/img/pont#{sens}1.png")
      image = Gtk::Image.new(pixbuf: pixbuf)
      image.set_name("p1h_#{x}_#{y}")
    when 2
      pixbuf = GdkPixbuf::Pixbuf.new(file: "../data/img/pont#{sens}2.png")
      image = Gtk::Image.new(pixbuf: pixbuf)
      image.set_name("p2h_#{x}_#{y}")
    end

    @tab_events[@map.plateau.y * x + y].remove(@tab_events[@map.plateau.y * x + y].child)
    @tab_events[@map.plateau.y * x + y].child = image
  end

  def afficher_ile_pleine(x, y)
    valeur = @map.plateau.getCase(x, y).element.valeur

    if @map.plateau.getCase(x, y).element.estFini?
      pixbuf = GdkPixbuf::Pixbuf.new(file: "../data/img/#{valeur.to_s}Pleine.png")
    else
      pixbuf = GdkPixbuf::Pixbuf.new(file: "../data/img/#{valeur.to_s}.png")
    end

    image = Gtk::Image.new(pixbuf: pixbuf)
    image.set_name("Img_#{x}_#{y}")
    @tab_events[@map.plateau.y * x + y].remove(@tab_events[@map.plateau.y * x + y].child)
    @tab_events[@map.plateau.y * x + y].child = image
  end

  def afficher_pont(sens, x, y)

    nb_ponts = @map.plateau.getCase(x, y).element.nb_ponts
    case sens
    when 'vertical'
      while @map.plateau.getCase(x, y).element.estPont?
        x += 1
      end

      afficher_ile_pleine(x, y)

      x -= 1

      while @map.plateau.getCase(x, y).element.estPont?
        changer_image(nb_ponts, 'V', x, y)

        x -= 1
      end

      afficher_ile_pleine(x, y)
    when 'horizontal'
      while @map.plateau.getCase(x, y).element.estPont?
        y += 1
      end

      afficher_ile_pleine(x, y)

      y -= 1

      while @map.plateau.getCase(x, y).element.estPont?
        changer_image(nb_ponts, 'H', x, y)

        y -= 1
      end

      afficher_ile_pleine(x, y)
    end

    @fenetre.show_all
    @map.afficherPlateau
  end

  def actualiserPontAjoutables(caseCourante, unX, unY, unBool)
    nbPonts = caseCourante.pontAjoutables
    pixbuf = GdkPixbuf::Pixbuf.new(file: '../data/img/0.png')
    x = unX
    y = unY
    if nbPonts - 1000 >= 0
      nbPonts -= 1000
      x += 1
      while @map.plateau.getCase(x, y).element.estPont?
        if unBool
          pixbuf = GdkPixbuf::Pixbuf.new(file: '../data/img/pontPV1.png')
        end
        @tab_events[@map.plateau.y * x + y].remove(@tab_events[@map.plateau.y * x + y].child)
        image = Gtk::Image.new(pixbuf: pixbuf)
        image.set_name("Img_#{x}_#{y}")
        @tab_events[@map.plateau.y * x + y].child = image
        x += 1
      end
    end

    x = unX
    y = unY
    if nbPonts - 100 >= 0
      nbPonts -= 100
      x -= 1
      while @map.plateau.getCase(x, y).element.estPont?
        if unBool
          pixbuf = GdkPixbuf::Pixbuf.new(file: '../data/img/pontPV1.png')
        end
        @tab_events[@map.plateau.y * x + y].remove(@tab_events[@map.plateau.y * x + y].child)
        image = Gtk::Image.new(pixbuf: pixbuf)
        image.set_name("Img_#{x}_#{y}")
        @tab_events[@map.plateau.y * x + y].child = image
        x -= 1
      end
    end

    x = unX
    y = unY
    if nbPonts - 10 >= 0
      nbPonts -= 10
      y -= 1
      while @map.plateau.getCase(x, y).element.estPont?
        if unBool
          pixbuf = GdkPixbuf::Pixbuf.new(file: '../data/img/pontPH1.png')
        end
        @tab_events[@map.plateau.y * x + y].remove(@tab_events[@map.plateau.y * x + y].child)
        image = Gtk::Image.new(pixbuf: pixbuf)
        image.set_name("Img_#{x}_#{y}")
        @tab_events[@map.plateau.y * x + y].child = image
        y -= 1
      end
    end

    x = unX
    y = unY
    if nbPonts - 1 >= 0
      nbPonts -= 1
      y += 1
      while @map.plateau.getCase(x, y).element.estPont?
        if unBool
          pixbuf = GdkPixbuf::Pixbuf.new(file: '../data/img/pontPH1.png')
        end
        @tab_events[@map.plateau.y * x + y].remove(@tab_events[@map.plateau.y * x + y].child)
        image = Gtk::Image.new(pixbuf: pixbuf)
        image.set_name("Img_#{x}_#{y}")
        @tab_events[@map.plateau.y * x + y].child = image
        y += 1
      end
    end

    @fenetre.show_all

    if @map.plateau.partieFini?
      
      @fini_label.set_text("Bravo !\nVous avez fini le niveau #{@niveau} en mode #{@mode} en difficulte #{@difficulte} \nVotre temps est de #{@map.chrono.chrono} et votre score est de #{@map.score} ")
      @map.sauvegarder_score
      @map.chrono.pauserChrono
      set_sensitive(false)
      @fini_dialog.run
    end

  end

  def refaire
    case_redo = @map.refaire

    unless case_redo.nil?
      @map.afficherPlateau

      if case_redo.element.sensHorizontal
        afficher_pont('horizontal', case_redo.x, case_redo.y)
      else
        afficher_pont('vertical', case_redo.x, case_redo.y)
      end
    end
  end

  def annuler
    case_undo = @map.annuler

    unless case_undo.nil?
      @map.afficherPlateau

      if case_undo.element.sensHorizontal
        afficher_pont('horizontal', case_undo.x, case_undo.y)
      else
        afficher_pont('vertical', case_undo.x, case_undo.y)
      end
    end
  end

  def corrigerErreur
    @map.corrigerErreur
    @map.afficherPlateau
    actualiserAffichage
  end

  def afficherErreur
    @map.afficherPontErreur
    @map.coups.each do |c|
      if c.pont.element.erreur
        afficher_pont(c.sens, c.pont.x, c.pont.y)
      end
    end
  end

  def actualiserAffichage
    (0...@donnee.x).each do |i|
      (0...@donnee.y).each do |j|
        if @tab_events[@map.plateau.y * j + i].child.name.match(/^Img/)
          if @map.plateau.getCase(j, i).element.estIle?
            unless @map.plateau.getCase(j, i).element.estFini?
              afficher_ile_pleine(j, i);
            end
          end
        end
        if @tab_events[@map.plateau.y * j + i].child.name.match(/^p2/)
          if @map.plateau.getCase(j, i).element.estPont?
            if @map.plateau.getCase(j, i).element.nb_ponts <= 1
              @tab_events[@map.plateau.y * j + i].remove(@tab_events[@map.plateau.y * j + i].child)
              if @map.plateau.getCase(j, i).element.estVertical?
                pixbuf = GdkPixbuf::Pixbuf.new(file: '../data/img/pontV1.png')
                image = Gtk::Image.new(pixbuf: pixbuf)
                image.set_name("p1v_#{j}_#{i}")
              else
                pixbuf = GdkPixbuf::Pixbuf.new(file: '../data/img/pontH1.png')
                image = Gtk::Image.new(pixbuf: pixbuf)
                image.set_name("p1h_#{j}_#{i}")
              end
              @tab_events[@map.plateau.y * j + i].child = image
            end
          end
        end

        if @tab_events[@map.plateau.y * j + i].child.name.match(/^p1/)
          if @map.plateau.getCase(j, i).element.estPont?
            if @map.plateau.getCase(j, i).element.nb_ponts == 0
              @tab_events[@map.plateau.y * j + i].remove(@tab_events[@map.plateau.y * j + i].child)
              pixbuf = GdkPixbuf::Pixbuf.new(file: '../data/img/0.png')
              image = Gtk::Image.new(pixbuf: pixbuf)
              image.set_name("Img_#{j}_#{i}")
              @tab_events[@map.plateau.y * j + i].child = image
            end
          end
        end
      end
    end

    @fenetre.show_all
  end

end
