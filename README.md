# fMRI_HCP_Cerebellum-Visual-Connectivity
Analyzing functional connectivity between visual cortex and the retinotopic cerebellum 

This project utilizes a public high-field fMRI dataset (HCP 7T-YA; n = 166 subjects) to investigate functional connectivity between visual cortex & retinotopic cerebellum.

We analyzed seed-to-voxel connectivity using each of 25 bilateral visual seeds (Wang et al., 2019) to the cerebellum, then investigated the resulting connectivity profiles by their strength of connectivity with each of 5 bilateral retinotopic cerebellar regions (Diedrichsen et al., 2019).

Analysis was performed at the level of individual subjects, then a nonparametric threshold-free cluster enhancement (Smith & Nichols, 2009) procedure was used to nonparametrically generate group-average cerebellar connectivity profiles from each cortical ROI.

An additional secondary analysis investigated visual connectivity lateralization by comparing the connectivity results using Pearson and partial correlation approaches (i.e., for each hemispheric cortical ROI, generate an average ROI-level BOLD timeseries, then compute the partial correlation between this and the BOLD timeseries of each cerebellar voxel while regressing out the average signal from the contralateral cortical ROI).

Further analyses investigated systematic differences in connectivity profiles across each of the dorsal, ventral, and lateral visual streams.

If you have questions, please contact ryanmarshall@fas.harvard.edu for more information. This code was used to generate a chapter of my dissertation (not necessarily built for direct public use!)
