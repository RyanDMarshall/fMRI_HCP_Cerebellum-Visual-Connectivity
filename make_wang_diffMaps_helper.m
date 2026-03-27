function [] = make_wang_diffMaps_helper(t_list, tfce_list, rois, out_dir, hemi, masktype, maskthr, corrtype)
    if strcmp(corrtype,"standard")
        nrois=length(rois); 
        t_files=cellstr(t_list);
        tfce_files=cellstr(tfce_list);

        %% Generate effect size difference maps
        cmat=zeros([nrois,1]); 
        cmat(rois=='V1d' | rois=='V2d' | rois=='V3d') = 1;
        cmat(rois=='V1v' | rois=='V2v' | rois=='V3v') = -1;
        make_diffMap(t_files,tfce_files,rois,cmat,masktype,maskthr,out_dir,strcat(hemi,'_',"EarlyDorsal"),"EarlyVentral",0)

        cmat=zeros([nrois,1]);
        cmat(rois=='V1d') = 1;
        cmat(rois=='V1v') = -1;
        make_diffMap(t_files,tfce_files,rois,cmat,masktype,maskthr,out_dir,strcat(hemi,'_',"V1d"),"V1v",0)

        cmat=zeros([nrois,1]); 
        cmat(rois=='V2d') = 1;
        cmat(rois=='V2v') = -1;
        make_diffMap(t_files,tfce_files,rois,cmat,masktype,maskthr,out_dir,strcat(hemi,'_',"V2d"),"V2v",0)

        cmat=zeros([nrois,1]); 
        cmat(rois=='V3d') = 1;
        cmat(rois=='V3v') = -1;
        make_diffMap(t_files,tfce_files,rois,cmat,masktype,maskthr,out_dir,strcat(hemi,'_',"V3d"),"V3v",0)

        % Late dorsal vs early dorsal
        cmat=zeros([nrois,1]);
        cmat(rois=='IPS0' | rois=='IPS1' | rois=='IPS2' | rois=='IPS3') = 1;
        cmat(rois=='V1d' | rois=='V2d' | rois=='V3d') = -1;
        make_diffMap(t_files,tfce_files,rois,cmat,masktype,maskthr,out_dir,strcat(hemi,'_',"LateDorsal"),"EarlyDorsal",0)
        
        % Late ventral vs early ventral
        cmat=zeros([nrois,1]);
        cmat(rois=='VO1' | rois=='VO2' | rois=='PHC1' | rois=='PHC2') = -1;
        cmat(rois=='V1v' | rois=='V2v' | rois=='V3v') = -1;
        make_diffMap(t_files,tfce_files,rois,cmat,masktype,maskthr,out_dir,strcat(hemi,'_',"LateVentral"),"EarlyVentral",0)
        
        % Late dorsal vs. late ventral
        cmat=zeros([nrois,1]); 
        cmat(rois=='V3A') = 1;
        cmat(rois=='hV4') = -1;
        make_diffMap(t_files,tfce_files,rois,cmat,masktype,maskthr,out_dir,strcat(hemi,'_',"V3A"),"hV4",0)

        cmat=zeros([nrois,1]); 
        cmat(rois=='V3A' | rois=='IPS0' | rois=='IPS1') = 1;
        cmat(rois=='hV4' | rois=='VO1' | rois=='VO2') = -1;
        make_diffMap(t_files,tfce_files,rois,cmat,masktype,maskthr,out_dir,strcat(hemi,'_',"V3A+IPS0+IPS1"),"hV4+VO1+VO2",0)

        cmat=zeros([nrois,1]); 
        cmat(rois=='V3A' | rois=='IPS0' | rois=='IPS1' | rois=='IPS2' | rois=='IPS3') = 1;
        cmat(rois=='hV4' | rois=='VO1' | rois=='VO2' | rois=='PHC1' | rois=='PHC2') = -1;
        make_diffMap(t_files,tfce_files,rois,cmat,masktype,maskthr,out_dir,strcat(hemi,'_',"V3A+IPS0+IPS1+IPS2+IPS3"),"hV4+VO1+VO2+PHC1+PHC2",0)

        cmat=zeros([nrois,1]); 
        cmat(rois=='IPS0' | rois=='IPS1') = 1;
        cmat(rois=='VO1' | rois=='VO2') = -1;
        make_diffMap(t_files,tfce_files,rois,cmat,masktype,maskthr,out_dir,strcat(hemi,'_',"IPS0+IPS1"),"VO1+VO2",0)

        cmat=zeros([nrois,1]); 
        cmat(rois=='IPS0' | rois=='IPS1' | rois=='IPS2' | rois=='IPS3') = 1;
        cmat(rois=='VO1' | rois=='VO2' | rois=='PHC1' | rois=='PHC2') = -1;
        make_diffMap(t_files,tfce_files,rois,cmat,masktype,maskthr,out_dir,strcat(hemi,'_',"LateDorsal(IPS0+IPS1+IPS2+IPS3)"),"LateVentral(VO1+VO2+PHC1+PHC2)",0)

        % Late lateral vs late dorsal
        cmat=zeros([nrois,1]); 
        cmat(rois=='LO1' | rois=='LO2') = 1;
        cmat(rois=='IPS0' | rois=='IPS1')= -1;
        make_diffMap(t_files,tfce_files,rois,cmat,masktype,maskthr,out_dir,strcat(hemi,'_',"LO1+LO2"),"IPS01+IPS1",0)

        cmat=zeros([nrois,1]); 
        cmat(rois=='LO1' | rois=='LO2') = 1;
        cmat(rois=='V3A' | rois=='V3B') = -1;
        make_diffMap(t_files,tfce_files,rois,cmat,masktype,maskthr,out_dir,strcat(hemi,'_',"LO1+LO2"),"V3A+V3B",0)

        cmat=zeros([nrois,1]); 
        cmat(rois=='LO1' | rois=='LO2' | rois=='TO1') = 1;
        cmat(rois=='IPS0' | rois=='IPS1' | rois=='IPS2')= -1;
        make_diffMap(t_files,tfce_files,rois,cmat,masktype,maskthr,out_dir,strcat(hemi,'_',"LO1+LO2+TO1"),"IPS0+IPS1+IPS2",0)

        cmat=zeros([nrois,1]); 
        cmat(rois=='LO1' | rois=='LO2' | rois=='TO2') = 1;
        cmat(rois=='V3A' | rois=='V3B') = -1;
        make_diffMap(t_files,tfce_files,rois,cmat,masktype,maskthr,out_dir,strcat(hemi,'_',"LO1+LO2+TO1"),"V3A+V3B",0)

        % Late lateral vs late ventral
        cmat=zeros([nrois,1]); 
        cmat(rois=='LO1' | rois=='LO2') = 1;
        cmat(rois=='VO1' | rois=='VO2')= -1;
        make_diffMap(t_files,tfce_files,rois,cmat,masktype,maskthr,out_dir,strcat(hemi,'_',"LO1+LO2"),"VO1+VO2",0)

        cmat=zeros([nrois,1]); 
        cmat(rois=='LO1' | rois=='LO2' | rois=='TO1') = 1;
        cmat(rois=='VO1' | rois=='VO2')= -1;
        make_diffMap(t_files,tfce_files,rois,cmat,masktype,maskthr,out_dir,strcat(hemi,'_',"LO1+LO2+TO1"),"VO1+VO2",0)

    
    end
        
    %% Compute Pearson contralateral effect size differences
    if strcmp(corrtype,"contralateral")
        nrois=length(rois);
        t_files=reshape(cellstr(t_list),[2*nrois,1]);
        tfce_files=reshape(cellstr(tfce_list),[2*nrois,1]);
        rois_contra=[rois;rois];
        lh_idx=[ones([nrois,1]);zeros([nrois,1])];
        rh_idx=[zeros([nrois,1]);ones([nrois,1])];

        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='V1d' | rois_contra=='V2d' | rois_contra=='V3d')) = 1;
        cmat(rh_idx & (rois_contra=='V1d' | rois_contra=='V2d' | rois_contra=='V3d')) = -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_V1d+V2d+V3d",1)

        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='V1v' | rois_contra=='V2v' | rois_contra=='V3v')) = 1;
        cmat(rh_idx & (rois_contra=='V1v' | rois_contra=='V2v' | rois_contra=='V3v')) = -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_V1v+V2v+V3v",0)

        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='V1d')) = 1;
        cmat(rh_idx & (rois_contra=='V1d')) = -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_V1d",1)

        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='V1v')) = 1;
        cmat(rh_idx & (rois_contra=='V1v')) = -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_V1v",0)

        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='V2d')) = 1;
        cmat(rh_idx & (rois_contra=='V2d')) = -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_V2d",0)

        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='V2v')) = 1;
        cmat(rh_idx & (rois_contra=='V2v')) = -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_V2v",0)

        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='V3d')) = 1;
        cmat(rh_idx & (rois_contra=='V3d')) = -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_V3d",0)

        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='V3v')) = 1;
        cmat(rh_idx & (rois_contra=='V3v')) = -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_V3v",0)

        % Late dorsal vs. ventral
        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='V3A')) = 1;
        cmat(rh_idx & (rois_contra=='V3A')) = -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_hV4",0)

        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='hV4')) = 1;
        cmat(rh_idx & (rois_contra=='hV4')) = -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_hV4",0)

        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='V3A' | rois_contra=='IPS0' | rois_contra=='IPS1')) = 1;
        cmat(rh_idx & (rois_contra=='V3A' | rois_contra=='IPS0' | rois_contra=='IPS1')) = -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_V3A+IPS0+IPS1",0)

        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='hV4' | rois_contra=='VO1' | rois_contra=='VO2')) = 1;
        cmat(rh_idx & (rois_contra=='hV4' | rois_contra=='VO1' | rois_contra=='VO2')) = -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_hV4+VO1+VO2",0)

        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='V3A' | rois_contra=='IPS0' | rois_contra=='IPS1' | rois_contra=='IPS2' | rois_contra=='IPS3')) = 1;
        cmat(rh_idx & (rois_contra=='V3A' | rois_contra=='IPS0' | rois_contra=='IPS1' | rois_contra=='IPS2' | rois_contra=='IPS3')) = -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_V3A+IPS0+IPS1+IPS2+IPS3",0)

        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='hV4' | rois_contra=='VO1' | rois_contra=='VO2' | rois_contra=='PHC1' | rois_contra=='PHC2')) = 1;
        cmat(rh_idx & (rois_contra=='hV4' | rois_contra=='VO1' | rois_contra=='VO2' | rois_contra=='PHC1' | rois_contra=='PHC2')) = -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_hV4+VO1+VO2+PHC1+PHC2",0)

        cmat=zeros([2*nrois,1]);
        cmat(lh_idx & (rois_contra=='IPS0' | rois_contra=='IPS1')) = 1;
        cmat(rh_idx & (rois_contra=='IPS0' | rois_contra=='IPS1')) = -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_IPS0+IPS1",0)

        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='VO1' | rois_contra=='VO2')) = 1;
        cmat(rh_idx & (rois_contra=='VO1' | rois_contra=='VO2')) = -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_VO1+VO2",0)

        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='IPS0' | rois_contra=='IPS1' | rois_contra=='IPS2' | rois_contra=='IPS3')) = 1;
        cmat(rh_idx & (rois_contra=='IPS0' | rois_contra=='IPS1' | rois_contra=='IPS2' | rois_contra=='IPS3')) = -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_IPS0+IPS1+IPS2+IPS3",0)

        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='VO1' | rois_contra=='VO2' | rois_contra=='PHC1' | rois_contra=='PHC2')) = 1;
        cmat(rh_idx & (rois_contra=='VO1' | rois_contra=='VO2' | rois_contra=='PHC1' | rois_contra=='PHC2')) = -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_VO1+VO2+PHC1+PHC2",0)

        % Late lateral vs dorsal/ventral
        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='LO1' | rois_contra=='LO2')) = 1;
        cmat(rh_idx & (rois_contra=='LO1' | rois_contra=='LO2'))= -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_LO1+LO2",0)

        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='VO1' | rois_contra=='VO2')) = 1;
        cmat(rh_idx & (rois_contra=='VO1' | rois_contra=='VO2'))= -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_VO1+VO2",0)

        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='V3A' | rois_contra=='V3B')) = 1;
        cmat(rh_idx & (rois_contra=='V3A' | rois_contra=='V3B')) = -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_V3A+V3B",0)

        cmat=zeros([2*nrois,1]); 
        cmat(lh_idx & (rois_contra=='LO1' | rois_contra=='LO2' | rois_contra=='TO1')) = 1;
        cmat(rh_idx & (rois_contra=='LO1' | rois_contra=='LO2' | rois_contra=='TO1'))= -1;
        make_diffMap(t_files,tfce_files,rois_contra,cmat,masktype,maskthr,out_dir,"lh","rh_LO1+LO2+TO1",0)
    end
end