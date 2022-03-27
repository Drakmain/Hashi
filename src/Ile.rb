load "Element.rb"

#class Ile
#
#la classe Ile représente un ile sur le plateau, elle hérite de Element
#
#Elle peut : 
#		- Dire qu'elle est une ile
#		- Dire si elel est terminé (si le nombre de pont qui la relie est équivalent à sa valeur)
class Ile < Element
	# @valeur = un int, représentant le nombre de pont devant être connecté à l'île
	# @nbLiens = un int, représentant le nombre de liens (ponts), connecté à l'île
	# @estFini = un bool, vrai si l'île à le bon nombre de liens, et faux dans le cas inverse

	########################################################################################################
	#								Methode de classe
	########################################################################################################

	#**************************************************
	#			Ile.creer()
	#
	#permet de créer une ile
	#
	#====== ATTRIBUTS
	#
	#*+uneValeur+ : la valeur de l'ile (un entier)
	#
	def Ile.creer(uneValeur)
		new(uneValeur)
	end
	
	#**************************************************
	#			initialize()
	#
	#permet d'initialiser une ile
	#
	#Par defaut : 
	#		- nbLiens = 0
	#		- estFini = false
	#
	#====== ATTRIBUTS
	#
	#*+uneValeur+ : la valeur de l'ile (un entier)
	#
	def initialize(uneValeur)  
		@valeur = uneValeur 
		@nbLiens = 0
		@estFini = false
  	end 
	
	########################################################################################################
	#									Methodes
	########################################################################################################

	#accessor
	attr_reader :valeur 
	attr_accessor :nbLiens, :estFini


	#**************************************************
	#				estIle?()
	#
	#retourne vrai car c'est une ile
	def estIle?() 
        return true
    end

	#**********************************************************
    #                   estElement?()
    #
    #retourne faux car c'est une ile
    def estElement?()
        return false
    end

	#**************************************************
	#				estFini?()
	#
	#retourne vrai car c'est l'ile est terminé
	def estFini?() 
        return @estFini
    end

	#**************************************************
	#				ajouterPont()
	#
	#incrémente de 1 @nbLiens et vérifie si l'île est fini
	def ajouterPont
		if(!estFini)then
			@nbLiens += 1
			if(@nbLiens == @valeur)then
				@estFini = true
			else
				@estFini = false
			end
		end
	end

	#**************************************************
	#				ajouterPont()
	#
	#décrémente de 1 @nbLiens
	def enlevePont()
		@nbLiens -= 1
		@estFini = false
	end

	#***********************************************************
    #                         to_s()
    #
    #affiche une ile
    def to_s
        return "Ile"
    end

end


