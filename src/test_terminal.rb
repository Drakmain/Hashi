load "ContreLaMontre.rb"

mode = ContreLaMontre.creer(Plateau.creer(1), "theo", "difficile", "6")
mode.initialiserJeu()

fin = false

print "**************************************************\n"
print "\nWelcome to Hashi's game !!!\n\n"
print "**************************************************\n\n\n"

print "debut de la partie : \n\n"

#Thread.start(){mode.lancerChrono}

while(!fin)
    mode.afficherPlateau
    puts "Voulez-vous vérifiez le plateau ? (1/0)"
    verif = gets
    verif = verif.to_i
    if(verif == 1)then
        mode.corrigerErreur
    end

    puts "Voulez-vous undo le coup ? (1/0)"
    undo = gets
    undo = undo.to_i
    while(undo == 1)
        mode.undo
        puts "Voulez-vous undo le coup ? (1/0)"
        undo = gets
        undo = undo.to_i
    end

    puts "Voulez-vous redo le coup ? (1/0)"
    undo = gets
    undo = undo.to_i
    while(undo == 1)
        mode.redo
        puts "Voulez-vous redo le coup ? (1/0)"
        undo = gets
        undo = undo.to_i
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
