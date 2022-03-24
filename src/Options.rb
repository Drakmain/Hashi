class Options
	require 'json'
	##
	#
	# @userName = Nom de l'utilisateur courant
	# @theme = reference du pont sur la quelle le click est fait
	# @resolutionRatio = ratio par le quelle on multiplie le format de l'ecran. Exemple 16/9 * 120 = 1920*1080. 100 donne 1600*900, 80 donne 1280*720
  
	attr_reader :user
	attr_reader :ratio
	attr_reader :theme
	attr_reader :langue
  
	##
	# Methode qui charge les donnees de
	def initialize
	  @fichierOptions = File.read('../data/settings/settings.json')
	  @hashOptions = JSON.parse(@fichierOptions)
	  @user = @hashOptions["username"]
	  @ratio = @hashOptions["resolutionratio"]
	  @theme = @hashOptions["theme"]
	  @langue = @hashOptions["langue"]
	end
  
	def enregistrer
	  fichier = File.open('../data/settings/settings.json', 'w')
	  fichier.write(JSON.dump(@hashOptions))
	end
  
	# update le nom d'utilisateur
	def updateUser(user)
	  @hashOptions["username"] = user
	  @user = user
	end
  
	# update le ratio par le quelle on multiplie le format de l'ecran. Exemple 16/9 * 120 = 1920*1080. 100 donne 1600*900, 80 donne 1280*720
	def updateResolutionratio(ratio)
	  @hashOptions["resolutionratio"] = ratio
	  @ratio = ratio
	end
  
	# update le theme, normalement claire ou sombre
	def updateTheme(theme)
	  @hashOptions["theme"] = theme
	  @theme = theme
	end
  
	# update la langue, normalement fr, es ou en
	def updateLangue(langue)
	  @hashOptions["langue"] = langue
	  @langue = langue
	end
  
	def to_s
	  puts("Username : #{@user} \nResolution : #{(9 * @ratio.to_i())}p \nLangue : #{@langue} \nTheme : #{@theme}\n")
	end
  end
  