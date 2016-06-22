clear;

for initYear = 2010:-1:2000;

    for currentYear = initYear:-1:initYear-1%2014

        loadSettings;
        p = loadParticles( settings );
        main(p,settings)

    end
end