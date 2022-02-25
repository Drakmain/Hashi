
#class Element 
#
#La classe element représente un element du plateau
#c'est une classe abstraite qui va être sois un pont, soit une ile
#
#elle peut : 
#   - S'afficher
#   - dire si elle est un pont ou une ile
#
class Element
    
    #Element.creer
    #
    #On ne peut pas creer un element car c'est une classe abstraite
    #soulève une erreur
    def Element.creer()
        puts "Ne peut pas creer d'instance d'un element"
        raise "exeception classe abstraite"
    end

    #estPont?
    #
    #retourne vrai si c'est un pont
    def estPont?() 
        return false
    end

    #estIle?
    #
    #retourne vrai si c'est une ile
    def estIle?() 
        return false
    end

    #to_s
    #
    #affiche un element
    def to_s
        return " element du tableau"
    end
end #fin de classe Element