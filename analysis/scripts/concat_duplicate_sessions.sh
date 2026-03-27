#takes in subjectname, finds matching pair of resting-state data and outputs the session ids
findpair() {
	subjectname=$1
	subjectname=$(echo ${subjectname::2} | tr ['lower'] ['upper'])
	rest_ids=$(cat sessid-rest | grep $subjectname)
	
	echo $rest_ids
}

for sess in $(cat sessid-rest); do 
	subjectname=$(echo -n ${sess:(-2)} | tr '[:upper:]' '[:lower:]'; echo 53); 
	echo $subjectname > $sess/subjectname;

	if [[ $(cat subjid-rest | grep $subjectname | wc -l) > 1 ]]; then 
		mkdir -p all_${sess:(-2)};
		echo $subjectname > all_${sess:(-2)}/subjectname
	fi
done

for dup_sess in $(ls -d 1 all_* | uniq); do
	dup_sess=$(echo $dup_sess | sed 's/://')
	out_dir=$dup_sess
	subj=${dup_sess:(-2)}
	sessid_pair=$(findpair $subj)
	echo "$sessid_pair" > $dup_sess/sessid-rest
	sessid_1=${sessid_pair::8}
	sessid_2=${sessid_pair:(-8)}
	echo $sessid_1 $sessid_2
	subjectname=$(echo -n $subj | tr '[:upper:]' '[:lower:]'; echo 53); 
	echo $subjectname
	rest_dir=$out_dir/rest/sessdata
	mkdir -p $rest_dir
	echo mri_concat --i $sessid_1/rest/sessdata/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.SUIT.nii.gz--i $sessid_2/rest/sessdata/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.SUIT.nii.gz --o $rest_dir/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.SUIT.sm3.nii.gz
	mri_concat --i $sessid_1/rest/sessdata/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.SUIT.nii.gz--i $sessid_2/rest/sessdata/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.SUIT.nii.gz --o $rest_dir/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.SUIT.sm3.nii.gz
	echo mri_concat --i $sessid_1/rest/sessdata/f.mcpr.sm3.sc.int.bpf.resiCompCor5.censor.fsaverage.lh.nii.gz --i $sessid_2/rest/sessdata/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.fsaverage.lh.nii.gz --o $rest_dir/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.fsaverage.lh.nii.gz
	mri_concat --i $sessid_1/rest/sessdata/f.mcpr.sm3.sc.int.bpf.resiCompCor5.censor.fsaverage.lh.nii.gz --i $sessid_2/rest/sessdata/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.fsaverage.lh.nii.gz --o $rest_dir/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.fsaverage.lh.nii.gz
	echo mri_concat --i $sessid_1/rest/sessdata/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.fsaverage.rh.nii.gz --i $sessid_2/rest/sessdata/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.fsaverage.rh.nii.gz --o $out_dir/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.fsaverage.rh.nii.gz
	mri_concat --i $sessid_1/rest/sessdata/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.fsaverage.rh.nii.gz --i $sessid_2/rest/sessdata/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.fsaverage.rh.nii.gz --o $out_dir/f.mcpr.sm3.sc.int.bpf.residCompCor5.censor.fsaverage.rh.nii.gz

	mkdir -p $out_dir/labels
	cp -r $sessid_1/labels/ $out_dir/labels
	cp -r $sessid_2/labels/ $out_dir/labels
done
