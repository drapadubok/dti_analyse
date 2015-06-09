#!/bin/bash
# Doing tractography
#
#
# Input - number of subject
n=$1

#Make a folder for output
#mkdir "/triton/becs/scratch/braindata/DSmirnov/DTI/review/${n}/FDTnew/pop"
#mkdir "/triton/becs/scratch/braindata/DSmirnov/DTI/review/${n}/FDTnew/ptr"
mkdir "/triton/becs/scratch/braindata/DSmirnov/DTI/review/${n}/FDTnew/ag"
#Here we track only using one seed mask
#probtrackx2 -x "/triton/becs/scratch/braindata/DSmirnov/DTI/ind_mask/$n/popbin.nii" -l --onewaycondition --pd -c 0.2 -S 6000 --steplength=0.2 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s "/triton/becs/scratch/braindata/DSmirnov/DTI/pandabear/$n.bedpostX/merged" -m "/triton/becs/scratch/braindata/DSmirnov/DTI/pandabear/$n.bedpostX/nodif_brain_mask"  --dir="/triton/becs/scratch/braindata/DSmirnov/DTI/review/${n}/FDTnew/pop"

#probtrackx2 -x "/triton/becs/scratch/braindata/DSmirnov/DTI/ind_mask/$n/ptrbin.nii" -l --onewaycondition --pd -c 0.2 -S 6000 --steplength=0.2 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s "/triton/becs/scratch/braindata/DSmirnov/DTI/pandabear/$n.bedpostX/merged" -m "/triton/becs/scratch/braindata/DSmirnov/DTI/pandabear/$n.bedpostX/nodif_brain_mask"  --dir="/triton/becs/scratch/braindata/DSmirnov/DTI/review/${n}/FDTnew/ptr"

probtrackx2 -x "/triton/becs/scratch/braindata/DSmirnov/DTI/ind_mask/$n/agbin.nii" -l --onewaycondition --pd -c 0.2 -S 6000 --steplength=0.2 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s "/triton/becs/scratch/braindata/DSmirnov/DTI/pandabear/$n.bedpostX/merged" -m "/triton/becs/scratch/braindata/DSmirnov/DTI/pandabear/$n.bedpostX/nodif_brain_mask"  --dir="/triton/becs/scratch/braindata/DSmirnov/DTI/review/${n}/FDTnew/ag"
