clear all;
parameters.Sigma0 = 1;
parameters.Sigma1 = 2;
parameters.Fc = 3;
parameters.Fs = 4;
parameters.Fv = 5;
parameters.DotPhi_s = 6;
parameters.Alpha = 7;

states.DotPhi = 9;
states.z = 8;

a = LuGreModel(states, parameters);

CalDotz = a.Dotz
Calg = a.g
Calh = a.h
CalFrictionForce = a.LuGreFrictionForce

