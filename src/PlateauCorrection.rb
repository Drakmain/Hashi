load 'Plateau.rb'

class PlateauCorrection < Plateau


    private_class_method :new

    def PlateauCorrection.creer()
        super()
    end


    #****************************************************************
	#				generateMatrice()
	#
	#génère la matrice à partir du fichier passé en parametre
	#elle récupère le x et le y de la matrice dans le fichier
	#
	#====== ATTRIBUTS
	#
	#*+file+ : le fichier qui contient le niveau à charger
	#
    def generateMatrice(file)
        File.open(file,'r') do |fichier|
          while line = fichier.gets
            if line = ~/^(x:)([0-9]+)( )(y:)([0-9]+)/ then
              @x = $5.to_i
              @y = $2.to_i
    
            elsif line = ~/(^(([0-9]|-)+( )*)+)/ then
    
                ligne = $1
                @matrice.push(ligne.split(' ').map(&:to_i))
            end
          end
        end
    end



    #************************************************************
	#					generatePlateau()
	#
	#Permet de générer le plateau de correction (transformer les entiers en Ponts, en Elements et en Ile)
	#
	def generatePlateau()
		#Ne plus toucher!
		x=-1
		y=-1
		@matrice.map! {|item|
			x+=1
			y=-1
			item.map!{ |elem| 
				y+=1
				case elem
                    
                when -4
					elem = Case.creer(x, y, self, Pont.creer(true,2))
				when -3
					elem = Case.creer(x, y, self, Pont.creer(true,1))
				when -2
					elem = Case.creer(x, y, self, Pont.creer(false,2))
				when -1
					elem = Case.creer(x, y, self, Pont.creer(false,1))

				when 0			
					elem = Case.creer(x, y, self, Element.creer)
				else
					e = Ile.creer(elem)
					@LesIles.push(e)
					elem = Case.creer(x, y, self, e)					
				end
                
			}
		}

	end


    

end