function [norm, normvol] = create_norms(tstat_files,tfce_files,maskthr,outfns)

    tstat_files=tstat_files{:}; tfce_files=tfce_files{:};
    nfiles=length(tstat_files);

    for i = 1:nfiles
        outfn = outfns{i};

        norm = standardize_nifti(tstat_files{i}); normvol=norm.vol;
        masknorm = binarize_nifti(tfce_files{i}, maskthr); maskvol = masknorm.vol;
    
        masknorm.vol = normvol .* maskvol;
        
        MRIwrite(norm,sprintf('%s.norm.nii.gz',outfn));
        MRIwrite(masknorm,sprintf('%s.masknorm.nii.gz',outfn));
    end
end