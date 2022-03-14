load 'Element.rb'


class Pont < Element

    # La classe Pont possède une variable d'instance
	#
	# @sensHorizontal = un bool représentant le sens du pont, horizontal si true, et vertical si false


    def Pont.creer()
        new()
    end

	def initialize(estHorizontal)
		@sensHorizontal = estHorizontal
        @nb_ponts= 0
	end


    # Créer les getters et setters de la variable sensHorizontal

    attr_accessor :sensHorizontal


    # Méthode qui retourne vrai

    def estPont?
        return true
    end

    

end



