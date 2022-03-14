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
	def initialize(unX,unY,unPlateau)
		@x = unX
		@y = unY
		@plateau = unPlateau
		@element = nil
	end

	#Accès a l'élément de la case
	attr_reader :element

	##################################################################################################
	#						Methode d'accès aux voisines
	##################################################################################################
	
	#*****************************************************************************
	#			voisineDroite()
	#
	#
	# Methode qui retourne la case de droite
	def voisineDroite()
		return @unPlateau.cases[@x+1][@y]
	end
	
	#*****************************************************************************
	#			voisineGauche()
	#
	# Methode qui retourne la case de gauche
	def voisineGauche()
		return @unPlateau.cases[@x-1][@y]
	end
	
	#*****************************************************************************
	#			voisineBas()
	#
	# Methode qui retourne la case d'en bas
	def voisineBas()
		return @unPlateau.cases[@x][@y-1]
	end
	
	#*****************************************************************************
	#			voisineHaut()
	#
	# Methode qui retourne la case d'en haut
	def voisineHaut()
		return @unPlateau.cases[@x][@y+1]
	end

end #fin de la classe Case
