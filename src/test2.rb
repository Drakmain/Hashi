require 'gtk3'
load 'Donnees.rb'

class RubyApp < Gtk::Fixed

  def initialize(map)
    super()

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

    for i in 0...@matrixPix.length do
      pixbuf = GdkPixbuf::Pixbuf.new(:file => "../data/image/#{numbers[i]}.png")
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
        @map.jouerCoup(x, y, click)

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
