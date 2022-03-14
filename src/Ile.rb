load "Element.rb"


class Ile < Element
	
	# La classe Ile possède trois variables d'instances et hérite de la classe Element
	#
	# @valeur = un int, représentant le nombre de pont devant être connecté à l'île
	# @nbLiens = un int, représentant le nombre de liens (ponts), connecté à l'île
	# @estFini = un bool, vrai si l'île à le bon nombre de liens, et faux dans le cas inverse

	
	def initialize(uneValeur)  
		@valeur = uneValeur 
		@nbLiens = 0
		@estFini = false
  	end 
	
	attr_reader :valeur 
	attr_accessor :nbLiens

	def estPont?
        return @estFini
    end

end


