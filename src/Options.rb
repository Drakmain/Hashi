class Options
	require 'json'
    	## 
	#
	# @userName = Nom de l'utilisateur courant
	# @theme = reference du pont sur la quelle le click est fait
	# @resolutionRatio = ratio par le quelle on multiplie le format de l'ecran. Exemple 16/9 * 120 = 1920*1080. 100 donne 1600*900, 80 donne 1280*720

	##
	# Methode qui charge les donnees de 
	def initialize()
		fichierOptions = File.read('../data/settings/settings.json')
		hashOptions=JSON.parse(file)
	end

	def enregistrer()
		fichierOptions.write('../data/settings/settings.json',JSON.dump(hashOptions)
	# update le nom d'utilisateur
	def updateUser(user)
		hashOptions["username"]=user
	# update le ratio par le quelle on multiplie le format de l'ecran. Exemple 16/9 * 120 = 1920*1080. 100 donne 1600*900, 80 donne 1280*720
	def updateResolutionratio(ratio)
		hashOptions["resolutionratio"]=ratio
	# update le theme, normalement claire ou sombre
	def updateTheme(theme)
		hashOptions["theme"]=theme
	# update la langue, normalement fr,es ou en
	def updateLangue(langue)
		hashOptions["langue"]=langue
end
