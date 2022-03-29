load "ContreLaMontre.rb"
load "Normal.rb"
load "Genie.rb"

mode = Normal.creer(Plateau.creer(), "4", "theo", "tuto")
mode.initialiserJeu()

fin = false

print "**************************************************\n"
print "\nWelcome to Hashi's game !!!\n\n"
print "**************************************************\n\n\n"

print "debut de la partie : \n\n"

#Thread.start(){mode.lancerChrono}

hyp = 0

while(!fin)
    mode.afficherPlateau

    puts "Voulez-vous vérifiez le plateau ? (1/0)"
    verif = gets
    verif = verif.to_i
    if(verif == 1)then
        mode.corrigerErreur
	end
 
=begin
    if(i==1)then
        puts "Voulez-vous désactiver le mode hypothèse (0/1)?"
        verif = gets
        verif = verif.to_i
        if(verif == 0)then
            mode.desactiverHypothese
            i=0
        end

    end

    if(hyp == 0)
        puts "Voulez-vous mettre le mode hypothese ? (1/0)"
        hyp = gets
        hyp = hyp.to_i
        if(hyp == 1)then
            mode.activerHypothese
        end

    end      
=end    


    puts "Voulez-vous vérifiez(0) le plateau(1) ?"
    verif = gets
    verif = verif.to_i
    puts verif.class
    if(verif == 0)then
        mode.afficherErreurs
 

        hyp = 1
    else
        puts "Voulez-vous enlever le mode hypothese ? (1/0)"
        desHyp = gets
        desHyp = desHyp.to_i
        if(desHyp == 1)
            mode.desactiverHypothese
        end

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


