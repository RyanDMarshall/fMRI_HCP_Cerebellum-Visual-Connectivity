function [] = save_flatmap_ts(varargin)

    if ischar(varargin{1})
        fn = varargin{1};
        gii = gifti(varargin);
    else
        gii = varargin;
    end

    flatmap=gifti('/projectnb/somerslab/apps/suit/flatmap/FLAT.surf.gii');
    cdata = gii.cdata;
    
    cdata(cdata==0) = NaN;
    
    h=figure();
    axis off
    colorbar
    p = patch('Vertices', flatmap.vertices, 'Faces', flatmap.faces, ...
    'FaceVertexCData', double(cdata(:,1)),'FaceLighting','flat');
    material([.3 .8 .3 5 1])
    material dull
    shading interp
    %camlight('headlight','infinite');

    ts_len = length(cdata(1,:));
    for i = 1:ts_len
        norm_cdata = double((cdata(:,i) - mean(cdata(:,i))) / std(cdata(:,i)));
        set(p, 'FaceVertexCData', norm_cdata)
        %drawnow;

        frame = getframe(1);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        if i == 1
          imwrite(imind,cm,gif_fn,'gif','Loopcount',inf);
        else
          imwrite(imind,cm,gif_fn,'gif','WriteMode','append');
        end
    end
end