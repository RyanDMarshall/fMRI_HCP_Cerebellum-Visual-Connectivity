#takes in subjectname, finds matching pair of resting-state data and outputs the session ids
findpair() {
	subjectname=$1
	subjectname=$(echo ${subjectname:0:2} | tr ['lower'] ['upper'])
	rest_ids=$(cat sessid-rest | grep $subjectname)
	
	echo $rest_ids
}

for sess in $(cat sessid-rest); do 
	subjectname=$(echo -n ${sess:(-2)} | tr '[:upper:]' '[:lower:]'; echo 53); 
	echo $subjectname > $sess/subjectname;

	if [[ $(cat subjid-rest | grep $subjectname | wc -l) > 1 ]]; then 
		mkdir -p all_${sess:(-2)};
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
	echo $subjectname > dup_sess/subjectname

	echo mri_concat --i $sessid_1/rest/sessdata/f.mcpr.sc.int.bpf.residMGSR.censor.SUIT.sm3.nii.gz --i $sessid_2/rest/sessdata/f.mcpr.sc.int.bpf.residMGSR.censor.SUIT.sm3.nii.gz --o $out_dir/f.mcpr.sc.int.bpf.residMGSR.censor.SUIT.sm3.nii.gz
	mri_concat --i $sessid_1/rest/sessdata/f.mcpr.sc.int.bpf.residMGSR.censor.SUIT.sm3.nii.gz --i $sessid_2/rest/sessdata/f.mcpr.sc.int.bpf.residMGSR.censor.SUIT.sm3.nii.gz --o $out_dir/f.mcpr.sc.int.bpf.residMGSR.censor.SUIT.sm3.nii.gz
	echo mri_concat --i $sessid_1/rest/sessdata/f.mcpr.sc.int.bpf.residMGSR.censor.fsaverage.lh.sm3.nii.gz --i $sessid_2/rest/sessdata/f.mcpr.sc.int.bpf.residMGSR.censor.fsaverage.lh.sm3.nii.gz --o $out_dir/f.mcpr.sc.int.bpf.residMGSR.censor.fsaverage.lh.sm3.nii.gz
	mri_concat --i $sessid_1/rest/sessdata/f.mcpr.sc.int.bpf.residMGSR.censor.fsaverage.lh.sm3.nii.gz --i $sessid_2/rest/sessdata/f.mcpr.sc.int.bpf.residMGSR.censor.fsaverage.lh.sm3.nii.gz --o $out_dir/f.mcpr.sc.int.bpf.residMGSR.censor.fsaverage.lh.sm3.nii.gz
	echo mri_concat --i $sessid_1/rest/sessdata/f.mcpr.sc.int.bpf.residMGSR.censor.fsaverage.rh.sm3.nii.gz --i $sessid_2/rest/sessdata/f.mcpr.sc.int.bpf.residMGSR.censor.fsaverage.rh.sm3.nii.gz --o $out_dir/f.mcpr.sc.int.bpf.residMGSR.censor.fsaverage.rh.sm3.nii
	mri_concat --i $sessid_1/rest/sessdata/f.mcpr.sc.int.bpf.residMGSR.censor.fsaverage.rh.sm3.nii.gz --i $sessid_2/rest/sessdata/f.mcpr.sc.int.bpf.residMGSR.censor.fsaverage.rh.sm3.nii.gz --o $out_dir/f.mcpr.sc.int.bpf.residMGSR.censor.fsaverage.rh.sm3.nii

done
