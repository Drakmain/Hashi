##
#La classe Chrono permet de lancer deux types de chronomètres :
#   -Un premier chronomètre qui compte le nombre de seconde depuis son lancement.
#   -Un deuxième qui cette fois-ci décompte et se stop une fois le temps écoulé.
#
#Cette classe possède 4 méthodes:
#
#   -lancerChrono : qui lance le chronomètre basique
#   -lancerChronoInverse(unTemps) : qui lance le chronomètre décompteur pour unTemps donné en paramètre.
#   -stopperChrono : qui permet de stopper n'importe quel des deux chronomètre.
#   -remiseAZero : qui réinitialise le chronomètre.
class Chrono
    #
    #@thr => le thread qui contient le chrono
    #@tempsDebut => le temps de début du chrono
    #@chrono => le chrono

    @thr
    @tempsDebut
    @chrono


    ###############################################################################
    #                   Methode de classe
    ###############################################################################

    #**********************************************************
    #                      initialize()
    #
    #Initialise le chronomètre à vide grâce à la méthode de remise à zéro.
    def initialize()  
		remiseAZero
  	end 


    ###############################################################################
    #                       Methode
    ###############################################################################


    #*********************************************************
    #                   lancerChrono()
    #
    #Compte le nombre de secondes depuis le lancement
    def lancerChrono()
        @thr = Thread.new {
            @tempsDebut = Time.now.to_i
            ancienne_valeur = @chrono
            while(true)
                @chrono = Time.now.to_i - @tempsDebut
                if(ancienne_valeur != @chrono)
                    ancienne_valeur = @chrono
                    puts(@chrono)
                end

            end
        }

        @thr.run

    end

    #*********************************************************
    #               lancerChronoInverse()
    #
    #Décompte à partir d'un temps donné et s'arrete à 0
    def lancerChronoInverse(unTemps)
        @thr = Thread.new {
            @tempsDebut = Time.now.to_i
            ancienne_valeur = unTemps
            while(true)
                @chrono = unTemps - (Time.now.to_i - @tempsDebut)
                if(ancienne_valeur != @chrono)
                    ancienne_valeur = @chrono
                    puts(@chrono+1)
                end

            end
        }

        @thr.run

        sleep(unTemps)

        stopperChrono

    end

    #*********************************************************
    #                    stopperChrono()
    #
    #Stoppe le chronomètre
    def stopperChrono()
        @thr.exit
        remiseAZero
    end

    #*******************************************************
    #                   remiseAZero()
    #
    #Remet les variables à 0
    def remiseAZero()
        @tempsDebut = 0
        @chrono = 0
    end

    #remise à zero est privée car appelé que en interne
    private :remiseAZero

    #permet de lire le chrono
    attr_reader :chrono

end
