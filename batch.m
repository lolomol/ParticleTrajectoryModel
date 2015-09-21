clear;

initYear = 2000;

for currentYear = 2000:2005
    
    loadSettings;
    p = loadParticles( settings );
    main(p,settings)

end