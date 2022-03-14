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

	##################################################################################################
	#						Methode d'accès aux voisines
	##################################################################################################
	
	##
	# Methode qui retourne la case de droite
	def voisineDroite()
		return @unPlateau.cases[@x+1][@y]
	end
	
	##
	# Methode qui retourne la case de gauche
	def voisineGauche()
		return @unPlateau.cases[@x-1][@y]
	end
	
	##
	# Methode qui retourne la case d'en bas
	def voisineBas()
		return @unPlateau.cases[@x][@y-1]
	end
	
	##
	# Methode qui retourne la case d'en haut
	def voisineHaut()
		return @unPlateau.cases[@x][@y+1]
	end
	
	attr_reader :element
end
