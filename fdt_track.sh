#!/bin/bash
# Transforming back to MNI

export FSLOUTPUTTYPE=NIFTI # So that output is saved without .gz extension

n=$1
seed=$2
termination=$3
rootpath="/triton/becs/scratch/braindata/DSmirnov/DTI/exterminatus"
MNI="/triton/becs/scratch/braindata/DSmirnov/HarvardOxford/MNI152_T1_2mm_brain_mask.nii" #MNI template brain

#Tracking
mkdir "$rootpath/$n/FDT_${seed}"
#probtrackx2  -x "$rootpath/$n/mask/$seed"  -l --onewaycondition --pd -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --stop="$rootpath/$n/mask/$termination" --forcedir --opd -s "$rootpath/$n.bedpostX/merged" -m "$rootpath/$n.bedpostX/nodif_brain_mask"  --dir="$rootpath/$n/FDT"

# Version without termination mask for triton
probtrackx2  -x "$rootpath/$n/mask/$seed.nii"  -l --onewaycondition --pd -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s "$rootpath/$n.bedpostX/merged" -m "$rootpath/$n.bedpostX/nodif_brain_mask"  --dir="$rootpath/$n/FDT_${seed}"
# Take results of FDT and transform them to MNI
flirt -in "$rootpath/$n/FDT_${seed}/fdt_paths.nii" -applyxfm -init "$rootpath/$n/transform/data_transform.mat" -out "$rootpath/$n/FDT_${seed}/mni_fdt_paths.nii" -paddingsize 0.0 -interp trilinear -ref $MNI

