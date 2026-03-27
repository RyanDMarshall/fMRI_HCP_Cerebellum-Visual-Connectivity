dir=/projectnb/somerslab/ryanmars/projects/CrossTaskAnalysis/proj_allrest
cd $dir

for sess in $(cat sessid-rest-ray); do
	for run in $(cat $sess/rest/runlist); do
		log=$dir/logs/${sess}.${run}.regSUIT.log
		
		#if [ -f "$dir/$sess/rest/$run/f.mcpr.sc.int.bpf.residMGSR.inner.SUIT.func.gii" ]; then continue; fi
		
		echo registerSUIT.sh -s $sess -fsd rest -funcfn f.mcpr.sc.int.bpf.residMGSR.nii.gz -r $run -fwhm 3 -reg2native -tr 2000 -savesurf
		registerSUIT.sh -s $sess -fsd rest -funcfn f.mcpr.sc.int.bpf.residMGSR.nii.gz -r $run -fwhm 3 -reg2native -tr 2000 -savesurf > $log
	done
done
