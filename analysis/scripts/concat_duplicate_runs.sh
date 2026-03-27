for sess in $(cat sessid-rest-ray); do
	out_dir=$sess
	rest_dir=$out_dir/rest/sessdata
	subj=${sess:(-2)}
	subjectname=$(echo -n $subj | tr '[:upper:]' '[:lower:]'; echo 53); 
	
	mkdir -p $rest_dir

	runs=$(cat $sess/rest/runlist)
	rm -rf temp*
	
	touch temp_fsave_lh_list.txt
	touch temp_fsave_rh_list.txt
	touch temp_SUIT_list.txt
	for run in $(echo $runs); do 	
		echo $sess/rest/$run/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.SUIT.nii.gz >> temp_SUIT_list.txt
		echo $sess/rest/$run/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.fsaverage.lh.nii.gz >> temp_fsave_lh_list.txt
		echo $sess/rest/$run/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.fsaverage.rh.nii.gz >> temp_fsave_rh_list.txt
	done

	echo mri_concat --f temp_SUIT_list.txt --o $rest_dir/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.SUIT.nii.gz
	mri_concat --f temp_SUIT_list.txt --o $rest_dir/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.SUIT.nii.gz
	echo mri_concat --f temp_fsave_lh_list.txt --o $rest_dir/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.fsaverage.lh.nii.gz
	mri_concat --f temp_fsave_lh_list.txt --o $rest_dir/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.fsaverage.lh.nii.gz
	echo mri_concat --f temp_fsave_rh_list.txt --o $rest_dir/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.fsaverage.rh.nii.gz
	mri_concat --f temp_fsave_rh_list.txt --o $rest_dir/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.fsaverage.rh.nii.gz

done
