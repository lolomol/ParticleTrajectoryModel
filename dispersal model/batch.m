clear;

for initYear = 2015:2015

    for currentYear = initYear:2015

        loadSettings;
        p = loadParticles( settings );
        p.z = 1000*ones(1, p.np);
        main(p,settings)

    end
end