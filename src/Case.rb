class Case
	
	##
	# Methode d'initialisation de la classe, prend en paramettre son id
	# @x => coordonées x de la case
	# @y => coordonées y de la case
	# @plateau => le plateau de jeux
	# @element => element que l'ile posséde ou non
	def initialize(unX,unY,unPlateau)
		@x = unX
		@y = unY
		@plateau = unPlateau
		@element = nil
	end
	
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
	
	attr :element
end
