class Chrono

    @thr

    def initialize()  
		@tempsDebut = 0
        @chrono = 0

  	end 

    def lancerChrono()
        @thr = Thread.new {
            @tempsDebut = Time.now.to_i
            ancienne_valeur = @chrono
            while(true)
                @chrono = Time.now.to_i - @tempsDebut
                if(ancienne_valeur != @chrono)
                    ancienne_valeur = @chrono
                    puts(@chrono)
                end

            end
        }

        @thr.run

    end

    def lancerChronoInverse(unTemps)
        @thr = Thread.new {
            @tempsDebut = Time.now.to_i
            ancienne_valeur = unTemps
            while(true)
                @chrono = unTemps - (Time.now.to_i - @tempsDebut)
                if(ancienne_valeur != @chrono)
                    ancienne_valeur = @chrono
                    puts(@chrono+1)
                end

            end
        }

        @thr.run

        sleep(unTemps)

        stopperChrono

    end

    def stopperChrono()
        @thr.exit
    end

    attr_reader :chrono

end

testChro = Chrono.new

testChro.lancerChronoInverse(20)
