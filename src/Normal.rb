load "Chrono.rb"

# La classe Normal est une sous-classe de la classe ContreLaMontre, elle possède les mêmes caractèristiques.
# La seule chose qui change est le sens du chronomètre
#
# Elle peut donc faire tous ce que peut faire la classe ContreLaMontre.
#
class Normal < ContreLaMontre

  # new est en privé
  private_class_method :new

  # Méthode qui permet de créer un mode normal.
  #
  # ==== Attributs
  #
  # * +unPlateau+ : une référence vers le plateau de jeu de la partie courante
  # * +unNiveau+ : le numéro du niveau choisis
  # * +unPseudo+ : le nom du joueur qui va jouer
  # * +uneDifficulte+ : la difficulté choisis
  #
  def Normal.creer(unPlateau, unNiveau, unPseudo, uneDifficulte)
    super(unPlateau, unNiveau, unPseudo, uneDifficulte)
  end

  # Méthode qui permet de lancer le chronometre dans le sens normal (part de 0 et s'incrémente jusqu'à ce que la partie soit terminée)
  def lancerChrono
    @chrono.lancerChrono
  end

end
