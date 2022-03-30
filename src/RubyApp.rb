require 'gtk3'
load 'Donnees.rb'
load 'Plateau.rb'

class RubyApp < Gtk::Fixed

  def initialize(fenetre, map, sens_popover)
    super()
    @fenetre = fenetre
    @sens_popover = sens_popover

    @map = map

    @matrixPix = Array.new()
    @matrixImg = Array.new()
    @donnee = Donnees.new()
    @events = Array.new()
    @Tabevents = Array.new()
    @donnee.getMatrice(@map.fichierJeu)
    @map.initialiserJeu

    init_ui
  end

  def init_ui
    createImgs
    putImg
  end

  def createImgs
    numbers = Array.new()

    (0...@donnee.y).each do |i|
      (0...@donnee.x).each do |j|
        @matrixPix.push("Img_#{i}_#{j}")
        @events.push("eventImg_#{i}_#{j}")
        numbers.push(@donnee.matrix[i][j])
      end
    end
    @events.each do |name|
      @Tabevents << instance_variable_set("@#{name}", Gtk::EventBox.new)
    end

=begin
    @Tabevents[i].signal_connect "button-enter-notify-event" do |widget, event|
=end

    (0...@matrixPix.length).each do |i|
      pixbuf = GdkPixbuf::Pixbuf.new(:file => "../data/img/#{numbers[i]}.png")
      image = Gtk::Image.new(:pixbuf => pixbuf)
      image.set_name(@matrixPix[i])
      @Tabevents[i].add(image)
      @Tabevents[i].signal_connect 'button-press-event' do |widget, event|
        tmp = widget.child.name.split('_')
        x = tmp[1].to_i
        y = tmp[2].to_i

        case event.button
        when 1
          click = true
        when 3
          click = false
        end

        sens = @map.jouerCoupInterface(x, y, click)
        puts @map.plateau.partieFini?

        afficher_pont(sens, x, y, click)
      end
    end
  end

  def putImg
    xl = 0
    yl = 0
    cpt = 0

    (0...@donnee.x * @donnee.y).each do |i|
      put @Tabevents[i], xl, yl
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
    afficher_pont(sens, x, y, nb_ponts, click)
    @sens_popover.popdown
  end

  def afficher_pont(sens, x, y, click)

    case sens
    when 'vertical'
      @map.jouerCoupVerticaleInterface(x, y, click)
      nb_ponts = @map.plateau.getCase(x, y).element.nb_ponts
      puts nb_ponts
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

        @Tabevents[@map.plateau.y * x + y].remove(@Tabevents[@map.plateau.y * x + y].child)
        image = Gtk::Image.new(:pixbuf => pixbuf)
        image.set_name("Img_#{x}_#{y}")
        @Tabevents[@map.plateau.y * x + y].child = image
        x -= 1
      end
      @fenetre.show_all

    when 'horizontal'
      @map.jouerCoupHorizontaleInterface(x, y, click)
      nb_ponts = @map.plateau.getCase(x, y).element.nb_ponts
      puts nb_ponts
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
        @Tabevents[@map.plateau.y * x + y].remove(@Tabevents[@map.plateau.y * x + y].child)
        image = Gtk::Image.new(:pixbuf => pixbuf)
        image.set_name("Img_#{x}_#{y}")
        @Tabevents[@map.plateau.y * x + y].child = image
        y -= 1
      end
      @fenetre.show_all
    when false
      @sens_popover.set_relative_to(widget)
      @sens_popover.popup
    end

  end

end
