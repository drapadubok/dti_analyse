%% Combining DTI and fMRI mutant!
clear all
addpath('/triton/becs/scratch/braindata/shared/toolboxes/NIFTI');
addpath(genpath('/triton/becs/scratch/braindata/heikkih3/spm8'));

%% Clustering PPI masks
% Here we get a mask with cluster labels for voxelss
mask=load_nii('/triton/becs/scratch/braindata/DSmirnov/Comprehension/PPI_SPM/test.img'); % load the clustered file from SPM
mask=sign(mask.img);
[x y z]=ind2sub(size(mask),find(mask==1));
a=[x y z];
clust=spm_clusters(a');
newmask=zeros(size(mask));
for c = 1:length(clust);
	cids=find(c==clust);
    csize=length(cids);
    if(csize<(5*5*5))
		for cc=1:length(cids)
          		mask(a(cids(cc),1),a(cids(cc),2),a(cids(cc),3))=0;
		end
	else
		for cc=1:length(cids)
        		newmask(a(cids(cc),1),a(cids(cc),2),a(cids(cc),3))=c;
		end
    end
end
save_nii(make_nii(newmask),'/triton/becs/scratch/braindata/DSmirnov/Comprehension/clustermask.nii');

subs = [2 3 5 6 7 8 9 10 12 13 14 15 17 18 19 20 21 22];
% relative recall ratings (for each story, rating was rescaled by dividing
% it with maximum rating for this story over sample, then for each subject we take mean
% over congruent stories. Order here corresponds to subs
recalls = [0.29 0.59 0.29 0.17  0.57 0.41 0.55 0.2 0.57 0.29 0.82 0.37 0.81 0.48 0.65 0.44 0.8 0.67]';
% [0.29 0.59 0.56 0.29 0.17  0.57 0.41 0.55 0.2 0.57 0.29 0.82 0.37 0.14 0.81 0.48 0.65 0.44 0.8 0.67]

dtipath = '/triton/becs/scratch/braindata/DSmirnov/DTI';
funcpath = '/triton/becs/scratch/braindata/DSmirnov/Comprehension/PPI_SPM/functional';
MNI = load_nii('/triton/becs/scratch/braindata/DSmirnov/HarvardOxford/MNI152_T1_2mm_brain_mask.nii');

for subj = 1:length(subs)    
    %% Load betas for two sessions and take average of them (or use t-map, they are almost the same)
    sess1 = load_nii(sprintf('%s/results_vigneau_revision_5mm/%i/beta_0001.img',funcpath,subs(subj)));
    sess2 = load_nii(sprintf('%s/results_vigneau_revision_5mm/%i/beta_0010.img',funcpath,subs(subj)));
    sess1 = reshape(sess1.img,[],1);
    sess2 = reshape(sess2.img,[],1);
    sessmix = [sess1 sess2];
    sessmean = mean(sessmix,2);
    % clear nans
    sessmean(isnan(sessmean))=0;
    %% Load streamlines for given subject
    dti = load_nii(sprintf('%s/exterminatus/%i/FDT/mni_fdt_paths.nii',dtipath,subs(subj))); dti = dti.img;
    dti = reshape(dti,[],1);
    %% Mask them
    % Left AG == 10; dACC == 9; Right IPC/PCC == 4
    lAGidx = find(newmask==10);
    rAGidx = find(newmask==4);
    ACCidx = find(newmask==9);    
    %% Take average of DTI
    lAGdti(subj) = mean(dti(lAGidx));
    rAGdti(subj) = mean(dti(rAGidx));
    ACCdti(subj) = mean(dti(ACCidx)); 
    %% Take average of PPI
    lAGppi(subj) = mean(sessmean(lAGidx));
    rAGppi(subj) = mean(sessmean(rAGidx));
    ACCppi(subj) = mean(sessmean(ACCidx));    
end
%% Correlate ROI values
[RHO,PVAL] = corr(lAGdti',lAGppi');
[RHO,PVAL] = corr(rAGdti',rAGppi');
[RHO,PVAL] = corr(ACCdti',ACCppi');

%% PPI betas vs RECALL?
clear ppi
inmask = find(MNI.img==1);
for subj = 1:length(subs)    
    %% Load betas for two sessions and take average of them (or use t-map, they are almost the same)
    sess1 = load_nii(sprintf('%s/results_vigneau_revision_5mm/%i/beta_0001.img',funcpath,subs(subj)));
    sess2 = load_nii(sprintf('%s/results_vigneau_revision_5mm/%i/beta_0010.img',funcpath,subs(subj)));
    sess1 = reshape(sess1.img,[],1);
    sess2 = reshape(sess2.img,[],1);
    sessmix = [sess1 sess2];
    sessmean = mean(sessmix,2);
    % clear nans
    sessmean(isnan(sessmean))=0;
    ppi(:,subj) = sessmean(inmask);
end
for vox = 1:length(ppi)
    [RHO,PVAL] = corr(ppi(vox,:)',recalls);
    rmtx(vox,1) = RHO;
    pmtx(vox,1) = PVAL;
end
threshmask = single(pmtx<0.005);
threshRHO = rmtx.*threshmask;
outmap = zeros(91,109,91);
outmap(inmask) = threshRHO;
save_nii(make_nii(outmap),'/triton/becs/scratch/braindata/DSmirnov/DTI/correlation_ppi_recall.nii');

%%%%%

inmask = find(MNI.img==1);
for subj = 1:length(subs)
    %% Load t-map for PPI
    ppiMEAN = load_nii(sprintf('%s/results_vigneau_revision_5mm/%i/spmT_0003.img',funcpath,subs(subj)));
    temp = reshape(ppiMEAN.img,[],1);
    ppiMEANvec(subj,:) = temp(inmask);
   
%     ppiPOP = load_nii(sprintf('%s/results_oper_revision_5mm/%i/spmT_0003.img',funcpath,subs(subj)));
%     temp = reshape(ppiPOP.img,[],1);
%     ppiPOPvec(subj,:) = temp(inmask);
%     
%     ppiPTR = load_nii(sprintf('%s/results_trian_revision_5mm/%i/spmT_0003.img',funcpath,subs(subj)));
%     temp = reshape(ppiPTR.img,[],1);
%     ppiPTRvec(subj,:) = temp(inmask);
    
    %% Load DTI maps
    dtiMEAN = load_nii(sprintf('%s/exterminatus/%i/FDT/mni_fdt_paths.nii',dtipath,subs(subj)));
    dtiMEANZ = zscore(reshape(dtiMEAN.img,[],1)); % For each voxel, how well it is connected to mean Broca's area
    dtiMEANvec(subj,:) = dtiMEANZ(inmask);
    
    dtiPOP = load_nii(sprintf('%s/exterminatus/%i/FDT_diff_pop/mni_fdt_paths.nii',dtipath,subs(subj)));
    dtiPOPZ = zscore(reshape(dtiPOP.img,[],1));    
    dtiPOPvec(subj,:) = dtiPOPZ(inmask);
    
    dtiPTR = load_nii(sprintf('%s/exterminatus/%i/FDT_diff_ptr/mni_fdt_paths.nii',dtipath,subs(subj)));
    dtiPTRZ = zscore(reshape(dtiPTR.img,[],1));    
    dtiPTRvec(subj,:) = dtiPTRZ(inmask);
end
%% DTI with PPI correlation
for vox = 1:length(ppiMEANvec)
    [RHO,PVAL] = corr(dtiMEANvec(:,vox),ppiMEANvec(:,vox));
    rmtx(vox,1) = RHO;
    pmtx(vox,1) = PVAL;
end
threshmask = single(pmtx<0.05);
threshRHO = rmtx.*threshmask;
outmap = zeros(91,109,91);
outmap(inmask) = threshRHO;
save_nii(make_nii(outmap),'/triton/becs/scratch/braindata/DSmirnov/DTI/correlation_ppi_dti_mean.nii');

%% DTI with RECALL correlation
[RHO,PVAL] = corr(dtiMEANvec,recalls);
threshmask = single(PVAL<0.005);
threshRHO = RHO.*threshmask;
outmap = zeros(91,109,91);
outmap(inmask) = threshRHO;
save_nii(make_nii(outmap),'/triton/becs/scratch/braindata/DSmirnov/DTI/correlation_recall_dti_mean.nii');

[RHO,PVAL] = corr(dtiPOPvec,recalls);
threshmask = single(PVAL<0.005);
threshRHO = RHO.*threshmask;
outmap = zeros(91,109,91);
outmap(inmask) = threshRHO;
save_nii(make_nii(outmap),'/triton/becs/scratch/braindata/DSmirnov/DTI/correlation_recall_dti_pop.nii');

[RHO,PVAL] = corr(dtiPTRvec,recalls);
threshmask = single(PVAL<0.005);
threshRHO = RHO.*threshmask;
outmap = zeros(91,109,91);
outmap(inmask) = threshRHO;
save_nii(make_nii(outmap),'/triton/becs/scratch/braindata/DSmirnov/DTI/correlation_recall_dti_ptr.nii');
%% Check correlation across DTI, PPI and RECALL, for each VOI, for connectivity estimated from each region

for ROI = 1:3
    % SEED selection
    for VOI = 1:n
         
% rerun the ppi first for vigneau seed
% collect Tmaps and betas into separate folder
% rerun it for posterior and anterior seeds, also collect maps separately
% We can also take AAL atlas connectivity? Or voxelwise connectivity?
% DTI: take a seed (broca?), get the streamlines.
% PPI: take the seed, get beta value for voxels
% We get image, one vector, not connectivity from each region to each region.
% How to get into the same space?
% Move both into standard?
% It will not work with several seeds. But it may work if we have termination seeds?
% Matrix option in FSL to get adjacency from DTI
% 
% Ok, my current suggestion is:
% We need to start with some DTI number anyway, so we can either take the termination mask in probabilistic tracking and take the number of iterations that reached it as our tract strength. That way for each ROI we have a number. 
% There are a few studies that used this approach to judge the tract strength.
% Then, we need a few other ROIs that are not involved in task. We need them to have some sort of idea on what are the numbers for unrelated tracts. Otherwise, how do we plan to tell that the correlation that we see makes any more sense than any random correlation.
% Then we can check whether tract strength to various ROIs correlates with recall and PPI beta values in those ROIs.
% 
% Big question is how to calculate it, because the FSL way is tricky (the weights don't make sense): 
% 1) We define the masks for each subject. For each ROI in PPI we define a central voxel. We transform them to individual space and make sure their location makes sense.
% 2) For each of those masks we get PPI beta.
% 3) For each of those masks we get an estimate of tract strength, by calculating how many times tract reached them.
% 4) We need to find what numbers are actually meaningful.
% 
% 
% compare groups!!! Check if anatomy is more correlated with function during specific type of stimulation
% don’t do any between-groups comparisons
% try to predict some DTI parameter with some external variable. 
% I guess the interpretation would be to check whether individual differences in anatomy are associated with individual differences functional connectivity, i.e. maybe high-bandwith connections should show large fconn effects in the neural responses going via this route? 
% If you can extract some kind of estimates for the track strengths, you could then correlate them with quite a nice number of variables: 
% i) recall performance
% ii) comprehension performance
% iii) GLM response at Broca
% iv) PPI responses at IPC (or elsewhere)
% Include corpus callosum as exclusion mask?
