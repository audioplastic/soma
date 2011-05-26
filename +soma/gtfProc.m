classdef gtfProc < soma.omeProc
    %GTFPROC Gammatone filtering
    %   Performs simple Gammaton filtering on signal. Nothing dynamic or
    %   special, but time-tested and true ;)
    
    properties(SetAccess = 'public')
        %BASILAR MEMBRANE MOTION PROPERTIES
        bmm_fMin    = 200;  %minimum filter centre frequency (Hz)
        bmm_fMax    = 6000; %maximum filter centre frequency (Hz)
        bmm_nChans  = 30;   %total number of channels
    end
    
    properties (SetAccess = 'private', Hidden = true)
        f2erbn %these ananymous functions are defined in the constructor due to 2008a bug
        erbn2f
        f2erbnNum
        erbnNum2f
    end
    
    %************************************************************
    % Dependents - never set by user, only calculated when needed
    %************************************************************
    properties (Dependent = true)
        cf  %Centre frequencies of cochlear filtering
        bmm %Signal post bmm processin
        bmm_RMSc %Channel-wise RMS
        bmm_RMSt %Sample-wise RMS
    end
    
    methods
        %% **********************************************************
        % Constructor
        %************************************************************
        function obj = gtfProc(varargin)
            obj = obj@soma.omeProc(varargin{:});
            
            %These have to be defined in the constructor due to some wacky
            %bug which prevents you clearing classes if they are defined in
            %the properties block ... which sucks a little, but works ok see:
            %http://www.mathworks.de/matlabcentral/newsreader/view_thread/166498
            obj.f2erbn =    @(f)24.7*(4.37*(f*1e-3)+1);
            obj.erbn2f =    @(erbn)1e3*(((erbn/24.7)-1)/4.37);
            obj.f2erbnNum = @(f)21.4*log10(4.37*(f*1e-3)+1);
            obj.erbnNum2f = @(erbnNum)(10.^(erbnNum/21.4)-1)/4.37e-3;
        end
        
        %% **********************************************************
        % Cochlear filtering -> get method
        %************************************************************
        function [value, obj] = get.bmm(obj)
            b = obj.f2erbn(obj.cf)*1.019; %Bandwidth with correction scalar
            T = 1/obj.sr;            
            
            bRad = b*2*pi;
            
            %Generate IIR coefficients
            %For full documentation on this see Slaney's Apple technical
            %report
            gain = abs((-2*exp(4*i*obj.cf*pi*T)*T + ...
                2*exp(-(bRad*T) + 2*i*obj.cf*pi*T).* ...
                T.*(cos(2*obj.cf*pi*T) - ...
                sqrt(3 - 2^(3/2))*sin(2*obj.cf*pi*T))) .*...
                (-2*exp(4*i*obj.cf*pi*T)*T +2*exp(-(bRad*T) +...
                2*i*obj.cf*pi*T).*T.*(cos(2*obj.cf*pi*T) +...
                sqrt(3 - 2^(3/2)) *sin(2*obj.cf*pi*T))).*...
                (-2*exp(4*i*obj.cf*pi*T)*T +2*exp(-(bRad*T) +...
                2*i*obj.cf*pi*T).*T.*(cos(2*obj.cf*pi*T) -...
                sqrt(3 + 2^(3/2))*sin(2*obj.cf*pi*T))) .*...
                (-2*exp(4*i*obj.cf*pi*T)*T+2*exp(-(bRad*T) +...
                2*i*obj.cf*pi*T).*T.*(cos(2*obj.cf*pi*T) +...
                sqrt(3 + 2^(3/2))*sin(2*obj.cf*pi*T))) ./...
                (-2 ./ exp(2*bRad*T) - 2*exp(4*i*obj.cf*pi*T) +...
                2*(1 + exp(4*i*obj.cf*pi*T))./exp(bRad*T)).^4);
            feedback=zeros(length(obj.cf),9);
            forward=zeros(length(obj.cf),5);
            forward(:,1) = T^4 ./ gain;
            forward(:,2) = -4*T^4*cos(2*obj.cf*pi*T)./exp(bRad*T)./gain;
            forward(:,3) = 6*T^4*cos(4*obj.cf*pi*T)./exp(2*bRad*T)./gain;
            forward(:,4) = -4*T^4*cos(6*obj.cf*pi*T)./exp(3*bRad*T)./gain;
            forward(:,5) = T^4*cos(8*obj.cf*pi*T)./exp(4*bRad*T)./gain;
            feedback(:,1) = ones(length(obj.cf),1);
            feedback(:,2) = -8*cos(2*obj.cf*pi*T)./exp(bRad*T);
            feedback(:,3) = 4*(4 + 3*cos(4*obj.cf*pi*T))./exp(2*bRad*T);
            feedback(:,4) = -8*(6*cos(2*obj.cf*pi*T) + cos(6*obj.cf*pi*T))./exp(3*bRad*T);
            feedback(:,5) = 2*(18 + 16*cos(4*obj.cf*pi*T) + cos(8*obj.cf*pi*T))./exp(4*bRad*T);
            feedback(:,6) = -8*(6*cos(2*obj.cf*pi*T) + cos(6*obj.cf*pi*T))./exp(5*bRad*T);
            feedback(:,7) = 4*(4 + 3*cos(4*obj.cf*pi*T))./exp(6*bRad*T);
            feedback(:,8) = -8*cos(2*obj.cf*pi*T)./exp(7*bRad*T);
            feedback(:,9) = exp(-8*bRad*T);
            
            %Do the actual filtering
            value = zeros(numel(obj.ome),numel(obj.cf));
            for kk=1:numel(obj.cf)
                value(:,kk)=filter(forward(kk,:),feedback(kk,:),obj.ome);
            end
            
        end
        
        %% **********************************************************
        % cf calculation -> get method
        %************************************************************
        function value = get.cf(obj)
            value = obj.erbnNum2f(  linspace(obj.f2erbnNum(obj.bmm_fMin),obj.f2erbnNum(obj.bmm_fMax),obj.bmm_nChans)  );
        end
        
        %% **********************************************************
        % RMSc - Channel-wise RMS -> get method
        %************************************************************
        function value = get.bmm_RMSc(obj)
            value = sqrt(mean( obj.bmm .^2 ,1));
        end
        
        %% **********************************************************
        % RMSt - Sample-wise RMS -> get method
        %************************************************************
        function value = get.bmm_RMSt(obj)
            value = sqrt(mean( obj.bmm .^2 ,2));
        end
        
        %% **********************************************************
        % Set methods - dull error catching code
        %************************************************************
        function obj = set.bmm_fMax(obj,value)
            assert (value < obj.sr/2 && value > 0,...
                'fMax must be +ve and below Nyquist limit ( < sr/2 )')
            obj.bmm_fMax = value;
        end
        function obj = set.bmm_fMin(obj,value)
            assert (value <= obj.bmm_fMax && value > 0,...
                'fMin must be +ve and equal to, or below fMax')
            obj.bmm_fMin = value;
        end
        function obj = set.bmm_nChans(obj,value)
            assert (value > 0 && ~mod(value,1),...
                'Number of channels must be a positive integer')
            obj.bmm_nChans = value;
        end
        
    end
end
