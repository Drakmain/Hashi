load 'Element.rb'

#
#class Pont 
#
#la classe Pont est une spécification de la classe Element
#
#On peut : 
#       - Creer un pont
#       - savoir si l'element est un pont
#       - ajouter un pont (soit il y a 1 pont, soit 2, soit 0)
#       - enlever le(s) pont(s)
#       - Connaitre l'orientation du pont (horizontale ou verticale)
#
# Un pont est un éléménent contenu dans une case, il permet de faire le lien entre 2 îles

class Pont < Element
    #@sensHorizontale => un boolean qui indique si le pont est horizontale ou pas
    #@nb_ponts => le nombre de ponts (0,1,2)

    ##############################################################################################################
    #                                           Methodes de classe
    ##############################################################################################################

    #******************************************************
    #               Pont.creer()
    #
    #Permet de creer un pont
    def Pont.creer(unSens, uneValeur=0)
        new(unSens, uneValeur)
    end

    #******************************************************
    #               initialize()
    #
    #Permet d'initialiser un pont
    #
    #Par defaut : 
    #   - sensHorizontale = false
    #   - nb_ponts = 0
    #
	def initialize(unSens, uneValeur)
		@sensHorizontal = unSens
        @nb_ponts= uneValeur
        @deuxSens = 0
	end

    #new est privée
    private_class_method :new


    ###############################################################################################################
    #                                               Methodes
    ###############################################################################################################


    # Créer les getters et setters de la variable sensHorizontal
    attr_accessor :sensHorizontal, :nb_ponts


    # *****************************************************
    #               estPont?()
    #
    #methode qui permet de dire que c'est un pont
    def estPont?
        return true
    end

    #*****************************************************
    #               ajoutePont()
    #
    #Methode qui permet d'ajouter un pont (s'active lorsque l'utilisateur fait un clic droit)
    #
    def ajoutePont()
        if(@nb_ponts >= 0 && @nb_ponts < 2)then
            @nb_ponts += 1     
        elsif(@nb_ponts == 2)then
            @nb_ponts -= 1
        end
    end

    #****************************************************
    #                   enlevePont()
    #
    #Methode qui permet d'enlever les ponts (mettre à 0)
    def enlevePont()
        @nb_ponts = 0     
    end

    #***************************************************
    #                   estHorizontale()
    #
    #Permet de dire que le pont est horizontale en modifiant le boolean
    def estHorizontal()
        @sensHorizontal = true
    end


    #***************************************************
    #                   estVertical()
    #
    #Permet de dire que le pont est horizontale en modifiant le boolean
    def estVertical()
        @sensHorizontal = false
    end

    #***************************************************
    #                   estHorizontal?()
    #
    #returne vrai si le pont est horizontale
    def estHorizontal?()
        @sensHorizontal
    end

    #***************************************************
    #                   estHorizontal?()
    #
    #returne vrai si le pont est vertical
    def estVertical?()
        @sensHorizontal == false
    end

    #**********************************************************
    #                   estElement?()
    #
    #retourne faux car c'est un pont
    def estElement?()
        return false
    end

    #***********************************************************
    #                   deuxSens()
    #
    #permet de d'incrémenter le nombre de sens d'un pont
    def deuxSens
        @deuxSens += 1
    end


    def aDeuxSens()
        return @deuxSens>0
    end

    def to_s
        return "sens = #{@sensHorizontal} || nombre de ponts : #{@nb_ponts}"
    end
end



