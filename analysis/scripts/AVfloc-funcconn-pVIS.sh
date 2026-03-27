for sess in $(cat sessid-pVIS); do 
	for seed in "dorsal-p-VIS" "ventral-p-VIS" "ventral-temporal" "lateral-occipital"; do 
		for hemi in lh rh; do 
			cd /projectnb/somerslab/ryanmars/projects/CrossTaskAnalysis/proj_allrest;
			echo $sess
			subjname=$(cat $sess/subjectname); 
			labeldir=/projectnb/somerslab/recons/$subjname/label

			mkdir -p $sess/seedTimeCourses/pVIS-ctx-to-cb; 
			mkdir -p $sess/corrMaps/pVIS-ctx-to-cb; 
			echo extract_timecourse.sh -f $sess/rest/sessdata/f.mcpr.sc.int.bpf.residMGSR.censor.fsaverage.$hemi.sm3.nii.gz -i $labeldir/${hemi}.${seed}.label -d $sess/seedTimeCourses/pVIS-ctx-to-cb/ -o ${hemi}.${seed}.dat; 
			extract_timecourse.sh -f $sess/rest/sessdata/f.mcpr.sc.int.bpf.residMGSR.censor.fsaverage.$hemi.sm3.nii.gz -i $labeldir/${hemi}.${seed}.label -d $sess/seedTimeCourses/pVIS-ctx-to-cb/ -o ${hemi}.${seed}.dat; 
			echo seed_corr.sh -f $sess/rest/sessdata/f.mcpr.sc.int.bpf.residMGSR.censor.SUIT.sm3.nii.gz -i $sess/seedTimeCourses/pVIS-ctx-to-cb/${hemi}.${seed}.dat -o $sess/corrMaps/pVIS-ctx-to-cb/${hemi}.${seed}.corrMap.nii; 
			seed_corr.sh -f $sess/rest/sessdata/f.mcpr.sc.int.bpf.residMGSR.censor.SUIT.sm3.nii.gz -i $sess/seedTimeCourses/pVIS-ctx-to-cb/${hemi}.${seed}.dat -o $sess/corrMaps/pVIS-ctx-to-cb/${hemi}.${seed}.corrMap.nii; 

			cd $sess/corrMaps/pVIS-ctx-to-cb/;
			createSUITSurfaceOverlay.sh -f ${hemi}.${seed}.corrMap.nii
		done; 
	done; 
done
