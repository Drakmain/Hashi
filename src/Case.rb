##
#
#classe Case
#
#La classe case représente un élément du plateau, elle peut être soit une île, soit un pont, soit un élément
#elle connait le plateau
#
#elle peut : 
#
#	- Donner ses voisines (droite, gauche, haut, bas)
#	- donner son élément
#
#elle connait : 
#
#	- Ses coordonnnées sur le plateau
#	- Le plateau
#	- son élément
#
class Case
	#@x => coordonées x de la case
	#@y => coordonées y de la case
	#@plateau => le plateau de jeux
	#@element => element que l'ile posséde ou non

	###############################################################################################
	#							Methode de classe
	###############################################################################################

	def Case.creer(unX,unY,unPlateau,unElem)
		new(unX,unY,unPlateau,unElem)
	end


	#new est en privée car il y a un parametre à passer dans la création
	private_class_method :new

	##
	# Methode d'initialisation de la classe
	#
	#===== ATTRIBUT
	#
	# unX => coordonées x de la case
	# unY => coordonées y de la case
	# unPlateau => le plateau de jeux
	#
	def initialize(unX,unY,unPlateau,unElem)
		@x = unX
		@y = unY
		@plateau = unPlateau
		@element = unElem
	end

	#Accès a l'élément de la case
	attr_reader :x, :y
	attr_accessor :element

	##################################################################################################
	#						Methode d'accès aux voisines
	##################################################################################################
	
	#*****************************************************************************
	#			voisineDroite()
	#
	#
	# Methode qui retourne la case de droite
	def voisineDroite()
		return @plateau.matrice[@x][@y+1]
	end
	
	#*****************************************************************************
	#			voisineGauche()
	#
	# Methode qui retourne la case de gauche
	def voisineGauche()
		return @plateau.matrice[@x][@y-1]
	end
	
	#*****************************************************************************
	#			voisineBas()
	#
	# Methode qui retourne la case d'en bas
	def voisineBas()
		if(@x+1 == @plateau.x)
			return nil
		else
			return @plateau.matrice[@x+1][@y]
		end
	end
	
	#*****************************************************************************
	#			voisineHaut()
	#
	# Methode qui retourne la case d'en haut
	def voisineHaut()
		return @plateau.matrice[@x-1][@y]
	end

	def to_s()
		return "x:#{@x}, y:#{@y} "
	end

end #fin de la classe Case
