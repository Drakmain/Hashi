load 'Genie.rb'

##
# La classe ContreLaMontre permet de lancer un niveau, en plus d'un chronomètre qui, une fois arrivé à 0, arrètera la partie
#
# Les aides disponibles sont : 
# - Hypothèse
# - assiste
# - Correcteur d'erreur
# - auto-correction
#
# La classe contrelaMontre est une spécialisation de la classe génie (elle ajoute des fontionnalités)
#
# elle peut : 
# - lancer un chrono
# - charger une partie
# - sauvegarder une partie
# - activer/désactiver des aides
#
# ==== Variables d'instance
# * @hypothese => boolean qui est a vrai si le mode hypothèse est activé
# * @assiste => boolean qui indique si le mode assiste est active ou pas
# * @fichier => le fichier qui contient les réponses au niveau que le joueur éxécute
#
class ContreLaMontre < Genie

  # new en privée
  private_class_method :new

  # creer un objet ContreLaMontre
  #
  # ==== Attributs
  #
  # * +unPlateau+ : une référence vers le plateau de jeu de la partie courante
  # * +unNiveau+ : le numéro du niveau choisis
  # * +unPseudo+ : le nom du joueur qui va jouer
  # * +uneDifficulte+ : la difficulté choisis
  #
  def ContreLaMontre.creer(unPlateau, unNiveau, unPseudo, uneDifficulte)
    new(unPlateau, unNiveau, unPseudo, uneDifficulte)
  end

  # initialise un objet
  #
  # ==== Attributs
  #
  # * +unPlateau+ : une référence vers le plateau de jeu de la partie courante
  # * +unNiveau+ : le numéro du niveau choisis
  # * +unPseudo+ : le nom du joueur qui va jouer
  # * +uneDifficulte+ : la difficulté choisis
  #
  def initialize(unPlateau, unNiveau, unPseudo, uneDifficulte)
    super(unPlateau, unNiveau, unPseudo, uneDifficulte)
    @autoCorrecteur = false
    @assiste = false
    @hypothese = false
  end

  # permet de lancer le chronometre dans le sens inverse (part de 300 et se décrémente jusqu'à ce que le temps soit à 0) (5min pour toutes les maps)
  def lancerChrono
    @chrono.lancerChronoInverse(300)
  end

  # Permet de corriger des erreurs
  # lit dans le fichier passé en parametre.
  #
  def corrigerErreur
    erreur = false
    for i in 0..@plateau.x - 1
      for j in 0..@plateau.y - 1
        elementCourant = @plateau.getCase(i, j).element
        elementCorrection = @correction.getCase(i, j).element
        if (elementCourant.estPont? && elementCourant.nb_ponts > 0) then
          if elementCorrection.estElement? then
            @plateau.getCase(i, j).enleverPont
            erreur = true
          elsif elementCourant.nb_ponts > elementCorrection.nb_ponts then
            enleverErreur(@plateau.getCase(i, j), elementCourant.nb_ponts - elementCorrection.nb_ponts)
            erreur = true
          elsif elementCourant.estHorizontal? then
            if (elementCorrection.estVertical?) then
              enleverErreur(@plateau.getCase(i, j), elementCourant.nb_ponts)
              erreur = true
            end
          elsif elementCourant.estVertical? then
            if (elementCorrection.estHorizontal?) then
              enleverErreur(@plateau.getCase(i, j), elementCourant.nb_ponts)
              erreur = true
            end
          end
        end
      end
    end

    @plateau.afficherJeu

    return erreur

  end

  # Permet de corriger des erreurs
  # enlève des ponts en fonction d'un nombre donné sur une case choisis.
  #
  # ==== Attributs
  #
  # * +uneCase+ : la case choisis
  # * +unNombre+ : le nombre depont à enlever
  #
  # ==== Exemples
  #
  # En prenant la case en coordonnée (2,2),
  # et le nombre 1, la méthode va supprimer un pont
  # à la case (2,2)
  def enleverErreur(uneCase, unNombre)
    case unNombre
    when 2
      puts '2'
      uneCase.enleverPont
      uneCase.enleverPont
    when 1
      puts '1'
      uneCase.enleverPont
    else
      puts 'Problème nombre de Pont'
    end
  end

  #################################################################################################
  #                   Mode détection erreur
  #################################################################################################

  # Renvoie le nombre d'erreur du joueur
  def nombreErreurs
    nbErreurs = 0

    for i in 0..@plateau.x - 1
      for j in 0..@plateau.y - 1
        elementCourant = @plateau.getCase(i, j).element
        elementCorrection = @correction.getCase(i, j).element

        if (elementCourant.estPont? && elementCourant.estHorizontal?) then
          if (elementCourant.nb_ponts > 0 && !@plateau.getCase(i, j).voisineGauche.element.estPont?) then
            if elementCorrection.estElement? then
              nbErreurs += 1
            elsif elementCourant.nb_ponts > elementCorrection.nb_ponts then
              nbErreurs += 1
            elsif (elementCorrection.estVertical?) then
              nbErreurs += 1
            end
          end

        elsif (elementCourant.estPont? && elementCourant.estVertical?) then
          if (elementCourant.nb_ponts > 0) then
            if (elementCourant.nb_ponts > 0 && !@plateau.getCase(i, j).voisineHaut.element.estPont?) then
              if elementCorrection.estElement? then
                nbErreurs += 1
              elsif elementCourant.nb_ponts > elementCorrection.nb_ponts then
                nbErreurs += 1
              elsif (elementCorrection.estHorizontal?) then
                nbErreurs += 1
              end
            end
          end
        end
      end
    end

    return nbErreurs
  end

  # permet de mettre en surbrillance les erreurs sur les ponts mal placés
  def afficherPontErreur
    for i in 0..@plateau.x - 1
      for j in 0..@plateau.y - 1
        elementCourant = @plateau.getCase(i, j).element
        elementCorrection = @correction.getCase(i, j).element
        if (elementCourant.estPont? && elementCourant.nb_ponts > 0) then
          if elementCorrection.estElement? then
            elementCourant.erreur = true
          elsif elementCourant.nb_ponts > elementCorrection.nb_ponts then
            elementCourant.erreur = true
          elsif elementCourant.estHorizontal? then
            if (elementCorrection.estVertical?) then
              elementCourant.erreur = true
            end
          elsif elementCourant.estVertical? then
            if (elementCorrection.estHorizontal?) then
              elementCourant.erreur = true
            end
          end
        end  
      end
    end
  end

  # affiche le nombre d'erreurs, puis, demande au joueur si il veut afficher ses erreurs, ou les supprimer
  def afficherErreurs
    puts "Tu as #{nombreErreurs.to_s} erreurs"
    puts 'Afficher toutes les erreurs(0) ou supprimer toutes les erreurs(1) ?'
    verif = gets
    verif = verif.to_i
    case verif
    when 0
      afficherPontErreur
    when 1
      corrigerErreur
    end
  end

  #################################################################################################
  #                   Mode AutoCorrecteur
  #################################################################################################

  # permet d'activer le mode AutoCorrecteur
  def activerAutoCorrecteur
    @autoCorrecteur = true
    corrigerErreur
  end

  # permet de desactiver le mode AutoCorrecteur et de supprimer tous les mauvais liens que l'utilisateur à créé
  def desactiverAutoCorrecteur
    @autoCorrecteur = false
  end

  #################################################################################################
  #                   Mode Hypothèse
  #################################################################################################

  # permet d'activer le mode hypothèse
  def activerHypothese
    @hypothese = true
  end

  # permet de desactiver le mode hypothèse et de supprimer tous les mauvais liens que l'utilisateur à créé
  def desactiverHypothese
    @hypothese = false
    while !@pileHypothese.empty?
      coup = @pileHypothese.pop
      pontCourant = coup.pont
      sens = coup.sens
      puts coup
      if coup.estAjout?
        pontCourant.enleverPont
      else
        if coup.estVertical?
          pontCourant.creerPont('haut', true)
          pontCourant.creerPont('bas', false)
        elsif coup.estHorizontal?
          pontCourant.creerPont('gauche', true)
          pontCourant.creerPont('droite', false)
        else
          puts 'erreur de undo dans hypothese'
        end
      end
    end
  end

  #################################################################################################
  #                   Suggestion de coup
  #################################################################################################

  # Permet de suggérer un coup à l'utilisateur, si le joueur a des erreurs, alors elles lui sont indiqué
  # et doit les corriger avant d'avoir un coup à jouer
  def suggestion
    res = []
    coup = nil
    # On parcours toutes les cases
    x = -1
    y = -1
    @plateau.matrice.each do |item|
      x += 1
      y = -1
      item.each do |elem|
        y += 1
        # Si la case est une ile
        if elem.element.estIle?
          bitPonts = elem.pontAjoutables
          valeurActuelle = elem.element.valeur - elem.element.nbLiens
          # Cas ou valeur <= 2 et nbVoisines = 1
          if valeurActuelle > 0 && valeurActuelle <= 2 && (bitPonts == 1 || bitPonts == 10 || bitPonts == 100 || bitPonts == 1000)
            res.push("Cette île a encore 2 ou 1 ponts a faire et n'as qu'une seule voisine, il faut donc la connecter à sa voisine")
            case bitPonts
            when 1
              coup = Coup.creer(false, elem.voisineDroite.element, true)
              res.push(coup)
              return res
            when 10
              coup = Coup.creer(false, elem.voisineGauche.element, true)
              res.push(coup)
              return res
            when 100
              coup = Coup.creer(false, elem.voisineHaut.element, false)
              res.push(coup)
              return res
            when 1000
              coup = Coup.creer(false, elem.voisineBas.element, false)
              res.push(coup)
              return res
            end
          # Cas ou valeur = 3 et nbVoisines = 2
          elsif valeurActuelle == 3 && (bitPonts == 11 || bitPonts == 110 || bitPonts == 101 || bitPonts == 1010 || bitPonts == 1001)
            res.push("Cette île a encore 3 ponts a faire et posséde 2 voisines, il faut donc la connecter à une de ses voisines")
            case bitPonts
            when 11
              coup = Coup.creer(false, elem.voisineDroite.element, true)
              res.push(coup)
              return res
            when 110
              coup = Coup.creer(false, elem.voisineGauche.element, true)
              res.push(coup)
              return res
            when 101
              coup = Coup.creer(false, elem.voisineHaut.element, false)
              res.push(coup)
              return res
            when 1010
              coup = Coup.creer(false, elem.voisineBas.element, false)
              res.push(coup)
              return res
            when 1001
              coup = Coup.creer(false, elem.voisineBas.element, false)
              res.push(coup)
              return res
            end
          # Cas ou valeur = 4 et nbVoisines = 2
          elsif valeurActuelle == 4 && (bitPonts == 11 || bitPonts == 110 || bitPonts == 101 || bitPonts == 1010 || bitPonts == 1001)
            res.push("Cette île a encore 4 ponts a faire et posséde 2 voisines, il faut donc la connecter à toutes ses voisines")
            case bitPonts
            when 11
              coup = Coup.creer(false, elem.voisineDroite.element, true)
              res.push(coup)
              return res
            when 110
              coup = Coup.creer(false, elem.voisineGauche.element, true)
              res.push(coup)
              return res
            when 101
              coup = Coup.creer(false, elem.voisineHaut.element, false)
              res.push(coup)
              return res
            when 1010
              coup = Coup.creer(false, elem.voisineBas.element, false)
              res.push(coup)
              return res
            when 1001
              coup = Coup.creer(false, elem.voisineBas.element, false)
              res.push(coup)
              return res
            end
          # Cas ou valeur = 5 et nbVoisines = 3
          elsif valeurActuelle == 5 && (bitPonts == 111 || bitPonts == 1011 || bitPonts == 1110 || bitPonts == 1101)
            res.push("Cette île a encore 5 ponts a faire et posséde 3 voisines, il faut donc la connecter à une de ses voisines")
            case bitPonts
            when 111
              coup = Coup.creer(false, elem.voisineDroite.element, true)
              res.push(coup)
              return res
            when 1011
              coup = Coup.creer(false, elem.voisineBas.element, false)
              res.push(coup)
              return res
            when 1110
              coup = Coup.creer(false, elem.voisineBas.element, false)
              res.push(coup)
              return res
            when 1101
              coup = Coup.creer(false, elem.voisineBas.element, false)
              res.push(coup)
              return res
            end
          # Cas ou valeur = 6 et nbVoisines = 3
          elsif valeurActuelle == 6 && (bitPonts == 111 || bitPonts == 1011 || bitPonts == 1110 || bitPonts == 1101)
            res.push("Cette île a encore 6 ponts a faire et posséde 3 voisines, il faut donc la connecter à toutes ses voisines")
            case bitPonts
            when 111
              coup = Coup.creer(false, elem.voisineDroite.element, true)
              res.push(coup)
              return res
            when 1011
              coup = Coup.creer(false, elem.voisineBas.element, false)
              res.push(coup)
              return res
            when 1110
              coup = Coup.creer(false, elem.voisineBas.element, false)
              res.push(coup)
              return res
            when 1101
              coup = Coup.creer(false, elem.voisineBas.element, false)
              res.push(coup)
              return res
            end
          # Cas ou valeur = 7 et nbVoisines = 4
          elsif valeurActuelle == 7 && (bitPonts == 1111)
            res.push("Cette île a encore 7 ponts a faire et posséde 5 voisines, il faut donc la connecter à un de ses voisines")
            coup = Coup.creer(false, elem.voisineDroite.element, true)
            res.push(coup)
            return res
          elsif valeurActuelle == 8 && (bitPonts == 1111)
            res.push("Cette île a encore 8 ponts a faire et posséde 5 voisines, il faut donc la connecter à un de ses voisines")
            coup = Coup.creer(false, elem.voisineDroite.element, true)
            res.push(coup)
            return res
          end
        end
      end
    end
  end

  #l'ordre est le suivant du bit droit au gauche : Droite,Gauche,Haut,Bas

end
