
This file describes matlab files that we used to obtain our results,
together with instructions for how can they be reproduced.

I. File List
------------

- dictVisualization.m  	visualize learned or pre-defined dictionary by patches

- getDictionary.m  		get pre-defined or ksvd learned dictionary based on input argument

- inPainting.m  		Perform the actual inpainting of the image

- ksvd.m  			Perform ksvd based on input training samples

- main.m 			main function that allows user to define degraded images, masks and dictionaries by themselves

- mergePatch.m 			merge vectorized patches back to original image

- OMP.m:		 	Our implementation of the Orthogonal Matching Pursuit 

- psnr.m:			Compute PSNR of the reconstructed image

- splitImg.m 			Split image into p patches and then vectorize each patch; form signal matrix using these column vectors

- trainDict.m 			Train a dictionary based on give dataset using ksvd

- ksvd_dict.mat			Our trained ksvd dictionary; you can train your own version using trainDict.m

- dctDict.mat 			Pre-defined DCT dictionary



II. Reproducing results
-----------------------

To run the code you just need to modify parameters in main.m 

Note that for now we just support grayscale square images. And the dimension of the image has to be able to be divided by patch size (neib).

The reconstructed image is single channel a matrix I_rec in [0,1] range of the same size as I.

III. Authors
------------
Chen Zhu, Department of Electrical Engineering, Stanford University, E-mail: chen0908@stanford.edu


IV. Code Reference
--------------
OMP.m refered the implementatino of https://github.com/porvaznikmichal/ETH-Image-Inpainting 

