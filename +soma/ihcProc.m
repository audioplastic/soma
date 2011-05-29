classdef ihcProc < soma.gtfProc
    %IHCPROC Inner haircell transduction
    %   Nothing flashy. Just half wave rectification, compression (log by
    %   default) and phase locking limitation implemented as an exponential
    %   decay moving average window (like an RC filter).

    properties
        %INNER HAIR CELL TRANSDUCTION PROPERTIES
        ihc_cmpType = 'log';%compression type ('none','log','sqrt') (AIM default = 'log')
        ihc_fCut    = 1200; %phase locking cutoff frequency (AIM default = 1.2 kHz)
        ihc_fOrd    = 2;    %phase locking filter order (AIM default = 2nd)
        
        darkTheme = true;
    end

    %************************************************************
    % Dependents - never set by user, only calculated when needed
    %************************************************************
    properties (Dependent = true)
        ihc %Signal post ihc processing
        ihc_RMSc %Channel-wise RMS
        ihc_RMSt %Sample-wise RMS
    end

    methods
        %% **********************************************************
        % Constructor
        %************************************************************
        function obj = ihcProc(varargin)
            obj = obj@soma.gtfProc(varargin{:});
        end

        %% **********************************************************
        % IHC transduction processing -> get method
        %************************************************************
        function value = get.ihc(obj)
            value = max(obj.bmm,0); %perform half-wave rectification
            switch lower(obj.ihc_cmpType) %this stage is compression
                case 'sqrt'
                    value = sqrt(value);
                case 'log'
                    % Scale up the signal so that values <1 become negligible This just
                    % rescales the sample values to fill the range of a 16-bit signed
                    % integer, then we lose the bottom bit of resolution. If the signal
                    % was sampled at 16-bit resolution, there shouldn't be anything to
                    % speak of there anyway. If it was sampled using a higher
                    % resolution, then some data will be discarded.
                    value = value*(2^15);

                    %avoid log problems by making everything > 1
                    value(value<1)=1;
                    value=log10(value);
            end

            %this stage is phase locking limitation
            %IMPORTANT: This is not a standard IIR filter because we do not
            %want any -ve op signal vals which would result from a standard
            %Butterworth or Cheby etc. Instead, this is a simple moving
            %average type filter.
            if obj.ihc_fOrd
                lockingTC  = 1/(2*pi*obj.ihc_fCut);
                lockingWin = exp( -(1:round(3*lockingTC*obj.sr))/round(lockingTC*obj.sr) ); % value @ 3*TC is negligible compared to sum
                lockingWin = lockingWin./sum(lockingWin);
                for n = 1:obj.ihc_fOrd
                    value = filter(lockingWin,1,value);
                end
            end
        end
        
        %% **********************************************************
        % RMSc - Channel-wise RMS -> get method
        %************************************************************
        function value = get.ihc_RMSc(obj)
            value = sqrt(mean( obj.ihc .^2 ,1));
        end
        
        %% **********************************************************
        % RMSt - Sample-wise RMS -> get method
        %************************************************************
        function value = get.ihc_RMSt(obj)
            value = sqrt(mean( obj.ihc .^2 ,2));
        end

        %% **********************************************************
        % Visualisation methods
        %************************************************************
        function see(obj)
            clf
            set(gcf, 'Units','normalized',...
                'Position',[.25 .2 .5 .6],...
                'NumberTitle', 'off',...
                'Name', 'SOMA: IHC output',...
                'ToolBar', 'none');                        
            
            ml = .1; %main lft
            mb = .3; %main btm 
            mw = .6; %main width
            mh = 1-mb-ml; %main height
            hspc = .07; %hrz spacing                        
            
            %*** 2D subplot ***
            hax2D = axes('Position',[ml mb mw mh]);
            pcolor(obj.tAxis*1e3, 1:obj.bmm_nChans, obj.ihc');
            shading interp; colormap bone
            ylabel('chan #');
            hTit2D = title(['Spiking prob: Compression = ',obj.ihc_cmpType], 'FontSize', 15);            
            set(gca,'XTick', [], 'XTickLabel', [])
            
            %*** RMSc ***
            haxC = axes('Position',[ml+mw+hspc mb 1-mw-hspc-1.5*ml mh]);
            hlC = barh(1:obj.bmm_nChans, obj.ihc_RMSc, 'BarWidth',1);
            ylim([1 obj.bmm_nChans])
            hTitC = title('RMS');            
            ylabel('chan #');
            grid on
            
            %*** RMSt ***
            haxT = axes('Position',[ml ml mw 1-mh-2.3*ml]);            
            hlT = plot(obj.tAxis*1e3, obj.ihc_RMSt, 'k');  
            xlim([obj.tAxis(1) obj.tAxis(end)]*1e3)
            xlabel('time [ms]');
            ylabel('RMS');
            grid on
            
            %*** TEXT LOGO ***
            %A little tribute to office space . . .
            flare = sprintf(...
                ['/ _\\ ___  _ __ ___   __ _ \n' ...
                '\\ \\ / _ \\| ''_ ` _ \\ / _` |\n' ...
                '_\\ \\ (_) | | | | | | (_| |\n' ...
                '\\__/\\___/|_| |_| |_|\\__,_|'] );            
            axes('Position',[ml+mw+hspc ml 1-mw-hspc-1.5*ml 1-mh-2.5*ml]) 
            axis off
            hFl = text('Units','normalized',...
                'Interpreter','none',...
                'Position',[.5 .5],...
                'HorizontalAlignment', 'center',...
                'FontName', 'FixedWidth',...
                'FontUnits', 'normalized',...
                'FontWeight', 'bold',...
                'FontSize', 0.13,...
                'String', flare);
            
            %Invert colours
            if obj.darkTheme
                set(gcf,'Color', [0 0 0]);
                
                set(haxT, 'XColor', [1 1 1], 'YColor', [1 1 1], 'ZColor', [1 1 1], 'Color', [0 0 0])
                set(hlT, 'Color', [0 1 1])
                
                set(haxC, 'XColor', [1 1 1], 'YColor', [1 1 1], 'ZColor', [1 1 1], 'Color', [0 0 0])
                set(hlC, 'EdgeColor', [0 1 1])
                
                set(hax2D,'XColor', [1 1 1], 'YColor', [1 1 1], 'ZColor', [1 1 1], 'Color', [0 0 0])
                set(hTit2D, 'Color', [1 1 1])
                set(hTitC, 'Color', [1 1 1])
                set(hFl, 'Color', [1 1 1])
                
            end
        end

        %% **********************************************************
        % Set methods - dull error catching code
        %************************************************************
        function obj = set.ihc_cmpType(obj,value)
            assert (strcmpi(value,'none') || strcmpi(value,'sqrt') || strcmpi(value,'log'),...
                'Compression type must be sqrt, log, or none')
            obj.ihc_cmpType = value;
        end
        function obj = set.ihc_fCut(obj,value)
            assert (value < obj.sr/2 && value > 0,...
                'fMax must be +ve and [well] below Nyquist limit ( < sr/2 )')
            obj.ihc_fCut = value;
        end
        function obj = set.ihc_fOrd(obj,value)
            assert (value >= 0 && ~mod(value,1),...
                'fOrd must be a non-negative integer (0 = off)')
            obj.ihc_fOrd = value;
        end
    end
end
