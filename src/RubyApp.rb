require 'gtk3'
load 'Donnees.rb'
load 'Plateau.rb'

class RubyApp < Gtk::Fixed

  def initialize(fenetre, map, sens_popover, fini_dialog)
    super()
    @fenetre = fenetre
    @sens_popover = sens_popover
    @fini_dialog = fini_dialog

    @map = map

    @matrixPix = Array.new
    @matrixImg = Array.new
    @donnee = Donnees.new
    @events = Array.new
    @tab_events = Array.new

    @donnee.getMatrice(@map.fichierJeu)

    @map.initialiserJeu

    init_ui
  end

  def init_ui
    create_imgs
    put_img(@tab_events)
  end

  def create_imgs
    numbers = Array.new()

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
      pixbuf = GdkPixbuf::Pixbuf.new(:file => "../data/img/#{numbers[i]}.png")
      image = Gtk::Image.new(:pixbuf => pixbuf)
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

        x -= 1

        while @map.plateau.getCase(x, y).element.estPont?
          case nb_ponts
          when 0
            pixbuf = GdkPixbuf::Pixbuf.new(:file => '../data/img/0.png')
          when 1
            pixbuf = GdkPixbuf::Pixbuf.new(:file => '../data/img/pontV1.png')
          when 2
            pixbuf = GdkPixbuf::Pixbuf.new(:file => '../data/img/pontV2.png')
          end

          @tab_events[@map.plateau.y * x + y].remove(@tab_events[@map.plateau.y * x + y].child)

          image = Gtk::Image.new(:pixbuf => pixbuf)
          image.set_name("Img_#{x}_#{y}")

          @tab_events[@map.plateau.y * x + y].child = image

          x -= 1
        end
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

        y -= 1

        while @map.plateau.getCase(x, y).element.estPont?
          case nb_ponts
          when 0
            pixbuf = GdkPixbuf::Pixbuf.new(:file => '../data/img/0.png')
          when 1
            pixbuf = GdkPixbuf::Pixbuf.new(:file => '../data/img/pontH1.png')
          when 2
            pixbuf = GdkPixbuf::Pixbuf.new(:file => '../data/img/pontH2.png')
          end
          @tab_events[@map.plateau.y * x + y].remove(@tab_events[@map.plateau.y * x + y].child)

          image = Gtk::Image.new(:pixbuf => pixbuf)
          image.set_name("Img_#{x}_#{y}")

          @tab_events[@map.plateau.y * x + y].child = image

          y -= 1
        end

        @fenetre.show_all
        @map.afficherPlateau
      end
    when false
      @sens_popover.popup
    end

    if @map.plateau.partieFini?
      @fini_dialog.run
    end
  end

  def afficher_pont(sens, x, y)

    case sens
    when 'vertical'

      nb_ponts = @map.plateau.getCase(x, y).element.nb_ponts
      while @map.plateau.getCase(x, y).element.estPont?
        x += 1
      end

      x -= 1

      while @map.plateau.getCase(x, y).element.estPont?
        case nb_ponts
        when 0
          pixbuf = GdkPixbuf::Pixbuf.new(:file => '../data/img/0.png')
        when 1
          pixbuf = GdkPixbuf::Pixbuf.new(:file => '../data/img/pontV1.png')
        when 2
          pixbuf = GdkPixbuf::Pixbuf.new(:file => '../data/img/pontV2.png')
        end

        @tab_events[@map.plateau.y * x + y].remove(@tab_events[@map.plateau.y * x + y].child)

        image = Gtk::Image.new(:pixbuf => pixbuf)
        image.set_name("Img_#{x}_#{y}")

        @tab_events[@map.plateau.y * x + y].child = image

        x -= 1
      end

      @fenetre.show_all
      @map.afficherPlateau
    when 'horizontal'

      nb_ponts = @map.plateau.getCase(x, y).element.nb_ponts
      while @map.plateau.getCase(x, y).element.estPont?
        y += 1
      end

      y -= 1

      while @map.plateau.getCase(x, y).element.estPont?
        case nb_ponts
        when 0
          pixbuf = GdkPixbuf::Pixbuf.new(:file => '../data/img/0.png')
        when 1
          pixbuf = GdkPixbuf::Pixbuf.new(:file => '../data/img/pontH1.png')
        when 2
          pixbuf = GdkPixbuf::Pixbuf.new(:file => '../data/img/pontH2.png')
        end
        @tab_events[@map.plateau.y * x + y].remove(@tab_events[@map.plateau.y * x + y].child)

        image = Gtk::Image.new(:pixbuf => pixbuf)
        image.set_name("Img_#{x}_#{y}")

        @tab_events[@map.plateau.y * x + y].child = image

        y -= 1
      end

      @fenetre.show_all
      @map.afficherPlateau

    end

  end

  def actualiserPontAjoutables(caseCourante, unX, unY, unBool)
    nbPonts = caseCourante.pontAjoutables
    pixbuf = GdkPixbuf::Pixbuf.new(:file => '../data/img/0.png')
    x = unX
    y = unY
    if nbPonts - 1000 >= 0
      nbPonts -= 1000
      x += 1
      while @map.plateau.getCase(x, y).element.estPont?
        if unBool
          pixbuf = GdkPixbuf::Pixbuf.new(:file => '../data/img/pontPV1.png')
        end
        @tab_events[@map.plateau.y * x + y].remove(@tab_events[@map.plateau.y * x + y].child)
        image = Gtk::Image.new(:pixbuf => pixbuf)
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
          pixbuf = GdkPixbuf::Pixbuf.new(:file => '../data/img/pontPV1.png')
        end
        @tab_events[@map.plateau.y * x + y].remove(@tab_events[@map.plateau.y * x + y].child)
        image = Gtk::Image.new(:pixbuf => pixbuf)
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
          pixbuf = GdkPixbuf::Pixbuf.new(:file => '../data/img/pontPH1.png')
        end
        @tab_events[@map.plateau.y * x + y].remove(@tab_events[@map.plateau.y * x + y].child)
        image = Gtk::Image.new(:pixbuf => pixbuf)
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
          pixbuf = GdkPixbuf::Pixbuf.new(:file => '../data/img/pontPH1.png')
        end
        @tab_events[@map.plateau.y * x + y].remove(@tab_events[@map.plateau.y * x + y].child)
        image = Gtk::Image.new(:pixbuf => pixbuf)
        image.set_name("Img_#{x}_#{y}")
        @tab_events[@map.plateau.y * x + y].child = image
        y += 1
      end
    end

    @fenetre.show_all

    if @map.plateau.partieFini?
      set_sensitive(false)
      @fini_dialog.run
    end

  end

  def refaire
    caseO = @map.redo

    unless caseO.nil?
      @map.afficherPlateau

      if caseO.element.sensHorizontal
        afficher_pont('horizontal', caseO.x, caseO.y)
      else
        afficher_pont('vertical', caseO.x, caseO.y)
      end
    end
  end

  def annuller
    caseO = @map.undo

    unless caseO.nil?
      @map.afficherPlateau

      if caseO.element.sensHorizontal
        afficher_pont('horizontal', caseO.x, caseO.y)
      else
        afficher_pont('vertical', caseO.x, caseO.y)
      end
    end
  end

  def corrigerErreur
    plateauCourant = @map.plateau.clone
    @map.corrigerErreur

    plateauCourant.afficherJeu
    @map.afficherPlateau
  end

  def afficherErreur
  end

end
