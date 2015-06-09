#!/bin/bash 

# START WITH THIS SCRIPT AFTER PREPROCESSING, must already have the masks in MNI space
# Input: subject n
# Produces transformation matrixes

export FSLOUTPUTTYPE=NIFTI # this means that output format will be .nii

n=$1 

#Some folder definitions
rootpath="/triton/becs/scratch/braindata/DSmirnov/DTI/exterminatus"
T1path="/triton/becs/scratch/braindata/DSmirnov/Anatomical/Subjects"
T1="$T1path/${n}subj/bet.nii" #where T1 image resides, i.e. /data/n/bet.nii
MNI="/triton/becs/scratch/braindata/DSmirnov/HarvardOxford/MNI152_T1_2mm_brain_mask.nii" #MNI template brain
#Make the folder for output
mkdir "$rootpath/$n/transform"

#Get T1 to MNI transformation matrix
flirt -in $T1 -ref $MNI -omat "$rootpath/$n/transform/str2standard.mat" -bins 256 -cost corratio -searchrx -120 120 -searchry -120 120 -searchrz -120 120 -dof 9
#Get inverse, i.e. MNI to T1 transformation matrix
convert_xfm -omat "$rootpath/$n/transform/standard2str.mat" -inverse "$rootpath/$n/transform/str2standard.mat" 

#Produces subject2diff transformation
flirt -in $T1 -ref "$rootpath/$n.bedpostX/nodif_brain_mask.nii.gz" -omat "$rootpath/$n/transform/str2diff.mat" -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 9 
convert_xfm -omat "$rootpath/$n/transform/diff2str.mat" -inverse "$rootpath/$n/transform/str2diff.mat" 

#Get Diff to MNI and its inverse
flirt -in "$rootpath/$n.bedpostX/nodif_brain_mask.nii.gz" -ref $MNI -omat "$rootpath/$n/transform/diff2standard.mat" -bins 256 -cost corratio -searchrx -120 120 -searchry -120 120 -searchrz -120 120 -dof 9
convert_xfm -omat "$rootpath/$n/transform/standard2diff.mat" -inverse "$rootpath/$n/transform/diff2standard.mat" 

# Concatenate matrix: diff2str with str2standard
convert_xfm -concat "$rootpath/$n/transform/str2standard.mat" -omat "$rootpath/$n/transform/data_transform.mat" "$rootpath/$n/transform/diff2str.mat"

