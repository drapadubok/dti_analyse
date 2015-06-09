clear all
close all
%% PARAMETERS
% where subject folders are located
rootpath = '/triton/becs/scratch/braindata/shared/playground';
% Subject folders
subjects = {
's1';
's2';
's3'
};
%% Main
% Which function to run on cluster
runfile = 'dti_prepro.sh';
for s = 1:length(subjects)
    subject = subjects{s};
    % job filename
    filename = fullfile(rootpath,subject,'dti_prepro_job');
    % log filename
    logfile = fullfile(rootpath,subject,'dti_prepro_logfile');
    %load the modules
    dlmwrite(filename, '#!/bin/sh', '');
    % Handle the long jobs
    dlmwrite(filename, '#SBATCH -p batch','-append','delimiter','');
    dlmwrite(filename, '#SBATCH -t 08:00:00','-append','delimiter','');
    dlmwrite(filename, ['#SBATCH -o "' logfile '"'],'-append','delimiter','');
    dlmwrite(filename, '#SBATCH --mem-per-cpu=30000','-append','delimiter','');
    dlmwrite(filename, 'cd /triton/becs/scratch/braindata/shared/playground','-append','delimiter','');
    %command
    dlmwrite(filename, sprintf('./%s %s %s',runfile,subject,rootpath),'-append','delimiter','');
    unix(['sbatch ' filename]);
end