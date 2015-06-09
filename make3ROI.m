clear all
%load the tracts
subs=[2 3 5 6 7 8 9 10 12 13 14 15 17 18 19 20 21 22];

folderpath='/triton/becs/scratch/braindata/DSmirnov/DTI/exterminatus';
%% For starters we will use the parcellation of BA 44-45 we had before, but honestly, we really need to do it properly!
% rois = {'ag.nii';'pop.nii';'ptr.nii'};
% matlabpool
parfor subj = 1:length(subs)
%     %% ROI atlas preparation
%     mask = zeros(128,128,53); % diffusion space
%     for roi = 1:length(rois);
%         % load the roi
%         roimask = load_nii(sprintf('%s/%i/%s',folderpath,subs(subj),rois{roi}));
%         roimask = sign(roimask.img);
%         mask(find(roimask==1)) = roi;
%     end
%     save_nii(make_nii(mask), sprintf('%s/%i/3ROI.nii',folderpath,subs(subj)));
    %% Three vectors: one from mixed Broca's, one from pop, one from ptr. We don't have Broca!
    % -44, 23, 15
    cd /triton/becs/scratch/braindata/DSmirnov/DTI/
%     make_mask(24,75,44,2.5,sprintf('%s/%i/ifg.nii',folderpath,subs(subj))); % make mask
%     system(sprintf('./1stOctober/fsl/trans_matrix.sh %i',subs(subj))); % get matrixes
    %% Mean Broca
%     system(sprintf('./1stOctober/fsl/trans_mask.sh %i ifg.nii',subs(subj))); % get mask into diff space
%     system(sprintf('./1stOctober/fsl/fdt_track.sh %i diff_ifg.nii',subs(subj))); % run fdt from mask
    %% POP
    system(sprintf('./1stOctober/fsl/trans_mask.sh %i pop.nii',subs(subj))); % get mask into diff space
    system(sprintf('./1stOctober/fsl/fdt_track.sh %i diff_pop.nii',subs(subj))); % run fdt from mask
    %% PTR
    system(sprintf('./1stOctober/fsl/trans_mask.sh %i ptr.nii',subs(subj))); % get mask into diff space
    system(sprintf('./1stOctober/fsl/fdt_track.sh %i diff_ptr.nii',subs(subj))); % run fdt from mask
end