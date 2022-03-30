class Donnees

  def initialize()
    @matrix = Array.new()
    @x = 0
    @y = 0
  end

  attr_accessor :matrix, :x, :y, :string

  def getMatrice(file)
    File.open(file, 'r') do |fichier|
      while line = fichier.gets
        if line = ~/^(x:)([0-9]+)( )(y:)([0-9]+)/ then
          @x = $2.to_i
          @y = $5.to_i

        else
          if line = ~/(^([0-9]+( )*)+)/ then
            ligne = $3 + $1
            @matrix.push(ligne.split(' ').map(&:to_i))
          end
        end
      end

    end

    def changeMatrice()
      @matrix.map! { |item|
        item.map! { |elem| elem }
      }
    end

    def to_s ()
      puts "le x : #{@x} , le y : #{@y}"
      puts "la matrice du jeu : "
      puts @matrix.inspect
      @matrix.each do |row|
        row.each do |column|
          print "#{column} "
        end
        print "\n"
      end
    end

  end
end
