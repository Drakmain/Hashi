load 'Element.rb'


class Pont < Element

    # La classe Pont possède une variable d'instance
	#
	# @sensHorizontal = un bool représentant le sens du pont, horizontal si true, et vertical si false


    def Pont.creer()
        new()
    end

	def initialize()
		@sensHorizontal = false
        @nb_ponts= 0
	end


    # Créer les getters et setters de la variable sensHorizontal

    attr_accessor :sensHorizontal


    # Méthode qui retourne vrai

    def estPont?
        return true
    end

    def ajoutePont()
        if(@nb_ponts >= 0 && @nb_ponts <= 2)then
            @nb_ponts += 1     
        elsif(@nb_ponts == 2)then
            @nb_ponts = 1
        end
    end

    
    def enlevePont()
        @nb_ponts = 0     
    end

    
    def estHorizontal()
        @sensHorizontal = true
    end


    def estVertical()
        @sensHorizontal = false
    end

end



