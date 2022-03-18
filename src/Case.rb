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
		if(@y == 0)
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
		if(@x == 0)
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
					@element = Pont.creer(true)
				end
				return true
			else
				bool = droite.ajouterPontDroite()
				if(bool == true)then
					if(@element.instance_of?(Element))then
						@element = Pont.creer(true)
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
					@element = Pont.creer(false)
				end
				return true
			else
				bool = bas.ajouterPontBas()
				if(bool == true)then
					if(!(@element.estIle?()) && !(@element.estPont?()))then
						@element = Pont.creer(false)
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
    def estEntoure()
		print "courante : " + self.to_s() + "\n"
		print "haut : " + self.voisineHaut.to_s() +"\n" +  "bas : " + self.voisineBas().to_s() + "\n" + "droite : " + self.voisineDroite().to_s() + "\n" + "Gauche : "+ self.voisineGauche().to_s() + "\n"
		if(self.voisineBas() == nil || self.voisineDroite() == nil || self.voisineGauche() == nil || self.voisineHaut == nil)then
			return false
		else
			return (self.voisineBas().element.estIle?() && (self.voisineDroite().element.estIle?())) || (self.voisineBas().element.estIle?() && (self.voisineGauche().element.estIle?())) || (self.voisineHaut().element.estIle?() && (self.voisineDroite().element.estIle?())) || (self.voisineHaut().element.estIle?() && (self.voisineGauche().element.estIle?()))
		end
    end


	def creerPontDefaut()	
		if(element.estPont?)then
			if(element.estVertical?)then
				self.creerPont("haut", true)
				self.creerPont("bas", false)
			else
				self.creerPont("gauche", true)
				self.creerPont("droite", false)
			end
		end
	end


	def creerPont(unSens, unBool)
		if(element.estPont?)then
			if(unBool)then
				element.ajoutePont
			end
			
			case(unSens)
			when "haut"
				self.voisineHaut.creerPont(unSens, true)
				self.element.estVertical
			when "bas"
				self.voisineBas.creerPont(unSens, true)
				self.element.estVertical
			when "gauche"
				self.voisineGauche.creerPont(unSens, true)
				self.element.estHorizontal
			when "droite"
				self.voisineDroite.creerPont(unSens, true)
				self.element.estHorizontal
			else
				puts "Pas compris le sens"
			end
			print element.to_s + "\n"
		end
	end

	#*********************************************************************
	#						to_s
	#
	#permet d'afficher une case (ses coordonnées) en retournant un string
	#
	#@return String
	def to_s()
		return "x:#{@x}, y:#{@y}"
	end

end #fin de la classe Case
