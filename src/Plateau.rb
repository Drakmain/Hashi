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
	#
	#===== ATTRIBUTS
	#
	#@matrice => la matrice de case avec les éléments
	#@x => la largeur du tableau
	#@y => la longueur du tableau
	#@LesIles => tableau des iles du plateau

	###########################################################################################
	#						Methodes de classe
	###########################################################################################

	#Mettre new en privée
	private_class_method :new
	
	#************************************************************
	#				Plateau.creer()
	#
	#permet de créer un plateau
	#
	#===== ATTRIBUTS
	#
	#
	def Plateau.creer()
		new()
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
	def initialize()
		@x = 0
		@y = 0 
		@matrice = Array.new() {Array.new()} #On initialise le tableau des cases pour le charger
		@LesIles = Array.new() #On initialise le tableau des ILes
	
	end

	
	##########################################################################################
	#						Methodes
	##########################################################################################

	#******************* Accessors **********************************************
	attr_accessor :matrice, :plateau, :x, :y


	#****************************************************************
	#				generateMatrice()
	#
	#Génère la matrice à partir du fichier passé en parametre
	#elle récupère la taille de la matrice, valeur de x(lignes) et la valeur de y(colonne),
	#puis parcourir la matrice et charger les valeurs.
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
	#permet de retourner la matrice de jeu en string.
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
	# Méthodes de débogage :
	#
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
		print "     " 
		for i in 0..@y-1 
			print " #{i} "
		end
		print "\n    "
		for i in 0..@y-1 
			print "###"
		end
		i = 0
		@matrice.each do |row|
			if i<10 
				print "\n #{i}  #"
			else
				print "\n #{i} #"
			end
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
	#					getCase( unX, unY )
	#
	#Méthode qui prend 2 coordonnées correspondants, à la valeur de la ligne(unX) et la colonne(unY) 
	# et retourne la case correspondante dans la matrice.
	#
	def getCase(unX, unY)
		return @matrice[unX][unY]
	end

	#*************************************************************************
	#					verifCoord(unX, unY)
	#
	#Méthode qui permet de verifie les coordonneés passées en parametre si elles ne debordent pas 
	#par-apport à la dimension de la matrice et retourne un boulean (true/false).
	#
	
	def verifCoord(unX, unY)
		return (unX>=0 && unX<@x) && (unY>=0 && unY<@y)
	end


	#*************************************************************************
	#					partieFini?()
	#
	#Méthode qui permet de savoir si une partie est finie. 
	#retourne un boulean (true/false).
	#
	
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

