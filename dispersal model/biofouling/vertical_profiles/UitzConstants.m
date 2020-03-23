classdef UitzConstants
    %UITZCONSTANTS These constants are used to contruct vertical profiles of chlorophyll
    % concentration, as outlined in Uitz 2006 (https://doi.org/10.1029/2005JC003207)
    %   See note, I change one constant in s_stratified to address non-physical fit
    
    % EXPLANATION OF METHOD
    %   Stratified waters (euphotic depth (z_eu) > mixed layer depth (MLD))
    %       parameterization is a linear decrease with depth added to a gaussian,
    %       centered at the chlorophyll maximum.  9 sets of fitted coefficients
    %       correspond to 9 bins of surface chlorophyll concentration.
    %   Mixed waters (z_eu < MLD)
    %       parameterization is no decrease with depth until z_eu, then a
    %       linear decrease hitting zero at 3*z_eu.  5 estimates of z_eu
    %       correspond to 5 bins of surface chlorophyll concentration.
    
    properties (Constant)
        ave_Z_eu_stratified = [119.1, 99.9, 91.0, 80.2, 70.3, 63.4, 54.4, 39.8, 26.1];  % m
        ave_Z_eu_mixed = [77.1, 53.2, 44.0, 31.5, 16.9];  % m
        C_b_stratified = [0.4710    0.5330    0.4280    0.5700    0.6110    0.3900    0.5690    0.8350    0.1880];
        s_stratified = [0.1350    0.1720    0.1380    0.1730    0.2140    0.1090    0.1830    0.2980         0.05];  % important: the final parameter (.05) is inserted by me, upon visual inspection, provides better fit than the original (.00) in Uitz's original paper, which is non-physical, as it means chl concentration never decreases with depth
        C_max_stratified = [1.5720    1.1940    1.0150    0.7660    0.6760    0.7880    0.6080    0.3820    0.8850];
        zeta_max_stratified = [0.9690    0.9210    0.9050    0.8140    0.6630    0.5210    0.4520    0.5120    0.3780];
        delta_zeta_stratified = [0.3930    0.4350    0.6300    0.5860    0.5390    0.6810    0.7440    0.6250    1.0810];
    end
    
    methods (Static)
        function class = stratified_concentration_class(chl_surf)
            % chl_surf: surface concentration of chl_a (mg m^-3), vector length n
            % returns: concentration class as defined in Uitz 2006
            bounds = [0, .04, .08, .12, .2, .3, .4, .8, 2.2, inf];  % mg m^-3, bounds of each concentration class
                                            %i.e. class 1 is 0 < chl_surf < .04, etc.
            [~, loc] = max(bounds' > chl_surf, [], 1);
            class = loc-1;
        end
        function class = mixed_concentration_class(chl_surf)
            % chl_surf: surface concentration of chl_a (mg m^-3), vector length n
            % returns: concentration class as defined in Uitz 2006
            bounds = [0, .4, .8, 1, 4, inf];    %% mg m^-3, bounds of each concentration class
                                            %i.e. class 1 is 0 < chl_surf < .4, etc.
            [~, loc] = max(bounds' > chl_surf, [], 1);
            class = loc-1;
        end
    end
end
