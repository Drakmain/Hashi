load "Genie.rb"

mode = Genie.creer(nil, Plateau.creer(1), "1", "theo")
mode.initialiserJeu("../map/difficile/demarrage/4.txt")

while(true)
    mode.afficherPlateau
    print "Jouer un coup \n"
    print "\nx : "
    x = gets
    print "\ny :"
    y = gets

    y = y.to_i
    x = x.to_i

    if(mode.verifCoord(x,y))then
        mode.jouerCoup(x, y, "droit")
    else
        puts "mauvaise coordonnées"
    end
end