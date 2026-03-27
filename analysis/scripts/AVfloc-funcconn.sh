
base_dir="/projectnb/somerslab/ryanmars/projects/CrossTaskAnalysis/proj_allrest"
search_dir="/projectnb/somerslab/rwlefco/AVFLoc/AV_2017_Abby/subjects"

for sess in $(cat sessid-rest-merged-dups); do 
	for seed in "sPCS" "iPCS" "midIFS"; do
		for hemi in lh rh; do 
			cd $base_dir
			echo $sess
			out_dir=$base_dir/$sess
			rest_dir=$out_dir/rest/sessdata
			sub_dir=AV_prob_labels-ctx-to-cb
			subj_name=$(cat $base_dir/$sess/subjectname);
			subj_id=$(echo ${subj_name::2} | tr '[:lower:]' '[:upper:]')
			echo $subj_name $subj_id
			if [[ ${sess::3} -eq "all" ]]; then
				echo "Finding session labels..."	
				sess_ids=$(cat $base_dir/sessid-rest | grep $subj_id);

				echo $sess_ids
				sess_id1="${sess_ids::8}"
				sess_id2="${sess_ids:(-8)}"
				echo $sess_id1 $sess_id2

				if [[ (-d $search_dir/$sess_id1/labels) && $(ls $search_dir/$sess_id1/labels | wc -l) > 0 ]]; then
					subj_label_dir=$search_dir/$sess_id1/labels
				else
			 		subj_label_dir=$search_dir/$sess_id2/labels
				fi			
			else
				subj_label_dir=$sess/labels
			fi

			echo $subject_label_dir
			echo $out_dir
			mkdir -p $out_dir/labels
			cp $subj_label_dir/$hemi.$seed.label $out_dir/labels/$hemi.$seed.label
			mkdir -p $out_dir/seedTimeCourses/$sub_dir; 
			mkdir -p $out_dir/corrMaps/$sub_dir; 
			echo extract_timecourse.sh -f $rest_dir/f.mcpr.sc.int.bpf.residMGSR.censor.fsaverage.$hemi.sm3.nii.gz -i $subj_label_dir/${hemi}.${seed}.label -d $out_dir/seedTimeCourses/$sub_dir/; 
			extract_timecourse.sh -f $rest_dir/f.mcpr.sc.int.bpf.residMGSR.censor.fsaverage.$hemi.sm3.nii.gz -i $subj_label_dir/${hemi}.${seed}.label -d $out_dir/seedTimeCourses/$sub_dir/; 
			echo seed_corr.sh -f $rest_dir/f.mcpr.sc.int.bpf.residMGSR.censor.SUIT.sm3.nii.gz -i $out_dir/seedTimeCourses/$sub_dir/${hemi}_${seed}.dat -o $out_dir/corrMaps/$sub_dir/${hemi}_${seed}_cb.corrMap.nii; 
			seed_corr.sh -f $rest_dir/f.mcpr.sc.int.bpf.residMGSR.censor.SUIT.sm3.nii.gz -i $out_dir/seedTimeCourses/$sub_dir/${hemi}_${seed}.dat -o $out_dir/corrMaps/$sub_dir/${hemi}_${seed}_cb.corrMap.nii; 

			cd $out_dir/corrMaps/$sub_dir/;
			createSUITSurfaceOverlay.sh -f ${hemi}_${seed}_cb.corrMap.nii
		done; 
	done; 
done


