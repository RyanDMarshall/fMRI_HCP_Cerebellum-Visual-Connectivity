delete(gcp('nocreate'))
nCores = str2num(getenv('NSLOTS'));

project_dir="/projectnb/somerslab/ryanmars/projects/CrossTaskAnalysis/proj_allrest/results/group/HCP_SUIT";
cd(project_dir)
pooldir=sprintf('~/.matlab/local_cluster_jobs');
pooljob=sprintf('%s/%s_pool%d',pooldir);

mkdir(pooldir);mkdir(pooljob);

pc = parcluster('local');
pc.JobStorageLocation = pooljob;
parpool(pc,nCores);
fname=sprintf('%s/%s',project_dir,'concatenated_subjects_list.txt');
map_fid=fopen(fname);
map_fnames=textscan(map_fid,'%s');map_fnames=map_fnames{1};

startidx = 1;
endidx = length(map_fnames);
for paridx = startidx:endidx
    cd(project_dir);
	map_fname=map_fnames{paridx};
	run_randomise_on_map(map_fname)
end
