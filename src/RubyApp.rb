require 'gtk3'
load 'Donnees.rb'
load 'Plateau.rb'

class RubyApp < Gtk::Fixed

  def initialize(fenetre, map)
    super()
    @fenetre = fenetre

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

    for i in 0...@donnee.y do
      for j in 0...@donnee.x do
        @matrixPix.push("Img_#{i}_#{j}")
        @events.push("eventImg_#{i}_#{j}")
        numbers.push(@donnee.matrix[i][j])
      end
    end
    @events.each do |name|
      @Tabevents << instance_variable_set("@" + name, Gtk::EventBox.new)
    end
  
=begin
    @Tabevents[i].signal_connect "enter-notify-event" do |widget, event|
    @Tabevents[i].signal_connect "leave-notify-event" do |widget, event|
=end

    for i in 0...@matrixPix.length do
      pixbuf = GdkPixbuf::Pixbuf.new(:file => "../data/img/#{numbers[i]}.png")
      image = Gtk::Image.new(:pixbuf => pixbuf)
      image.set_name(@matrixPix[i])
      @Tabevents[i].add(image)
      @Tabevents[i].signal_connect "button-press-event" do |widget, event|
        tmp = widget.child.name.split("_")
        x = tmp[1].to_i
        y = tmp[2].to_i

        if event.button == 1 then
          click = true
        elsif event.button == 3 then
          click = false
        end

        if(@map.plateau.getCase(x, y).element.estPont?)then
          sens = @map.jouerCoupInterface(x, y, click)
          @map.afficherPlateau
          puts @map.plateau.partieFini?

          double = @map.plateau.getCase(x, y).element.nb_ponts

          if sens == "vertical"
            while @map.plateau.getCase(x, y).element.estPont? do
              x += 1
            end

            x -= 1
            puts "sens : Vertical"

            while @map.plateau.getCase(x, y).element.estPont? do
              case double
              when 0
                pixbuf = GdkPixbuf::Pixbuf.new(:file => "../data/img/0.png")
              when 1
                pixbuf = GdkPixbuf::Pixbuf.new(:file => "../data/img/pontV1.png")
              when 2
                pixbuf = GdkPixbuf::Pixbuf.new(:file => "../data/img/pontV2.png")
              end

              @Tabevents[@map.plateau.y * x + y].remove(@Tabevents[@map.plateau.y * x + y].child)
              image = Gtk::Image.new(:pixbuf => pixbuf)
              image.set_name("Img_#{x}_#{y}")
              @Tabevents[@map.plateau.y * x + y].child = image
              x -= 1
            end

            @fenetre.show_all

          elsif sens == "horizontal"
            while @map.plateau.getCase(x, y).element.estPont? do
              y += 1
            end

            y -= 1
            puts "sens : horizontal"

            while @map.plateau.getCase(x, y).element.estPont? do
              case double
              when 0
                pixbuf = GdkPixbuf::Pixbuf.new(:file => "../data/img/0.png")
              when 1
                pixbuf = GdkPixbuf::Pixbuf.new(:file => "../data/img/pontH1.png")
              when 2
                pixbuf = GdkPixbuf::Pixbuf.new(:file => "../data/img/pontH2.png")
              end
              @Tabevents[@map.plateau.y * x + y].remove(@Tabevents[@map.plateau.y * x + y].child)
              image = Gtk::Image.new(:pixbuf => pixbuf)
              image.set_name("Img_#{x}_#{y}")
              @Tabevents[@map.plateau.y * x + y].child = image
              y -= 1
            end

            @fenetre.show_all
          elsif !sens then
            puts "faire un choix"
          end
        end

      end
    end
  end

  def putImg
    xl = 0
    yl = 0
    cpt = 0

    for i in 0...@donnee.x * @donnee.y do
      put @Tabevents[i], xl, yl
      xl += 50
      cpt += 1
      if (cpt == @donnee.x) then
        yl += 50
        xl = 0
        cpt = 0
      end
    end
  end

end
