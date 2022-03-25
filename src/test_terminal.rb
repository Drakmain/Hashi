load "ContreLaMontre.rb"

mode = ContreLaMontre.creer(Plateau.creer(1), "theo", "difficile", "6")
mode.initialiserJeu()

fin = false

print "**************************************************\n"
print "\nWelcome to Hashi's game !!!\n\n"
print "**************************************************\n\n\n"

print "debut de la partie : \n\n"

while(!fin)
    mode.afficherPlateau
    puts "Voulez-vous vérifiez(0) le plateau(1) ?"
    verif = gets
    verif = verif.to_i
    puts verif.class
    if(verif == 0)then
        mode.corrigerErreur
    end

    print "\nJouer un coup \n"
    print "\nx : "
    x = gets
    print "\ny :"
    y = gets

    y = y.to_i
    x = x.to_i

    if(mode.verifCoord(x,y))then
        fin = mode.jouerCoup(x, y, "droit")
        print "\n"
    else
        puts "mauvaise coordonnées"
    end
end

puts "Felicitation !!!!"

mode.afficherPlateau

puts "\n\n****************************************\nfin du jeu\n*******************************************\n\n"