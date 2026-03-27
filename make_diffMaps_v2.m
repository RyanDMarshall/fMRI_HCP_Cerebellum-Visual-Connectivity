%% Basic file I/O
group_dir='/projectnb/somerslab/ryanmars/projects/CrossTaskAnalysis/proj_allrest/results/group/HCP_SUIT';

out_dir=sprintf('%s/diffMaps',group_dir);
out_dir_pearson_t=sprintf('%s/pearson_t',out_dir); out_dir_pearson_tfce=sprintf('%s/pearson_tfce',out_dir);
out_dir_partial_t=sprintf('%s/partial_t',out_dir); out_dir_partial_tfce=sprintf('%s/partial_tfce',out_dir);
out_dir_zmaps=sprintf('%s/group_zstat',group_dir); out_dir_zstd=sprintf('%s/group_zstd',group_dir);
out_dir_debug=sprintf('%s/debug',out_dir);

t_dir = sprintf('%s/group_tstat',group_dir); tfce_dir = sprintf('%s/group_tfce',group_dir);
pearson_hemis=["lh","rh","bilat"]; partial_hemis=["lh" "rh"];
rois_fn = sprintf('%s/rois.txt',group_dir); rois_fID = fopen(rois_fn); 
rois = textscan(rois_fID,'%s'); rois=string(rois{1});

pearson_t_dir = sprintf('%s/pearson',t_dir); partial_t_dir = sprintf('%s/partial',t_dir);
pearson_tfce_dir = sprintf('%s/pearson',t_dir); partial_tfce_dir = sprintf('%s/partial',tfce_dir);

pearson_t_list_fn = sprintf('%s/list_group_tstat_pearson.txt',group_dir); 
pearson_t_fID = fopen(pearson_t_list_fn); pearson_t_list = textscan(pearson_t_fID,'%s'); pearson_t_list=string(pearson_t_list{1});
partial_t_list_fn = sprintf('%s/list_group_tstat_partial.txt',group_dir); 
partial_t_fID = fopen(partial_t_list_fn); partial_t_list = textscan(partial_t_fID,'%s'); partial_t_list=string(partial_t_list{1});
pearson_tfce_list_fn = sprintf('%s/list_group_tfce_pearson.txt',group_dir); 
pearson_tfce_fID = fopen(pearson_tfce_list_fn); pearson_tfce_list = textscan(pearson_tfce_fID,'%s'); pearson_tfce_list=string(pearson_tfce_list{1});
partial_tfce_list_fn = sprintf('%s/list_group_tfce_partial.txt',group_dir); 
partial_tfce_fID = fopen(partial_tfce_list_fn); partial_tfce_list = textscan(partial_tfce_fID,'%s'); partial_tfce_list=string(partial_tfce_list{1});

%Rearrange to group by hemisphere
pearson_t_lh = pearson_t_list(contains(pearson_t_list,'lh'));
pearson_t_rh = pearson_t_list(contains(pearson_t_list,'rh'));
pearson_t_bilat = pearson_t_list(contains(pearson_t_list,'bilat'));
pearson_t_list = [pearson_t_lh, pearson_t_rh, pearson_t_bilat];

pearson_tfce_lh = pearson_t_list(contains(pearson_tfce_list,'lh'));
pearson_tfce_rh = pearson_t_list(contains(pearson_tfce_list,'rh'));
pearson_tfce_bilat = pearson_t_list(contains(pearson_tfce_list,'bilat'));
pearson_tfce_list = [pearson_tfce_lh, pearson_tfce_rh, pearson_tfce_bilat];

partial_t_lh = partial_t_list(contains(partial_t_list,'lh'));
partial_t_rh = partial_t_list(contains(partial_t_list,'rh'));
partial_t_list = [partial_t_lh, partial_t_rh];

partial_tfce_lh = partial_t_list(contains(partial_tfce_list,'lh'));
partial_tfce_rh = partial_t_list(contains(partial_tfce_list,'rh'));
partial_tfce_list = [partial_tfce_lh, partial_tfce_rh];

%% 
nrois=length(rois);
pearson_z_list=string(zeros([nrois,3])); 
pearson_z_std_list=pearson_z_list; 
partial_z_list=string(zeros([nrois,2])); 
partial_z_std_list=partial_z_list; 

hemis=pearson_hemis;
for i=1:length(rois)
    for j=1:length(hemis)
        cd(sprintf('%s/%s/',t_dir,'pearson'));
        sprintf('%s %s',rois(i),hemis(j));
        pearson_z_list(i,j)=sprintf('%s/%s/perm_vsm4_%s_%s_zstat1.nii.gz',out_dir_zmaps,rois(i),hemis(j));
        convert_spm_stat('TtoZ',pearson_t_list(i,j),pearson_z_list(i,j),'165');
        pearson_z_std_list(i,j) = replace(replace(pearson_z_list(i,j),'_zstat1','_std_zstat1'),out_dir_zmaps,out_dir_zstd);
        z_std = standardize_nifti(pearson_z_list);
        MRIwrite(z_std,z_std_list(i,j));
    end
end



%% Finish setup
cd /projectnb/somerslab/ryanmars/projects/CrossTaskAnalysis/proj_allrest/results/group/HCP_SUIT
lh_z_list=z_list(:,1); rh_z_list=z_list(:,2); bilat_z_list = z_list(:,3);

lhrh_z_list=reshape(z_list(:,1:2),[2*nrois,1]);
lhrh_p_list=reshape(p_list(:,1:2),[2*nrois,1]);
lhrh_rois=[rois;rois]; 
lh_idx=[ones([nrois,1]);zeros([nrois,1])];
rh_idx=[zeros([nrois,1]);ones([nrois,1])];

%% Generate contrasts/ difference maps using normalized output
% Bilateral - early dorsal vs. ventral
cmat=zeros([nrois,1]); 
cmat(rois=='V1d' | rois=='V2d' | rois=='V3d') = 1;
cmat(rois=='V1v' | rois=='V2v' | rois=='V3v') = -1;
make_diffMap(bilat_z_list,bilat_p_list,rois,cmat,"union",0.99,out_dir_bilat,"EarlyDorsal","EarlyVentral",0)

cmat=zeros([nrois,1]);
cmat(rois=='V1d') = 1;
cmat(rois=='V1v') = -1;
make_diffMap(bilat_z_list,bilat_p_list,rois,cmat,"union",0.99,out_dir_bilat,"V1d","V1v",0)

cmat=zeros([nrois,1]); 
cmat(rois=='V2d') = 1;
cmat(rois=='V2v') = -1;
make_diffMap(bilat_z_list,bilat_p_list,rois,cmat,"union",0.99,out_dir_bilat,"V2d","V2v",0)

cmat=zeros([nrois,1]); 
cmat(rois=='V3d') = 1;
cmat(rois=='V3v') = -1;
make_diffMap(bilat_z_list,bilat_p_list,rois,cmat,"union",0.99,out_dir_bilat,"V3d","V3v",0)

% Late dorsal vs. ventral
cmat=zeros([nrois,1]); 
cmat(rois=='V3A') = 1;
cmat(rois=='hV4') = -1;
make_diffMap(bilat_z_list,bilat_p_list,rois,cmat,"union",0.99,out_dir_bilat,"V3A","hV4",0)



cmat=zeros([nrois,1]); 
cmat(rois=='V3A' | rois=='IPS0' | rois=='IPS1') = 1;
cmat(rois=='hV4' | rois=='VO1' | rois=='VO2') = -1;
make_diffMap(bilat_z_list,bilat_p_list,rois,cmat,"union",0.99,out_dir_bilat,"V3A+IPS0+IPS1","hV4+VO1+VO2",0)

cmat=zeros([nrois,1]); 
cmat(rois=='V3A' | rois=='IPS0' | rois=='IPS1' | rois=='IPS2' | rois=='IPS3') = 1;
cmat(rois=='hV4' | rois=='VO1' | rois=='VO2' | rois=='PHC1' | rois=='PHC2') = -1;
make_diffMap(bilat_z_list,bilat_p_list,rois,cmat,"union",0.99,out_dir_bilat,"V3A+IPS0+IPS1+IPS2+IPS3","hV4+VO1+VO2+PHC1+PHC2",0)

cmat=zeros([nrois,1]); 
cmat(rois=='IPS0' | rois=='IPS1') = 1;
cmat(rois=='VO1' | rois=='VO2') = -1;
make_diffMap(bilat_z_list,bilat_p_list,rois,cmat,"union",0.99,out_dir_bilat,"IPS0+IPS1","VO1+VO2",0)

cmat=zeros([nrois,1]); 
cmat(rois=='IPS0' | rois=='IPS1' | rois=='IPS2' | rois=='IPS3') = 1;
cmat(rois=='VO1' | rois=='VO2' | rois=='PHC1' | rois=='PHC2') = -1;
make_diffMap(bilat_z_list,bilat_p_list,rois,cmat,"union",0.99,out_dir_bilat,"IPS0+IPS1+IPS2+IPS3","VO1+VO2+PHC1+PHC2",0)

% Late lateral vs dorsal/ventral
cmat=zeros([nrois,1]); 
cmat(rois=='LO1' | rois=='LO2') = 1;
cmat(rois=='VO1' | rois=='VO2')= -1;
make_diffMap(bilat_z_list,bilat_p_list,rois,cmat,"union",0.99,out_dir_bilat,"LO1+LO2","VO1+VO2",0)

cmat=zeros([nrois,1]); 
cmat(rois=='LO1' | rois=='LO2') = 1;
cmat(rois=='V3A' | rois=='V3B') = -1;
make_diffMap(bilat_z_list,bilat_p_list,rois,cmat,"union",0.99,out_dir_bilat,"LO1+LO2","V3A+V3B",0)

cmat=zeros([nrois,1]); 
cmat(rois=='LO1' | rois=='LO2' | rois=='TO1') = 1;
cmat(rois=='VO1' | rois=='VO2')= -1;
make_diffMap(bilat_z_list,bilat_p_list,rois,cmat,"union",0.99,out_dir_bilat,"LO1+LO2+TO1","VO1+VO2",0)

cmat=zeros([nrois,1]); 
cmat(rois=='LO1' | rois=='LO2' | rois=='TO2') = 1;
cmat(rois=='V3A' | rois=='V3B') = -1;
make_diffMap(bilat_z_list,bilat_p_list,rois,cmat,"union",0.99,out_dir_bilat,"LO1+LO2+TO1","V3A+V3B",0)

%% lh & rh contrasts
cmat=zeros([nrois,1]); 
cmat(rois=='V1d' | rois=='V2d' | rois=='V3d') = 1;
cmat(rois=='V1v' | rois=='V2v' | rois=='V3v') = -1;
make_diffMap(lh_z_list,lh_p_list,rois,cmat,"union",0.99,out_dir_lh,"EarlyDorsal","EarlyVentral",0)

cmat=zeros([nrois,1]); 
cmat(rois=='V1d') = 1;
cmat(rois=='V1v') = -1;
make_diffMap(lhrh_z_list,lhrh_p_list,rois,cmat,"union",0.99,out_dir_lh,"V1d","V1v",0)

cmat=zeros([nrois,1]); 
cmat(rois=='V2d') = 1;
cmat(rois=='V2v') = -1;
make_diffMap(lh_z_list,lh_p_list,rois,cmat,"union",0.99,out_dir_lh,"V2d","V2v",0)

cmat=zeros([nrois,1]); 
cmat(rois=='V3d') = 1;
cmat(rois=='V3v') = -1;
make_diffMap(lh_z_list,lh_p_list,rois,cmat,"union",0.99,out_dir_lh,"V3d","V3v",0)

% Late dorsal vs. ventral
cmat=zeros([nrois,1]); 
cmat(rois=='V3A') = 1;
cmat(rois=='hV4') = -1;
make_diffMap(lh_z_list,lh_p_list,rois,cmat,"union",0.99,out_dir_lh,"V3A","hV4",0)

cmat=zeros([nrois,1]); 
cmat(rois=='V3A' | rois=='IPS0' | rois=='IPS1') = 1;
cmat(rois=='hV4' | rois=='VO1' | rois=='VO2') = -1;
make_diffMap(lh_z_list,lh_p_list,rois,cmat,"union",0.99,out_dir_lh,"V3A+IPS0+IPS1","hV4+VO1+VO2",0)

cmat=zeros([nrois,1]); 
cmat(rois=='V3A' | rois=='IPS0' | rois=='IPS1' | rois=='IPS2' | rois=='IPS3') = 1;
cmat(rois=='hV4' | rois=='VO1' | rois=='VO2' | rois=='PHC1' | rois=='PHC2') = -1;
make_diffMap(lh_z_list,lh_p_list,rois,cmat,"union",0.99,out_dir_lh,"V3A+IPS0+IPS1+IPS2+IPS3","hV4+VO1+VO2+PHC1+PHC2",0)

cmat=zeros([nrois,1]); 
cmat(rois=='IPS0' | rois=='IPS1') = 1;
cmat(rois=='VO1' | rois=='VO2') = -1;
make_diffMap(lh_z_list,lh_p_list,rois,cmat,"union",0.99,out_dir_lh,"IPS0+IPS1","VO1+VO2",0)

cmat=zeros([nrois,1]); 
cmat(rois=='IPS0' | rois=='IPS1' | rois=='IPS2' | rois=='IPS3') = 1;
cmat(rois=='VO1' | rois=='VO2' | rois=='PHC1' | rois=='PHC2') = -1;
make_diffMap(lh_z_list,lh_p_list,rois,cmat,"union",0.99,out_dir_lh,"IPS0+IPS1+IPS2+IPS3","VO1+VO2+PHC1+PHC2",0)

% Late lateral vs dorsal/ventral
cmat=zeros([nrois,1]); 
cmat(rois=='LO1' | rois=='LO2') = 1;
cmat(rois=='VO1' | rois=='VO2')= -1;
make_diffMap(lh_z_list,lh_p_list,rois,cmat,"union",0.99,out_dir_lh,"LO1+LO2","VO1+VO2",0)

cmat=zeros([nrois,1]); 
cmat(rois=='LO1' | rois=='LO2') = 1;
cmat(rois=='V3A' | rois=='V3B') = -1;
make_diffMap(lh_z_list,lh_p_list,rois,cmat,"union",0.99,out_dir_lh,"LO1+LO2","V3A+V3B",0)

cmat=zeros([nrois,1]); 
cmat(rois=='LO1' | rois=='LO2' | rois=='TO1') = 1;
cmat(rois=='VO1' | rois=='VO2')= -1;
make_diffMap(lh_z_list,lh_p_list,rois,cmat,"union",0.99,out_dir_lh,"LO1+LO2+TO1","VO1+VO2",0)

cmat=zeros([nrois,1]); 
cmat(rois=='LO1' | rois=='LO2' | rois=='TO2') = 1;
cmat(rois=='V3A' | rois=='V3B') = -1;
make_diffMap(lh_z_list,lh_p_list,rois,cmat,"union",0.99,out_dir_lh,"LO1+LO2+TO1","V3A+V3B",0)

% rh
cmat=zeros([nrois,1]); 
cmat(rois=='V1d' | rois=='V2d' | rois=='V3d') = 1;
cmat(rois=='V1v' | rois=='V2v' | rois=='V3v') = -1;
make_diffMap(rh_z_list,rh_p_list,rois,cmat,"union",0.99,out_dir_rh,"EarlyDorsal","EarlyVentral",0)

cmat=zeros([nrois,1]); 
cmat(rois=='V1d') = 1;
cmat(rois=='V1v') = -1;
make_diffMap(rh_z_list,rh_p_list,rois,cmat,"union",0.99,out_dir_rh,"V1d","V1v",0)

cmat=zeros([nrois,1]); 
cmat(rois=='V2d') = 1;
cmat(rois=='V2v') = -1;
make_diffMap(rh_z_list,rh_p_list,rois,cmat,"union",0.99,out_dir_rh,"V2d","V2v",0)

cmat=zeros([nrois,1]); 
cmat(rois=='V3d') = 1;
cmat(rois=='V3v') = -1;
make_diffMap(rh_z_list,rh_p_list,rois,cmat,"union",0.99,out_dir_rh,"V3d","V3v",0)

% Late dorsal vs. ventral
cmat=zeros([nrois,1]); 
cmat(rois=='V3A') = 1;
cmat(rois=='hV4') = -1;
make_diffMap(rh_z_list,rh_p_list,rois,cmat,"union",0.99,out_dir_rh,"V3A","hV4",0)

cmat=zeros([nrois,1]); 
cmat(rois=='V3A' | rois=='IPS0' | rois=='IPS1') = 1;
cmat(rois=='hV4' | rois=='VO1' | rois=='VO2') = -1;
make_diffMap(rh_z_list,rh_p_list,rois,cmat,"union",0.99,out_dir_rh,"V3A+IPS0+IPS1","hV4+VO1+VO2",0)

cmat=zeros([nrois,1]); 
cmat(rois=='V3A' | rois=='IPS0' | rois=='IPS1' | rois=='IPS2' | rois=='IPS3') = 1;
cmat(rois=='hV4' | rois=='VO1' | rois=='VO2' | rois=='PHC1' | rois=='PHC2') = -1;
make_diffMap(rh_z_list,rh_p_list,rois,cmat,"union",0.99,out_dir_rh,"V3A+IPS0+IPS1+IPS2+IPS3","hV4+VO1+VO2+PHC1+PHC2",0)

cmat=zeros([nrois,1]); 
cmat(rois=='IPS0' | rois=='IPS1') = 1;
cmat(rois=='VO1' | rois=='VO2') = -1;
make_diffMap(rh_z_list,rh_p_list,rois,cmat,"union",0.99,out_dir_rh,"IPS0+IPS1","VO1+VO2",0)

cmat=zeros([nrois,1]); 
cmat(rois=='IPS0' | rois=='IPS1' | rois=='IPS2' | rois=='IPS3') = 1;
cmat(rois=='VO1' | rois=='VO2' | rois=='PHC1' | rois=='PHC2') = -1;
make_diffMap(rh_z_list,rh_p_list,rois,cmat,"union",0.99,out_dir_rh,"IPS0+IPS1+IPS2+IPS3","VO1+VO2+PHC1+PHC2",0)

% Late lateral vs dorsal/ventral
cmat=zeros([nrois,1]); 
cmat(rois=='LO1' | rois=='LO2') = 1;
cmat(rois=='VO1' | rois=='VO2')= -1;
make_diffMap(rh_z_list,rh_p_list,rois,cmat,"union",0.99,out_dir_rh,"LO1+LO2","VO1+VO2",0)

cmat=zeros([nrois,1]); 
cmat(rois=='LO1' | rois=='LO2') = 1;
cmat(rois=='V3A' | rois=='V3B') = -1;
make_diffMap(rh_z_list,rh_p_list,rois,cmat,"union",0.99,out_dir_rh,"LO1+LO2","V3A+V3B",0)

cmat=zeros([nrois,1]); 
cmat(rois=='LO1' | rois=='LO2' | rois=='TO1') = 1;
cmat(rois=='VO1' | rois=='VO2')= -1;
make_diffMap(rh_z_list,rh_p_list,rois,cmat,"union",0.99,out_dir_rh,"LO1+LO2+TO1","VO1+VO2",0)

cmat=zeros([nrois,1]); 
cmat(rois=='LO1' | rois=='LO2' | rois=='TO2') = 1;
cmat(rois=='V3A' | rois=='V3B') = -1;
make_diffMap(rh_z_list,rh_p_list,rois,cmat,"union",0.99,out_dir_rh,"LO1+LO2+TO1","V3A+V3B",0)

%% Contralateral
cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='V1d' | lhrh_rois=='V2d' | lhrh_rois=='V3d')) = 1;
cmat(rh_idx & (lhrh_rois=='V1d' | lhrh_rois=='V2d' | lhrh_rois=='V3d')) = -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_V1d+V2d+V3d",0)

cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='V1v' | lhrh_rois=='V2v' | lhrh_rois=='V3v')) = 1;
cmat(rh_idx & (lhrh_rois=='V1v' | lhrh_rois=='V2v' | lhrh_rois=='V3v')) = -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_V1v+V2v+V3v",0)

cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='V1d')) = 1;
cmat(rh_idx & (lhrh_rois=='V1d')) = -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_V1d",1)

cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='V1v')) = 1;
cmat(rh_idx & (lhrh_rois=='V1v')) = -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_V1v",0)

cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='V2d')) = 1;
cmat(rh_idx & (lhrh_rois=='V2d')) = -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_V2d",0)

cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='V2v')) = 1;
cmat(rh_idx & (lhrh_rois=='V2v')) = -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_V2v",0)

cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='V3d')) = 1;
cmat(rh_idx & (lhrh_rois=='V3d')) = -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_V3d",0)

cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='V3v')) = 1;
cmat(rh_idx & (lhrh_rois=='V3v')) = -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_V3v",0)

% Late dorsal vs. ventral
cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='V3A')) = 1;
cmat(rh_idx & (lhrh_rois=='V3A')) = -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_hV4",0)

cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='hV4')) = 1;
cmat(rh_idx & (lhrh_rois=='hV4')) = -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_hV4",0)

cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='V3A' | lhrh_rois=='IPS0' | lhrh_rois=='IPS1')) = 1;
cmat(rh_idx & (lhrh_rois=='V3A' | lhrh_rois=='IPS0' | lhrh_rois=='IPS1')) = -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_V3A+IPS0+IPS1",0)

cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='hV4' | lhrh_rois=='VO1' | lhrh_rois=='VO2')) = 1;
cmat(rh_idx & (lhrh_rois=='hV4' | lhrh_rois=='VO1' | lhrh_rois=='VO2')) = -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_hV4+VO1+VO2",0)

cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='V3A' | lhrh_rois=='IPS0' | lhrh_rois=='IPS1' | lhrh_rois=='IPS2' | lhrh_rois=='IPS3')) = 1;
cmat(rh_idx & (lhrh_rois=='V3A' | lhrh_rois=='IPS0' | lhrh_rois=='IPS1' | lhrh_rois=='IPS2' | lhrh_rois=='IPS3')) = -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_V3A+IPS0+IPS1+IPS2+IPS3",0)

cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='hV4' | lhrh_rois=='VO1' | lhrh_rois=='VO2' | lhrh_rois=='PHC1' | lhrh_rois=='PHC2')) = 1;
cmat(rh_idx & (lhrh_rois=='hV4' | lhrh_rois=='VO1' | lhrh_rois=='VO2' | lhrh_rois=='PHC1' | lhrh_rois=='PHC2')) = -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_hV4+VO1+VO2+PHC1+PHC2",0)

cmat=zeros([2*nrois,1]);
cmat(lh_idx & (lhrh_rois=='IPS0' | lhrh_rois=='IPS1')) = 1;
cmat(rh_idx & (lhrh_rois=='IPS0' | lhrh_rois=='IPS1')) = -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_IPS0+IPS1",0)

cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='VO1' | lhrh_rois=='VO2')) = 1;
cmat(rh_idx & (lhrh_rois=='VO1' | lhrh_rois=='VO2')) = -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_VO1+VO2",0)

cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='IPS0' | lhrh_rois=='IPS1' | lhrh_rois=='IPS2' | lhrh_rois=='IPS3')) = 1;
cmat(rh_idx & (lhrh_rois=='IPS0' | lhrh_rois=='IPS1' | lhrh_rois=='IPS2' | lhrh_rois=='IPS3')) = -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_IPS0+IPS1+IPS2+IPS3",0)

cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='VO1' | lhrh_rois=='VO2' | lhrh_rois=='PHC1' | lhrh_rois=='PHC2')) = 1;
cmat(rh_idx & (lhrh_rois=='VO1' | lhrh_rois=='VO2' | lhrh_rois=='PHC1' | lhrh_rois=='PHC2')) = -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_VO1+VO2+PHC1+PHC2",0)

% Late lateral vs dorsal/ventral
cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='LO1' | lhrh_rois=='LO2')) = 1;
cmat(rh_idx & (lhrh_rois=='LO1' | lhrh_rois=='LO2'))= -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_LO1+LO2",0)

cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='VO1' | lhrh_rois=='VO2')) = 1;
cmat(rh_idx & (lhrh_rois=='VO1' | lhrh_rois=='VO2'))= -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_VO1+VO2",0)

cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='V3A' | lhrh_rois=='V3B')) = 1;
cmat(rh_idx & (lhrh_rois=='V3A' | lhrh_rois=='V3B')) = -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_V3A+V3B",0)

cmat=zeros([2*nrois,1]); 
cmat(lh_idx & (lhrh_rois=='LO1' | lhrh_rois=='LO2' | lhrh_rois=='TO1')) = 1;
cmat(rh_idx & (lhrh_rois=='LO1' | lhrh_rois=='LO2' | lhrh_rois=='TO1'))= -1;
make_diffMap(lhrh_z_list,lhrh_p_list,lhrh_rois,cmat,"union",0.99,out_dir_contra,"lh","rh_LO1+LO2+TO1",0)
