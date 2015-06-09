function make_mask(x,y,z,radius,name)
addpath('/triton/becs/scratch/braindata/shared/toolboxes/NIFTI'); % change this to where your NIFTI folder is, or remove if you have it somewhere setup already
origmask = load_nii('/triton/becs/scratch/braindata/DSmirnov/HarvardOxford/MNI152_T1_2mm_brain_mask.nii');
[X,Y,Z]=ndgrid(1:91,1:109,1:91);
mask=zeros(91,109,91);
mask=sqrt((X-x).^2+(Y-y).^2+(Z-z).^2)<=radius;
origmask.img=double(mask);
save_nii(origmask,name);