class Coup extend Element

    	## La classe Pont possède une variable d'instance
	#
	# @clickDroit = boolean qui décrit si le mouvement était click gauche ou droit
	# @pont = reference du pont sur la quelle le click est fait

	def Coup.creer(clickdroit, pont)
		initialize(clickdroit, pont)
	end


	def initialize(clickdroit, pont)
		@clickDroit = clickdroit
		@pont = pont
	end



end
