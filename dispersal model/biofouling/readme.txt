The Biofouling model is adapted from Kooi 2017 
It contains two components.
1. algae growth/death calculation (contained in algae_flux/)
2. setting velocity calculation (contained in hydrodynamics/)

vertical_profiles/ contains functions which extrapolate vertical profiles from surface data

the remaining files do simple particle-oriented tasks, like updating the total density
    and radius of particles based on the attached algae, or loading forcing data onto
    the particle structure.

Sources:
Kooi 2017, biofouling model (https://doi.org/10.1021/acs.est.6b04702)
Uitz 2006, vertical profiles of chlorophyll (https://doi.org/10.1029/2005JC003207)
Sharqawy 2010, parameterizations of properties of seawater (DOI: 10.5004/dwt.2010.1079)
Calbet 2004, algae grazing mortality (https://doi.org/10.4319/lo.2004.49.1.0051)
    Calbet 2004 contains regionally varying mortality values which are NOT used currently