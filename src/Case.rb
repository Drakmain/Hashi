##
#
#classe Case
#
#La classe case représente un élément du plateau, elle peut être soit une île, soit un pont, soit un élément
#elle connait le plateau
#
#elle peut : 
#
#	- Donner ses voisines (droite, gauche, haut, bas)
#	- donner son élément
#
#elle connait : 
#
#	- Ses coordonnnées sur le plateau
#	- Le plateau
#	- son élément
#
class Case
	#@x => coordonées x de la case
	#@y => coordonées y de la case
	#@plateau => le plateau de jeux
	#@element => element que l'ile posséde ou non

	###############################################################################################
	#							Methode de classe
	###############################################################################################

	def Case.creer(unX,unY,unPlateau,unElem)
		new(unX,unY,unPlateau,unElem)
	end


	#new est en privée car il y a un parametre à passer dans la création
	private_class_method :new

	##
	# Methode d'initialisation de la classe
	#
	#===== ATTRIBUT
	#
	# unX => coordonées x de la case
	# unY => coordonées y de la case
	# unPlateau => le plateau de jeux
	#
	def initialize(unX,unY,unPlateau,unElem)
		@x = unX
		@y = unY
		@plateau = unPlateau
		@element = unElem
	end

	#Accès a l'élément de la case
	attr_reader :x, :y
	attr_accessor :element

	##################################################################################################
	#						Methode d'accès aux voisines
	##################################################################################################
	
	#*****************************************************************************
	#			voisineDroite()
	#
	#
	# Methode qui retourne la case de droite
	def voisineDroite()
		if(@y+1 == @plateau.y)
			return nil
		else
			return @plateau.matrice[@x][@y+1]
		end
	end
	
	#*****************************************************************************
	#			voisineGauche()
	#
	# Methode qui retourne la case de gauche
	def voisineGauche()
		if(@y-1 == @plateau.y)
			return nil
		else
			return @plateau.matrice[@x][@y-1]
		end
	end
	
	#*****************************************************************************
	#			voisineBas()
	#
	# Methode qui retourne la case d'en bas
	def voisineBas()
		if(@x+1 == @plateau.x)
			return nil
		else
			return @plateau.matrice[@x+1][@y]
		end
	end
	
	#*****************************************************************************
	#			voisineHaut()
	#
	# Methode qui retourne la case d'en haut
	def voisineHaut()
		if(@x-1 == @plateau.x)
			return nil
		else
			return @plateau.matrice[@x-1][@y]
		end
	end

	#****************************************************************************
	#					AjouterPontDroite()
	#
	#Methode qui permet d'ajouter des pont à droite de la case appelante
	#La case vérifie :
	#
	#	- Si elle a un île a sa droite
	#	- Si elle a du vide
	#
	#@return true si le pont peut être créé, false sinon
	def ajouterPontDroite()
		droite = voisineDroite()
		if(droite == nil)then
			return false
		else
			if(droite.element.estIle?())then
				if(@element.instance_of?(Element))then
					@element = Pont.creer()
				end
				return true
			else
				bool = droite.ajouterPontDroite()
				if(bool == true)then
					if(@element.instance_of?(Element))then
						@element = Pont.creer()
					end
					return true
				else
					return false
				end
			end
		end
	end


	#****************************************************************************
	#					AjouterPontBas()
	#
	#Methode qui permet d'ajouter des pont en bas de la case appelante
	#La case vérifie :
	#
	#	- Si elle a un île en dessous
	#	- Si elle a du vide
	#
	#@return true si le pont peut être créé, false sinon
	def ajouterPontBas()
		bas = voisineBas()
		if(bas == nil)then
			return false
		else
			if(bas.element.estIle?())then
				if(@element.instance_of?(Element))then
					@element = Pont.creer()
				end
				return true
			else
				bool = bas.ajouterPontBas()
				if(bool == true)then
					if(!(@element.estIle?()) && !(@element.estPont?()))then
						@element = Pont.creer()
					end
					return true
				else
					return false
				end
			end
		end
	end

	#***************************************************
    #                   estEntouré?()
    #
    #retourne vrai si le pont sélectionner peut être soit horizontale, soit vertical
    def estEntouré(){
		if(self.voisineBas() == nil || self.voisineDroite() == nil || self.voisineGauche() == nil || self.voisineHaut == nil)then
			return false
		else
			return !(self.voisineBas().estElement?()) && !(self.voisineDroite().estElement?())
		end
    }

	#*********************************************************************
	#						to_s
	#
	#permet d'afficher une case (ses coordonnées) en retournant un string
	#
	#@return String
	def to_s()
		return "x:#{@x}, y:#{@y} "
	end

end #fin de la classe Case
