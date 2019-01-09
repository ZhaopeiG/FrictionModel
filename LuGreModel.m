%% This is a class of the LuGre friction model
% This model is inspired by "Static Friction in a Robot Joint - Modeling and Identification of Load and Temperature Effects"
%% Example
% clear all;
% 
% parameters.Sigma0 = 1; % Initial the parameters' value
% parameters.Sigma1 = 2;
% parameters.Fc = 3;
% parameters.Fs = 4;
% parameters.Fv = 5;
% parameters.DotPhi_s = 6;
% parameters.Alpha = 7;
% 
% states.DotPhi = 9;  % Initial the states' value
% states.z = 8;
% 
% a = LuGreModel(states, parameters); %Initial the object
% 
% CalDotz = a.Dotz
% Calg = a.g
% Calh = a.h
% CalFrictionForce = a.LuGreFrictionForce % friction force of LuGre model

%%

classdef LuGreModel
    properties
        Sigma0    % parameters, stiffness parameter
        Sigma1    % parameters, damping parameter
        Fc        % parameters, Coulomb friction parameter
        Fs        % parameters, standstill friction parameter
        Fv        % parameters, viscous friction parameter
        DotPhi_s  % parameters, Stribeck velocity
        Alpha     % parameters, exponent of the Stribeck nonlinearity
                
        DotPhi    % states, velocity
        z         % states, internal state related to dynamic of friction or the bristle deform    
    end
    
    properties (Dependent)
        LuGreFrictionForce      % the calculated friction force
        Dotz                    % the derivation of z
        g                       % Equation of g, see the thesis mentioned above
        h                       % Equation of h, see the thesis mentioned above
    end
       
    methods
        function obj = LuGreModel(states, parameters) % constructor
            if nargin > 0
                obj.Sigma0 = parameters.Sigma0;     % Initial the parameters' value
                obj.Sigma1 = parameters.Sigma1;
                obj.Fc = parameters.Fc;
                obj.Fs = parameters.Fs;
                obj.Fv = parameters.Fv;
                obj.DotPhi_s = parameters.DotPhi_s;
                obj.Alpha = parameters.Alpha;
                
                obj.DotPhi = states.DotPhi;         % Initial the states' value
                obj.z = states.z;
            else
                error('Please input the correct value')
            end           
        end
        
        function Dotz = get.Dotz(obj)
            Dotz = obj.DotPhi - (obj.Sigma0)*abs(obj.DotPhi)*obj.z/(obj.g);
        end
        
        function LuGreFrictionForce = get.LuGreFrictionForce(obj)
           LuGreFrictionForce = obj.Sigma0 * obj.z + obj.Sigma1 * obj.Dotz + obj.h;
        end
        
        function g = get.g(obj)
           g = obj.Fc + obj.Fs * exp(-1 * (abs((obj.DotPhi)/(obj.DotPhi_s))^obj.Alpha)); 
        end
        
        function h = get.h(obj)
           h = obj.Fv * obj.DotPhi;
        end     
        
    end
    
end
