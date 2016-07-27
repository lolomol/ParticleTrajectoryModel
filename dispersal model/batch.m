clear;

for initYear = 2008:2008;

    for currentYear = initYear:2014

        loadSettings;
        p = loadParticles( settings );
        main(p,settings)

    end
end