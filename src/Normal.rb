class Normal < contrelaMontre

    private_class_method :new

    def Normal.creer(unFichier)
        super(unFichier)
    end

    #************************************
    #           lancerChrono()
    #
    #permet de lancer le chronometre dans le sens normal (part de 0 et s'incrémente jusqu'à ce que la partie soit terminé)
    def lancerChrono()
        @chrono.lancerChrono
    end
    
end