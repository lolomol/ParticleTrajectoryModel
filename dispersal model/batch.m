clear;

for initYear = 2011;

    for currentYear = initYear:2014

        loadSettings;
        p = loadParticles( settings );
        main(p,settings)

    end
end