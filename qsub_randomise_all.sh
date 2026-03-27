proj_dir="/projectnb/somerslab/ryanmars/projects/CrossTaskAnalysis/proj_allrest/results/group/HCP_SUIT"; cd $proj_dir
map_list="$proj_dir/concatenated_subjects_list.txt"
map_count=$(cat $map_list | wc -l);

for (( i=1; i<=$map_count; i++ )); do
	map_fn=$(cat $map_list | head -$i | tail -1)
	roi=$(echo "$map_fn" | awk -F/ '{print $2}')
	hemi=$(echo "$map_fn" | grep -o "lh\|rh\|bilat")
	corr_type=$(echo "$map_fn" | grep -o "pearson\|partial")
	map_stem=$(echo "$map_fn" | awk -F/ '{print $NF}')

	job_name="run_randomise_on_${corr_type}_${hemi}_${roi}"
	qsub_name=${job_name}.qsub
	cp run_randomise_on_map.qsub $qsub_name
	sed -i "34i #$ -N "$job_name" " $qsub_name
	sed -i "65i $proj_dir/run_randomise_on_map.sh $map_fn" $qsub_name
	qsub $qsub_name
done
