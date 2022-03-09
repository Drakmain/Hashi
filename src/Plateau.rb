class Plateau
	
	##
	# Methode d'initialisation de la classe, prend en paramettre son id
	# @cases => Matrice de cases
	# @id => un entier avec l'id du niveau
	def initialize(uneID)
		@id = uneID
		@cases = Array.new(0) {Array.new(0)} #On initialise le tableau des cases pour le charger
	end

	
	def to_s()
		print @cases
	end
	
	attr :cases, :id
end
