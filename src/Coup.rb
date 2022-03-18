#
#class Coup
#
#permet de sauvegarder les coups pour pouvoir faire les undo ou les redo
#
#On peut juste créer un coup (qui sera créer à chaques coup d el'utilsiateur)
#
class Coup < Element

	###################################################################################
	#							Methodes de classe
	###################################################################################



    ## La classe Pont possède une variable d'instance
	#
	# @clickDroit = boolean qui décrit si le mouvement était click gauche ou droit
	# @pont = reference du pont sur la quelle le click est fait

	#***********************************************************************
	#				Coup.creer()
	#
	#Permet de creer un nouveau coup
	#
	#===== ATTRIBUT
	#
	#*+clickDroit+ : boolean qui indique si le clic etait droit ou pas
	#*+pont+ : le pont sur lequel le clic est réalisé
	#
	def Coup.creer(clickdroit, pont)
		new(clickdroit, pont)
	end

	#***********************************************************************
	#				initialize()
	#
	#Permet de initialiser un coup
	#
	#===== ATTRIBUT
	#
	#*+clickDroit+ : boolean qui indique si le clic etait droit ou pas
	#*+pont+ : le pont sur lequel le clic est réalisé
	#
	def initialize(clickdroit, pont)
		@clickDroit = clickdroit
		@pont = pont
	end



end
