#!/bin/bash
# Doing tractography
#
#
# Input - number of subject
n=$1

#Make a folder for output
mkdir "/triton/becs/scratch/braindata/DSmirnov/DTI/review/${n}/FDT/pop"
mkdir "/triton/becs/scratch/braindata/DSmirnov/DTI/review/${n}/FDT/ptr"

#Here we track only using one seed mask
probtrackx --mode=seedmask -x "/triton/becs/scratch/braindata/DSmirnov/DTI/ind_mask/$n/popbin.nii" -l -c 0.2 -S 2000 --steplength=0.5 -P 5000 --forcedir --opd -s "/triton/becs/scratch/braindata/DSmirnov/DTI/pandabear/$n.bedpostX/merged" -m "/triton/becs/scratch/braindata/DSmirnov/DTI/pandabear/$n.bedpostX/nodif_brain_mask" --dir="/triton/becs/scratch/braindata/DSmirnov/DTI/review/${n}/FDT/pop"

probtrackx --mode=seedmask -x "/triton/becs/scratch/braindata/DSmirnov/DTI/ind_mask/$n/ptrbin.nii" -l -c 0.2 -S 2000 --steplength=0.5 -P 5000 --forcedir --opd -s "/triton/becs/scratch/braindata/DSmirnov/DTI/pandabear/$n.bedpostX/merged" -m "/triton/becs/scratch/braindata/DSmirnov/DTI/pandabear/$n.bedpostX/nodif_brain_mask" --dir="/triton/becs/scratch/braindata/DSmirnov/DTI/review/${n}/FDT/ptr"
