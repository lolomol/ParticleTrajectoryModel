clear;

for initYear = 2015:2015

    for currentYear = initYear:2015

        loadSettings;
        p = loadParticles( settings );
        % initialize stuff for biofouling, here temporarily
        p.rho_pl = 920*ones(1, p.np);
        p.r_pl = .0001*ones(1, p.np);
        p.r_tot = p.r_pl;
        p.rho_tot = p.rho_pl;
        p.A = 1*ones(1, p.np);
        p.dzdt = zeros(1, p.np);
        
        % load ALL the forcing data mhm
        disp('starting forcing data load');
        settings = loadForcingData(p, settings, datetime([settings.initDate, settings.finalDate], 'convertfrom','datenum'));
        disp('loaded!');
        
        main(p,settings)

    end
end