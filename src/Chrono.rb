class Chrono

    def initialize()  
		@tempsDebut = 0
        @chrono = 0
  	end 

    def lancerChrono()
        thr = Thread.new {
            @tempsDebut = Time.now.to_i
            ancienne_valeur = @chrono
            while(@chrono < 10)
                @chrono = Time.now.to_i - @tempsDebut
                if(ancienne_valeur != @chrono)
                    ancienne_valeur = @chrono
                    puts(@chrono)
                end

            end
        }

        thr.join

    end

    attr_reader :chrono

end

testChro = TestChrono.new

testChro.lancerChrono