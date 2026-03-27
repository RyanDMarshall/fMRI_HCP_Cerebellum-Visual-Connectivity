%% Basic file I/O
group_dir='/projectnb/somerslab/ryanmars/projects/CrossTaskAnalysis/proj_allrest/results/group/HCP_SUIT';

out_dir=sprintf('%s/diffMaps',group_dir);
out_dir_pearson=sprintf('%s/pearson',out_dir); 
out_dir_partial=sprintf('%s/partial',out_dir); 
out_dir_debug=sprintf('%s/debug',out_dir);

t_dir = sprintf('%s/group_tstat',group_dir); tfce_dir = sprintf('%s/group_tfce',group_dir);

pearson_hemis=["lh","rh","bilat"]; partial_hemis=["lh" "rh"];
rois_fn = sprintf('%s/rois-sorted.txt',group_dir); rois_fID = fopen(rois_fn); 
rois = textscan(rois_fID,'%s'); rois=string(rois{1});
nrois=length(rois);

pearson_t_dir = sprintf('%s/pearson',t_dir); partial_t_dir = sprintf('%s/partial',t_dir);
pearson_tfce_dir = sprintf('%s/pearson',tfce_dir); partial_tfce_dir = sprintf('%s/partial',tfce_dir);

pearson_t_list_fn = sprintf('%s/list_group_tstat_pearson.txt',group_dir); 
pearson_t_fID = fopen(pearson_t_list_fn); pearson_t_list = textscan(pearson_t_fID,'%s'); pearson_t_list=string(pearson_t_list{1});
partial_t_list_fn = sprintf('%s/list_group_tstat_partial.txt',group_dir); 
partial_t_fID = fopen(partial_t_list_fn); partial_t_list = textscan(partial_t_fID,'%s'); partial_t_list=string(partial_t_list{1});
pearson_tfce_list_fn = sprintf('%s/list_group_tfce_pearson.txt',group_dir); 
pearson_tfce_fID = fopen(pearson_tfce_list_fn); pearson_tfce_list = textscan(pearson_tfce_fID,'%s'); pearson_tfce_list=string(pearson_tfce_list{1});
partial_tfce_list_fn = sprintf('%s/list_group_tfce_partial.txt',group_dir); 
partial_tfce_fID = fopen(partial_tfce_list_fn); partial_tfce_list = textscan(partial_tfce_fID,'%s'); partial_tfce_list=string(partial_tfce_list{1});

% Rearrange to group files by analysis type/ hemisphere
pearson_t_lh = pearson_t_list(contains(pearson_t_list,'lh')); pearson_t_lh_full=strcat(pearson_t_dir,'/',pearson_t_lh);
pearson_t_rh = pearson_t_list(contains(pearson_t_list,'rh')); pearson_t_rh_full=strcat(pearson_t_dir,'/',pearson_t_rh);
pearson_t_bilat = pearson_t_list(contains(pearson_t_list,'bilat')); pearson_t_bilat_full=strcat(pearson_t_dir,'/',pearson_t_bilat);
pearson_t_list = [pearson_t_lh, pearson_t_rh, pearson_t_bilat]; pearson_t_list_full = [pearson_t_lh_full, pearson_t_rh_full, pearson_t_bilat_full];

pearson_tfce_lh = pearson_tfce_list(contains(pearson_tfce_list,'lh')); pearson_tfce_lh_full=strcat(pearson_tfce_dir,'/',pearson_tfce_lh);
pearson_tfce_rh = pearson_tfce_list(contains(pearson_tfce_list,'rh')); pearson_tfce_rh_full=strcat(pearson_tfce_dir,'/',pearson_tfce_rh);
pearson_tfce_bilat = pearson_tfce_list(contains(pearson_tfce_list,'bilat')); pearson_tfce_bilat_full=strcat(pearson_tfce_dir,'/',pearson_tfce_bilat);
pearson_tfce_list = [pearson_tfce_lh, pearson_tfce_rh, pearson_tfce_bilat]; pearson_tfce_list_full = [pearson_tfce_lh_full, pearson_tfce_rh_full, pearson_tfce_bilat_full];

partial_t_lh = partial_t_list(contains(partial_t_list,'lh')); partial_t_lh_full=strcat(partial_t_dir,'/',partial_t_lh);
partial_t_rh = partial_t_list(contains(partial_t_list,'rh')); partial_t_rh_full=strcat(partial_t_dir,'/',partial_t_rh);
partial_t_list = [partial_t_lh, partial_t_rh]; partial_t_list_full = [partial_t_lh_full, partial_t_rh_full];

partial_tfce_lh = partial_tfce_list(contains(partial_tfce_list,'lh')); partial_tfce_lh_full=strcat(partial_tfce_dir,'/',partial_tfce_lh); 
partial_tfce_rh = partial_tfce_list(contains(partial_tfce_list,'rh')); partial_tfce_rh_full=strcat(partial_tfce_dir,'/',partial_tfce_rh); 
partial_tfce_list = [partial_tfce_lh, partial_tfce_rh]; partial_tfce_list_full = [partial_tfce_lh_full, partial_tfce_rh_full]; 

out_dir_pearson_u95 = sprintf('%s/u_thr0.95',out_dir_pearson);
out_dir_pearson_u99 = sprintf('%s/u_thr0.99',out_dir_pearson);
out_dir_pearson_i95 = sprintf('%s/i_thr0.95',out_dir_pearson);
out_dir_pearson_i99 = sprintf('%s/i_thr0.99',out_dir_pearson);
out_dir_partial_u95 = sprintf('%s/u_thr0.95',out_dir_partial);
out_dir_partial_u99 = sprintf('%s/u_thr0.99',out_dir_partial);
out_dir_partial_i95 = sprintf('%s/i_thr0.95',out_dir_partial);
out_dir_partial_i99 = sprintf('%s/i_thr0.99',out_dir_partial);

%% Run (corrected) p < 0.05 union mask analysis
% U95 Pearson
make_wang_diffMaps_helper(pearson_t_bilat_full, pearson_tfce_bilat_full, rois, out_dir_pearson_u95, 'bilat', 'union', 0.95, "standard")
make_wang_diffMaps_helper(pearson_t_lh_full, pearson_tfce_lh_full, rois, out_dir_pearson_u95, 'lh', 'union', 0.95, "standard")
make_wang_diffMaps_helper(pearson_t_rh_full, pearson_tfce_rh_full, rois, out_dir_pearson_u95, 'rh', 'union', 0.95, "standard")
make_wang_diffMaps_helper([pearson_t_lh_full; pearson_t_rh_full], [pearson_tfce_lh_full; pearson_tfce_rh_full], rois, out_dir_pearson_u95, 'lh', 'union', 0.95, "contralateral")

% U95 partial
make_wang_diffMaps_helper(partial_t_lh_full, partial_tfce_lh_full, rois, out_dir_partial_u95, 'lh', 'union', 0.95, "standard")
make_wang_diffMaps_helper(partial_t_rh_full, partial_tfce_rh_full, rois, out_dir_partial_u95, 'rh', 'union', 0.95, "standard")
make_wang_diffMaps_helper([partial_t_lh_full; partial_t_rh_full], [partial_tfce_lh_full; partial_tfce_rh_full], rois, out_dir_partial_u95, 'lh', 'union', 0.95, "contralateral")

%% Run (corrected) p < 0.01 union mask analysis
% U99 Pearson
make_wang_diffMaps_helper(pearson_t_bilat_full, pearson_tfce_bilat_full, rois, out_dir_pearson_u99, 'bilat', 'union', 0.99, "standard")
make_wang_diffMaps_helper(pearson_t_lh_full, pearson_tfce_lh_full, rois, out_dir_pearson_u99, 'lh', 'union', 0.99, "standard")
make_wang_diffMaps_helper(pearson_t_rh_full, pearson_tfce_rh_full, rois, out_dir_pearson_u99, 'rh', 'union', 0.99, "standard")
make_wang_diffMaps_helper([pearson_t_lh_full; pearson_t_rh_full], [pearson_tfce_lh_full; pearson_tfce_rh_full], rois, out_dir_pearson_u99, 'lh', 'union', 0.99, "contralateral")

% U99 partial
make_wang_diffMaps_helper(partial_t_lh_full, partial_tfce_lh_full, rois, out_dir_partial_u99, 'lh', 'union', 0.99, "standard")
make_wang_diffMaps_helper(partial_t_rh_full, partial_tfce_rh_full, rois, out_dir_partial_u99, 'rh', 'union', 0.99, "standard")
make_wang_diffMaps_helper([partial_t_lh_full; partial_t_rh_full], [partial_tfce_lh_full; partial_tfce_rh_full], rois, out_dir_partial_u99, 'lh', 'union', 0.99, "contralateral")

%% Run (corrected) p < 0.05 intersection mask analysis
% U95 Pearson
make_wang_diffMaps_helper(pearson_t_bilat_full, pearson_tfce_bilat_full, rois, out_dir_pearson_i95, 'bilat', 'intersect', 0.95, "standard")
make_wang_diffMaps_helper(pearson_t_lh_full, pearson_tfce_lh_full, rois, out_dir_pearson_i95, 'lh', 'intersect', 0.95, "standard")
make_wang_diffMaps_helper(pearson_t_rh_full, pearson_tfce_rh_full, rois, out_dir_pearson_i95, 'rh', 'intersect', 0.95, "standard")
make_wang_diffMaps_helper([pearson_t_lh_full; pearson_t_rh_full], [pearson_tfce_lh_full; pearson_tfce_rh_full], rois, out_dir_pearson_i95, 'lh', 'intersect', 0.95, "contralateral")

% U95 partial
make_wang_diffMaps_helper(partial_t_lh_full, partial_tfce_lh_full, rois, out_dir_partial_i95, 'lh', 'intersect', 0.95, "standard")
make_wang_diffMaps_helper(partial_t_rh_full, partial_tfce_rh_full, rois, out_dir_partial_i95, 'rh', 'intersect', 0.95, "standard")
make_wang_diffMaps_helper([partial_t_lh_full; partial_t_rh_full], [partial_tfce_lh_full; partial_tfce_rh_full], rois, out_dir_partial_i95, 'lh', 'union', 0.95, "contralateral")

%% Run (corrected) p < 0.01 intersection mask analysis
% U99 Pearson
make_wang_diffMaps_helper(pearson_t_bilat_full, pearson_tfce_bilat_full, rois, out_dir_pearson_i99, 'bilat', 'intersect', 0.99, "standard")
make_wang_diffMaps_helper(pearson_t_lh_full, pearson_tfce_lh_full, rois, out_dir_pearson_i99, 'lh', 'intersect', 0.99, "standard")
make_wang_diffMaps_helper(pearson_t_rh_full, pearson_tfce_rh_full, rois, out_dir_pearson_i99, 'rh', 'intersect', 0.99, "standard")
make_wang_diffMaps_helper([pearson_t_lh_full; pearson_t_rh_full], [pearson_tfce_lh_full; pearson_tfce_rh_full], rois, out_dir_pearson_i99, 'lh', 'intersect', 0.99, "contralateral")

% U99 partial
make_wang_diffMaps_helper(partial_t_lh_full, partial_tfce_lh_full, rois, out_dir_partial_i99, 'lh', 'intersect', 0.99, "standard")
make_wang_diffMaps_helper(partial_t_rh_full, partial_tfce_rh_full, rois, out_dir_partial_i99, 'rh', 'intersect', 0.99, "standard")
make_wang_diffMaps_helper([partial_t_lh_full; partial_t_rh_full], [partial_tfce_lh_full; partial_tfce_rh_full], rois, out_dir_partial_i99, 'lh', 'intersect', 0.99, "contralateral")
