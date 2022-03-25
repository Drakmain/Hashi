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
        for i in 0..@plateau.x-1 
			for j in 0..@plateau.y-1 
                elementCourant = @plateau.getCase(i,j).element
                elementCorrection = @correction.getCase(i,j).element
                if (elementCourant.estPont? && elementCourant.nb_ponts > 0) then
                    if elementCorrection.estElement? then
                        @plateau.getCase(i,j).enleverPont
                    elsif elementCourant.nb_ponts > elementCorrection.nb_ponts then 
                        enleverErreur(@plateau.getCase(i,j), elementCourant.nb_ponts - elementCorrection.nb_ponts)
                    elsif elementCourant.estHorizontal? then
                        if(elementCorrection.estVertical?)then
                            enleverErreur(@plateau.getCase(i,j), elementCourant.nb_ponts)
                        end
                    elsif elementCourant.estVertical? then
                        if(elementCorrection.estHorizontal?)then
                            enleverErreur(@plateau.getCase(i,j), elementCourant.nb_ponts)
                        end
                    end

                end

            end
		end

        @plateau.afficherJeu

    end



    def enleverErreur(uneCase, unNombre)
        case unNombre
        when 2
            puts "2"
            uneCase.enleverPont
            uneCase.enleverPont
        when 1
            puts "1"
            uneCase.enleverPont
        else
            puts "Problème nombre de Pont"
        end
    end


    #################################################################################################
    #                   Mode détection erreur
    #################################################################################################

    #********************************************
    #       nombreErreurs()
    #
    #Renvoie le nombre d'erreur du joueur
    def nombreErreurs()
        nbErreurs = 0

        for i in 0..@plateau.x-1 
			for j in 0..@plateau.y-1 
                elementCourant = @plateau.getCase(i,j).element
                elementCorrection = @correction.getCase(i,j).element
                if (elementCourant.estPont? && elementCourant.nb_ponts > 0) then
                    if elementCorrection.estElement? then
                        nbErreurs += 1
                    elsif elementCourant.nb_ponts > elementCorrection.nb_ponts then 
                        nbErreurs += 1
                    elsif elementCourant.estHorizontal? then
                        if(elementCorrection.estVertical?)then
                            nbErreurs += 1
                        end
                    elsif elementCourant.estVertical? then
                        if(elementCorrection.estHorizontal?)then
                            nbErreurs += 1
                        end
                    end

                end

            end
		end

        return nbErreurs
    end


    #********************************************
    #       afficherPontErreur()
    #
    #permet de mettre en surbrillance les erreurs sur les ponts mal placés
    def afficherPontErreur()
        for i in 0..@plateau.x-1 
			for j in 0..@plateau.y-1 
                elementCourant = @plateau.getCase(i,j).element
                elementCorrection = @correction.getCase(i,j).element
                if (elementCourant.estPont? && elementCourant.nb_ponts > 0) then
                    if elementCorrection.estElement? then
                        elementCourant = true
                    elsif elementCourant.nb_ponts > elementCorrection.nb_ponts then 
                        elementCourant = true
                    elsif elementCourant.estHorizontal? then
                        if(elementCorrection.estVertical?)then
                            elementCourant = true
                        end
                    elsif elementCourant.estVertical? then
                        if(elementCorrection.estHorizontal?)then
                            elementCourant = true
                        end
                    end

                end

            end
		end
    end


    def afficherErreurs()
        puts "Tu as " + nombreErreurs().to_s + " erreurs"
        puts "Afficher toutes les erreurs(0) ou supprimer toutes les erreurs(1) ?"
        verif = gets
        verif = verif.to_i
        if(verif == 0)then
            afficherPontErreur
        elsif(verif == 1)then
            corrigerErreur
        end
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

        save("Hypothese")
    end

    #*******************************************
    #           desactiverHypothese()
    #
    #permet de desactiver le mode hypothèse et de supprimer tous les mauvais liens que l'utilisateur à créé
    def desactiverHypothese()
        @hypothese = false
        
        #load("Hypothese")
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
