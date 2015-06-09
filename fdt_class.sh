#!/bin/bash
# Transforming back to MNI

export FSLOUTPUTTYPE=NIFTI # So that output is saved without .gz extension

n=$1
seed=$2
targetmask1=$3
targetmask2=$4
rootpath="/triton/becs/scratch/braindata/DSmirnov/DTI/exterminatus"
MNI="/triton/becs/scratch/braindata/DSmirnov/HarvardOxford/MNI152_T1_2mm_brain_mask.nii" #MNI template brain

#Classification
mkdir "$rootpath/$n/FDT_class/"
rm $rootpath/$n/FDT_class/targets.txt # clear targets just in case
cat $rootpath/$n/FDT_class/targets.txt # create targets file
echo $rootpath/$n/mask/$targetmask1 >> $rootpath/$n/FDT_class/targets.txt # fill it with targets
echo $rootpath/$n/mask/$targetmask2 >> $rootpath/$n/FDT_class/targets.txt

probtrackx2  -x "$rootpath/$n/mask/$seed"  -l --onewaycondition --pd -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s "$rootpath/$n.bedpostX/merged" -m "$rootpath/$n.bedpostX/nodif_brain_mask"  --dir="$rootpath/$n/FDT_class" --targetmasks="$rootpath/$n/FDT_class/targets.txt" --os2t
