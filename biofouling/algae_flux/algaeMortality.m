function dAdt = algaeMortality(p)
%ALGAEMORTALITY calculates rate of algae death due to grazing for each particle. Kooi 2017, eq. 11, first term
% p: particle structure
% return: change in concentration of algae on particle surface due to grazing mortality (# algal cells m^-2 s^-1)

    %From Kooi 2017 eq. 11, term 3.  Kooi uses a single mortality coefficient from Calbet 2004.
    dAdt = - BiofoulingConstants.m_A * p.A;
end

