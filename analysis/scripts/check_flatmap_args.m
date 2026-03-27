function [issave, istimeseries, issubplot, isaspectratio, outfn, outdir, subplot_dims, aspectratio] = check_flatmap_args(varargin)
    % Set default values
    issave = 0; issubplot = 0; isaspectratio = 0;
    outfn = 'flatmap';
    outdir = 'flatmaps';
    subplot_dims = [1 1];
    aspectratio = [4 3];
    for i = 1:length(varargin)
        arg = varargin{i};
        if ischar(arg)
            switch varargin{i}
                case 'save'
                    issave = i; 
                    outfn = varargin{i+1};
                    outdir = varargin{i+2};
                case 'subplot'
                    issubplot = i;
                    subplot_dims = varargin{i+1};
                case 'aspectratio'
                    isaspectratio = i; 
                    aspectratio = varargin{i+1};
                otherwise continue;
            end
        end
    end
end
