load 'Pont.rb'
load 'Element.rb'
load 'Ile.rb'
load 'Case.rb'

require 'matrix'

#
#class Plateau
#
#la classe plateau représente les cases du jeu, le plateau a une taille défini dans le fichier
#
#Elle est capable : 
#	- De charger un fichier
#	- de générer le plateau en fonction du fichier
#	- d'ajouter les ponts possible
#	- de s'afficher
#
#Le plateau est composé de case, et chaque case est composé d'un element, qui est soit une ile, soit un pont, soit un element
#
class Plateau
	#@matrice => la matrice de case avec les éléments
	#@id => un entier avec l'id du niveau
	#@x => la largeur du tableau
	#@y => la longueur du tableau
	#@iles => tableau des iles du

	###########################################################################################
	#						Methodes de classe
	###########################################################################################

	#************************************************************
	#				Plateau.creer()
	#
	#permet de créer un plateau
	#
	#===== ATTRIBUTS
	#
	#*+uneID+ : l'id du niveau
	#
	def Plateau.creer(uneID)
		new(uneID)
	end

	#************************************************************
	#				Plateau.creer()
	#
	#permet d'initialiser un plateau
	#
	#===== ATTRIBUTS
	#
	#*+uneID+ : l'id du niveau
	#
	def initialize(uneID)
		@id = uneID
		@x = 0
		@y = 0 
		@matrice = Array.new() {Array.new()} #On initialise le tableau des cases pour le charger
		#@plateau = Array.new() {Array.new()} #On initialise le tableau des cases pour le charger
		@LesIles = Array.new()
	
	end

	#Mettre new en privée
	private_class_method :new


	##########################################################################################
	#						Methodes
	##########################################################################################

	#******************* Accessors **********************************************
	attr_accessor :matrice, :plateau, :x, :y


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
	  
			  elsif line = ~/(^([0-9]+( )*)+)/ then
				  ligne = $3+$1
				  @matrice.push(ligne.split(' ').map(&:to_i))
			  end
			end
		end
	end

		
	#************************************************************
	#					generatePlateau()
	#
	#Permet de générer le plateau (transformer les entiers en Elements et en Ile)
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
				if(elem == 0) then			
					elem = Case.creer(x, y, self, Element.creer)
				else
					e = Ile.creer(elem)
					@LesIles.push(e)
					elem = Case.creer(x, y, self, e)
				end
			}
		}
	end



	#**********************************************************
	#						to_s
	#
	#permet de retourner la matrice de jeu en string
	#
	#@return = string
	def to_s()
		res = "le x : #{@x} , le y : #{@y}\n"
    	res = res + "la matrice du jeu : \n"
    	@matrice.each do |row|
      		row.each do |column|
        		res = res + "#{column} "
      		end
      		res = res + "\n"
    	end
		return res
	end
	

	#**********************************************************
	#					affiche()
	#
	#permet d'afficher la matrice une fois que les éléments ont été initialisé
	#
	def affiche()
		@matrice.each do |row|
			row.each do |column|
			  if column.element.instance_of?(Element) then
				print("E ")
			  elsif column.element.instance_of?(Ile) then
				print("I ")
			  elsif column.element.instance_of?(Pont) then
				print("P ")
			  end
			end
			print "\n"
	  	end
	end


=begin
	def initPont()
		@matrice.each do |row|
			row.each do |column|
				if column.element.instance_of?(Ile) then
					casetmp = column
					for i in column.y...@y
						casetmp2 = casetmp.voisineDroite
						if(casetmp2 != nil)
							if(casetmp2.element.instance_of?(Ile))then
								creerPontVide(column, casetmp2)
								break
							end							
							casetmp = casetmp2
						end
					end
					

					casetmp = column
					for i in column.x...@x
						casetmp2 = casetmp.voisineBas
						if(casetmp2 != nil)
							if(casetmp2.element.instance_of?(Ile))then
								creerPontVide(column, casetmp2)
								break
							end
							casetmp = casetmp2
						end
					end
				end
			end
	  	end
	end
	

	#Cases valables
	def creerPontVide(case1, case2)
		if(case1.x == case2.x)
			long = case2.y - case1.y

			caseTmp = case1
			for i in 0...long-1
				caseTmp.voisineDroite.element = Pont.creer()
				caseTmp = caseTmp.voisineDroite
			end
		else
			long = case2.x - case1.x
			caseTmp = case1
			for i in 0...long-1@nb_pontsTmp.voisineBas.element = Pont.creer()
				caseTmp = caseTmp.voisineBas
			end
		end
	end
=end

	#**************************************************************************
	#					ajouterPont()
	#
	#Permet d'ajouter des ponts là ou le joueur pourra en créer
	#
	def ajouterPont()
		@matrice.each do |row|
			row.each do |column|
				if(column != nil && column.element.instance_of?(Ile))then
					column.ajouterPontDroite()
					column.ajouterPontBas()
				end
			end
		end
	end


	#************************************************************
	#						afficherJeu()
	#
	#permet d'afficher un plateau de jeu en terminal
	#
	#	* . : ponts possibles
	#	* - : pont simple
	#	* = : ponts doubles
	#	* n : iles (valeur)
	def afficherJeu()
		i = 0
		print "    "
		for i in 0..@y-1 
			print " #{i} "
		end
		print "\n   "
		for i in 0..@y-1 
			print "###"
		end
		i = 0
		@matrice.each do |row|
			print "\n #{i} #"
			i += 1
			row.each do |column|
				elem = column.element
				if elem.estIle?()then
					print " " + elem.valeur.to_s() + " "
				elsif elem.estPont?
					if(elem.nb_ponts == 0)then
						print " . "
					else 
						if(elem.nb_ponts == 1)then
							if(elem.estHorizontal?)then
								print "---"
							else
								print " | "
							end
						else
							if(elem.estHorizontal?)then
								print "==="
							else
								print "|| "
							end
						end
					end
				else
					print "   "
				end
			end
		end
		print "\n"
	end


	#*************************************************************************
	#					getCase()
	#
	#permet de récuperer la case en x y
	def getCase(unX, unY)
		return @matrice[unX][unY]
	end


	def verifCoord(unX, unY)
		return (unX>=0 && unX<@x) && (unY>=0 && unY<@y)
	end


	def partieFini?()
		res = true
		@LesIles.map{|x| res = res && x.estFini?}
		return res
	end

end	

=begin
test = Plateau.creer(1)
test.generateMatrice("../map/facile/correction/2.txt")

puts test
print "\n"

test.generateCorrection()
test.affiche()

test = Plateau.creer(1)
test.generateMatrice("../map/facile/demarrage/2.txt")

puts test
print "\n"

test.generateCorrection()
test.affiche()


print "INIT PONT V1\n"
test.initPont()
test.affiche()

print "INIT PONT V2\n"
test.ajouterPont()
test.affiche()
=end

