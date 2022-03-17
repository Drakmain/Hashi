
load "Chrono.rb"
load "Plateau.rb"


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
    def Genie.creer(unFichier, unPlateau, unNiveau, unPseudo)
        new(unFichier, unPlateau, unNiveau, unPseudo)
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
    def initialize(unFichier, unPlateau, unNiveau, unPseudo)
		@score = 0
        @chrono = Chrono.new
        @anciensCoups = []
        @coups = []
        @fichier = unFichier
        @plateau = unPlateau
        @save = nil;
        @dir = "../data/save/" + unNiveau + "/"
        @pseudo = unPseudo
	end

    #############################################################################################
    #                               Methodes
    #############################################################################################

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
    def lancerChroncreerdeleteCoup()
    end
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
    #
    #===== ATTRIBUTS
    #
    #*+unX+ => coordonnée X de la case
    #*+unY+ => Coordonnée Y de la case
    #
    def jouerCoup(unX, unY, unClic)
        @anciensCoups.push(Coup.creer(unClic, unPlateau.getCase(unX, unY)))

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


end# fin de la classe génie


genie = Genie.creer(nil, [1,2,3,4,5], "1", "mathieu")
genie.save()
print(genie)
g = genie.load()
print(g)