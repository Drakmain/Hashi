
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
    #   unFichier : le chemin vers le fichier qui contient la correction
    #   unPlateau : une référence vers le plateau de jeu de la partie courante
    #
    def initialize(unPlateau, unPseudo,  uneDifficulte, unNiveau)
		@score = 0
        @chrono = Chrono.new
        @anciensCoups = []
        @coups = []
        @fichierJeu = "../map/" + uneDifficulte + "/demarrage/" + unNiveau + ".txt"
        @fichierCorrection = "../map/" + uneDifficulte + "/correction/" + unNiveau + ".txt"
        @plateau = unPlateau
        @save = nil;
        @dir = "../data/save" + self.class.to_s + "/"
        @pseudo = unPseudo
        @correction = PlateauCorrection.creer(unNiveau)
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
    def save()
        puts "\nsave..."
        Dir.mkdir(@dir) unless File.exists?(@dir)
        f = File.open(File.expand_path(@dir + @pseudo + "save.bn"), "w")
        @save = Marshal::dump(self)
        f.write(@save)
        f.close()
    end

    #***********************************
    #           load()
    #
    #permet de charger une partie, elle déserialize le fiichier demandé
    def load()
        puts "\nload..."
        f = File.open(File.expand_path(@dir + @pseudo + "save.bn"), "r")
        @save = f.read()
        f.close()
        return Marshal::load(@save)
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
    def lancerChrono()
        @chrono.lancerChrono
    end
    #
    #permet de supprimer le dernier coup dans la liste des coups, le met dans a liste des anciens coups 
    def deleteCoup()
        @anciensCoups.push(@coup.pop)
    end

    #***********************************
    #               getCoup()
    #
    #permet de récupérer l'ancien coup supprimer dans la liste des anciens coups
    def getCoup()
        @coup.push(@anciensCoups.pop)
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
                    caseCourante.creerPontDefaut
                elsif(caseCourante.element.aDeuxSens)then
                    #caseCourante.estEntoure() ne sert probablement à rien
                    puts "vous voulez faire un coup horizontal(1) ou vertical(2) ?"
                    sens = gets
                    if(sens.to_i == 1)then
                        if(caseCourante.pontAjoutable("droite",true) && caseCourante.pontAjoutable("gauche",true))then
                            caseCourante.creerPont("droite", true)
                            caseCourante.creerPont("gauche", false)
                        end
                    else
                        if(caseCourante.pontAjoutable("haut",true) && caseCourante.pontAjoutable("bas",true))then
                            caseCourante.creerPont("haut", true)
                            caseCourante.creerPont("bas", false)
                        end
                    end
                    print "case courante : " + caseCourante.element.to_s+"\n"
                else
                    puts "coup fait"
                    caseCourante.creerPontDefaut
                    puts "fin du coup"
                end
            else
                caseCourante.enleverPont
            end
            @anciensCoups.push(Coup.creer(unClic, caseCourante))
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

    def afficherCorrection()
        @correction.afficherJeu()
    end

    def verifCoord(unX, unY)
        @plateau.verifCoord(unX, unY)
    end


end# fin de la classe génie





genie = Genie.creer(Plateau.creer(1), "theo", "facile", "2")
genie.initialiserJeu()
#genie.jouerCoup(7,2, "droit")


genie.save()
genie.afficherPlateau
#g = genie.load()
genie.afficherCorrection

