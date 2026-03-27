all_sess=$(cat sessid_overlap)
sess_odd=()
sess_even=()

all_sess=(${all_sess// / })

for ((i=0;i<${#all_sess[@]};i++)); do
  sess_first+=("${all_sess[$i]}")
  sess_second+=("${all_sess[${i}+1]}")
  i=$((i+1))
done

for ((i=0;i<${#sess_first[@]};i++)); do
  subj="${sess_first[$i]: -2}"
  mkdir -p avg${subj}/corrMaps/cort_networks_to_cb/lh
  mkdir -p avg${subj}/corrMaps/cort_networks_to_cb/rh

  echo $subj

  for roi in $(cat lh_rois); do
    fslmerge -t avg${subj}/corrMaps/cort_networks_to_cb/lh/all.lh.${roi}.nii.gz ${sess_first[$i]}/corrMaps/cort_networks_to_cb/lh/lh.${roi}.nii.gz ${sess_second[$i]}/corrMaps/cort_networks_to_cb/lh/lh.${roi}.nii.gz
    fslmaths avg${subj}/corrMaps/cort_networks_to_cb/lh/all.lh.${roi}.nii.gz -Tmean avg${subj}/corrMaps/cort_networks_to_cb/lh/lh.${roi}.nii.gz
  done
  for roi in $(cat rh_rois); do
    fslmerge -t avg${subj}/corrMaps/cort_networks_to_cb/rh/all.rh.${roi}.nii.gz ${sess_first[$i]}/corrMaps/cort_networks_to_cb/rh/rh.${roi}.nii.gz ${sess_second[$i]}/corrMaps/cort_networks_to_cb/rh/rh.${roi}.nii.gz
    fslmaths avg${subj}/corrMaps/cort_networks_to_cb/rh/all.rh.${roi}.nii.gz -Tmean avg${subj}/corrMaps/cort_networks_to_cb/rh/rh.${roi}.nii.gz
  done
done
