class Pont extend Element

    # La classe Pont possède une variable d'instance
	#
	# @sensHorizontal = un bool représentant le sens du pont, horizontal si true, et vertical si false


	def initialize()
		@sensHorizontal = true
	end


    # Créer les getters et setters de la variable sensHorizontal

    attr_accessor :sensHorizontal


    # Méthode qui retourne vrai

    def estPont?
        return true
    end

    # Méthode qui retourne faux

    def estIle?
        return false
    end

end