
#class Element 
#
#La classe element représente un element du plateau
#c'est une classe qui va être sois un pont, soit une ile, soit un element
#
#elle peut : 
#   - S'afficher
#   - dire si elle est un pont ou une ile
#
class Element

    ####################################################################################################
    #                               Methodes de classe
    ####################################################################################################
    
    #***********************************************************
    #               Element.creer()
    #
    #Creer un nouvelle element
    def Element.creer()
        new()
    end

    #new en privée
    private_class_method :new

    ####################################################################################################
    #                                   Methodes
    ####################################################################################################

    #***********************************************************
    #                       estPont?()
    #
    #retourne vrai si c'est un pont
    def estPont?() 
        return false
    end

    #**********************************************************
    #                       estIle?()
    #
    #retourne vrai si c'est une ile
    def estIle?() 
        return false
    end


    #**********************************************************
    #                   estElement?()
    #
    #retourne vrai car c'est un élément
    def estElement?()
        return true
    end

    #***********************************************************
    #                         to_s()
    #
    #affiche un element
    def to_s
        return " element du tableau"
    end
end #fin de classe Element





