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
	# @coupAjouter = le coup donner : boolean qui dit si c'est un ajout ou pas
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
	def Coup.creer(typeCoup, pont, sens)
		new(typeCoup, pont, sens)
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
	def initialize(typeCoup, pont, sens)
		@coupAjouter = typeCoup
		@pont = pont
		@sens = sens
	end


	attr_reader :coupAjouter, :pont, :sens



end
