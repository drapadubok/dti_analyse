%% uh-huh
clear all

%load the tracts
subs=[2 3 5 6 7 8 9 10 12 13 14 15 17 18 19 20 21 22];

path='/triton/becs/scratch/braindata/DSmirnov/DTI/exterminatus/';
% masks={'new_dti_mni_ptr.nii';
%        'new_dti_mni_pop.nii';
%        'new_dti_mni_ag.nii'};
masks={'dti_mni_pop.nii';
       'dti_mni_pop_step.nii';
       'dti_mni_ptr.nii';
       'dti_mni_ptr_step.nii'};
   
for k = 1:length(masks)
    mask = masks{k};
    sum_fdt_bin=zeros(91,109,91);
    for i=1:length(subs)
        subj=subs(i); %keep the number of subject
        fullpath=sprintf('%s/%i/%s',path,subj,mask);
        fdt=load_nii(fullpath);
    %%  get binary maps with full data
%         bin_fdt=fdt.img;
%         bin_fdt(bin_fdt>0)=1;
%         sum_fdt_bin=double(sum_fdt_bin)+double(bin_fdt);
%     %     

    %% Thresholding part         
        thresh=100; %decide on a value
        thrfdt=fdt; %keep the original nifti intact
        thrfdt.img(thrfdt.img<=thresh)=0; %remove all voxels under the thresh
        thrfdt.img(thrfdt.img>0)=1; % binarise the remnants of the glory!
        sum_fdt_bin=double(sum_fdt_bin)+double(thrfdt.img);        
    end
    save_nii(make_nii(sum_fdt_bin), sprintf('sum_%s.nii',mask));
end


