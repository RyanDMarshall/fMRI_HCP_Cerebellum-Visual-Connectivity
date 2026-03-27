function [cbllmwtmap] = createGroupSigMap(hemi)
    projectdir='/projectnb/somerslab/ryanmars/projects/CrossTaskAnalysis/proj_allrest/group/corrMaps/AV_prob_labels-ctx-to-cb/Normalized_CorrMaps/aud-vs-vis/group';

    % load cerebellar volume
    cbllm = MRIread('/projectnb/somerslab/SUITmasks/SUITtemplatemask.2mm.nii');
    cbllmidx = find(cbllm.vol);

    sig_pos_corr_fn = sprintf('%s/%s_perm_vsm4_tfce_corrp_tstat1.nii.gz',projectdir,hemi);
    sig_neg_corr_fn = sprintf('%s/neg.%s_perm_vsm4_tfce_corrp_tstat1.nii.gz',projectdir,hemi);

    sig_pos = MRIread(sig_pos_corr_fn); 
    sig_neg = MRIread(sig_neg_corr_fn); 

    sig_pos_vec = sig_pos.vol(cbllmidx);
    sig_neg_vec = sig_neg.vol(cbllmidx);

    % get indices of positive and negative values 
    posidx = find(sig_pos_vec >= sig_neg_vec); 
    negidx = find(sig_neg_vec > sig_pos_vec); 

    % combine positive and negative -log10(p) values
    mapvec = nan(length(cbllmidx),1);
    mapvec(posidx) = sig_pos_vec(posidx);
    mapvec(negidx) = -sig_neg_vec(negidx); % reverse sign

    % create volumetric weight map
    cbllmwtmap = cbllm;
    cbllmwtmap.vol = double(zeros(cbllmwtmap.volsize));
    cbllmwtmap.vol(cbllmidx) = mapvec;

    % save
    MRIwrite(cbllmwtmap,sprintf('%s/%s.sig.zperm.weight.tfce.vsm4.discriminancemap.SUIT.nii.gz',projectdir,hemi));
    end
