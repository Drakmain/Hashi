
load "Chrono.rb"
load "Plateau.rb"
load "PlateauCorrection.rb"
load "Coup.rb"


# La classe Genie représente le mode génie, c'est le mode le plus "simple" dans le sens où aucune aide ne sera disponible.
# Elle est donc la classe mère des autres mode de jeu.
#
# Elle peut : 
#
# - sauvegarder la partie
# - charger une partie
# - calculer le score du joueur
# - lancer le chronometre
# - Supprimer/remettre un coup
# - jouer un coup
# - récupérer le coup jouer
#
# ==== Variables d'instance
# * @score         => le score du joueur
# * @chrono        => le chrono qui se lance en début de partie
# * @anciensCoups  => la file des anciens coups
# * @coups         => la pile de coups
# * @pileHypothese => la pile de coups du mode hypothèse
# * @fichierJeu    => le chemin vers le fichier qui contient la grille basique
# * @fichierCorrection => le chemin vers le fichier qui contient la correction
# * @plateau       => le plateau de jeu courant
# * @save          => la sauvegarde de la partie
# * @dir           => le chemin vers le dossier qui contient les fichiers
# * @pseudo        => le pseudo du joueur
# * @correction    => le plateau de jeu avec la correction
# * @chronoFirst   => temps au début du tour de jeu
# * @hypothese     => état du mode hypothèse
# * @autoCorrecteur : boolean qui indique si le mode auto-correcteur est activé
#
class Genie

    ##############################################################################################
    #                               Methode de classe
    ##############################################################################################


    # La méthode new est en privé
    private_class_method :new


    # Méthode qui permet de créer un mode génie
    #
    # ==== Attributs
    #
    # * +unPlateau+ : une référence vers le plateau de jeu de la partie courante
    # * +unNiveau+ : le numéro du niveau choisis
    # * +unPseudo+ : le nom du joueur qui va jouer
    # * +uneDifficulte+ : la difficulté choisis
    #
    def Genie.creer(unPlateau, unNiveau, unPseudo, uneDifficulte)
        new(unPlateau, unNiveau, unPseudo, uneDifficulte)
    end

    # Méthode qui permet d'initialiser un mode génie
    #
    # ==== Attributs
    #
    # * +unPlateau+ : une référence vers le plateau de jeu de la partie courante
    # * +unNiveau+ : le numéro du niveau choisis
    # * +unPseudo+ : le nom du joueur qui va jouer
    # * +uneDifficulte+ : la difficulté choisis
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
        @autoCorrecteur = false
	end


    #############################################################################################
    #                               Methodes
    #############################################################################################


    # Méthode qui permet d'initialiser le jeu (le plateau de jeu et sa correction)
    def initialiserJeu()
        @plateau.generateMatrice(@fichierJeu)
        @plateau.generatePlateau
        @plateau.ajouterPont

        @correction.generateMatrice(@fichierCorrection)
        @correction.generatePlateau
    end


    # Méthode qui permet de sauvegarder une partie, elle sérialize l'objet courant
    #
    # ==== Attributs
    #
    # * +nomFichier+ - Le nom du fichier pour la sauvegarde
    def save(nomFichier)
        puts "\nsave..."
        Dir.mkdir(@dir) unless File.exists?(@dir)
        f = File.open(File.expand_path(@dir + @pseudo + nomFichier + ".bn"), "w")
        @save = Marshal::dump(self)
        f.write(@save)
        f.close()
    end


    # Méthode qui permet de charger une partie, elle désérialize le fichier demandé
    #
    # ==== Attributs
    #
    # * +nomFichier+ - Le nom du fichier pour le chargement
    def load(nomFichier)
        puts "\nload..."
        f = File.open(File.expand_path(@dir + @pseudo + nomFichier + ".bn"), "r")
        @save = f.read()
        f.close()
        return Marshal::load(@save)
    end


    # Méthode qui permet de calculer le score du joueur
    def calculScore()
        chronoNow = @chrono.chrono
        if @chronoFirst - chronoNow != 0 then
            @score += 100 - (5 * 100 / (@chronoFirst - chronoNow))
        end
    end


    # Méthode qui permet de lancer le chronometre dans le sens normal (part de 0 et s'incrémente jusqu'à ce que la partie soit terminé)
    def lancerChrono()
        @chrono.lancerChrono
    end
    

    # Méthode qui permet de supprimer le dernier coup dans la liste des coups, le met dans à liste des anciens coups 
    def deleteCoup()
        @anciensCoups.push(@coup.pop)
    end

    
    # Méthode qui permet de récupérer l'ancien coup supprimer dans la liste des anciens coups
    def getCoup()
        @coups.push(@anciensCoups.pop)
    end


    # Méthode qui permet d'enlever le dernier coup 
    def undo
        if(!@coups.empty?)then
            coup = @coups.pop
            pontCourant = coup.pont
            sens = coup.sens
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



    # Méthode qui permet de remettre le dernier coup supprimer
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


    # Méthode qui permet de jouer un coup
    #
    # ==== Attributs
    #
    # * +unX+ - coordonnée X de la case
    # * +unY+ - Coordonnée Y de la case
    # * +unClic+ - type de clic fait par le joueur
    #
    # ==== Retourne
    #
    # - true si la partie est finie, 
    # - false si la case jouée n'est pas un pont ou si la partie n'est pas finie
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

        if(@autoCorrecteur)then
            corrigerErreur
        end

        return @plateau.partieFini?
        
    end


    # Méthode qui permet de jouer un coup sur une interface
    #
    # ==== Attributs
    #
    # * +unX+ - la coordonnée x de la case
    # * +unY+ - La coordonnée y de la case
    # * +unClic+ - l'action effectué par l'utilisateur
    def jouerCoupInterface(unX, unY, unClic)
        caseCourante = @plateau.getCase(unX, unY)

        if(caseCourante.element.estPont?)then
            if(unClic)then
                if(caseCourante.element.nb_ponts > 0)then
                    sens = caseCourante.creerPontDefaut
                elsif (caseCourante.element.aDeuxSens) then
                    return false
                else
                    sens = caseCourante.creerPontDefaut
                end
                unClic = "ajouter"
            else
                sens = caseCourante.enleverPont
                unClic = "enlever"
            end

            if(@hypothese)then
                @pileHypothese.push(Coup.creer(unClic, caseCourante, sens))
            else
                @coups.push(Coup.creer(unClic, caseCourante, sens))
            end

        else
            puts "case pas un pont"
        end

        if(@autoCorrecteur)then
            corrigerErreur
        end

        return true
    end

    # Méthode qui permet de jouer un coup horizontale sur une interface
    #
    # ==== Attributs
    #
    # * +unX+ - la coordonnée x de la case
    # * +unY+ - La coordonnée y de la case
    # * +unClic+ - l'action effectué par l'utilisateur
    def jouerCoupHorizontaleInterface(unX, unY, unClic)
        caseCourante = @plateau.getCase(unX, unY)
        if(caseCourante.pontAjoutable("droite",true) && caseCourante.pontAjoutable("gauche",true))then
            caseCourante.creerPont("droite", true)
            caseCourante.creerPont("gauche", false)
            sens = "horizontal"
        end
        if(@hypothese)then
            @pileHypothese.push(Coup.creer(unClic, caseCourante, sens))
        else
            @coups.push(Coup.creer(unClic, caseCourante, sens))
        end
    end

    # Méthode qui permet de jouer un coup verticale sur une interface
    #
    # ==== Attributs
    #
    # * +unX+ - la coordonnée x de la case
    # * +unY+ - La coordonnée y de la case
    # * +unClic+ - l'action effectué par l'utilisateur
    def jouerCoupVerticaleInterface(unX, unY, unClic)
        caseCourante = @plateau.getCase(unX, unY)
        if(caseCourante.pontAjoutable("haut",true) && caseCourante.pontAjoutable("bas",true))then
            caseCourante.creerPont("haut", true)
            caseCourante.creerPont("bas", false)
            sens = "vertical"
        end
        if(@hypothese)then
            @pileHypothese.push(Coup.creer(unClic, caseCourante, sens))
        else
            @coups.push(Coup.creer(unClic, caseCourante, sens))
        end
    end


    # Méthode qui permet d'afficher le mode génie
    #
    # ==== Retourne
    #
    # L'état de la partie en cours
    #
    def to_s
        return "Je suis en mode génie \n" + "plateau : " + @plateau.to_s + "\nScore : " + @score.to_s
    end



    # Méthode qui affiche le plateau sur le terminal    
    def afficherPlateau()
        @plateau.afficherJeu()
    end


    # Méthode qui affiche le plateau de correction sur le terminal  
    def afficherCorrection()
        @correction.afficherJeu()
    end


    # Méthode qui permet de verifier les coordonnées d'une case
    #
    # ==== ATTRIBUTS
    #
    # * +unX+ - coordonnée X de la case
    # * +unY+ - Coordonnée Y de la case
    #
    def verifCoord(unX, unY)
        @plateau.verifCoord(unX, unY)
    end


end# fin de la classe génie



