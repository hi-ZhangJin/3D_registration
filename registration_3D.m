%% Demo for 3D image registration

% 3D data preparation: Our experiment data collected from SSRL BL6-2c and
% image preprocessing (reconstruction) was performed using an in-house
% developed software package known as TXM-Wizard.

% Contact: Jin Zhang (zjin0930@gmail.com).


clear; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('Data\');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load fixed 3D images
fixed = load('fixed.mat');
% Generate binary matrix of fixed 3D images using K means
fixed_binary = reshape(kmeans(fixed(:),2),size(fixed));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load moving 3D images
moving = load('moving.mat');
% Generate binary matrix of moving 3D images using K means
moving_binary = reshape(kmeans(moving(:),2),size(moving));    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the optimizer and metric and set the modality to 'monomodal'
[optimizer,metric] = imregconfig('monomodal');
% Tune the properties of optimizer
optimizer.GradientMagnitudeTolerance = 1e-04;
optimizer.MinimumStepLength = 1e-05;  
optimizer.MaximumStepLength = 0.0625/2;
optimizer.MaximumIterations = 100;
optimizer.RelaxationFactor = 0.5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the transform matrix for registration
tform = imregtform(moving_binary,fixed_binary,'affine',optimizer,metric,'DisplayOptimization',true);
% Reference 3D image to world coordinates
Rfixed = imref3d(size(fixed));
% Apply transform matrix to moving images
movingRegistered = imwarp(moving,tform,'OutputView',Rfixed);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%If you don't need to get the exact value of the transform matrix, you
%could directly use:
movingRegistered = imregister(moving,fixed,'affine',optimizer,metric,'DisplayOptimization',true);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In our case, there are 42 tomograms recorded at different energies.
% Therefore, we should register each tomogram with fixed images and we add
% a for loop in this section.
