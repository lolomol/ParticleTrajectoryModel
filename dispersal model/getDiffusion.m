function [Dx,Dy]=getDiffusion (p, settings)

% getDiffusion
% -------------
%
% returns Dx,Dy vectors of random turbulent diffusion component

Rnx = rand(1,p.np)*2-1;
Rny = rand(1,p.np)*2-1;

Dx = Rnx .* sqrt( 6 *settings.EddyDiffusivity * settings.modelTimestep );
Dy = Rny .* sqrt( 6 *settings.EddyDiffusivity * settings.modelTimestep );



