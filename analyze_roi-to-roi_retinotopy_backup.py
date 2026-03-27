import os
import csv
import math
import itertools
import nibabel as nb
import numpy as np
import pandas as pd
import scipy as sp
import matplotlib.pyplot as plt
from scipy.cluster.hierarchy import linkage, dendrogram
from pathlib import Path

def setup_retinotopic_connectivity(which_stat="pearson"):
	proj_dir = f'projectnb/somerslab/ryanmars/projects/CrossTaskAnalysis/proj_allrest/results/group/HCP_SUIT'
	atlas_dir = f'projectnb/somerslab/ryanmars/atlases'

	ctx_atlas_fn = f'/projectnb/somerslab/ryanmars/projects/CrossTaskAnalysis/proj_allrest/results/group/HCP_SUIT/rois-sorted.txt'
	ctx_atlas = np.loadtxt(ctx_atlas_fn,dtype=str)

	cb_labels_fn = f'/{atlas_dir}/cerebellum/vanEsRetinotopy/cerebellum_retmaps.csv'
	cb_ret_labels = np.loadtxt(cb_labels_fn, dtype=str, delimiter=',')
	cb_ret_vals = cb_ret_labels[:,1]
	cb_ret_keys = [int(x) for x in cb_ret_labels[:,0]]

	cb_atlas_fn = f'/{atlas_dir}/cerebellum/vanEsRetinotopy/cerebellum_retmaps.nii'
	cb_atlas = nb.load(cb_atlas_fn)
	cb_atlas_nii = nb.load(cb_atlas_fn)
	cb_atlas_fd = cb_atlas_nii.get_fdata()

	#print("hello")

	ex_roi='FEF'
	corrtype=which_stat
	hemis = ["bilat"] if corrtype == "pearson" else ["lh", "rh"]
	#print("hello2")

	ex_hemi = hemis[0]
	ex_subs_map_fn = f'/{proj_dir}/{ex_roi}/perms-{corrtype}_unthresholded_fisherz/allsubjects_{ex_roi}.{ex_hemi}.fisherz.SUIT.dscalar.nii'
	ex_group_map_fn = f'/{proj_dir}/{ex_roi}/perms-{corrtype}_unthresholded_fisherz/perm_vsm4_{ex_roi}_{ex_hemi}_{corrtype}_tstat1.nii.gz'
	ex_subs_map = nb.load(ex_subs_map_fn)
	ex_group_map = nb.load(ex_group_map_fn)

	ex_subs_map_fd = ex_subs_map.get_fdata()
	ex_sub_map = ex_subs_map_fd[:,:,:,0]

	n_ctx_rois = np.size(ctx_atlas); n_cb_rois = np.size(cb_ret_vals);
	n_subs = np.shape(ex_subs_map_fd)[3]
	n_hemis = len(hemis)

	#print("hello3")
	#print(hemis,n_hemis)

	corrs_cb_by_roi = np.zeros(shape = (n_ctx_rois, n_ctx_rois, n_hemis));
	mean_corrs_bysub = np.zeros(shape = (n_subs, n_ctx_rois, n_cb_rois, n_hemis));
	mean_tstats_bygroup = np.zeros(shape = (n_ctx_rois, n_cb_rois, n_hemis));
	mean_pvals_bygroup = np.zeros(shape = (n_ctx_rois, n_cb_rois, n_hemis))
	
	## Group whole-cerebellum correlations 
	for hemi_i in range(0,n_hemis):
		#print("hello4")
		hemi = hemis[hemi_i]
		for roi_i in range(0,n_ctx_rois):
			#print("hello5")
			roi = ctx_atlas[roi_i]
			roi_subs_fn = f'/{proj_dir}/{roi}/perms-{corrtype}_unthresholded_fisherz/allsubjects_{roi}.{hemi}.fisherz.SUIT.dscalar.nii'
			roi_subs_fisherz = nb.load(roi_subs_fn)
			roi_subs_fisherz_fd = roi_subs_fisherz.get_fdata()
		
			roi_group_pval_fn = f'/{proj_dir}/{roi}/perms-{corrtype}_unthresholded_fisherz/perm_vsm4_{roi}_{hemi}_{corrtype}_tfce_corrp_tstat1.nii.gz'
			roi_group_pval = nb.load(roi_group_pval_fn)
			roi_group_pval_fd = roi_group_pval.get_fdata()
	
			roi_group_tstat_fn = f'/{proj_dir}/{roi}/perms-{corrtype}_unthresholded_fisherz/perm_vsm4_{roi}_{hemi}_{corrtype}_tstat1.nii.gz'
			roi_group_tstat = nb.load(roi_group_tstat_fn)
			roi_group_tstat_fd = roi_group_tstat.get_fdata()

			for cb_roi_i in range(0,n_cb_rois):
				cb_roi_idx = cb_ret_keys[cb_roi_i]
				cb_roi_label = cb_ret_vals[cb_roi_i]
	
				cb_roi_group_map = roi_group_tstat_fd[cb_atlas_fd==cb_roi_idx]
				mean_tstats_bygroup[roi_i,cb_roi_i,hemi_i] = np.mean(cb_roi_group_map)
	
				cb_roi_pvals = 1 - roi_group_pval_fd[cb_atlas_fd==cb_roi_idx] # TFCE output is 1 - p value
				cb_roi_zvals = sp.stats.norm.ppf(1 - cb_roi_pvals / 2)
				cb_roi_mean_zval = np.mean(cb_roi_zvals)
				mean_pvals_bygroup[roi_i,cb_roi_i,hemi_i] = 2 * (1 - sp.stats.norm.cdf(abs(cb_roi_mean_zval)))
	
				for sub_i in range(0,n_subs):
					sub_map = roi_subs_fisherz_fd[:,:,:,sub_i]
					cb_roi_sub_map = sub_map[cb_atlas_fd==cb_roi_idx]
					mean_corrs_bysub[sub_i,roi_i,cb_roi_i,hemi_i] = np.mean(cb_roi_sub_map)
	
			for roi_j in range(0,n_ctx_rois):
				roi2 = ctx_atlas[roi_j]
				roi2_group_fn = f'/{proj_dir}/{roi2}/perms-{corrtype}_unthresholded_fisherz/perm_vsm4_{roi2}_{hemi}_{corrtype}_tstat1.nii.gz'
				roi2_group_tstat = nb.load(roi2_group_fn)
				roi2_group_tstat_fd = roi2_group_tstat.get_fdata()
		
				corrs_cb_by_roi[roi_i,roi_j,hemi_i] = np.corrcoef(np.ndarray.flatten(roi_group_tstat_fd), np.ndarray.flatten(roi2_group_tstat_fd))[0,1]

	#print("hello6")
	class Output:
		pass

	output = Output()
	output.proj_dir = proj_dir
	output.corrtype = corrtype
	output.ctx_atlas = ctx_atlas
	output.cb_atlas = cb_ret_vals
	output.group_mean_tstats = mean_tstats_bygroup
	output.group_mean_pvals = mean_pvals_bygroup
	output.subs_mean_zcorr = mean_corrs_bysub
	output.pairwise_roi_corrs = corrs_cb_by_roi
	return output

def run_pairwise_ttests(proj_dir, ctx_atlas, cb_ret_vals, mean_corrs_bysub):## Pairwise cerebellar t-tests by cortical ROI
	output_paired_cb_tstats_fn = f'/{proj_dir}/paired_cb_tstats_by_cortical_roi.csv'
	n_ctx_rois = len(ctx_atlas)
	n_cb_rois = len(cb_ret_vals)
	for i in range(0,n_ctx_rois):
		for j, k in list(itertools.combinations(range(0,n_cb_rois),2)):
			ttest_output = sp.stats.ttest_ind(mean_corrs_bysub[:,i,j],mean_corrs_bysub[:,i,k],equal_var=False)
			tstat = ttest_output.statistic; pval = ttest_output.pvalue;
			with open(output_paired_cb_tstats_fn, 'a') as f:
					print(f'{ctx_atlas[i]},{cb_ret_vals[j]},{cb_ret_vals[k]},',"{:6.4f}".format(tstat),',',"{:.{}e}".format(pval,5),file=f,sep="")

	## Pairwise cortical t-tests by cerebellar ROI
	output_paired_ctx_tstats_fn = f'/{proj_dir}/paired_ctx_tstats_by_cerebellar_roi.csv'
	for i in range(0,n_cb_rois):
		for j, k in list(itertools.combinations(range(0,n_ctx_rois),2)):
			ttest_output = sp.stats.ttest_ind(mean_corrs_bysub[:,j,i],mean_corrs_bysub[:,k,i],equal_var=False)	
			tstat = ttest_output.statistic; pval = ttest_output.pvalue;
			with open(output_paired_ctx_tstats_fn, 'a') as f:
					print(f'{cb_ret_vals[i]},{ctx_atlas[j]},{ctx_atlas[k]},',"{:6.4f}".format(tstat),',',"{:.{}e}".format(pval,5),file=f,sep="")

## Plot dendrogram based on [n_cb_rois x n_ctx_rois] pairwise correlations
# Input is the output from setup_retinotopic_connectivyt
def plot_cb_dendrogram(input):
	corrs_cb_by_roi = input.pairwise_roi_corrs
	ctx_atlas = input.ctx_atlas
	rm_idx = [index for index, item in enumerate(ctx_atlas) if item == "SPL1" or item == "IPS5"]
	corrs_cb_by_roi = np.delete(corrs_cb_by_roi,rm_idx,0)
	corrs_cb_by_roi = np.delete(corrs_cb_by_roi,rm_idx,1)
	ctx_atlas = np.delete(ctx_atlas,rm_idx)
	n_hemis=np.shape(corrs_cb_by_roi)[2]
	hemis = ["bilat"] if n_hemis==1 else ["lh", "rh"]
	fig, axes = plt.subplots(nrows=n_hemis, ncols=1)
	for i in range(0,n_hemis):
		hemi=hemis[i]
		ax=axes[i] if n_hemis==2 else axes
		dist = 1 - corrs_cb_by_roi[:,:,i]; links = linkage(dist, method = 'ward')
		dendrogram(links, ax=ax, labels=ctx_atlas, leaf_rotation=45.);
		plt.xlabel('ROIs'); plt.ylabel('Distance'); 
		plt.title('Dendrogram of visual functional connectivity with cerebellum'); 
		ax.set_title(hemi)
	plt.tight_layout()
	fig.show()
	return fig


## Input is the direct output of setup_retinotopic_connectivity(),
# plot_which_labels can be a string for a single label (default V1v) or a list of strings for multiple labels
# plot_which_stat can be "t" (default) or "p" (z to be added?)
# layout_override (optional) is a 2-element array, [num_desired_rows, num_desired_columns]
#
# The function identifies from the input whether the correlations are bilateral pearson 
#   or unilateral partical correlations
# If pearson, one plot is created per label; If partials, two plots are created (left 
#   corresponding to left hemisphere cortex and right to right cortex)
# It identifies whether each label is a cortical label or a cerebellar label and then plots its connectivity
#   against all ROIs from the opposite region. Left and right cerebellar ROIs are plotted on each map
#   (left cerebellar in green, right cerebellar in red) (TODO: switch to colorblind-friendly or customizable template
def plot_rose(input, plot_which_labels="V1v", plot_which_stat="t", scale_max=10, layout_override=None):

	mean_tstats_bygroup = input.group_mean_tstats
	mean_pvals_bygroup = input.group_mean_pvals
	ctx_labels = input.ctx_atlas
	cb_labels = input.cb_atlas

	if isinstance(plot_which_labels,str):
		plot_which_labels = [plot_which_labels]

	n_hemis = np.shape(mean_tstats_bygroup)[2]
	n_plots = len(plot_which_labels) * n_hemis
	n_rows = math.isqrt(n_plots)
	n_cols = math.ceil(n_plots / n_rows)
	
	if layout_override is not None:
			n_rows = layout_override[0]
			n_cols = layout_override[1]

	hemis = ["lh","rh"] if n_hemis==2 else ["bilat"]

	if plot_which_stat == "p":
		connectivity = -np.log10(mean_pvals_bygroup)
	elif plot_which_stat == "t":
		connectivity = mean_tstats_bygroup

	ctx_label_order = ["V1d", "V2d", "V3d", "V3A", "V3B", "IPS0", "IPS1", "IPS2", "IPS3", "IPS4", "IPS5", "SPL1", "FEF",
						"LO1", "LO2", "TO1", "TO2", "PHC2", "PHC1", "VO2", "VO1", "hV4", "V3v", "V2v", "V1v"]
	cb_label_order = ["mOMV", "lOMV", "VIIb", "mVIIIb", "lVIIIb"]
	cb_label_order_full = ["left_mOMV", "left_lOMV", "left_VIIb", "left_mVIIIb", "left_lVIIIb", "right_mOMV", "right_lOMV", "right_VIIb", "right_mVIIIb", "right_lVIIIb"]
	ctx_groups = [["V1d", "V2d", "V3d"], ["V3A", "V3B", "IPS0", "IPS1", "IPS2"], ["IPS3", "IPS4", "IPS5", "SPL1", "FEF"],
					["LO1", "LO2"], ["TO1", "TO2"], ["PHC1", "PHC12"], ["VO1", "VO2", "hV4"], ["V1v", "V2v", "V3v"]]
	cb_groups = [["mOMV","lOMV"],["VIIb"],["mVIIIb","lVIIIb"]]
	plot_which_structure = ['ctx' if elem in ctx_labels else 'cb' if elem in cb_label_order else elem for elem in plot_which_labels]

	if n_hemis == 2:
		connectivity_ctx_lh = connectivity[:,:,0]
		connectivity_ctx_rh = connectivity[:,:,1]
		connectivity_ctx_lh = pd.DataFrame(connectivity_ctx_lh, index = ctx_labels, columns = cb_labels)
		connectivity_ctx_rh = pd.DataFrame(connectivity_ctx_rh, index = ctx_labels, columns = cb_labels)
		connectivity_ctx_lh = connectivity_ctx_lh.loc[ctx_label_order,cb_label_order_full]
		connectivity_ctx_rh = connectivity_ctx_rh.loc[ctx_label_order,cb_label_order_full]
		connectivity = np.vstack((connectivity_ctx_lh, connectivity_ctx_rh))
	else:
		connectivity = np.squeeze(connectivity)
		connectivity = pd.DataFrame(connectivity, index = ctx_label_order, columns = cb_labels)
		connectivity = connectivity.loc[ctx_label_order,cb_label_order_full]

	fig, axes = plt.subplots(nrows=n_rows, ncols=n_cols, subplot_kw={'projection':'polar'})
	if n_rows == 1 or n_cols == 1:
		axes = np.atleast_2d(axes)

	for i in range(n_plots, n_rows * n_cols):
		axes.flat[i].set_visible(False)
	
	for i in range(0,len(plot_which_labels)):
		for j in range(0,n_hemis):
			ax = axes.flat[2*i+j]
			roi = str(plot_which_labels[i])
			structure = plot_which_structure[i]
			title = hemis[j] + roi
			ax.set_title(title)

			if structure == "ctx": # For a cortical ROI we plot against cerebellar ROIs and vice versa
				angles = np.array(np.linspace(0, 2 * np.pi, len(cb_label_order), endpoint=False).tolist())
				label_order = cb_label_order
				ctx_idx = [index for index, item in enumerate(ctx_label_order) if item == roi]

				left_idx = [index for index, item in enumerate(cb_label_order_full) if item.startswith("left_")]
				right_idx = [index for index, item in enumerate(cb_label_order_full) if item.startswith("right_")]
		
				connectivity_lh = connectivity[25*j+np.array(ctx_idx),left_idx]
				connectivity_rh = connectivity[25*j+np.array(ctx_idx),right_idx]
		
			elif structure == "cb":
				angles = np.array(np.linspace(0, 2 * np.pi, len(ctx_label_order), endpoint=False).tolist())
				label_order = ctx_label_order	
				cb_idx_lh = np.where([elem.endswith(roi) and elem.startswith("left_") for elem in cb_label_order_full])
				cb_idx_rh = np.where([elem.endswith(roi) and elem.startswith("right_") for elem in cb_label_order_full])
			
				connectivity_lh = np.ndarray.flatten(connectivity[25*j:25*(j+1),cb_idx_lh])
				connectivity_rh = np.ndarray.flatten(connectivity[25*j:25*(j+1),cb_idx_rh])
			
			ax.set_xticks(angles)
			ax.set_xticklabels(label_order)
			ax.plot(angles, connectivity_lh, marker='o', color='green')
			ax.plot(angles, connectivity_rh, marker='o', color='red')
		
		#ax.set_theta_offset(np.pi/2)
			if plot_which_stat == "p":
				ax.set_yticks([0.0, 1.0, 2.0, 3.0, 4.0])  # Customize the y-axis ticks as needed
				#ax.set_xlabel('-log10(p)')
			elif plot_which_stat == "t":
				ax.set_yticks(np.linspace(0,scale_max,int((scale_max/2) + 1)))
				#ax.set_xlabel('mean tstat')

	fig.tight_layout()
	fig.show()
	return fig

