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
	#					ajouterPontDroite()
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
				elsif(@element.estPont?)then
					@element.deuxSens
				end
				return true
			else
				bool = droite.ajouterPontDroite()
				if(bool == true)then
					if(@element.instance_of?(Element))then
						@element = Pont.creer(true)
					elsif(@element.estPont?)then
						@element.deuxSens
					end
					return true
				else
					return false
				end
			end
		end
	end


	#****************************************************************************
	#					ajouterPontBas()
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
				elsif(@element.estPont?)then
					@element.deuxSens
				end
				return true
			else
				bool = bas.ajouterPontBas()
				if(bool == true)then
					if(!(@element.estIle?()) && !(@element.estPont?()))then
						@element = Pont.creer(false)
					elsif(@element.estPont?)then
						@element.deuxSens
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


	#***************************************************
    #                   creerPontDefaut()
    #
    # Créé les tous les ponts entre 2 îles, ces ponts ne peuvent que être vertical ou horizontal
	def creerPontDefaut()	
		if(@element.estPont?)then
			if(@element.estVertical?)then
				puts "test"
				if(pontAjoutable("haut") && pontAjoutable("bas"))then
					puts "test"
					self.creerPont("haut", true)
					self.creerPont("bas", false)
				end
			else
				if(pontAjoutable("gauche") && pontAjoutable("droite"))then
					self.creerPont("gauche", true)
					self.creerPont("droite", false)
				end
			end
		end
	end


	#***************************************************
    #                   creerPont()
    # 
    # Créé les tous les ponts entre 2 îles
	def creerPont(unSens, unBool)
		if(@element.estPont?)then
			if(unBool)then
				@element.ajoutePont
			end
			case(unSens)
			when "haut"
				#if(pontAjoutable("haut"))then
					self.voisineHaut.creerPont(unSens, true)
					self.element.estVertical
				#end
			when "bas"
				#if(pontAjoutable("bas"))then
					self.voisineBas.creerPont(unSens, true)
					self.element.estVertical
				#end
			when "gauche"
				#if(pontAjoutable("gauche"))then
					self.voisineGauche.creerPont(unSens, true)
					self.element.estHorizontal
				#end
			when "droite"
				#if(pontAjoutable("droite"))then
					self.voisineDroite.creerPont(unSens, true)
					self.element.estHorizontal
				#end
			else
				puts "Pas compris le sens"
			end
		elsif(@element.estIle?)then
			@element.ajouterPont
		end
		print element.to_s + "\n"
	end


	#*********************************************************************
	#					pontAjoutable()
	#
	#permet de dire si oui ou non le pont peut être ajouté
	def pontAjoutable(unSens)
		if(@element.estPont?())then
			if(@element.nb_ponts != 0)then
				puts "nb_ponts > 0"
				return ileFini?(unSens)
			elsif(unSens == "droite")then
				return voisineDroite.pontAjoutable(unSens)
			elsif(unSens == "gauche")
				return  voisineGauche.pontAjoutable(unSens)
			elsif(unSens == "haut")
				return voisineHaut.pontAjoutable(unSens)
			elsif(unSens == "bas")
				voisineBas.pontAjoutable(unSens)
			else
				puts "erreur de comprehension"
				return false
			end
		elsif(@element.estIle?)then
			if(@element.estFini)
				return false
			else
				return true
			end
		else
			return false
		end
	end


	def ileFini?(unSens)
		if(@element.estIle?)then
			if(@element.estFini)
				return false
			else
				return true
			end
		else
			case(unSens)
			when "haut"
				return voisineHaut.ileFini?(unSens) 
			when "gauche"
				return voisineGauche.ileFini?(unSens)
			when "droite"
				return voisineDroite.ileFini?(unSens)
			when "bas"
				return voisineBas.ileFini?(unSens)
			else
				puts "pas compris"
			end
		end
	end


	def enleverPont()
		if(@element.estPont?)then
			if(@element.estVertical?)
				enleverPontSens("haut")
				enleverPontSens("bas")
			else
				enleverPontSens("droite")
				enleverPontSens("gauche")
			end
		end
	end


	def enleverPontSens(unSens)
		if(@element.estPont?)then
			@element.enlevePont
			case(unSens)
				when "haut" 
					voisineHaut.enleverPontSens("haut")
				when "bas"
					voisineBas.enleverPontSens("bas")
				when "droite"
					voisineDroite.enleverPontSens("droite")
				when "gauche"
					voisineGauche.enleverPontSens("gauche")
				else
					puts "erreur de comprehension"
			end
		elsif(@element.estIle?)then
			@element.enlevePont
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
