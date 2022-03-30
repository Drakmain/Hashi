
load "Chrono.rb"
load "Plateau.rb"
load "PlateauCorrection.rb"
load "Coup.rb"


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
    #@coups         => la pile de coups
    #@pileHypothese => la pile de coups du mode hypothèse
    #@fichierJeu    => le chemin vers le fichier qui contient la grille basique
    #@fichierCorrection => le chemin vers le fichier qui contient la correction
    #@plateau       => le plateau de jeu courant
    #@save          => la sauvegarde de la partie
    #@dir           => le chemin vers le dossier qui contient les fichiers
    #@pseudo        => le pseudo du joueur
    #@correction    => le plateau de jeu avec la correction
    #@chronoFirst   => temps au début du tour de jeu
    #@hypothese     => état du mode hypothèse

    attr_reader :fichierJeu

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
    #   unPlateau : une référence vers le plateau de jeu de la partie courante
    #   unNiveau : le numéro du niveau choisis
    #   unPseudo : le nom du joueur qui va jouer
    #   uneDifficulte : la difficulté choisis
    #
    def Genie.creer(unPlateau, unNiveau, unPseudo, uneDifficulte)
        new(unPlateau, unNiveau, unPseudo, uneDifficulte)
    end

    #**************************************************
    #           Genie.creer()
    #
    #permet d'initialiser une instance de génie
    #
    #==== ATTRIBUTS
    #
    #   unPlateau : une référence vers le plateau de jeu de la partie courante
    #   unPseudo : le nom du joueur qui va jouer
    #   uneDifficulte : la difficulté choisis
    #   unNiveau : le numéro du niveau choisis
    #
    def initialize(unPlateau, unNiveau, unPseudo, uneDifficulte)
		@score = 0
        @chrono = Chrono.new
        @anciensCoups = []
        @coups = []
        @pileHypothese = []
        @fichierJeu = "../data/map/" + uneDifficulte + "/demarrage/" + unNiveau + ".txt"
        @fichierCorrection = "../data/map/" + uneDifficulte + "/correction/" + unNiveau + ".txt"
        @plateau = unPlateau
        @save = nil;
        @dir = "../data/save" + self.class.to_s + unNiveau + "/"
        @pseudo = unPseudo
        @correction = PlateauCorrection.creer()
        @chronoFirst = 0
        @hypothese = true
	end

    #############################################################################################
    #                               Methodes
    #############################################################################################


    def initialiserJeu()
        @plateau.generateMatrice(@fichierJeu)
        @plateau.generatePlateau
        @plateau.ajouterPont

        @correction.generateMatrice(@fichierCorrection)
        @correction.generatePlateau
    end

    #************************************
    #           save()
    #
    #permet de sauvegarder une partie, elle sérialize l'objet courant
    def save(nomFichier)
        puts "\nsave..."
        Dir.mkdir(@dir) unless File.exists?(@dir)
        f = File.open(File.expand_path(@dir + @pseudo + nomFichier + ".bn"), "w")
        @save = Marshal::dump(self)
        f.write(@save)
        f.close()
    end

    #***********************************
    #           load()
    #
    #permet de charger une partie, elle déserialize le fiichier demandé
    def load(nomFichier)
        puts "\nload..."
        f = File.open(File.expand_path(@dir + @pseudo + nomFichier + ".bn"), "r")
        @save = f.read()
        f.close()
        return Marshal::load(@save)
    end

    #***********************************
    #           calculerScore()
    #
    #permet de calculer le score du joueur
    def calculScore()
        chronoNow = @chrono.chrono
        if @chronoFirst - chronoNow != 0 then
            @score += 100 - (5 * 100 / (@chronoFirst - chronoNow))
        end
    end

    #************************************
    #           lancerChrono()
    #
    #permet de lancer le chronometre dans le sens normal (part de 0 et s'incrémente jusqu'à ce que la partie soit terminé)
    def lancerChrono()
        @chrono.lancerChrono
    end
    #
    #permet de supprimer le dernier coup dans la liste des coups, le met dans a liste des anciens coups 
    def deleteCoup()
        @anciensCoups.push(@coup.pop)
    end

    def corrigerErreur()
    end

    #***********************************
    #               getCoup()
    #
    #permet de récupérer l'ancien coup supprimer dans la liste des anciens coups
    def getCoup()
        @coups.push(@anciensCoups.pop)
    end

    #************************************
    #               undo
    #
    #permet d'enlever le dernier coup 
    def undo
        if(!@coups.empty?)then
            coup = @coups.pop
            pontCourant = coup.pont
            sens = coup.sens
            puts coup
            if(coup.estAjout?)then
                pontCourant.enleverPont
                @anciensCoups.push(Coup.creer("ajouter", coup.pont, sens))
            else
                if(coup.estVertical?)then
                    pontCourant.creerPont("haut", true)
                    pontCourant.creerPont("bas", false)
                elsif(coup.estHorizontal?)then
                    pontCourant.creerPont("gauche", true)
                    pontCourant.creerPont("droite", false)
                else
                    puts "erreur de undo"
                end
                @score -= 10 
                @anciensCoups.push(Coup.creer("enlever", coup.pont, sens))
            end
        end
    end


    #*************************************
    #               redo
    #
    #
    #permet de remettre le dernier coup supprimer
    def redo
        if(!@anciensCoups.empty?)then
            coup = @anciensCoups.pop
            pontCourant = coup.pont
            puts pontCourant
            if(coup.estEnleve?)then
                pontCourant.enleverPont
            else
                if(coup.estVertical?)then
                    pontCourant.creerPont("haut", true)
                    pontCourant.creerPont("bas", false)
                elsif(coup.estHorizontal?)then
                    pontCourant.creerPont("gauche", true)
                    pontCourant.creerPont("droite", false)
                else
                    puts "erreur de redo"
                end
            end
            @score -= 10 
            @coups.push(coup)
        end
    end

    #**********************************
    #               jouerCoup()
    #
    #permet de jouer un coup
    #
    #===== ATTRIBUTS
    #
    #*+unX+ => coordonnée X de la case
    #*+unY+ => Coordonnée Y de la case
    #*+unClic+ => type de clic fait par le joueur
    #
    def jouerCoup(unX, unY, unClic)

        caseCourante = @plateau.getCase(unX, unY)

        joue = -1
        if(caseCourante.element.estPont?()) then
            if(caseCourante.element.nb_ponts > 0)then
                puts "Vous voulez enlever(1) un pont ou en ajouter(2) un ?"
                joue = gets
                joue = joue.to_i
            end

            if(joue == 2 || joue == -1)then
                if(caseCourante.element.nb_ponts > 0)then
                    sens = caseCourante.creerPontDefaut
                elsif(caseCourante.element.aDeuxSens)then
                    #caseCourante.estEntoure() ne sert probablement à rien
                    puts "vous voulez faire un coup horizontal(1) ou vertical(2) ?"
                    sens = gets
                    if(sens.to_i == 1)then
                        if(caseCourante.pontAjoutable("droite",true) && caseCourante.pontAjoutable("gauche",true))then
                            caseCourante.creerPont("droite", true)
                            caseCourante.creerPont("gauche", false)
                            sens = "horizontal"
                        end
                    else
                        if(caseCourante.pontAjoutable("haut",true) && caseCourante.pontAjoutable("bas",true))then
                            caseCourante.creerPont("haut", true)
                            caseCourante.creerPont("bas", false)
                            sens = "vertical"
                        end
                    end
                    print "case courante : " + caseCourante.element.to_s+"\n"
                else
                    sens = caseCourante.creerPontDefaut
                end
                unClic = "ajouter"
            else
                sens = caseCourante.enleverPont
                unClic = "enlever"
            end
            puts "sens : " + sens.to_s
            if(@hypothese)then
                @pileHypothese.push(Coup.creer(unClic, caseCourante, sens))
            else
                @coups.push(Coup.creer(unClic, caseCourante, sens))
            end
            #calculScore
            #@chronoFirst = @chrono.chrono
            #puts @score
        else
            puts "case pas un pont"
            return false
        end

        return @plateau.partieFini?
        
    end

    #**********************************
    #              to_s
    #
    #Permet d'afficher le mode génie
    #
    #Affiche l'état de la partie en cours
    #
    def to_s
        return "Je suis en mode génie \n" + "plateau : " + @plateau.to_s + "\nScore : " + @score.to_s
    end


    #**********************************
    #              afficherPlateau
    #
    #Affiche le plateau
    def afficherPlateau()
        @plateau.afficherJeu()
    end

     #**********************************
    #              afficherCorrection
    #
    #Affiche le plateau avec la correction
    def afficherCorrection()
        @correction.afficherJeu()
    end

    #**********************************
    #               verifCoord()
    #
    #permet de verifier les coordonnées
    #
    #===== ATTRIBUTS
    #
    #*+unX+ => coordonnée X de la case
    #*+unY+ => Coordonnée Y de la case
    #
    def verifCoord(unX, unY)
        @plateau.verifCoord(unX, unY)
    end


end# fin de la classe génie



