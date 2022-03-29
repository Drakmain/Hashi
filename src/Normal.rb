load "Chrono.rb"


# class Normal
#
# La classe normal est une sous-classe de la classe contre-la-montre, elle possède les mêmes caractèristiques
# la seule chose qui change est le sens du chronometre
#
#  Elle peut donc faire tous ce que peut faire la classe ContreLaMontre
#
class Normal < ContreLaMontre

<<<<<<< HEAD
	#la method new est en privé
=======
    # New est privée
>>>>>>> fe6266b20a59b6cbbb6eddd0cf9f165e8dad5599
    private_class_method :new

    # Normal.creer
    #
    # permet de creer un nouveau mode normal
    #
    # ==== ATTRIBUTS
    # 
    # *+unPlateau+ : unPlateau
    #
    #
    def Normal.creer(unPlateau, unNiveau, unPseudo, uneDifficulte)
        super(unPlateau, unNiveau, unPseudo, uneDifficulte)
    end

    #   lancerChrono
    #
    # permet de lancer le chronometre dans le sens normal (part de 0 et s'incrémente jusqu'à ce que la partie soit terminé)
    def lancerChrono()
        @chrono.lancerChrono
    end
    
end
