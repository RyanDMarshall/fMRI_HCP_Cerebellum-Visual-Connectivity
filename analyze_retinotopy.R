library(dplyr)
library(ggplot2)
library(gridExtra)
library(ply)
---
  title: "retinotopic_cerebellum.Rmd"
author: "Ryan Marshall"
date: '2023-05-10'
output: pdf_document
---
  
  ```{r}
library(dplyr)
library(ggplot2)
library(gridExtra)

# define streams
streams <- list(
  dorsal = c("V1d", "V2d", "V3d", "V3A", "V3B", "IPS0", "IPS1", "IPS2", "IPS3", "IPS4", "IPS5", "SPL1", "FEF"),
  ventral = c("V1v", "V2v", "V3v", "hV4", "VO1", "VO2", "PHC1", "PHC2"),
  lateral = c("LO1", "LO2", "TO1", "TO2")
)

streams_big <- list(
  early_dorsal = c("V1d","V2d","V3d"),
  mid_dorsal = c("V3A","V3B","IPS0","IPS1","IPS2"),
  late_dorsal = c("IPS3","IPS4","FEF"),
  early_lateral = c("LO1","LO2"),
  late_lateral = c("TO1","TO2"),
  early_ventral = c("V1v", "V2v", "V3v"),
  mid_ventral = c("hV4","VO1","VO2"),
  late_ventral = c("PHC1","PHC2")
)

# Define the color palette
dorsal_palette <- c("#00BFC4", "#00939C", "#007377")
ventral_palette <- c("#F8766D", "#C43C35", "#7F0000")
lateral_palette <- c("#FFB85F", "#D46F00")
color_palette_full <- c(dorsal_palette, ventral_palette, lateral_palette)
color_palette_small <- c("#00BFC4", "#F8766D", "#FFB85F")


## Load data
df <- as.data.frame(read.csv("retinotopic_tstats_full.csv"))
rois <- as.list(unique(df$roi))
nsub = 166; dof = nsub - 2;

rois_reorder <- c("V1d", "V2d", "V3d", "V3A", "V3B", 
                  "IPS0", "IPS1", "IPS2", "IPS3", 
                  "IPS4", "IPS5", "SPL1", "FEF", 
                  "V1v", "V2v", "V3v", "hV4", 
                  "VO1", "VO2", "PHC1", "PHC2", 
                  "LO1", "LO2", "TO1", "TO2")
rois_reorder <- rois_reorder[rois_reorder!=c("IPS5", "SPL1")]

df <- df %>% filter(cb_idx != 0 & roi %in% rois_reorder) %>%
  mutate(stream = case_when(
    roi %in% streams$dorsal ~ "dorsal",
    roi %in% streams$ventral ~ "ventral",
    roi %in% streams$lateral ~ "lateral"
  )) %>% 
  mutate(stream = factor(stream, levels = c("dorsal", "ventral", "lateral"))) %>% 
  mutate(stream_depth = case_when(
    roi %in% streams_big$early_dorsal ~ "early_dorsal",
    roi %in% streams_big$mid_dorsal ~ "mid_dorsal",
    roi %in% streams_big$late_dorsal ~ "late_dorsal",
    roi %in% streams_big$early_lateral ~ "early_lateral",
    roi %in% streams_big$late_lateral ~ "late_lateral",
    roi %in% streams_big$early_ventral ~ "early_ventral",
    roi %in% streams_big$mid_ventral ~ "mid_ventral",
    roi %in% streams_big$late_ventral ~ "late_ventral"
  )) %>%
  mutate(stream_depth = factor(stream_depth, levels = c("early_dorsal", "mid_dorsal", "late_dorsal", "early_ventral", "mid_ventral", "late_ventral","early_lateral","late_lateral")))

cb_roi_full_map <- list("R_lat_VIIIb/IX","R_med_VIIIb/IX","L_med_VIIIb/IX","L_lat_VIIIb/IX","L_VIIb/VIIIa","R_VIIb/VIIIa","L_med_OMV","L_lat_OMV","R_med_OMV","R_lat_OMV" )

cb_roi_full_reorder <- list("L_lat_VIIIb/IX","L_med_VIIIb/IX","L_VIIb/VIIIa","L_lat_OMV","L_med_OMV","R_med_OMV","R_lat_OMV","R_VIIb/VIIIa","R_med_VIIIb/IX","R_lat_VIIIb/IX" )
cb_roi_full_reorder_RL <- list("L_med_OMV","R_med_OMV","L_lat_OMV","R_lat_OMV","L_VIIb/VIIIa","R_VIIb/VIIIa","L_med_VIIIb/IX","R_med_VIIIb/IX","L_lat_VIIIb/IX","R_lat_VIIIb/IX" )
cb_roi_full_reorder_bh <- list("med_OMV","lat_OMV","VIIb/VIIIa","med_VIIIb/IX","lat_VIIIb/IX")

# define mapping for cb_roi and cb_hemi
cb_roi_map <- c("lat_VIIIb/IX","med_VIIIb/IX","med_VIIIb/IX","lat_VIIIb/IX","VIIb/VIIIa","VIIb/VIIIa","med_OMV","lat_OMV","med_OMV","lat_OMV")
cb_hemi_map <- c("R","R","L", "L", "L", "R", "L", "L", "R", "R")

df$cb_roi_full <- cb_roi_full_map[df$cb_idx]
df$cb_roi <- cb_roi_map[df$cb_idx]
df$cb_hemi <- cb_hemi_map[df$cb_idx]

bh_pear_df <- df %>% filter(hemi == "bilat" & corrtype == "pearson")
lh_pear_df <- df %>% filter(hemi == "lh" & corrtype == "pearson")
lhrh_pear_df <- df %>% filter(hemi != "bilat" & corrtype == "pearson")
rh_pear_df <- df %>% filter(hemi == "rh" & corrtype == "pearson")
lhrh_pear_diff <- lh_pear_df %>% select(roi,stream,stream_depth,corrtype)
lhrh_pear_diff$tdiff <- lh_pear_df$t - rh_pear_df$t

lh_part_df <- df %>% filter(hemi == "lh" & corrtype == "partial")
rh_part_df <- df %>% filter(hemi == "rh" & corrtype == "partial")

```
# Create t boxplots for each ROI averaged across cb_roi and grouped by stream_depth
```{r}
bh_pear_df %>%
  group_by(roi, stream_depth) %>%
  # Plot data
  ggplot(aes(x = factor(roi, levels = rois_reorder), y = t, fill= stream_depth), fill = stream_depth) +
  geom_boxplot() +
  facet_grid(scales = "fixed") +
  scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
  labs(title = paste0("bilat pearson t values across retinotopic cerebellar seeds"),
       x = "ROI",
       y = "T value") +
  scale_fill_manual(values=color_palette_full)

# Create t boxplots for each bilateral cerebellar retinotopic seeds, also grouped by stream_depth
bh_pear_df %>%
  group_by(roi, stream_depth) %>%
  # Plot data
  ggplot(aes(x = factor(cb_roi, levels = cb_roi_full_reorder_bh), y = t, fill = stream_depth)) +
  geom_boxplot() +
  facet_grid(scales = "fixed") +
  scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
  labs(title = paste0("bilat pearson t values across retinotopic cerebellar seeds"),
       x = "ROI",
       y = "T value") +
  scale_fill_manual(values=color_palette_full)

# Create same boxplots but converted to correlation values from t statistic
bh_pear_df %>%
  mutate(r = sqrt(t^2 / (t^2 + dof))) %>%
  group_by(roi, stream_depth) %>%
  # Plot data
  ggplot(aes(x = factor(roi, levels = rois_reorder), y = r, fill= stream_depth), fill = stream_depth) +
  geom_boxplot() +
  facet_grid(scales = "fixed") +
  scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
  scale_y_continuous(limits = c(0,1), breaks = seq(0,1,.1)) + 
  labs(title = paste0("bilat pearson r values by cortical ROI"),
       x = "ROI",
       y = "Effect size r") +
  scale_fill_manual(values=color_palette_full)

# Filter and group data
bh_pear_df %>%
  mutate(r = sqrt(t^2 / (t^2 + dof))) %>%
  group_by(roi, stream_depth) %>%
  # Plot data
  ggplot(aes(x = factor(cb_roi, levels = cb_roi_full_reorder_bh), y = r, fill = stream_depth)) +
  geom_boxplot() +
  facet_grid(scales = "fixed") +
  scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
  scale_y_continuous(limits = c(0,1), breaks = seq(0,1,.1)) + 
  labs(title = paste0("bilat pearson r values by retinotopic cerebellar ROI"),
       x = "ROI",
       y = "Effect size (r)") +
  scale_fill_manual(values=color_palette_full)
  