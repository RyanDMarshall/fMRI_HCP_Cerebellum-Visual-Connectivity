clear;clc;

subs={'CC','TL','KK','DD','AA','OG','NO'};

sess1g={'140731CC','140731TL','140801KK','140801DD','140910AA','141016OG','141017NO'};
sess2g={'140811CC','140827TL','140902KK','140910DD','140930AA','141112OG','141107NO'};

hemis={'lh'  'rh'};

proj='cb_tasks';
expt_fid=fopen('cb_tasks_corrMaps');
expts=textscan(expt_fid,'%s'); expts=expts{1};

%%
for i=1:length(subs)
    for j=1:length(hemis)
        for k=1:length(expts)
            sub=subs{i};
            sess1=sess1g{i}; sess2=sess2g{i};
            hemi=hemis{j}; expt=expts{k};
            
            dir1=sprintf('%s/corrMaps/%s_corrMaps/%s',sess1,proj,hemi);
            dir2=sprintf('%s/corrMaps/%s_corrMaps/%s',sess2,proj,hemi);
            
            file1=sprintf('%s/%s_mask.corrMap.nii',dir1,expt);
            file2=sprintf('%s/%s_mask.corrMap.nii',dir2,expt);
            
            sess1_corrMap=MRIread(file1);
            sess2_corrMap=MRIread(file2);

            sessave=sess1_corrMap;
            sessave.vol=(sess1_corrMap.vol+sess2_corrMap.vol)./2;

            sub=sprintf('14avg%s',sub);
            outdir=sprintf('%s/corrMaps/%s_corrMaps/%s/',sub,proj,hemi);
            mkdir(outdir);
            
            outfname=sprintf('%s/%s_mask.corrMap.nii',outdir,expt);
            
            MRIwrite(sessave,outfname);
        end
    end
end
