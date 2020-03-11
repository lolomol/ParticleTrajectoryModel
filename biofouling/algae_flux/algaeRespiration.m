function dAdt = algaeRespiration(p)
%ALGAERESPIRATION calculates rate of algae death due to bacterial respiration for each particle. Kooi 2017, eq. 11, first term
% p: particle structure
% return: change in concentration of algae on particle surface due to bacterial respiration (# algal cells m^-2 s^-1)
    Q_10 = BiofoulingConstants.Q_10;
    R_A = BiofoulingConstants.Resp_A;
    dAdt = - R_A * Q_10.^((p.T-20)/10) .* p.A;
end

