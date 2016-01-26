clear;

for initYear = 2010:2014;

    for currentYear = initYear:2014

        loadSettings;
        p = loadParticles( settings );
        main(p,settings)

    end
end