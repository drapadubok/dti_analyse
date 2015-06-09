#!/bin/bash
# Transforming back to MNI

export FSLOUTPUTTYPE=NIFTI

n=$1

input="${n}subj" #Folder with subject files (fdt etc)
t1folder="/archive/braindata/2011/contextual_effect/Anatomical/Subjects" #where T1 resides
outputfolder="/scratch/braindata/DSmirnov/DTI/DTI2MNI" #General folder for outputs
bedpostfolder="/scratch/braindata/DSmirnov/DTI/review" #General folder with bedposts

mkdir "$outputfolder/$n"

#Produces first matrix, from Subject space to Standard space
flirt -in "$t1folder/$input/bet.nii" -ref "/scratch/braindata/DSmirnov/HarvardOxford/MNI152_T1_2mm_brain.nii" -omat "$outputfolder/$n/dti1.mat" -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 7 

#Produces the second matrix, from DTI space to Subject space, not sure if I need to escape a dot 
flirt -in "$bedpostfolder/${n}.bedpostX/nodif_brain_mask.nii.gz" -ref "$t1folder/$input/bet.nii" -omat "$outputfolder/$n/dti2.mat" -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12 

#Final matrix
convert_xfm -concat "$outputfolder/$n/dti1.mat" -omat "$outputfolder/$n/dti_fin.mat" "$outputfolder/$n/dti2.mat"

#Transform the data
flirt -in "$bedpostfolder/${n}/FDT/pop/fdt_paths.nii.gz" -applyxfm -init "$outputfolder/$n/dti_fin.mat" -out "$outputfolder/$n/dti_mni_pop" -paddingsize 0.0 -interp trilinear -ref "/scratch/braindata/DSmirnov/HarvardOxford/MNI152_T1_2mm_brain.nii"

flirt -in "$bedpostfolder/${n}/FDT/ptr/fdt_paths.nii.gz" -applyxfm -init "$outputfolder/$n/dti_fin.mat" -out "$outputfolder/$n/dti_mni_ptr" -paddingsize 0.0 -interp trilinear -ref "/scratch/braindata/DSmirnov/HarvardOxford/MNI152_T1_2mm_brain.nii"
