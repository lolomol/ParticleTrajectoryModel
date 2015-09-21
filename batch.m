clear;

initYear = 2011;

for currentYear = 2011:2014
    
    loadSettings;
    p = loadParticles( settings );
    main(p,settings)

end