classdef nerveView < handle
    properties
        hFig
        lcopy
    end
    
    properties (Access=private)    
        hax2D
        haxC
        hTit2D
        hlC
        hTitC
        hlT
        haxT
        hFl
    end
    
    properties (SetObservable, AbortSet)
        darkTheme = true
    end
    
    methods
        function obj = nerveView(evtobj)
            % Pass the object generating the event to the constructor
            % Add the listeners from the constructor
            if nargin > 0
                assert(isa(evtobj, 'soma.ihcProc'))
                
                %This confusing looking bit of code adds an event listener
                %to every observable property of the evtobj. This is nice
                %as it gives the flexibility to change property names in
                %evtobj without breaking this code.
                metaDat = metaclass(evtobj);
                pList = {};
                for nn=1:numel(metaDat.Properties)
                    if metaDat.Properties{nn}.SetObservable
                        pList{numel(pList)+1}=metaDat.Properties{nn}.Name; %#ok<AGROW>
                    end
                end
                addlistener(evtobj,pList,'PostSet',@obj.actionOnEvent);
                addlistener(obj,'darkTheme','PostSet',@obj.actionOnEvent);
                obj.lcopy = evtobj;
            end
            obj.hFig = figure;
            set(obj.hFig, 'Units','normalized',...
                'Position',[.25 .2 .5 .6],...
                'NumberTitle', 'off',...
                'Name', 'SOMA: IHC output',...
                'ToolBar', 'none');
            obj.updateGfx
        end
        
        %This is the destructor although it doesn't really work (yet)
        %http://www.mathworks.com/matlabcentral/newsreader/view_thread/302865
        %Hopefully TMW will fix all of their OO bugs in coming releases
        function delete(obj)
            if ishghandle(obj.hFig)
                close(obj.hFig);
            end
        end%destructor
        
        function actionOnEvent(varargin)            
            obj = varargin{1};
            metaProp = varargin{2};
            disp([metaProp.Name ' change detected. Redrawing.'])
            
            switch metaProp.Name 
                case 'darkTheme'
                    obj.setColours
                otherwise                                                     
                    obj.updateGfx
            end
        end
        
        function updateGfx(obj)
            if ishghandle(obj.hFig)
                figure(obj.hFig)
                clf(obj.hFig)
                
                ml = .1; %main lft
                mb = .3; %main btm
                mw = .6; %main width
                mh = 1-mb-ml; %main height
                hspc = .07; %hrz spacing
                
                %*** 2D subplot ***
                obj.hax2D = axes('Position',[ml mb mw mh]);
                pcolor(obj.lcopy.tAxis*1e3, 1:obj.lcopy.bmm_nChans, obj.lcopy.ihc');
                shading interp; colormap bone
                ylabel('chan #');
                obj.hTit2D = title(['Spiking prob: Compression = ',obj.lcopy.ihc_cmpType], 'FontSize', 15);
                set(gca,'XTick', [], 'XTickLabel', [])
                
                %*** RMSc ***
                obj.haxC = axes('Position',[ml+mw+hspc mb 1-mw-hspc-1.5*ml mh]);
                obj.hlC = barh(1:obj.lcopy.bmm_nChans, obj.lcopy.ihc_RMSc, 'BarWidth',1);
                ylim([1 obj.lcopy.bmm_nChans])
                obj.hTitC = title('RMS');
                ylabel('chan #');
                grid on
                
                %*** RMSt ***
                obj.haxT = axes('Position',[ml ml mw 1-mh-2.3*ml]);
                obj.hlT = plot(obj.lcopy.tAxis*1e3, obj.lcopy.ihc_RMSt, 'k');
                xlim([obj.lcopy.tAxis(1) obj.lcopy.tAxis(end)]*1e3)
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
                obj.hFl = text('Units','normalized',...
                    'Interpreter','none',...
                    'Position',[.5 .5],...
                    'HorizontalAlignment', 'center',...
                    'FontName', 'FixedWidth',...
                    'FontUnits', 'normalized',...
                    'FontWeight', 'bold',...
                    'FontSize', 0.13,...
                    'String', flare);                         
                obj.setColours;                
            end
        end
        
        function setColours(obj)
            if obj.darkTheme
                set(obj.hFig,'Color', [0 0 0]);
                
                set(obj.haxT, 'XColor', [1 1 1], 'YColor', [1 1 1], 'ZColor', [1 1 1], 'Color', [0 0 0])
                set(obj.hlT, 'Color', [0 1 1])
                
                set(obj.haxC, 'XColor', [1 1 1], 'YColor', [1 1 1], 'ZColor', [1 1 1], 'Color', [0 0 0])
                set(obj.hlC, 'EdgeColor', [0 1 1])
                
                set(obj.hax2D,'XColor', [1 1 1], 'YColor', [1 1 1], 'ZColor', [1 1 1], 'Color', [0 0 0])
                set(obj.hTit2D, 'Color', [1 1 1])
                set(obj.hTitC, 'Color', [1 1 1])
                set(obj.hFl, 'Color', [1 1 1])
            else
                set(obj.hFig,'Color', [0.8 0.8 0.8]);
                
                set(obj.haxT, 'XColor', [0 0 0], 'YColor', [0 0 0], 'ZColor', [0 0 0], 'Color', [1 1 1])
                set(obj.hlT, 'Color', [0 0 0])
                
                set(obj.haxC, 'XColor', [0 0 0], 'YColor', [0 0 0], 'ZColor', [0 0 0], 'Color', [1 1 1])
                set(obj.hlC, 'EdgeColor', [0 0 0])
                
                set(obj.hax2D,'XColor', [0 0 0], 'YColor', [0 0 0], 'ZColor', [0 0 0], 'Color', [1 1 1])
                set(obj.hTit2D, 'Color', [0 0 0])
                set(obj.hTitC, 'Color', [0 0 0])
                set(obj.hFl, 'Color', [0 0 0])
            end
        end
        
        
        
    end %end of methods
    
    
    methods (Static)
        
    end
end