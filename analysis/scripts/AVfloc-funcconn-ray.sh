
base_dir="/projectnb/somerslab/ryanmars/projects/CrossTaskAnalysis/proj_allrest"
search_dir="/projectnb/somerslab/rwlefco/AVFLoc/AV_2017_Abby/subjects"

for sess in $(cat sessid-rest-ray); do 
	for seed in "sPCS" "iPCS" "midIFS"; do
		for hemi in lh rh; do 
			cd $base_dir
			echo $sess
			out_dir=$base_dir/$sess
			rest_dir=$out_dir/rest/sessdata
			subj_name=$(cat $base_dir/$sess/subjectname);
			subj_id=$(echo ${subj_name::2} | tr '[:lower:]' '[:upper:]')
			subj_label_dir=$search_dir/$sess/labels
			mkdir -p $out_dir/labels
			cp $subj_label_dir/$hemi.$seed.label $out_dir/labels/$hemi.$seed.label
			mkdir -p $out_dir/seedTimeCourses/AV_prob_labels-ctx-to-cb; 
			mkdir -p $out_dir/corrMaps/AV_prob_labels-ctx-to-cb; 
			echo extract_timecourse.sh -f $rest_dir/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.fsaverage.$hemi.nii.gz -i $subj_label_dir/${hemi}.${seed}.label -d $out_dir/seedTimeCourses/AV_prob_labels-ctx-to-cb/; 
			extract_timecourse.sh -f $rest_dir/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.fsaverage.$hemi.nii.gz -i $subj_label_dir/${hemi}.${seed}.label -d $out_dir/seedTimeCourses/AV_prob_labels-ctx-to-cb/; 
			echo seed_corr.sh -f $rest_dir/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.SUIT.nii.gz -i $out_dir/seedTimeCourses/AV_prob_labels-ctx-to-cb/${hemi}_${seed}.dat -o $out_dir/corrMaps/AV_prob_labels-ctx-to-cb/${hemi}_${seed}_cb.corrMap.nii; 
			seed_corr.sh -f $rest_dir/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.SUIT.nii.gz -i $out_dir/seedTimeCourses/AV_prob_labels-ctx-to-cb/${hemi}_${seed}.dat -o $out_dir/corrMaps/AV_prob_labels-ctx-to-cb/${hemi}_${seed}_cb.corrMap.nii; 

			cd $out_dir/corrMaps/AV_prob_labels-ctx-to-cb/;
			createSUITSurfaceOverlay.sh -f ${hemi}_${seed}_cb.corrMap.nii
		done; 
	done; 
done


