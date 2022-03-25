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
    #==== ATTRIBUTS
    #
    #   unPlateau : une référence vers le plateau de jeu de la partie courante
    #   unNiveau : le numéro du niveau choisis
    #   unPseudo : le nom du joueur qui va jouer
    #   uneDifficulte : la difficulté choisis
    #
    def ContreLaMontre.creer(unPlateau, unNiveau, unPseudo, uneDifficulte)
        new(unPlateau, unNiveau, unPseudo, uneDifficulte)
    end

    #************************************************
    #       initialize()
    #
    #initialise un objet
    #
    #==== ATTRIBUTS
    #
    #   unPlateau : une référence vers le plateau de jeu de la partie courante
    #   unNiveau : le numéro du niveau choisis
    #   unPseudo : le nom du joueur qui va jouer
    #   uneDifficulte : la difficulté choisis
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


    #**********************************
    #       corrigerErreur
    #
    #   Permet de corriger des erreurs
    #  enlève des ponts en fonction d'un nombre donné
    #
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

                if(elementCourant.estPont? && elementCourant.estHorizontal?)then
                    if(elementCourant.nb_ponts > 0 && !@plateau.getCase(i,j).voisineGauche.element.estPont?) then
                        if elementCorrection.estElement? then
                            nbErreurs += 1
                        elsif elementCourant.nb_ponts > elementCorrection.nb_ponts then 
                            nbErreurs += 1
                        elsif(elementCorrection.estVertical?)then
                                nbErreurs += 1
                        end
                    end

                elsif(elementCourant.estPont? && elementCourant.estVertical?)then
                    if(elementCourant.nb_ponts > 0) then
                        if(elementCourant.nb_ponts > 0 && !@plateau.getCase(i,j).voisineHaut.element.estPont?)then
                            if elementCorrection.estElement? then
                                nbErreurs += 1
                            elsif elementCourant.nb_ponts > elementCorrection.nb_ponts then 
                                nbErreurs += 1
                            elsif(elementCorrection.estHorizontal?)then
                                    nbErreurs += 1
                            end
                        
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


    #********************************************
    #       afficherErreur()
    #
    #affiche le nombre d'erreurs, puis, demande au joueur si il veut afficher ses erreurs, ou les supprimer
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
    end

    #*******************************************
    #           desactiverHypothese()
    #
    #permet de desactiver le mode hypothèse et de supprimer tous les mauvais liens que l'utilisateur à créé
    def desactiverHypothese()
        @hypothese = false
        while(!@pileHypothese.empty?)
            coup = @pileHypothese.pop
            pontCourant = coup.pont
            sens = coup.sens
            puts coup
            if(coup.estAjout?)then
                pontCourant.enleverPont
            else
                if(coup.estVertical?)then
                    pontCourant.creerPont("haut", true)
                    pontCourant.creerPont("bas", false)
                elsif(coup.estHorizontal?)then
                    pontCourant.creerPont("gauche", true)
                    pontCourant.creerPont("droite", false)
                else
                    puts "erreur de undo dans hypothese"
                end
            end
        end
        
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

        #On parcours toutes les cases
        x=-1
		y=-1
		@plateau.matrice.each {|item|
			x+=1
			y=-1
			item.each{ |elem| 
				y+=1
                #Si la case est une ile
				if(elem.element.estIle?)			
					bitPonts = elem.pontAjoutables
                    valeurActuelle = elem.element.valeur-elem.element.nbLiens
                    #Cas ou valeur <= 2 et nbVoisines = 1
                    if (valeurActuelle <= 2 && (bitPonts == 1 || bitPonts == 10 || bitPonts == 100 || bitPonts == 1000))
                        puts ("L'ile a la position #{x}, #{y} a encore 2 ou 1 ponts a faire et n'as qu'une seule voisine, il faut donc la connecter a sa voisine")
                        case bitPonts
                        when 1
                            return(coup.creer(false,voisineDroite.element))
                        when 10
                            return(coup.creer(false,voisineGauche.element))
                        when 100
                            return(coup.creer(false,voisineHaut.element))
                        when 1000
                            return(coup.creer(false,voisineBas.element))
                        end
                    end
                    #Cas ou valeur = 3 et nbVoisines = 2
                    if (valeurActuelle == 3 && (bitPonts == 11 || bitPonts == 110 || bitPonts == 101 || bitPonts == 1010 || bitPonts == 1001))
                        puts ("L'ile a la position #{x}, #{y} a encore 3 ponts a faire et posséde 2 voisines, il faut donc la connecter a une de ses voisines")
                        case bitPonts
                        when 11
                            return(coup.creer(false,voisineDroite.element))
                        when 110
                            return(coup.creer(false,voisineGauche.element))
                        when 101
                            return(coup.creer(false,voisineHaut.element))
                        when 1010
                            return(coup.creer(false,voisineBas.element))
                        when 1001
                            return(coup.creer(false,voisineBas.element))
                        end
                    end
                    #Cas ou valeur = 4 et nbVoisines = 2
                    if (valeurActuelle == 4 && (bitPonts == 11 || bitPonts == 110 || bitPonts == 101 || bitPonts == 1010 || bitPonts == 1001))
                        puts ("L'ile a la position #{x}, #{y} a encore 4 ponts a faire et posséde 2 voisines, il faut donc la connecter toutes ses voisines")
                        case bitPonts
                        when 11
                            return(coup.creer(false,voisineDroite.element))
                        when 110
                            return(coup.creer(false,voisineGauche.element))
                        when 101
                            return(coup.creer(false,voisineHaut.element))
                        when 1010
                            return(coup.creer(false,voisineBas.element))
                        when 1001
                            return(coup.creer(false,voisineBas.element))
                        end
                    end
                    #Cas ou valeur = 5 et nbVoisines = 3
                    if (valeurActuelle == 5 && (bitPonts == 111 || bitPonts == 1011 || bitPonts == 1110 || bitPonts == 1101))
                        puts ("L'ile a la position #{x}, #{y} a encore 5 ponts a faire et posséde 3 voisines, il faut donc la connecter a une de ses voisines")
                        case bitPonts
                        when 111
                            return(coup.creer(false,voisineDroite.element))
                        when 1011
                            return(coup.creer(false,voisineBas.element))
                        when 1110
                            return(coup.creer(false,voisineBas.element))
                        when 1101
                            return(coup.creer(false,voisineBas.element))
                        end
                    end
                    #Cas ou valeur = 6 et nbVoisines = 3
                    if (valeurActuelle == 6 && (bitPonts == 111 || bitPonts == 1011 || bitPonts == 1110 || bitPonts == 1101))
                        puts ("L'ile a la position #{x}, #{y} a encore 6 ponts a faire et posséde 3 voisines, il faut donc la connecter a toutes ses voisines")
                        case bitPonts
                        when 111
                            return(coup.creer(false,voisineDroite.element))
                        when 1011
                            return(coup.creer(false,voisineBas.element))
                        when 1110
                            return(coup.creer(false,voisineBas.element))
                        when 1101
                            return(coup.creer(false,voisineBas.element))
                        end
                    end
                    #Cas ou valeur = 7 et nbVoisines = 4
                    if (valeurActuelle == 7 && (bitPonts == 1111))
                        puts ("L'ile a la position #{x}, #{y} a encore 7 ponts a faire et posséde 5 voisines, il faut donc la connecter a un de ses voisines")
                        return(coup.creer(false,voisineDroite.element))
                    end
                    if (valeurActuelle == 8 && (bitPonts == 1111))
                        puts ("L'ile a la position #{x}, #{y} a encore 8 ponts a faire et posséde 5 voisines, il faut donc la connecter a un de ses voisines")
                        return(coup.creer(false,voisineDroite.element))
                    end
                end
			}
		}
	end

#l'ordre est le suivant du bit droit au gauche : Droite,Gauche,Haut,Bas
	
end#fin de classe ContreLaMontre
