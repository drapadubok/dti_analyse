#!/bin/bash
# Transforming back to MNI

export FSLOUTPUTTYPE=NIFTI

n=$1

input="${n}subj" #Folder with subject files (fdt etc)
t1folder="/archive/braindata/2011/contextual_effect/Anatomical/Subjects" #where T1 resides
outputfolder="/scratch/braindata/DSmirnov/DTI/DTI2MNI" #General folder for outputs
bedpostfolder="/scratch/braindata/DSmirnov/DTI/review" #General folder with bedposts

mkdir "/scratch/braindata/DSmirnov/DTI/exterminatus/$n/"

#Produces subject2diff transformation
flirt -in "/archive/braindata/2011/contextual_effect/Anatomical/Subjects/$input/bet.nii" -ref "/scratch/braindata/DSmirnov/DTI/review/$n.bedpostX/nodif_brain_mask.nii.gz" -omat "/scratch/braindata/DSmirnov/DTI/str2diff_$n.mat" -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 9 

# Takes masks in subject space and transforms them to diff
flirt -in "/scratch/braindata/DSmirnov/DTI/ind_mask/$n/agbin.nii" -applyxfm -init "/scratch/braindata/DSmirnov/DTI/str2diff_$n.mat" -out "/scratch/braindata/DSmirnov/DTI/exterminatus/$n/ag.nii" -paddingsize 0.0 -interp trilinear -ref "/scratch/braindata/DSmirnov/DTI/review/$n.bedpostX/nodif_brain_mask.nii.gz"

flirt -in "/scratch/braindata/DSmirnov/DTI/ind_mask/$n/popbin.nii" -applyxfm -init "/scratch/braindata/DSmirnov/DTI/str2diff_$n.mat" -out "/scratch/braindata/DSmirnov/DTI/exterminatus/$n/pop.nii" -paddingsize 0.0 -interp trilinear -ref "/scratch/braindata/DSmirnov/DTI/review/$n.bedpostX/nodif_brain_mask.nii.gz"

flirt -in "/scratch/braindata/DSmirnov/DTI/ind_mask/$n/ptrbin.nii" -applyxfm -init "/scratch/braindata/DSmirnov/DTI/str2diff_$n.mat" -out "/scratch/braindata/DSmirnov/DTI/exterminatus/$n/ptr.nii" -paddingsize 0.0 -interp trilinear -ref "/scratch/braindata/DSmirnov/DTI/review/$n.bedpostX/nodif_brain_mask.nii.gz"

# Perform simple termination tracking, default settings
mkdir "/scratch/braindata/DSmirnov/DTI/exterminatus/$n/FDT_term_pop/"
# from pop to ag
probtrackx2  -x "/scratch/braindata/DSmirnov/DTI/exterminatus/$n/pop.nii"  -l --onewaycondition --pd -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --stop="/scratch/braindata/DSmirnov/DTI/exterminatus/$n/ag.nii" --forcedir --opd -s "/scratch/braindata/DSmirnov/DTI/pandabear/$n.bedpostX/merged" -m "/scratch/braindata/DSmirnov/DTI/pandabear/$n.bedpostX/nodif_brain_mask"  --dir="/scratch/braindata/DSmirnov/DTI/exterminatus/$n/FDT_term_pop"
mkdir "/scratch/braindata/DSmirnov/DTI/exterminatus/$n/FDT_term_ptr/"
# from ptr to ag
probtrackx2  -x "/scratch/braindata/DSmirnov/DTI/exterminatus/$n/ptr.nii"  -l --onewaycondition --pd -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --stop="/scratch/braindata/DSmirnov/DTI/exterminatus/$n/ag.nii" --forcedir --opd -s "/scratch/braindata/DSmirnov/DTI/pandabear/$n.bedpostX/merged" -m "/scratch/braindata/DSmirnov/DTI/pandabear/$n.bedpostX/nodif_brain_mask"  --dir="/scratch/braindata/DSmirnov/DTI/exterminatus/$n/FDT_term_ptr"
mkdir "/scratch/braindata/DSmirnov/DTI/exterminatus/$n/FDT_term_ptr_step/"
# with 6000 steps and 0.2 stepsize
probtrackx2  -x "/scratch/braindata/DSmirnov/DTI/exterminatus/$n/ptr.nii"  -l --onewaycondition --pd -c 0.2 -S 6000 --steplength=0.2 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --stop="/scratch/braindata/DSmirnov/DTI/exterminatus/$n/ag.nii" --forcedir --opd -s "/scratch/braindata/DSmirnov/DTI/review/$n.bedpostX/merged" -m "/scratch/braindata/DSmirnov/DTI/review/$n.bedpostX/nodif_brain_mask"  --dir="/scratch/braindata/DSmirnov/DTI/exterminatus/$n/FDT_term_ptr_step"

mkdir "/scratch/braindata/DSmirnov/DTI/exterminatus/$n/FDT_term_pop_step/"
probtrackx2  -x "/scratch/braindata/DSmirnov/DTI/exterminatus/$n/pop.nii"  -l --onewaycondition --pd -c 0.2 -S 6000 --steplength=0.2 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --stop="/scratch/braindata/DSmirnov/DTI/exterminatus/$n/ag.nii" --forcedir --opd -s "/scratch/braindata/DSmirnov/DTI/review/$n.bedpostX/merged" -m "/scratch/braindata/DSmirnov/DTI/review/$n.bedpostX/nodif_brain_mask"  --dir="/scratch/braindata/DSmirnov/DTI/exterminatus/$n/FDT_term_pop_step"

# classification approach
mkdir "/scratch/braindata/DSmirnov/DTI/exterminatus/$n/FDT_clas_ag/"
cat /scratch/braindata/DSmirnov/DTI/exterminatus/$n/FDT_clas_ag/targets.txt
echo /scratch/braindata/DSmirnov/DTI/exterminatus/$n/pop.nii >> /scratch/braindata/DSmirnov/DTI/exterminatus/$n/FDT_clas_ag/targets.txt
echo /scratch/braindata/DSmirnov/DTI/exterminatus/$n/ptr.nii >> /scratch/braindata/DSmirnov/DTI/exterminatus/$n/FDT_clas_ag/targets.txt
probtrackx2  -x "/scratch/braindata/DSmirnov/DTI/exterminatus/$n/ag.nii"  -l --onewaycondition --pd -c 0.2 -S 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s "/scratch/braindata/DSmirnov/DTI/review/$n.bedpostX/merged" -m "/scratch/braindata/DSmirnov/DTI/review/$n.bedpostX/nodif_brain_mask"  --dir="/scratch/braindata/DSmirnov/DTI/exterminatus/$n/FDT_clas_ag" --targetmasks="/scratch/braindata/DSmirnov/DTI/exterminatus/$n/FDT_clas_ag/targets.txt" --os2t

mkdir "/scratch/braindata/DSmirnov/DTI/exterminatus/$n/FDT_clas_ag_step/"
cat /scratch/braindata/DSmirnov/DTI/exterminatus/$n/FDT_clas_ag_step/targets.txt
echo /scratch/braindata/DSmirnov/DTI/exterminatus/$n/pop.nii >> /scratch/braindata/DSmirnov/DTI/exterminatus/$n/FDT_clas_ag_step/targets.txt
echo /scratch/braindata/DSmirnov/DTI/exterminatus/$n/ptr.nii >> /scratch/braindata/DSmirnov/DTI/exterminatus/$n/FDT_clas_ag_step/targets.txt
probtrackx2  -x "/scratch/braindata/DSmirnov/DTI/exterminatus/$n/ag.nii"  -l --onewaycondition --pd -c 0.2 -S 6000 --steplength=0.2 -P 5000 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s "/scratch/braindata/DSmirnov/DTI/review/$n.bedpostX/merged" -m "/scratch/braindata/DSmirnov/DTI/review/$n.bedpostX/nodif_brain_mask"  --dir="/scratch/braindata/DSmirnov/DTI/exterminatus/$n/FDT_clas_ag_step" --targetmasks="/scratch/braindata/DSmirnov/DTI/exterminatus/$n/FDT_clas_ag_step/targets.txt" --os2t








