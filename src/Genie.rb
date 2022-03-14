##
#
#class Genie
#
#la classe génie représente le mode génie, c'est le mode le plus "simple" dans le sens ou aucune aide ne sera disponible
#Elle est donc la classe mère des autres mode de jeu
#
#elle peut : 
#
#   - sauvegarder la partie
#   - charger une partie
#   - calculer le score du joueur
#   - lancer le chronometre
#   - Supprimer/remettre un coup
#   - jouer un coup
#   - récupérer le coup jouer
#
class Genie
    #
    #@score         => le score du joueur
    #@chrono        => le chrono qui se lance en début de partie
    #@anciensCoups  => la file des anciens coups
    #@fichier       => le chemin vers le fichier qui contient la correction
    #@plateau       => le plateau de jeu courant


    ##############################################################################################
    #                               Methode de classe
    ##############################################################################################


    #la method new est en privé
    private_class_method :new

    #**************************************************
    #           Genie.creer()
    #
    #permet de creer une instance de génie
    #
    #==== ATTRIBUTS
    #
    #   unFichier : le chemin vers le fichier qui contient la correction
    #   unPlateau : une référence vers le plateau de jeu de la partie courante
    #
    def Genie.creer(unFichier, unPlateau)
        new(unFichier, unPlateau)
    end

    #**************************************************
    #           Genie.creer()
    #
    #permet d'initialiser une instance de génie
    #
    #==== ATTRIBUTS
    #
    #   unFichier : le chemin vers le fichier qui contient la correction
    #   unPlateau : une référence vers le plateau de jeu de la partie courante
    #
    def initialize(unFichier, unPlateau)
		@score = 0
        @chrono = Chrono.new
        @anciensCoups = "Pile"
        @coups = "Pile"
        @fichier = unFichier
        @plateau = unPlateau
	end

    #############################################################################################
    #                               Methodes
    #############################################################################################

    #************************************
    #           save()
    #
    #permet de sauvegarder une partie, elle sérialize l'objet courant
    def save()
        
    end

    #***********************************
    #           load()
    #
    #permet de charger une partie, elle déserialize le fiichier demandé
    def load()

    end

    #***********************************
    #           calculerScore()
    #
    #permet de calculer le score du joueur
    def calculScore()

    end

    #************************************
    #           lancerChrono()
    #
    #permet de lancer le chronometre dans le sens normal (part de 0 et s'incrémente jusqu'à ce que la partie soit terminé)
    def lancerChroncreerdeleteCoup()
    #
    #permet de supprimer le dernier coup dans la liste des coups, le met dans a liste des anciens coups 
    def deleteCoup()
    
    end

    #***********************************
    #               getCoup()
    #
    #permet de récupérer l'ancien coup supprimer dans la liste des anciens coups
    def getCoup()

    end

    #**********************************
    #               jouerCoup()
    #
    #permet de jouer un coup
    def jouerCoup()

    end


end# fin de la classe génie