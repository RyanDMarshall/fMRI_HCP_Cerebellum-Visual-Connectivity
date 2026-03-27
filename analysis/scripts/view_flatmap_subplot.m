%% Documentation: RDM 10-22-2020
% view_flatmap_subplot takes as its principal argument a path to a filename, a
% gifti object, or a 28935xN cdata matrix to be viewed on the flatmap
% surface. %%FIXME - Want to generalize to viewing/patching cells arrays of data
% 
% As it's secondary & third arguments, you can use ('save','outfn') to save
% an image as either a TIFF (if 28935x1) or a gif (if 28935xN, e.g. timeseries)
%
% view_flatmap_subplot takes as its fourth argument a directory to output files to
% If v

% Example calls:
% view_flatmap('file.SUIT.func.gii')
% view_flatmap(gii_object)
% view_flatmap(gii_cdata) 
% view_flatmap('file.SUIT.timeseries.func.gii','save','file.SUIT.gif')
function [] = view_flatmap_subplot(varargin)
    clear f2
    flatmap=gifti('/projectnb/somerslab/apps/suit/flatmap/FLAT.surf.gii');

    % Handle provided arguments
    data = varargin{1}; cdata = [];
    issave = length(varargin) > 1 && strcmp(varargin{2}, 'save');
    if issave
        outfn = varargin{3};
        title(outfn);
    end
    if length(varargin) > 3
        out_dir = varargin{4};
        outfn = sprintf('%s/%s',out_dir,outfn);
    end
    issubplot = length(varargin) > 4 && strcmp(varargin{5},'subplot');
    if issubplot; subplot_dims = varargin{6}; end

    % Load in cdata and concatenate column-wise
    for i = 1:length(data)
        datum = data{i};
        istimeseries = 0;

        if ischar(datum)              % If first arg is filename
            fn = data;
            gii = gifti(fn);
            cdatum = gii.cdata;
        elseif isfield(data,'cdata') % If first arg is loaded gifti
            gii = datum; 
            cdatum = gii.cdata;
        elseif ismatrix(data)        % If first arg is cdata matrix
            cdatum = datum;
            istimeseries = ~isvector(cdatum);
        end

        if istimeseries
            cdata = cat(3, cdatum, cdata);
        else
            cdata = cat(2, cdatum, cdata);
        end
    end

    
    f2 = flatmap;
    v = f2.vertices;
    f = f2.faces;
    f2.vertices = [];
    f2.faces = [];

    % Find corners of bounding box - bottom left = A, bottom right = B,
    % ...
    A = [min(v(:,1)), min(v(:,2))];
    B = [max(v(:,1)), min(v(:,2))]; 
    C = [min(v(:,1)), max(v(:,2))];
    D = [max(v(:,1)), max(v(:,2))]; 

    BB = [[A - A; B - A]; [C - A; D - A]];
    BB(BB ~= 0) = BB(BB ~= 0) + 5; % Add small margins so figures don't overlap

    for i = 1:subplot_dims(1)
        for j = 1:subplot_dims(2)
            % Re-zero and calculate new subplot 0 point
            A = BB(1,:); B = BB(2,:); C = BB(3,:); D = BB(4,:);
        
            A(1) = A(1) + (i-1)*(B(1) - A(1)); 
            A(2) = A(2) + (j-1)*(C(2) - A(2));
            f2.vertices = [f2.vertices; v(:,1) + A(1), v(:,2) + A(2), v(:,3)];

            % uniquely re-identify new faces
            maxfaceidx = max(max(f2.faces)); 
            if isempty(maxfaceidx); maxfaceidx = 0; end
            f2.faces = [f2.faces; f + maxfaceidx];
        end
    end
    save('suit_restingstate.mat')

    if istimeseries
        datum = squeeze(cdata(:,1,:)); datum = datum(:);

        p = patch('Vertices', f2.vertices, 'Faces', f2.faces, ...
            'FaceVertexCData', normalize(datum), 'FaceLighting', 'flat');

        material([.3 .8 .3 5 1])
        material dull
        shading interp
        %camlight('headlight','infinite');
        colorbar;
        caxis([-3 3]);

        for i=1:size(cdata,2)
            datum = squeeze(cdata(:,i,:)); datum = datum(:);

            set(p,'FaceVertexCData',normalize(datum))
            drawnow;

            frame = getframe(gcf);
            img =  frame2im(frame);
            [img,cmap] = rgb2ind(img,256);
            if ~contains(outfn,'.gif'); outfn = [outfn '.gif']; end
            if issave; imwrite(img,cmap,outfn,'gif','WriteMode','append','DelayTime',0.2); end

        end
    else
        p = patch('Vertices', f2.vertices, 'Faces', f2.faces, ...
            'FaceVertexCData', normalize(cdata(:)), 'FaceLighting', 'flat');

        material([.3 .8 .3 5 1])
        material dull
        shading interp
        %camlight('headlight','infinite');
        colorbar;
        caxis([-3 3]);

        frame = getframe(gcf);
        img =  frame2im(frame);
        [img,cmap] = rgb2ind(img,256);
        if ~contains(outfn,'.tif'); outfn = [outfn '.tif']; end
        if issave; imwrite(img,cmap,outfn); end
    end

    material([.3 .8 .3 5 1])
    material dull
    shading interp
    %camlight('headlight','infinite');
    colorbar;
    caxis([-3 3]);

    frame = getframe(gcf);
    img =  frame2im(frame);
    [img,cmap] = rgb2ind(img,256);
    %if issave; imwrite(img,cmap,outfn); end

end