% Save SUIT space RS time series
%% Load data - time consuming so prefer to only do it once!

function [inner_cdata, mid_cdata, outer_cdata] = analyze_RS_SUIT(data)

%% View timeseries at all depths


%% Functional connectivity Analysis
% First, let's examine how the activation of same pixel correlates with
% itself in time between the inner, mid and outer layers

%   delete(gcp('nocreate'));
%   parpool;
%   parfor i = 1:size(inner_cdata,1)
%       tmp = corrcoef(inner_cdata(i,:),mid_cdata(i,:)); inner_mid_voxel_corr(i) = tmp(1,2);
%       tmp = corrcoef(inner_cdata(i,:),outer_cdata(i,:)); inner_outer_voxel_corr(i) = tmp(1,2);
%       tmp = corrcoef(mid_cdata(i,:),outer_cdata(i,:)); mid_outer_voxel_corr(i) = tmp(1,2);
%   end

%   tmp = corrcoef(inner_cdata,mid_cdata); inner_mid_corr = tmp(1,2);
%   tmp = corrcoef(inner_cdata,outer_cdata); inner_outer_corr = tmp(1,2);
%   tmp = corrcoef(mid_cdata,outer_cdata); mid_outer_corr = tmp(1,2);

%   inner_mid_partial_voxel_corr(i) = partialcorr(inner_cdata(i,:)', mid_cdata(i,:)', outer_cdata(i,:)');
%   inner_outer_partial_voxel_corr(i) = partialcorr(inner_cdata(i,:)', outer_cdata(i,:)', mid_cdata(i,:)'); 
%   mid_outer_partial_voxel_corr(i) = partialcorr(inner_cdata(i,:)', mid_cdata(i,:)', outer_cdata(i,:)'); 

%   inner_mid_partial_corr = partialcorr(inner_cdata', mid_cdata', outer_cdata', 'rows', 'pairwise');
%   inner_outer_partial_corr = partialcorr(inner_cdata', outer_cdata', mid_cdata', 'rows', 'pairwise');
%   mid_outer_partial_corr = partialcorr(mid_cdata', outer_cdata', inner_cdata', 'rows', 'pairwise');


    %% View flatmap time series and save 180-frame gif
    % Save voxelwise correlation maps between depths
    inner_mid_corr_fn = sprintf('%s.%03d.SUIT.inner-vs-outer-corr.tif',session,run);
    inner_outer_corr_fn = replace(inner_mid_corr_fn,'mid','outer');
    mid_outer_corr_fn = replace(inner_outer_corr_fn,'outer','mid');
    
    view_flatmap(inner_mid_voxel_corr', 'save', inner_mid_corr_fn, out_dir);
    view_flatmap(inner_outer_voxel_corr', 'save', inner_outer_corr_fn, out_dir);
    view_flatmap(mid_outer_voxel_corr', 'save', mid_outer_corr_fn, out_dir);
end

