clear;

for initYear = 2015:2015

    for currentYear = initYear:2015

        loadSettings;
        p = loadParticles( settings );
        settings.forcedDepth = 1000;
        main(p,settings)

    end
end