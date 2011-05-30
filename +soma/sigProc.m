classdef sigProc < handle
    %SIGPROC Simple signal class
    %   Superclass for everything. Includes a few simple properties such as
    %   duration calculation etc.

    properties (SetObservable, AbortSet)
        sr           = 25e3
        sig          = repmat([1; zeros(499,1)],5,1)
    end
    %************************************************************
    % Dependents - never set by user, only calculated when needed
    %************************************************************
    properties (Dependent = true)
        tAxis
        nSamp
        dur
    end

    methods
        %% **********************************************************
        % Constructor - can pass audio signal on instantiation
        %************************************************************
        function obj = sigProc(ip,sr)
            if nargin > 0
                obj.sig = ip;
            end
            if nargin > 1
                obj.sr = sr;
            end
        end

        %% **********************************************************
        % Overloaded functions
        %************************************************************
        function soundsc(obj)
            soundsc(obj.sig,obj.sr);
        end
        function sound(obj)
            sound(obj.sig,obj.sr);
        end
        
        %% **********************************************************
        % Utility get methods
        %************************************************************
        function value = get.nSamp(obj)
            value = length(obj.sig);
        end
        function value = get.dur(obj)
            value = obj.nSamp/obj.sr;
        end
        function value = get.tAxis(obj)
            value = 1/obj.sr:1/obj.sr:obj.dur;
        end
       
        %% ***********************************************************
        % Set methods - dull error catching code
        %************************************************************
        function obj = set.sr(obj,value)
            assert (value > 0,...
                'Sampling rate must be positive')
            obj.sr = value;
        end
        function obj = set.sig(obj,value)
            assert (size(value,2) < 2 ,...
                'Audio signal must be input as a mono column-vector (use a second soma object for stereo)')
            obj.sig = value;
        end
               
    end
    %************************************************************
    % Static method Easter Egg
    %************************************************************
    methods (Static)
        function Splash
            if ismac
                disp('This is going to be ugly!');
            end
            splTmp =[   '                __    __               \n' ...
                ' _ __  _ __ ___/ / /\\ \\ \\__ _ _ __ ___ ™\n' ...
                '| ''_ \\| ''__/ __\\ \\/  \\/ / _` | ''__/ _ \\ \n' ...
                '| | | | | | (__ \\  /\\  / (_| | | |  __/\n' ...
                '|_| |_•_|• \\___| \\/  \\/ \\__,_|_|  \\___| © Nick Clark 2009\n\n\n'   ];
            fprintf(1,splTmp);
        end%Splash
    end%static methods
end
