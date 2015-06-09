#!/bin/bash 
####
# If you have some masks that you prepare in MNI space (from atlases, meta-analyses or wherever)
# And you want to get them to subject space, you can use this script
####
# Input: subject number and folder where subject resides (change names according to your conventions)
# Assumes you have a transformation matrix from T1 to MNI (usually acquired during preprocessing of functional data, for example if you normalize/register to MNI space)
# Produces transformation matrix from MNI to SUBJECT space
# Applies FLIRT transform to the masks
# Outputs matrix and nii with mask in subject space
export FSLOUTPUTTYPE=NIFTI
#Subject number
n=$1 
#Where masks reside
rootpath=$2
#Make the name of the folder, have some conventions please
subj="subj"
nsubj="${n}subj"
#Make the folder for output
mkdir "${rootpath}/$n"
#Take the transformation matrix from T1 to MNI (can be acquired with FLIRT in FSL), invert it and save it as .mat
convert_xfm -omat "$rootpath/$n/inverse_mni" -inverse "/triton/becs/scratch/braindata/shared/playground/$n/SPRG2MNI.mat" 
mv "$rootpath/$n/inverse_mni" "$rootpath/$n/inverse_mni.mat"
#Take the prepared mask in MNI space, and using the inverted matrix, get it to the subject space
#bet.nii is a T1 brain extracted image
flirt -in "/scratch/braindata/shared/playground/mask1.nii" -applyxfm -init "$rootpath/$n/inverse_mni.mat" -out "$rootpath/$n/mask1" -paddingsize 0.0 -interp trilinear -ref "/scratch/braindata/shared/playground/Anatomical/Subjects/$nsubj/bet.nii"
fslmaths "$rootpath/$n/mask1.nii" -bin "$rootpath/$n/mask1binary"



