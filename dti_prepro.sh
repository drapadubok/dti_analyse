#!/bin/bash 
# DTI preprocessing
# 1) Perform eddy current correction
# 2) And extract mask from resulting file
# 3) Perform DTIFIT reconstruction
# 4) do the bedpostx
# Folder structure:
# -n.nii.gz
# -bvals
# -bvecs
# -bet.nii
# by Dima Smirnov, somewhere in 2012

n=$1 #n gets the first argument
rootpath=$2 #folder with subject files, i.e. /$rootpath/$n/n.nii.gz and /$rootpath/$n/bvecs
#-------Main part
	for filename in "$rootpath/$n/$n.nii.gz" ; do 
		subj=`$FSLDIR/bin/remove_ext $filename` # subj is n.nii.gz but without .nii.gz extension
		echo "Processing $filename"
#-------ECC		
		if [ ! -e "$rootpath/$n/data.nii.gz" ];  # if ECC file doesn't exist
		then
			echo "ECC on $subj.nii" # Do ECC, save file
			eddy_correct "$subj.nii" "${subj}_c" 0
		else
			echo "ECC was done before, moving on to mask extraction"
		fi

#--------BET
		if [ ! -e "$rootpath/$n/nodif_brain_mask.nii.gz" ]; # if mask doesn't exist
		then
			echo "Creating mask for $subj"
			bet "${subj}_c.nii.gz" "$subj"  -f 0.3 -g 0 -n -m
		else
			echo "Mask was done, DTIFIT now"
		fi
#--------DTIFIT
		if [ ! -e "${subj}_dti_FA.nii.gz" ];
		then
			echo "DTIFIT"
			dtifit --data="${subj}_c.nii.gz" --out="${subj}_dti" --mask="${subj}_mask.nii.gz" --bvecs="$rootpath/bvecs" --bvals="$rootpath/bvals"
		else
			echo "DTIFIT was done, now the longest part - bedpostx"
		fi
#--------BEDPOSTX

		if [ ! -e "$rootpath/$n/data.nii.gz" ];
		then	mv "${subj}_c.nii.gz" "$rootpath/$n/data.nii.gz"
		fi
		
		if [ ! -e "$rootpath/$n/nodif_brain_mask.nii.gz" ];		
		then	mv "${subj}_mask.nii.gz" "$rootpath/$n/nodif_brain_mask.nii.gz"
		fi

		cp "$rootpath/bvecs" "$rootpath/$n/bvecs"
		cp "$rootpath/bvals" "$rootpath/$n/bvals"
	done 
	bedpostx "$rootpath/$n"
#done
