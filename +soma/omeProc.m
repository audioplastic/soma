classdef omeProc < soma.sigProc
    %OMEPROC Outer middle ear processing
    %   Very simplified version of oute rmiddle ear transfer function. Just
    %   a butterworth filter.

    properties (SetObservable, AbortSet)
        %OUT/MID EAR PROPERTIES
        ome_fLoCut  = 450;  %lf cutoff (default = 450 Hz)
        ome_fHiCut  = 8000; %hf cutoff (default = 8000 Hz)
        ome_fOrd    = 2;    %filter order (default = 2nd)
    end

    %************************************************************
    % Dependents - never set by user, only calculated when needed
    %************************************************************
    properties (Dependent = true)
        ome %Signal post ome processing
    end

    methods
        %% **********************************************************
        % Constructor
        %************************************************************
        function obj = omeProc(varargin)
            obj = obj@soma.sigProc(varargin{:});
        end
        
        %% **********************************************************
        % Outer/mid ear processing -> get method
        %************************************************************
        function value = get.ome(obj)
            if obj.ome_fOrd
                [midEar_b,midEar_a] = butter(obj.ome_fOrd,...
                    [obj.ome_fLoCut obj.ome_fHiCut]*2*(1/obj.sr)); %Middle ear transfer coefficients            
                value = filter(midEar_b,midEar_a,obj.sig);
            else
                value = obj.sig;
            end
        end

        %% **********************************************************
        % Set methods - dull error catching code
        %************************************************************
        function obj = set.ome_fHiCut(obj,value)
            assert (value < obj.sr/2 && value > 0,...
                'fMax must be +ve and below Nyquist limit ( < sr/2 )')
            obj.ome_fHiCut = value;
        end
        function obj = set.ome_fLoCut(obj,value)
            assert (value <= obj.ome_fHiCut && value > 0,...
                'fMin must be +ve and below fMax')
            obj.ome_fLoCut = value;
        end
        function obj = set.ome_fOrd(obj,value)
            assert (value >= 0 && ~mod(value,1),...
                'fOrd must be a positive integer')
            obj.ome_fOrd = value;
        end
    end
end
