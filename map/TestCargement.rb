
#test de chargement des maps : lecture ligne par ligne

class TestCargement

	def fichierOuvrir(nom,mode)
		@fic = File.open(nom,mode)
		puts " fichier ouvert : #{nom}"
	end
	
	def lectureFichier1()
		
		@fic.each_line do |line| #lecture ligne à ligne
			print " "
			puts line #lecture de chaque mot d'une ligne
		end
		@fic.close
		
	end
	
	def lectureFichier2()
		
		@fic.each_line do |line| #lecture ligne à ligne

			#traitement de la ligne 
			line = line.split('')

			i=0 #compteur

			#if line.empty? == true #si la ligne est vide
				#puts
			#end

			line.length.times do #traitement de la ligne 
				
				case line[i]
						when "0"
							print " "
						#when " "
							#if i === 0 #si on est au debut de la ligne 
								#print " "
							#else
								#print ""
							#end
							
						when "-"
					 			i+=1
					 			#if i===1 #si on est au debut de la ligne 
					 			#	print " "
					 			#end				 	 	
								case line[i]
									when "1"
										print "|"
									when "2"
										print "||"
									when "3"
										print "-"
									when "4"
										print "="
								end#case
						else
							#print " "
							print "#{line[i]}"	
							#print " " 
				end#case
				i+=1	
			 
			 end#do
			 
			end#do

		@fic.close
		puts
	end#def
  
end#class           
    
#main(){   

	fichier1="medium/demarrage/2.txt"
	fichier2="medium/correction/2.txt"
	  
	chargement = TestCargement.new()

	puts " matrice vide de jeu "
	chargement.fichierOuvrir(fichier1,'r')
	chargement.lectureFichier1()

	puts " matrice intérmediaire "
	chargement.fichierOuvrir(fichier2,'r')
	chargement.lectureFichier1()

	chargement.fichierOuvrir(fichier2,'r')
	puts " matrice resultat "
	chargement.lectureFichier2()
#}





