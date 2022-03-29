##
# La classe Chrono permet de lancer deux types de chronomètres :
# - Un premier chronomètre qui compte le nombre de seconde depuis son lancement.
# - Un deuxième qui cette fois-ci décompte et se stop une fois le temps écoulé.
#
# Cette classe possède 4 méthodes:
#
# - lancerChrono : qui lance le chronomètre basique
# - lancerChronoInverse(unTemps) : qui lance le chronomètre décompteur pour unTemps donné en paramètre.
# - stopperChrono : qui permet de stopper n'importe quel des deux chronomètre.
# - remiseAZero : qui réinitialise le chronomètre.
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

    # Initialise le chronomètre à vide grâce à la méthode de remise à zéro.
    def initialize()  
		remiseAZero
  	end 


    ###############################################################################
    #                       Methode
    ###############################################################################


    # Créer le getter de la variable chrono
    attr_reader :chrono

    # Lance le chronomètre, et compte le nombre de secondes depuis ce lancement.
    def lancerChrono()
        @thr = Thread.new {

        Thread.start(){
            @tempsDebut = Time.now.to_i
            ancienne_valeur = @chrono
            while(true)
                @chrono = Time.now.to_i - @tempsDebut
                if(ancienne_valeur != @chrono)
                    ancienne_valeur = @chrono
                    #puts(@chrono)
                end

            end
        }
    }

        @thr.run()

    end

    
    # Décompte à partir d'un temps donné et s'arrete à 0
    #
    # ==== Attributs
    #
    # * +unTemps+ - temps à décompter
    #
    # ==== Exemples
    #
    # Avec un temps donné en paramètre de 25, la méthode
    # va stopper le chronomètre au bout de 25 secondes.
    def lancerChronoInverse(unTemps)
        @thr = Thread.new {
            @tempsDebut = Time.now.to_i
            ancienne_valeur = unTemps
            while(true)
                @chrono = unTemps - (Time.now.to_i - @tempsDebut)
                if(ancienne_valeur != @chrono)
                    ancienne_valeur = @chrono
                    #puts(@chrono+1)
                end

            end
        }

        @thr.run

        sleep(unTemps)

        stopperChrono

    end

    # Stoppe le chronomètre.
    def stopperChrono()
        @thr.exit
        remiseAZero
    end

 
    #*******************************************************
    #                   remiseAZero()
    #
    #Remet les attributs à 0
 
    # Remet les variables tempsDebut et chrono à 0.
 
    def remiseAZero()
        @tempsDebut = 0
        @chrono = 0
    end

    # remise à zero est privée car appelé que en interne
    private :remiseAZero

 
    #accesseur en lecture du chrono
 
    # permet de lire le chrono
 
    attr_reader :chrono

end
