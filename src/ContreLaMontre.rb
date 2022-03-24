load "Genie.rb"

##
#@autor Pierre garçon
#
#
#@description : 
#class contreLaMontre
#
#La classe contre la montre permet de lancer un niveau, en plus d'un chronomètre qui, une fois arrivé à 0, arrètera la partie
#
#Les aides disponnibles sont : 
#   - Hypothèse
#   - assiste
#   - Correcteur d'erreur
#   - auto-correction
#
#La classe contrelaMontre est une spécialisation de la classe génie (elle ajoute des fontionnalités)
#
#elle peut : 
#   - lancer un chrono
#   - charger une partie
#   - sauvegarder une partie
#   - activer/désactiver des aides



class ContreLaMontre < Genie
    #
    #@hypothese : boolean qui est a vrai si le mode hypothèse est activé
    #@assite : boolean qui indique si le mode assiste est active ou pas
    #@fichier : le fichier qui contient les réponses au niveau que le joueur éxécute
    #@autoCorrecteur : boolean qui indique si le mode auto-correcteur est activé
    #
    @hypothese
    @assiste
    @autoCorrecteur
    @fichier

    #je met la methode new en privée 
    private_class_method :new


    #**********************************************
    #       ContreLaMontre.creer()
    #
    #creer un objet ContreLaMontre
    #
    #====== ATTRIBUTS
    #
    #   unFichier : un chemin vers le fichier à ouvrir pour vérifier la grille
    #
    def ContreLaMontre.creer(unPlateau, unNiveau, unPseudo, uneDifficulte)
        new(unPlateau, unNiveau, unPseudo, uneDifficulte)
    end

    #************************************************
    #       initialize()
    #
    #initialise un objet
    #
    #====== ATTRIBUTS
    #
    #   unFichier : un chemin vers le fichier à ouvrir pour vérifier la grille
    #
    def initialize(unPlateau, unNiveau, unPseudo, uneDifficulte)
        super(unPlateau, unNiveau, unPseudo, uneDifficulte)
        @autoCorrecteur = false
        @assiste = false
        @hypothese = false
    end

    #************************************
    #           lancerChrono()
    #
    #permet de lancer le chronometre dans le sens inverse (part de 300 et se décrémente jusqu'à ce que le temps soit à 0) (5min pour toutes les maps)
    def lancerChrono()
        @chrono.lancerChronoInverse(300)
    end


    #**********************************
    #       corrigerErreur
    #
    #   Permet de corriger des erreurs
    #  lit dans le fichier passé en parametre
    #
    def corrigerErreur()

        for i in 0..@plateau.X-1 
			for j in 0..@plateau.Y-1 

                if @plateau.getCase(i,j).element.estPont? then

                    if @plateau.getCase(i,j).element.nb_ponts > @correction.getCase(i,j).element.nb_ponts then 
                        case @plateau.getCase(i,j).element.nb_ponts - @correction.getCase(i,j).element.nb_ponts
                        when 2
                            @plateau.getCase(i,j).enlevePont
                            @plateau.getCase(i,j).enlevePont
                        when 1
                            @plateau.getCase(i,j).enlevePont
                        else
                            puts "Problème nombre de Pont"
                        end
                    end

                end

            end
		end

    end

    #################################################################################################
    #                   Mode assiste
    #################################################################################################

    #********************************************
    #       activerAssite()
    #
    #permet d'activer le mode assiste
    def activerAssiste()
        @assiste = true
    end

    #*******************************************
    #       desactiverAssiste()
    #
    #permet de desactiver le mode assiste
    def desactiverAssiste()
        @assiste = false
    end






    #################################################################################################
    #                   Mode AutoCorrecteur
    #################################################################################################

    #*******************************************
    #           activerAutoCorrecteur()
    #
    #permet d'activer le mode AutoCorrecteur
    def activerAutoCorrecteur()
        @autoCorrecteur = true
    end

    #*******************************************
    #           desactiverAutoCorrecteur()
    #
    #permet de desactiver le mode AutoCorrecteur et de supprimer tous les mauvais liens que l'utilisateur à créé
    def desactiverAutoCorrecteur()
        @autoCorrecteur = false
        corrigerErreur(unFichier)
    end







    #################################################################################################
    #                   Mode Hypothèse
    #################################################################################################

    #*******************************************
    #           activerHypothese()
    #
    #permet d'activer le mode hypothèse
    def activerHypothese()
        @hypothese = true
    end

    #*******************************************
    #           desactiverHypothese()
    #
    #permet de desactiver le mode hypothèse et de supprimer tous les mauvais liens que l'utilisateur à créé
    def desactiverHypothese()
        @hypothese = false
        corrigerErreur(unFichier)
    end



    #################################################################################################
    #                   Suggestion de coup
    #################################################################################################

    #********************************************
    #               suggestion()
    #
    #Permet de suggérer un coup à l'utilisateur, si le joueur a des erreurs, alors elles lui sont indiqué
    #et doit les corriger avant d'avoir un coup à jouer
    def suggestion()
        puts("Mode suggestion activé")
    end


end#fin de classe ContreLaMontre
