class Plateau
	
	##
	# Methode d'initialisation de la classe, prend en paramettre son id
	# @cases => Matrice de cases
	# @id => un entier avec l'id du niveau
	def initialize(uneID)
		@cases = Array.new(0) {Array.new(0)}
		@id = uneID
	end
	
	##
	# Methode pour charger le niveau a l'aide de l'id
	def chargerJeu()
		#On cherche un fichier selon l'id et fait le chargement
	end
	
	attr :cases, :id
end
