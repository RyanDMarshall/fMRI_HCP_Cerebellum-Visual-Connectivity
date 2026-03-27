clear;clc;close all;

restdir = "/projectnb/somerslab/ryanmars/projects/CrossTaskAnalysis/proj_allrest";
outdir = sprintf('%s/group/corrMaps/AV_prob_labels-ctx-to-cb',restdir);
sess_fID = fopen(sprintf("%s/sessid-rest-ray",restdir),'r');
sessions = textscan(sess_fID,'%s'); sessions = sessions{1};

names = ["lh_sPCS" "lh_iPCS" "lh_midIFS" "rh_sPCS" "rh_iPCS" "rh_midIFS"];
corrVols = {};
corrVols_flat = {};
corrNorm_Vols = {};
corrNorm_flatVols = {};

for i = 1:length(sessions)
    for j = 1:length(names)
  	  	corrMap_fn{i,j} = sprintf('%s/%s/corrMaps/AV_prob_labels-ctx-to-cb/%s_cb.corrMap.nii',restdir,sessions{j},names(i)); 
    
        corrMap{i,j} = MRIread(corrMap_fn{i,j});
		corrMap{i,j}.vol(corrMap.vol <= 0) = nan; % Threshold out negative correlations
		corrMap{i,j}.vol = real(fisherz(corrMap.vol)); % Fisher-z transform

        corrVols{i,j} = corrMap{i,j}.vol;
        corrVols_flat{i,j} = reshape(corrVols{i,j},[],1);
        
        corrVols_flatNorm{i,j} = (corrVols_flat{i,j} - mean(corrVols_flat{i,j},'omitnan'))./std(corrVols_flat{i,j},'omitnan');
        corrVols_Norm{i,j} = reshape(corrVols_flatNorm{j}, size(corrVols{1}));
        
        corrNorm_fn{i,j} = sprintf('%s/Normalized_CorrMaps/%s_%s_r-to-z_normalized.nii',outdir,sessions{i},names{j});
        corrNorm = corrMap{i,j}; corrNorm.vol = corrVols_Norm{i,j};
        MRIwrite(corrNorm, corrNorm_fn, 'float');
    end
end

for i=1:length(names)
    for j=1:length(sessions)
        ROI_fn{i,j} = sprintf('%s/Normalized_CorrMaps/%s_%s_%s_r-to-z_normalized.nii',outdir,sessions{j},names{i});
        ROI{i,j} = MRIread(ROI_fn{i,j});
        ROI_vol{i,j} = ROI{i,j}.vol;
        ROI_vol_flat{i,j} = reshape(ROI{i,j}.vol,[],1);
    end
    
    group_norm_corrMaps{i} = mean(cell2mat(ROI_vol_flat{i,:}),2,'omitnan');

    sPCS_lh_vol_flat{i} = reshape(ROI_vol_flat{i,1},[],1);
    iPCS_lh_vol_flat{i} = reshape(iPCS_lh_vol{i,2},[],1);
    midIFS_lh_vol_flat{i} = reshape(midIFS_lh_vol{i,3},[],1);
    sPCS_rh_vol_flat{i} = reshape(sPCS_rh_vol{i,4},[],1);
    iPCS_rh_vol_flat{i} = reshape(iPCS_rh_vol{i,5},[],1);
    midIFS_rh_vol_flat{i} = reshape(midIFS_rh_vol{i,6},[],1);

    sPCS_vs_2_lh_vol_flat{i} = sPCS_lh_vol_flat{i} - mean([iPCS_lh_vol_flat{i},midIFS_lh_vol_flat{i}],2,'omitnan');
    iPCS_vs_2_lh_vol_flat{i} = iPCS_lh_vol_flat{i} - mean([sPCS_lh_vol_flat{i},midIFS_lh_vol_flat{i}],2,'omitnan');
    midIFS_vs_2_lh_vol_flat{i} = midIFS_lh_vol_flat{i} - mean([sPCS_lh_vol_flat{i},iPCS_lh_vol_flat{i}],2,'omitnan');
    sPCS_vs_2_rh_vol_flat{i} = sPCS_rh_vol_flat{i} - mean([iPCS_rh_vol_flat{i},midIFS_rh_vol_flat{i}],2,'omitnan');
    iPCS_vs_2_rh_vol_flat{i} = iPCS_rh_vol_flat{i} - mean([sPCS_rh_vol_flat{i},midIFS_rh_vol_flat{i}],2,'omitnan');
    midIFS_vs_2_rh_vol_flat{i} = midIFS_rh_vol_flat{i} - mean([sPCS_rh_vol_flat{i},iPCS_rh_vol_flat{i}],2,'omitnan');

    sPCS_vs_2_lh{i} = ROI_; 
    sPCS_vs_2_lh{i}.vol = reshape(sPCS_vs_2_lh_vol_flat{i}, size(sPCS_lh_vol{1}));
    iPCS_vs_2_lh{i} = iPCS_lh; 
    iPCS_vs_2_lh{i}.vol = reshape(iPCS_vs_2_lh_vol_flat{i}, size(sPCS_lh_vol{1}));
    midIFS_vs_2_lh{i} = midIFS_lh; 
    midIFS_vs_2_lh{i}.vol = reshape(midIFS_vs_2_lh_vol_flat{i}, size(sPCS_lh_vol{1}));
    sPCS_vs_2_rh{i} = sPCS_rh; 
    sPCS_vs_2_rh{i}.vol = reshape(sPCS_vs_2_rh_vol_flat{i}, size(sPCS_rh_vol{1}));
    iPCS_vs_2_rh{i} = iPCS_rh; 
    iPCS_vs_2_rh{i}.vol = reshape(iPCS_vs_2_rh_vol_flat{i}, size(sPCS_rh_vol{1}));
    midIFS_vs_2_rh{i} = midIFS_rh; 
    midIFS_vs_2_rh{i}.vol = reshape(midIFS_vs_2_rh_vol_flat{i}, size(sPCS_rh_vol{1}));

    sPCS_vs_2_lh_fn = sprintf('%s/Normalized_CorrMaps/sPCS-iPCS-midIFS/%s_lh_sPCS-vs-iPCS+midIFS_norm_corr_diffMap.nii',outdir,sessions{i});
    iPCS_vs_2_lh_fn = sprintf('%s/Normalized_CorrMaps/sPCS-iPCS-midIFS/%s_lh_iPCS-vs-sPCS+midIFS_norm_corr_diffMap.nii',outdir,sessions{i});
    midIFS_vs_2_lh_fn = sprintf('%s/Normalized_CorrMaps/sPCS-iPCS-midIFS/%s_lh_midIFS-vs-sPCS+iPCS_norm_corr_diffMap.nii',outdir,sessions{i});
    sPCS_vs_2_rh_fn = sprintf('%s/Normalized_CorrMaps/sPCS-iPCS-midIFS/%s_rh_sPCS-vs-iPCS+midIFS_norm_corr_diffMap.nii',outdir,sessions{i});
    iPCS_vs_2_rh_fn = sprintf('%s/Normalized_CorrMaps/sPCS-iPCS-midIFS/%s_rh_iPCS-vs-sPCS+midIFS_norm_corr_diffMap.nii',outdir,sessions{i});
    midIFS_vs_2_rh_fn = sprintf('%s/Normalized_CorrMaps/sPCS-iPCS-midIFS/%s_rh_midIFS-vs-sPCS+iPCS_norm_corr_diffMap.nii',outdir,sessions{i});

    MRIwrite(sPCS_vs_2_lh{i}, sPCS_vs_2_lh_fn, 'float');
    MRIwrite(iPCS_vs_2_lh{i}, iPCS_vs_2_lh_fn, 'float');
    MRIwrite(midIFS_vs_2_lh{i}, midIFS_vs_2_lh_fn, 'float');
    MRIwrite(sPCS_vs_2_rh{i}, sPCS_vs_2_rh_fn, 'float');
    MRIwrite(iPCS_vs_2_rh{i}, iPCS_vs_2_rh_fn, 'float');
    MRIwrite(midIFS_vs_2_rh{i}, midIFS_vs_2_rh_fn, 'float');
end

%%
group_sPCS_lh_fn = sprintf('%s/Normalized_CorrMaps/single-condition/ave_lh_sPCS_norm_corrMap.nii',outdir);
group_iPCS_lh_fn = sprintf('%s/Normalized_CorrMaps/single-condition/ave_lh_iPCS_norm_corrMap.nii',outdir);
group_midIFS_lh_fn = sprintf('%s/Normalized_CorrMaps/single-condition/ave_lh_midIFS_norm_corrMap.nii',outdir);
group_sPCS_rh_fn = sprintf('%s/Normalized_CorrMaps/single-condition/ave_rh_sPCS_norm_corrMap.nii',outdir);
group_iPCS_rh_fn = sprintf('%s/Normalized_CorrMaps/single-condition/ave_rh_iPCS_norm_corrMap.nii',outdir);
group_midIFS_rh_fn = sprintf('%s/Normalized_CorrMaps/single-condition/ave_rh_midIFS_norm_corrMap.nii',outdir);

group_sPCS_lh_flat = mean(cell2mat(sPCS_lh_vol_flat),2,'omitnan');
group_iPCS_lh_flat = mean(cell2mat(iPCS_lh_vol_flat),2,'omitnan');
group_midIFS_lh_flat = mean(cell2mat(midIFS_lh_vol_flat),2,'omitnan');
group_sPCS_rh_flat = mean(cell2mat(sPCS_rh_vol_flat),2,'omitnan');
group_iPCS_rh_flat = mean(cell2mat(iPCS_rh_vol_flat),2,'omitnan');
group_midIFS_rh_flat = mean(cell2mat(midIFS_rh_vol_flat),2,'omitnan');

group_sPCS_lh = sPCS_lh; group_sPCS_lh.vol=reshape(group_sPCS_lh_flat,size(sPCS_lh.vol));
group_iPCS_lh = iPCS_lh; group_iPCS_lh.vol=reshape(group_iPCS_lh_flat,size(iPCS_lh.vol));
group_midIFS_lh = midIFS_lh; group_midIFS_lh.vol=reshape(group_midIFS_lh_flat,size(midIFS_lh.vol));
group_sPCS_rh = sPCS_rh; group_sPCS_rh.vol=reshape(group_sPCS_rh_flat,size(sPCS_rh.vol));
group_iPCS_rh = iPCS_rh; group_iPCS_rh.vol=reshape(group_iPCS_rh_flat,size(iPCS_rh.vol));
group_midIFS_rh = midIFS_rh; group_midIFS_rh.vol=reshape(group_midIFS_rh_flat,size(midIFS_rh.vol));

MRIwrite(group_sPCS_lh,group_sPCS_lh_fn,'float');
MRIwrite(group_iPCS_lh,group_iPCS_lh_fn,'float');
MRIwrite(group_midIFS_lh,group_midIFS_lh_fn,'float');
MRIwrite(group_sPCS_rh,group_sPCS_rh_fn,'float');
MRIwrite(group_iPCS_rh,group_iPCS_rh_fn,'float');
MRIwrite(group_midIFS_rh,group_midIFS_rh_fn,'float');
%% Save counts for NANs and "significant" (arbitrary threshold of r = 0.25)

group_sPCS_count_lh_fn = sprintf('%s/Normalized_CorrMaps/single-condition/ave_lh_sPCS_norm_corrMap_count.nii',outdir);
group_midIFS_count_lh_fn = sprintf('%s/Normalized_CorrMaps/single-condition/ave_lh_midIFS_norm_corrMap_count.nii',outdir);
group_iPCS_count_lh_fn = sprintf('%s/Normalized_CorrMaps/single-condition/ave_lh_iPCS_norm_corrMap_count.nii',outdir);
group_sPCS_count_rh_fn = sprintf('%s/Normalized_CorrMaps/single-condition/ave_rh_sPCS_norm_corrMap_count.nii',outdir);
group_midIFS_count_rh_fn = sprintf('%s/Normalized_CorrMaps/single-condition/ave_rh_midIFS_norm_corrMap_count.nii',outdir);
group_iPCS_count_rh_fn = sprintf('%s/Normalized_CorrMaps/single-condition/ave_rh_iPCS_norm_corrMap_count.nii',outdir);

group_sPCS_count_lh_flat = sum(~isnan(cell2mat(sPCS_lh_vol_flat)),2);
group_iPCS_count_lh_flat = sum(~isnan(cell2mat(iPCS_lh_vol_flat)),2);
group_midIFS_count_lh_flat = sum(~isnan(cell2mat(midIFS_lh_vol_flat)),2);
group_sPCS_count_rh_flat = sum(~isnan(cell2mat(sPCS_rh_vol_flat)),2);
group_iPCS_count_rh_flat = sum(~isnan(cell2mat(iPCS_rh_vol_flat)),2);
group_midIFS_count_rh_flat = sum(~isnan(cell2mat(midIFS_rh_vol_flat)),2);

group_sPCS_count_lh = sPCS_lh; group_sPCS_count_lh.vol=reshape(group_sPCS_count_lh_flat,size(sPCS_lh.vol));
group_iPCS_count_lh = iPCS_lh; group_iPCS_count_lh.vol=reshape(group_iPCS_count_lh_flat,size(iPCS_lh.vol));
group_midIFS_count_lh = midIFS_lh; group_midIFS_count_lh.vol=reshape(group_midIFS_count_lh_flat,size(midIFS_lh.vol));
group_sPCS_count_rh = sPCS_rh; group_sPCS_count_rh.vol=reshape(group_sPCS_count_rh_flat,size(sPCS_rh.vol));
group_iPCS_count_rh = iPCS_rh; group_iPCS_count_rh.vol=reshape(group_iPCS_count_rh_flat,size(iPCS_rh.vol));
group_midIFS_count_rh = midIFS_rh; group_midIFS_count_rh.vol=reshape(group_midIFS_count_rh_flat,size(midIFS_rh.vol));

MRIwrite(group_sPCS_count_lh,group_sPCS_count_lh_fn,'float');
MRIwrite(group_iPCS_count_lh,group_iPCS_count_lh_fn,'float');
MRIwrite(group_midIFS_count_lh,group_midIFS_count_lh_fn,'float');
MRIwrite(group_sPCS_count_rh,group_sPCS_count_rh_fn,'float');
MRIwrite(group_iPCS_count_rh,group_iPCS_count_rh_fn,'float');
MRIwrite(group_midIFS_count_rh,group_midIFS_count_rh_fn,'float');

%%
group_sPCS_sigcount_lh_fn = sprintf('%s/Normalized_CorrMaps/single-condition/ave_lh_sPCS_norm_corrMap_sigcount.nii',outdir);
group_midIFS_sigcount_lh_fn = sprintf('%s/Normalized_CorrMaps/single-condition/ave_lh_midIFS_norm_corrMap_sigcount.nii',outdir);
group_iPCS_sigcount_lh_fn = sprintf('%s/Normalized_CorrMaps/single-condition/ave_lh_iPCS_norm_corrMap_sigcount.nii',outdir);
group_sPCS_sigcount_rh_fn = sprintf('%s/Normalized_CorrMaps/single-condition/ave_rh_sPCS_norm_corrMap_sigcount.nii',outdir);
group_midIFS_sigcount_rh_fn = sprintf('%s/Normalized_CorrMaps/single-condition/ave_rh_midIFS_norm_corrMap_sigcount.nii',outdir);
group_iPCS_sigcount_rh_fn = sprintf('%s/Normalized_CorrMaps/single-condition/ave_rh_iPCS_norm_corrMap_sigcount.nii',outdir);

group_sPCS_sigcount_lh_flat = sum(cell2mat(sPCS_lh_vol_flat)>0.25,2);
group_iPCS_sigcount_lh_flat = sum(cell2mat(iPCS_lh_vol_flat)>0.25,2);
group_midIFS_sigcount_lh_flat = sum(cell2mat(midIFS_lh_vol_flat)>0.25,2);
group_sPCS_sigcount_rh_flat = sum(cell2mat(sPCS_rh_vol_flat)>0.25,2);
group_iPCS_sigcount_rh_flat = sum(cell2mat(iPCS_rh_vol_flat)>0.25,2);
group_midIFS_sigcount_rh_flat = sum(cell2mat(midIFS_rh_vol_flat)>0.25,2);

group_sPCS_sigcount_lh = sPCS_lh; group_sPCS_sigcount_lh.vol=reshape(group_sPCS_sigcount_lh_flat,size(sPCS_lh.vol));
group_iPCS_sigcount_lh = iPCS_lh; group_iPCS_sigcount_lh.vol=reshape(group_iPCS_sigcount_lh_flat,size(iPCS_lh.vol));
group_midIFS_sigcount_lh = midIFS_lh; group_midIFS_sigcount_lh.vol=reshape(group_midIFS_sigcount_lh_flat,size(midIFS_lh.vol));
group_sPCS_sigcount_rh = sPCS_rh; group_sPCS_sigcount_rh.vol=reshape(group_sPCS_sigcount_rh_flat,size(sPCS_rh.vol));
group_iPCS_sigcount_rh = iPCS_rh; group_iPCS_sigcount_rh.vol=reshape(group_iPCS_sigcount_rh_flat,size(iPCS_rh.vol));
group_midIFS_sigcount_rh = midIFS_rh; group_midIFS_sigcount_rh.vol=reshape(group_midIFS_sigcount_rh_flat,size(midIFS_rh.vol));

MRIwrite(group_sPCS_sigcount_lh,group_sPCS_sigcount_lh_fn,'float');
MRIwrite(group_iPCS_sigcount_lh,group_iPCS_sigcount_lh_fn,'float');
MRIwrite(group_midIFS_sigcount_lh,group_midIFS_sigcount_lh_fn,'float');
MRIwrite(group_sPCS_sigcount_rh,group_sPCS_sigcount_rh_fn,'float');
MRIwrite(group_iPCS_sigcount_rh,group_iPCS_sigcount_rh_fn,'float');
MRIwrite(group_midIFS_sigcount_rh,group_midIFS_sigcount_rh_fn,'float');

%% Make 1-vs-2 contrasts for each region
group_sPCS_map_lh_fn = sprintf('%s/Normalized_CorrMaps/sPCS-iPCS-midIFS/group/ave_lh_sPCS_vs_iPCS+midIFS_norm_corrMap.nii',outdir);
group_iPCS_map_lh_fn = sprintf('%s/Normalized_CorrMaps/sPCS-iPCS-midIFS/group/ave_lh_iPCS_vs_sPCS+midIFS_norm_corrMap.nii',outdir);
group_midIFS_map_lh_fn = sprintf('%s/Normalized_CorrMaps/sPCS-iPCS-midIFS/group/ave_lh_midIFS_vs_sPCS+iPCS_norm_corrMap.nii',outdir);
group_sPCS_map_rh_fn = sprintf('%s/Normalized_CorrMaps/sPCS-iPCS-midIFS/group/ave_rh_sPCS_vs_iPCS+midIFS_norm_corrMap.nii',outdir);
group_iPCS_map_rh_fn = sprintf('%s/Normalized_CorrMaps/sPCS-iPCS-midIFS/group/ave_rh_iPCS_vs_sPCS+midIFS_norm_corrMap.nii',outdir);
group_midIFS_map_rh_fn = sprintf('%s/Normalized_CorrMaps/sPCS-iPCS-midIFS/group/ave_rh_midIFS_vs_sPCS+iPCS_norm_corrMap.nii',outdir);

group_sPCS_map_lh = sPCS_lh; group_sPCS_map_lh.vol = reshape(mean(cell2mat(sPCS_vs_2_lh_vol_flat),2,'omitnan'),size(sPCS_lh_vol{1}));
group_iPCS_map_lh = iPCS_lh; group_iPCS_map_lh.vol = reshape(mean(cell2mat(iPCS_vs_2_lh_vol_flat),2,'omitnan'),size(sPCS_lh_vol{1}));
group_midIFS_map_lh = midIFS_lh; group_midIFS_map_lh.vol = reshape(mean(cell2mat(midIFS_vs_2_lh_vol_flat),2,'omitnan'),size(sPCS_lh_vol{1}));
group_sPCS_map_rh = sPCS_rh; group_sPCS_map_rh.vol = reshape(mean(cell2mat(sPCS_vs_2_rh_vol_flat),2,'omitnan'),size(sPCS_rh_vol{1}));
group_iPCS_map_rh = iPCS_rh; group_iPCS_map_rh.vol = reshape(mean(cell2mat(iPCS_vs_2_rh_vol_flat),2,'omitnan'),size(sPCS_rh_vol{1}));
group_midIFS_map_rh = midIFS_rh; group_midIFS_map_rh.vol = reshape(mean(cell2mat(midIFS_vs_2_rh_vol_flat),2,'omitnan'),size(sPCS_rh_vol{1}));

MRIwrite(group_sPCS_map_lh,group_sPCS_map_lh_fn,'float');
MRIwrite(group_iPCS_map_lh,group_iPCS_map_lh_fn,'float');
MRIwrite(group_midIFS_map_lh,group_midIFS_map_lh_fn,'float');
MRIwrite(group_sPCS_map_rh,group_sPCS_map_rh_fn,'float');
MRIwrite(group_iPCS_map_rh,group_iPCS_map_rh_fn,'float');
MRIwrite(group_midIFS_map_rh,group_midIFS_map_rh_fn,'float');