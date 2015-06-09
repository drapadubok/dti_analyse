#!/bin/bash 

# START WITH THIS SCRIPT AFTER PREPROCESSING
# Input: Number of subject  
# Produces transformation matrix from MNI to SUBJECT space
# Applies FLIRT transform to the masks
# Outputs matrix and nii with mask in subject space

export FSLOUTPUTTYPE=NIFTI

#Where masks reside
rootpath="/triton/becs/scratch/braindata/DSmirnov/DTI/ind_mask" 

#Take the subject number
n=$1 

#Make the name of the folder, have some conventions please
subj="subj"
nsubj="${n}subj"

#Make the folder for output
mkdir "${rootpath}/$n"

# THIS GOES FIRST
#Take the transformation matrix from T1 to MNI, invert it and save it as .mat
#convert_xfm -omat "$rootpath/$n/inverse_mni" -inverse "/triton/becs/scratch/braindata/DSmirnov/PREPRO3/$n/epi_SPRG2MNI.mat" 
#mv "$rootpath/$n/inverse_mni" "$rootpath/$n/inverse_mni.mat"

# THIS GOES SECOND
#Take the prepared mask in MNI space, and using the inverted matrix, get it to the subject space
flirt -in "/scratch/braindata/DSmirnov/DTI/ag.nii" -applyxfm -init "$rootpath/$n/inverse_mni.mat" -out "$rootpath/$n/ag" -paddingsize 0.0 -interp trilinear -ref "/archive/braindata/2011/contextual_effect/Anatomical/Subjects/$nsubj/bet.nii"
fslmaths "$rootpath/$n/ag.nii" -bin "$rootpath/$n/agbin"



