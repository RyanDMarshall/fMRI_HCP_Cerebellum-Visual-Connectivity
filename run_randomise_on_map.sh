# $1 = ROI
# $2 = hemi ('lh', 'rh' for partial; 'lh' 'rh' 'bilat' for pearson)
# $3 = corr_type ('pearson' or 'partial')
run_randomise_on_map () {
	cwd="$(pwd)";pwd
	map_fn=$1
	roi=$(echo "$map_fn" | awk -F/ '{print $2}')
	hemi=$(echo "$map_fn" | grep -o "lh\|rh\|bilat")
	corr_type=$(echo "$map_fn" | grep -o "pearson\|partial")
	map_stem=$(echo "$map_fn" | awk -F/ '{print $NF}')
	cd "$cwd/$roi/perms-${corr_type}_unthresholded_fisherz"
	echo "randomise -i $map_stem -o perm_vsm4_${roi}_${hemi}_${corr_type} -1 -m /projectnb/somerslab/vaibhavt/standard.nii.gz -n 5000 -T -v 4 -R"
	randomise -i $map_stem -o perm_vsm4_${roi}_${hemi}_${corr_type} -1 -m /projectnb/somerslab/vaibhavt/standard.nii.gz -n 5000 -T -v 4 -R
	cd $cwd
}

run_randomise_on_map $1
