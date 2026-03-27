data_dir=/projectnb/somerslab/ryanmars/projects/CrossTaskAnalysis/proj_allrest/data/HCP_RS
sessid_list=$data_dir/sessid-list
sessions=$(cat $sessid_list)

for sess in $(echo $sessions); do
	rfmri="concatenated_normalized_rfMRI_7T_Atlas_1.6mm_MSMAll.dtseries.nii"
	mfmri="concatenated_normalized_tfMRI_MOVIE_7T_Atlas_1.6mm_MSMAll.dtseries.nii"

	cd $data_dir/$sess

	wb_command -cifti-separate $rfmri COLUMN -metric CORTEX_LEFT $(echo $rfmri | sed 's/.dtseries.nii/.CortexLeft.dtseries.func.gii/')
	wb_command -cifti-separate $rfmri COLUMN -metric CORTEX_RIGHT $(echo $rfmri | sed 's/.dtseries.nii/.CortexRight.dtseries.func.gii/')
	#wb_command -cifti-separate $rfmri COLUMN -metric CEREBELLUM_LEFT $(echo $rfmri | sed 's/.dtseries.nii/.CerebellumLeft.dtseries.func.gii/')
	#wb_command -cifti-separate $rfmri COLUMN -metric CEREBELLUM_RIGHT $(echo $rfmri | sed 's/.dtseries.nii/.CerebellumRight.dtseries.func.gii/')

	wb_command -cifti-separate $mfmri COLUMN -metric CORTEX_LEFT $(echo $mfmri | sed 's/.dtseries.nii/.CortexLeft.dtseries.func.gii/')
	wb_command -cifti-separate $mfmri COLUMN -metric CORTEX_RIGHT $(echo $mfmri | sed 's/.dtseries.nii/.CortexRight.dtseries.func.gii/')
	#wb_command -cifti-separate $mfmri COLUMN -metric CEREBELLUM_LEFT $(echo $mfmri | sed 's/.dtseries.nii/.CerebellumLeft.dtseries.func.gii/')
	#wb_command -cifti-separate $mfmri COLUMN -metric CEREBELLUM_RIGHT $(echo $mfmri | sed 's/.dtseries.nii/.CerebellumRight.dtseries.func.gii/')

	echo "Completed extractions for subject: " $sess
done
