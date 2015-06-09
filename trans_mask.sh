#!/bin/bash 

# Input: subject n and maskname
# Applies FLIRT transform to the masks
# Outputs .nii with mask in subject space

export FSLOUTPUTTYPE=NIFTI # this means that output format will be .nii

n=$1 
maskname=$2

#Some folder definitions
rootpath="/triton/becs/scratch/braindata/DSmirnov/DTI/exterminatus"
T1path="/triton/becs/scratch/braindata/DSmirnov/Anatomical/Subjects"
T1="$T1path/${n}subj/bet.nii" #where T1 image resides, i.e. /data/n/bet.nii
MNI="/triton/becs/scratch/braindata/DSmirnov/HarvardOxford/MNI152_T1_2mm_brain_mask.nii" #MNI template brain

#Make the folder for output
mkdir "$rootpath/$n/mask"

#Take the prepared mask in MNI space, and using the inverted matrix, get it to the T1 space
# -in: the mask in MNI, here it is in the root folder, i.e. /data
# -out: the mask in subject space, here it will be created in /data/n/mask/mask1.nii
flirt -in "$rootpath/$n/$maskname" -applyxfm -init "$rootpath/$n/transform/standard2str.mat" -out "$rootpath/$n/mask/$maskname" -paddingsize 0.0 -interp trilinear -ref "$T1"
#Binarize the mask
fslmaths "$rootpath/$n/mask/$maskname" -bin "$rootpath/$n/mask/bin_$maskname"
# Takes mask in subject space and transforms it to diff
flirt -in "$rootpath/$n/mask/bin_$maskname" -applyxfm -init "$rootpath/$n/transform/str2diff.mat" -out "$rootpath/$n/mask/diff_$maskname" -paddingsize 0.0 -interp trilinear -ref "$rootpath/$n.bedpostX/nodif_brain_mask.nii.gz"


