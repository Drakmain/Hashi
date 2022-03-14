load 'Pont.rb'
load 'Element.rb'
load 'Ile.rb'
load 'Case.rb'

require 'matrix'

class Plateau
	
	##
	# Methode d'initialisation de la classe, prend en paramettre son id
	# @cases => Matrice de cases
	# @id => un entier avec l'id du niveau
	def initialize(uneID)
		@id = uneID
		@x = 0
		@y = 0 
		@matrice = Array.new() {Array.new()} #On initialise le tableau des cases pour le charger
		@plateau = Array.new() {Array.new()} #On initialise le tableau des cases pour le charger
	
	end

	def generateMatrice(file)
		File.open(file,'r') do |fichier|
			while line = fichier.gets
			  if line = ~/^(x:)([0-9]+)( )(y:)([0-9]+)/ then
				@x = $5.to_i
				@y = $2.to_i
	  
			  elsif line = ~/(^([0-9]+( )*)+)/ then
				  ligne = $3+$1
				  @matrice.push(ligne.split(' ').map(&:to_i))
			  end
			end
		end
	end

		
	#Ne plus toucher!
	def generatePlateau()
		x=-1
		y=-1
		@matrice.map! {|item|
			x+=1
			y=-1
			item.map!{ |elem| 
				y+=1
				if(elem == 0) then			
					elem = Case.creer(x, y, self, Element.creer)
				else
					elem = Case.creer(x, y, self, Ile.creer(elem))
				end
			}
		}
	end



	def to_s()
		puts "le x : #{@x} , le y : #{@y}"
    	puts "la matrice du jeu : "
    	puts @matrice.inspect
    	@matrice.each do |row|
      		row.each do |column|
        		print "#{column} "
      		end
      		print "\n"
    	end
	end
	

	def affiche()
		@matrice.each do |row|
			row.each do |column|
				print column
			  if column.element.instance_of?(Element) then
				print("E ")
			  elsif column.element.instance_of?(Ile) then
				print("I ")
			  end
			end
			print "\n"
	  	end
	end


	#def initPont()
	#	@matrice.each do |row|
	#		row.each do |column|
	#			if column.element.instance_of?(Ile) then
	#				casetmp=column
	#				casetmp2=nil
	#
	#		end
	#  	end
	#end


	#Cases valables
	def creerPont(case1, case2)
		if(case1.x == case2.x)
			long = case2.y - case1.y
			caseTmp = case1
			for i in 0...long
				caseTmp.voisineDroite.element = Pont.creer(true)
				caseTmp = caseTmp.voisineDroite
			end
		else
			long = case2.x - case1.x
			caseTmp = case1
			for i in 0...long
				caseTmp.voisineBas.element = Pont.creer(false)
				caseTmp = caseTmp.voisineBas
			end
		end
	end

	attr_accessor :matrice, :x, :y

end	

test = Plateau.new(1)
test.generateMatrice("../map/facile/demarrage/2.txt")

test.to_s()
print "\n"
test.generatePlateau()
test.affiche()
