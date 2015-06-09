Scripts include some analyses that I've ran and also some tream of thought, so if some idea expressed here was interesting to you - best thing you can do is ask me directly, and I will explain which scripts did what.

1) Preprocess DTI data with FSL routines
./dti_prepro.sh : when you run this one, you will get all the preprocessing done, typically folder with output will look like screen1.png

2) Cook the transformation matrixes
./trans_matrix.sh : after you run this one, you will get a folder with matrixes like screen2.png

3) Transform masks for analys
./trans_mask.sh : here you will get folder with transformed masks, for each mask it will be mask.nii (T1 space), diff_mask.nii and bin_mask.nii (binarized T1)

4) FDT tracking
./fdt_track.sh : here we have three arguments, first being the subject folder, second - seed mask in subject space, third - termination mask in subject space. Results are in screen3.png. For this subject you get fdt_paths.nii where for each voxel you have a value specifying how many times path was traced through this voxel and mni_fdt_paths.nii which is the same thing but in mni space.

5) FDT classification
./fdt_class.sh : you can have more arguments, here it pretty much depends on how many classification targets you would have. Here the results are versions of the starting mask which shows how likely each voxel in that mask is to connect to all the areas in targets.
