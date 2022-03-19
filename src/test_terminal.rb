load "Genie.rb"

mode = Genie.creer(nil, Plateau.creer(1), "1", "theo")
mode.initialiserJeu("../map/facile/demarrage/1.txt")

fin = false

while(!fin)
    mode.afficherPlateau
    print "Jouer un coup \n"
    print "\nx : "
    x = gets
    print "\ny :"
    y = gets

    y = y.to_i
    x = x.to_i

    if(mode.verifCoord(x,y))then
        fin = mode.jouerCoup(x, y, "droit")
        puts fin
    else
        puts "mauvaise coordonnées"
    end
end