#####################################################
# Description: Chick Embryo | Somite Period Analysis
# Author: Isabel Duarte <iduarte.scientist@gmail.com>
# Date: April 2023
# Citation: This analysis is part of the publication:
#           Spatio-temporal Dynamics of early somite segmentation
#           in the chicken embryo. Ana Maia-Fernandes, et al. 2023.
#           XPTO journal.
# Notes:    Early somites refers to somites 1-9.
#           Late somites, refers to somites 14-20.
#####################################################

## Load required packages
library(ggbeeswarm)
library(ggrepel)
library(ggsci) # color palettes
library(colorspace)
library(rstatix)
library(patchwork)
library(tidyverse)
library(here)

## Install and Load the SomiteExploreR package (that makes available the data)

# remotes::install_github('iduarte/SomiteExploreR')
# library(SomiteExploreR)

## Path to save the outpt
output_path <- here('output_plots/')

## Create separate data frames for early and late somites based on the metadata input file
somite_summary_early <- filter(somite_periods, DevelTime == 'Early')
somite_summary_late <- filter(somite_periods, DevelTime == 'Late')

#### Plots | Early somites ####

## Create color palette

### Function to get the default colors from ggplot2
gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}
myPal_early <- gg_color_hue(9)

## List to save all plots
somite_plots <- list()

#
##
### Plotting Early somites
##
#

### Plot "stairs" ###
somite_plots$stairs <-
  ggplot(
    data = filter(embryo_lengths, DevelTime == 'Early'),
    mapping = aes(x = time, y = length, color = somite_id)
  )
somite_plots$stairs +
  geom_point() +
  scale_color_manual (values = myPal_early) +
  scale_fill_manual (values = myPal_early) +
  xlab('Time (min)') + ylab('Length (um)') +
  ggtitle("Early | Somite Length per Time", subtitle = "Somite Classification") +
  facet_wrap( ~ embryo_id)
ggsave(
  path = output_path,
  filename = "stairs_early.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 280,
  height = 195,
  units = "mm"
)

## Plot length vs period
somite_plots$len_period <- ggplot(
  data = somite_summary_early,
  mapping = aes(x = somite_period,
                y = somite_length,
                fill = somite_id)
)

somite_plots$len_period +
  geom_point(pch = 21, size = 3.5, alpha = 0.7) +
  scale_color_manual (values = myPal_early) +
  scale_fill_manual (values = myPal_early) +
  xlab('Somite formation time (min)') +
  ylab('Somite length (um)') +
  ggtitle("Early | Somite Length vs Somite Formation Time") +
  xlim(c(0, 150)) +
  ylim(c(50, 260)) +
  scale_x_continuous(breaks = seq(0, 150, 15)) +
  facet_wrap( ~ embryo_id)
ggsave(
  path = output_path,
  filename = "length_per_period_early.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 280,
  height = 195,
  units = "mm"
)


### ### ### ### ### ### ### ### ### ### ### ### ### ###
####               Early Period plots              ####
### ### ### ### ### ### ### ### ### ### ### ### ### ###

## Period distribution per somite - beeswarm is preferred over points because some points will be hidden
somite_plots$period_som <- ggplot(data = somite_summary_early,
                                  mapping = aes(x = somite_id,
                                                y = somite_period))

## Period distribution per somite - beeswarm color by somite
somite_plots$period_som +
  geom_violin(draw_quantiles = 0.5, color = "grey") +
  geom_beeswarm(
    aes(fill = somite_id),
    cex = 1,
    pch = 21,
    size = 3.5,
    alpha = 0.75
  ) +
  scale_fill_manual (values = myPal_early) +
  xlab('Somite') + ylab('Somite formation time (min)') +
  ggtitle("Early | Period distribution per Somite", subtitle = "Color by somite") +
  scale_y_continuous(breaks = seq(0, 135, 15), limits = c(0, 135))
ggsave(
  path = output_path,
  filename = "period_per_somite_colSomite_early.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 280,
  height = 195,
  units = "mm"
)


## Period distribution per embryo
somite_plots$period_emb <- ggplot(data = somite_summary_early,
                                  mapping = aes(x = embryo_id,
                                                y = somite_period))

## Period distribution per embryo - beeswarm color by embryo
somite_plots$period_emb +
  geom_violin(draw_quantiles = 0.5, color = "grey") +
  geom_beeswarm(
    aes(fill = somite_id),
    cex = 1,
    pch = 21,
    size = 3.5,
    alpha = 0.7
  ) +
  scale_color_manual (values = myPal_early) +
  scale_fill_manual (values = myPal_early) +
  xlab('') + ylab('Somite formation time (min)')  +
  ggtitle("Early | Somite Period distribution per Embryo", subtitle = "Color by somite") +
  scale_y_continuous(breaks = seq(0, 135, 15), limits = c(0, 135)) +
  guides(x = guide_axis(angle = 90))
ggsave(
  path = output_path,
  filename = "period_per_embryo_colSomite_early.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 280,
  height = 195,
  units = "mm"
)

### ### ### ### ### ### ### ### ### ### ### ### ### ###
####              Early Length plots               ####
### ### ### ### ### ### ### ### ### ### ### ### ### ###

## Length distribution per somite
somite_plots$length_som <- ggplot(data = somite_summary_early,
                                  mapping = aes(x = somite_id,
                                                y = somite_length))

somite_plots$length_som +
  geom_violin(draw_quantiles = 0.5, color = "grey") +
  geom_beeswarm(aes(fill = somite_id),
                pch = 21,
                size = 3.5,
                alpha = 0.9) +
  scale_fill_manual (values = myPal_early) +
  xlab('Somite') + ylab('Somite length (um)') +
  ggtitle("Early | Somite Length distribution per Somite", subtitle = 'Color by somite') +
  ylim(c(50, 260))
ggsave(
  path = output_path,
  filename = "length_per_somite_colSomite_early.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 280,
  height = 195,
  units = "mm"
)

## Length distribution per embryo
somite_plots$length_emb <- ggplot(data = somite_summary_early,
                                  mapping = aes(x = embryo_id,
                                                y = somite_length))

somite_plots$length_emb +
  geom_violin(draw_quantiles = 0.5, color = "grey") +
  geom_beeswarm(aes(fill = somite_id),
                pch = 21,
                size = 3.5,
                alpha = 0.7) +
  scale_color_manual (values = myPal_early) +
  scale_fill_manual (values = myPal_early) +
  xlab('') + ylab('Somite length (um)') +
  ggtitle("Early | Somite Length distribution per Embryo", subtitle = 'Color by somite') +
  ylim(c(50, 260)) +
  guides(x = guide_axis(angle = 90))
ggsave(
  path = output_path,
  filename = "length_per_embryo_colSomite_early.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 280,
  height = 195,
  units = "mm"
)

#### Plots | Late somites ####

## Create color palette

### Personally chosen colors
myPal_late <- c("#e6194B", "#f58231", "#ffe119",
                "#bfef45", "#3cb44b", "#42d4f4",
                "#4363d8", "#911eb4", "#f032e6",
                "#a9a9a9", "#e6beff", "#aaffc3")

#
##
### Plotting Late somites
##
#

### Plot stairs ###
somite_plots$stairs_late <-
  ggplot(
    data = filter(embryo_lengths, DevelTime == 'Late'),
    mapping = aes(x = time,
                  y = length)
  )

somite_plots$stairs_late +
  geom_point(aes(color = somite_id)) +
  scale_color_manual (values = myPal_late) +
  scale_fill_manual (values = myPal_late) +
  xlab('Time (min)') + ylab('Length (um)') +
  ggtitle("Late | Somite Length per Time", subtitle = "Somite Classification") +
  facet_wrap( ~ embryo_id)
ggsave(
  path = output_path,
  filename = "stairs_late.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 280,
  height = 195,
  units = "mm"
)

## Plot length vs period
somite_plots$len_period_late <- ggplot(data = somite_summary_late,
                                       mapping = aes(x = somite_period,
                                                     y = somite_length))

somite_plots$len_period_late +
  geom_point(aes(fill = somite_id),
             pch = 21,
             size = 3.5,
             alpha = 0.7) +
  scale_color_manual (values = myPal_late) +
  scale_fill_manual (values = myPal_late) +
  xlab('Somite formation time (min)') + ylab('Somite length (um)') +
  ggtitle("Late | Somite Length vs Somite Formation Time") +
  facet_wrap( ~ embryo_id) +
  ylim(50, 260)
ggsave(
  path = output_path,
  filename = "length_per_period_late.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 280,
  height = 195,
  units = "mm"
)

### ### ### ### ### ### ### ### ### ### ### ### ### ###
####              Late Period plots                ####
### ### ### ### ### ### ### ### ### ### ### ### ### ###


## Period distribution per somite - beeswarm is preferred over points because some points will be hidden
somite_plots$period_som_late <- ggplot(data = somite_summary_late,
                                       mapping = aes(x = somite_id,
                                                     y = somite_period))

## Period distribution per somite - beeswarm color by somite
somite_plots$period_som_late +
  geom_violin(draw_quantiles = 0.5, color = "grey") +
  geom_beeswarm(
    aes(fill = somite_id),
    cex = 1,
    pch = 21,
    size = 3.5,
    alpha = 0.9
  ) +
  scale_color_manual (values = myPal_late) +
  scale_fill_manual (values = myPal_late) +
  xlab('Somite') + ylab('Somite formation time (min)') +
  ggtitle("Late | Period distribution per Somite", subtitle = "Color by somite") +
  scale_y_continuous(breaks = seq(0, 135, 15), limits = c(0, 135))
ggsave(
  path = output_path,
  filename = "period_per_somite_colSomite_late.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 280,
  height = 195,
  units = "mm"
)

## Period distribution per embryo
somite_plots$period_emb_late <- ggplot(data = somite_summary_late,
                                       mapping = aes(x = embryo_id,
                                                     y = somite_period))

## Period distribution per embryo - beeswarm color by somite
somite_plots$period_emb_late +
  geom_violin(draw_quantiles = 0.5, color = "grey") +
  geom_beeswarm(
    aes(fill = somite_id),
    cex = 1,
    pch = 21,
    size = 3.5,
    alpha = 0.9
  ) +
  scale_color_manual (values = myPal_late) +
  scale_fill_manual (values = myPal_late) +
  xlab('') + ylab('Somite formation time (min)')  +
  ggtitle("Late | Somite Period distribution per Embryo", subtitle = "Color by somite") +
  scale_y_continuous(breaks = seq(0, 135, 15), limits = c(0, 135))
ggsave(
  path = output_path,
  filename = "period_per_embryo_colSomite_late.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 280,
  height = 195,
  units = "mm"
)

### ### ### ### ### ### ### ### ### ### ### ### ### ###
####                Late Length plots              ####
### ### ### ### ### ### ### ### ### ### ### ### ### ###

## Length distribution per somite
somite_plots$length_som_late <- ggplot(data = somite_summary_late,
                                       mapping = aes(x = somite_id,
                                                     y = somite_length))

somite_plots$length_som_late +
  geom_violin(draw_quantiles = 0.5, color = "grey") +
  geom_beeswarm(aes(fill = somite_id),
                pch = 21,
                size = 3.5,
                alpha = 0.9) +
  scale_fill_manual (values = myPal_late) +
  xlab('Somite') + ylab('Somite length (um)') +
  ggtitle("Late | Somite Length distribution per Somite", subtitle = 'Color by somite') +
  ylim(c(50, 260))
ggsave(
  path = output_path,
  filename = "length_per_somite_colSomite_late.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 280,
  height = 195,
  units = "mm"
)

## Length distribution per embryo
somite_plots$length_emb_late <- ggplot(data = somite_summary_late,
                                       mapping = aes(x = embryo_id,
                                                     y = somite_length))

somite_plots$length_emb_late +
  geom_violin(draw_quantiles = 0.5, color = "grey") +
  geom_beeswarm(aes(fill = somite_id),
                pch = 21,
                size = 3.5,
                alpha = 0.9) +
  scale_color_manual (values = myPal_late) +
  scale_fill_manual (values = myPal_late) +
  xlab('') + ylab('Somite length (um)') +
  ggtitle("Late | Somite Length distribution per Embryo", subtitle = 'Color by somite') +
  ylim (c(50, 260))
ggsave(
  path = output_path,
  filename = "length_per_embryo_colSomite_late.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 280,
  height = 195,
  units = "mm"
)

## Plots | Detrended data

#
##
### Plotting Detrended Data
##
#

# Make plots with raw data detrended (to show the peaks of somite formation)
embryo_lengths %>%
  group_by(embryo_id) %>% select(length) %>%
  mutate(detrended = c(0, diff(length))) %>%
  mutate(my.index = row_number()) -> embryo_lengths_detrended

############# All embryos in the same plot #############
ggplot(
  embryo_lengths_detrended,
  aes(
    y = embryo_lengths_detrended$detrended,
    x = c(1:length(embryo_lengths_detrended$detrended)),
    colour = embryo_id
  )
) +
  geom_point () +
  geom_line() +
  xlab("Index (ordered measurements)") + ylab("Detrended Length (um)")
ggsave(
  path = output_path,
  filename = "detrended_all_embryos.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 280,
  height = 195,
  units = "mm"
)

############# Individual Plots in facet (same page with all plots) #############
somite_plots$detrended.plots <-
  ggplot(embryo_lengths_detrended,
         aes(y = detrended, x = my.index)) +
  geom_point () +
  geom_line() +
  xlab("Index (ordered measurements)") +
  ylab("Detrended Length (um)")
somite_plots$detrended.plots + facet_wrap(. ~ embryo_id)
ggsave(
  path = output_path,
  filename = "detrended_facet.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 280,
  height = 195,
  units = "mm"
)

############# Individual Plots (each plot separated in single image) #############

for (emb_id in unique(embryo_lengths_detrended$embryo_id)) {
  print(
    ggplot(embryo_lengths_detrended[embryo_lengths_detrended$embryo_id == emb_id, ],
           aes(y = detrended, x = my.index)) +
      geom_point () + geom_line() +
      xlab("Index (ordered measurements)") +
      ylab("Detrended Length (um)") +
      ggtitle(emb_id)
  )
  ggsave(
    path = output_path,
    filename = paste0("detrended_", emb_id, ".pdf"),
    plot = last_plot(),
    device = "pdf",
    width = 280,
    height = 195,
    units = "mm"
  )
}


#
##
#### Plots and Figures (plot-panels) for Publication ####
##
#

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
#### Panel 1 | Length per Somite, Color by Somite | Early and Late ####
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###

## Early
somite_plots$length_som +
  geom_violin(draw_quantiles = 0.5, color = "grey") +
  geom_beeswarm(
    aes(fill = somite_id),
    pch = 21,
    size = 3.5,
    alpha = 0.9,
    show.legend = FALSE
  ) +
  scale_fill_manual (values = myPal_early) +
  xlab('Somite number') + ylab('Somite length (micrometre)') +
  ylim(c(50, 260)) -> somite_plots$plot_panel1_early

## Late
somite_plots$length_som_late +
  geom_violin(draw_quantiles = 0.5, color = "grey") +
  geom_beeswarm(
    aes(fill = somite_id),
    pch = 21,
    size = 3.5,
    alpha = 0.9,
    show.legend = FALSE
  ) +
  scale_fill_manual (values = myPal_late) +
  xlab('Somite number') + ylab('Somite length (micrometre)') +
  ylim(c(50, 260)) -> somite_plots$plot_panel1_late

## Create panel
somite_plots$plot_panel1_early + somite_plots$plot_panel1_late + plot_annotation(tag_levels = 'A')

## Save plot
ggsave(
  path = output_path,
  filename = "panel1_somite_length_per_somite_colSomite.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 400,
  height = 200,
  units = "mm"
)


### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
#### Panel 2 | Period per Somite, Color by Somite | Early and Late ####
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###

## Early
somite_plots$period_som +
  geom_violin(draw_quantiles = 0.5, color = "grey") +
  geom_beeswarm(
    aes(fill = somite_id),
    cex = 1,
    pch = 21,
    size = 3.5,
    alpha = 0.75,
    show.legend = FALSE
  ) +
  scale_fill_manual (values = myPal_early) +
  xlab('Somite number') + ylab('Time (min)') +
  scale_y_continuous(breaks = seq(0, 135, 15), limits = c(0, 135)) -> somite_plots$plot_panel2_early

## Late
somite_plots$period_som_late +
  geom_violin(draw_quantiles = 0.5, color = "grey") +
  geom_beeswarm(
    aes(fill = somite_id),
    cex = 1,
    pch = 21,
    size = 3.5,
    alpha = 0.9,
    show.legend = FALSE
  ) +
  scale_color_manual (values = myPal_late) +
  scale_fill_manual (values = myPal_late) +
  xlab('Somite number') + ylab('Time (min)') +
  scale_y_continuous(breaks = seq(0, 135, 15), limits = c(0, 135)) -> somite_plots$plot_panel2_late

## Create panel
somite_plots$plot_panel2_early + somite_plots$plot_panel2_late +
  plot_annotation(tag_levels = 'A')

## Save plot
ggsave(
  path = output_path,
  filename = "panel2_period_per_somite_colSomite.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 400,
  height = 200,
  units = "mm"
)


### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
#### Panel 3 | Stairs | Early and Late ####
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###

## Early
somite_plots$stairs +
  geom_point(size = 0.2) +   ### XPTO | Check point size for final plot
  scale_color_manual (values = myPal_early) +
  scale_fill_manual (values = myPal_early) +
  xlab('Time (min)') + ylab('SEG length (micrometre)') +
  labs(color = "Somite #") +
  facet_wrap( ~ embryo_id, nrow = 3, ncol = 4) -> somite_plots$plot_panel3_stairs_early

## Late
somite_plots$stairs_late +
  geom_point(aes(color = somite_id), size = 0.2) +  ### XPTO | Check point size for final plot
  scale_color_manual (values = myPal_late) +
  scale_fill_manual (values = myPal_late) +
  xlab('Time (min)') + ylab('SEG length (micrometre)') +
  labs(color = "Somite #") +
  facet_wrap( ~ embryo_id, nrow = 1, ncol = 4) -> somite_plots$plot_panel3_stairs_late

## Create Panel
somite_plots$plot_panel3_stairs_early / (somite_plots$plot_panel3_stairs_late / plot_spacer()) +
  plot_annotation(tag_levels = 'A')

## Save plot
ggsave(
  path = output_path,
  filename = "panel3_stairs.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 210,
  height = 297,
  units = "mm"
)

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
#### Panel 4 | Length per Embryo, Color by Somite | Early and Late ####
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###

## Early
somite_plots$length_emb +
  geom_violin(draw_quantiles = 0.5, color = "grey") +
  geom_beeswarm(aes(fill = somite_id),
                pch = 21,
                size = 3.5,
                alpha = 0.7) +
  scale_color_manual (values = myPal_early) +
  scale_fill_manual (values = myPal_early) +
  xlab('Embryo') + ylab('Somite length (micrometre)') +
  scale_x_discrete(labels = LETTERS[1:11]) +
  labs(fill = "Somite #") +
  ylim(c(50, 260)) -> somite_plots$panel4_plot_length_embryo_colSomite_early

## Late
somite_plots$length_emb_late +
  geom_violin(draw_quantiles = 0.5, color = "grey") +
  geom_beeswarm(aes(fill = somite_id),
                pch = 21,
                size = 3.5,
                alpha = 0.9) +
  scale_color_manual (values = myPal_late) +
  scale_fill_manual (values = myPal_late) +
  xlab('Embryo') + ylab('Somite length (micrometre)') +
  scale_x_discrete(labels = c("J", "K", "L", "M")) +
  labs(fill = "Somite #") +
  ylim (c(50, 260)) -> somite_plots$panel4_plot_length_embryo_colSomite_late

## Create panel
somite_plots$panel4_plot_length_embryo_colSomite_early + somite_plots$panel4_plot_length_embryo_colSomite_late +
  plot_annotation(tag_levels = 'A')

## Save plot
ggsave(
  path = output_path,
  filename = "panel4_length_embryo_colSomite.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 400,
  height = 200,
  units = "mm"
)

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
#### Panel 5 | Period per Embryo, Color by Somite | Early and Late ####
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###

## Early
somite_plots$period_emb +
  geom_violin(draw_quantiles = 0.5, color = "grey") +
  geom_beeswarm(
    aes(fill = somite_id),
    cex = 1,
    pch = 21,
    size = 3.5,
    alpha = 0.7
  ) +
  scale_color_manual (values = myPal_early) +
  scale_fill_manual (values = myPal_early) +
  xlab('Embryo') + ylab('Time (min)')  +
  scale_x_discrete(labels = LETTERS[1:11]) +
  labs(fill = "Somite #") +
  scale_y_continuous(breaks = seq(0, 135, 15), limits = c(0, 135)) -> somite_plots$panel5_plot_period_embryo_colSomites_early

## Late
somite_plots$period_emb_late +
  geom_violin(draw_quantiles = 0.5, color = "grey") +
  geom_beeswarm(
    aes(fill = somite_id),
    cex = 1,
    pch = 21,
    size = 3.5,
    alpha = 0.9
  ) +
  scale_color_manual (values = myPal_late) +
  scale_fill_manual (values = myPal_late) +
  xlab('Embryo') + ylab('Time (min)')  +
  scale_x_discrete(labels = c("J", "K", "L", "M")) +
  labs(fill = "Somite #") +
  scale_y_continuous(breaks = seq(0, 135, 15), limits = c(0, 135)) -> somite_plots$panel5_plot_period_embryo_colSomites_late

## Create panel
somite_plots$panel5_plot_period_embryo_colSomites_early + somite_plots$panel5_plot_period_embryo_colSomites_late +
  plot_annotation(tag_levels = 'A')

## Save plot
ggsave(
  path = output_path,
  filename = "panel5_period_embryo_colSomite.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 400,
  height = 200,
  units = "mm"
)


### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
#### Detrended plot for publication ####
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###

ggplot(embryo_lengths_detrended[embryo_lengths_detrended$embryo_id == "EmbryoD",],
       aes(y = detrended, x = my.index)) +
  geom_point () + geom_line() +
  xlab("Index (ordered measurements)") +
  ylab("Detrended SEG length (micrometre)")

## Save plot
ggsave(
  path = output_path,
  filename = "panel0_detrended_plot_embryoD.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 280,
  height = 195,
  units = "mm"
)

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
#### Stairs for publication ####
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###

### Plot "stairs" ###
ggplot(
  data = filter(embryo_lengths, DevelTime == 'Early', embryo_id == 'EmbryoD'),
  mapping = aes(x = time, y = length, color = somite_id)
) +
  geom_point() +
  scale_color_manual (values = myPal_early) +
  scale_fill_manual (values = myPal_early) +
  scale_y_continuous(breaks = seq(0, 1600, 400), limits = c(0, 1600)) +
  xlab('Time (min)') + ylab('SEG length (micrometre)') +
  labs(color = "Somite #")

## Save plot
ggsave(
  path = output_path,
  filename = "panel0_stairs_plot_embryoD.pdf",
  plot = last_plot(),
  device = "pdf",
  width = 280,
  height = 195,
  units = "mm"
)

#### Linear modeling of somite formation ####

## Linear fitting to infer the rate of somite formation in head, neck, and trunk somites

# Create the variables required for the linear fitting
lm_data <- list()

somite_periods %>%
  ungroup() %>%
  mutate(nr_of_somites = as.numeric(somite_id)) %>%
  select(nr_of_somites, start_time, somite_period) %>%
  filter(nr_of_somites != 1 &
           nr_of_somites != 14) %>% # remove somites with no period
  group_by(nr_of_somites) %>%
  summarise(
    mean_period = round(mean(somite_period, na.rm = TRUE), 2),
    sd_period = round(sd(somite_period, na.rm = TRUE), 2),
    mean_start_time = round(mean(start_time, na.rm = TRUE), 2),
    sd_start_time = round(sd(start_time, na.rm = TRUE), 2)
  ) %>%
  mutate(region = c(rep("head", 4), rep("neck", 4), rep("trunk", 6))) -> lm_data$full

# Subset the data according to different fittings required
lm_data$head <- subset(lm_data$full, region == "head")
lm_data$neck <- subset(lm_data$full, region == "neck")
lm_data$trunk <- subset(lm_data$full, region == "trunk")

# Linear fit
lm_data$fit_head <-
  lm(mean_start_time ~ nr_of_somites, data = lm_data$head)
lm_data$fit_neck <-
  lm(mean_start_time ~ nr_of_somites, data = lm_data$neck)
lm_data$fit_trunk <-
  lm(mean_start_time ~ nr_of_somites, data = lm_data$trunk)

# Calculate 95% confidence interval for fit coefficients
lm_data$confint_head <- confint(lm_data$fit_head)
lm_data$confint_neck <- confint(lm_data$fit_neck)
lm_data$confint_trunk <- confint(lm_data$fit_trunk)

# Summary of fitted models
lm_data$summary_head <- summary(lm_data$fit_head)
lm_data$summary_neck <- summary(lm_data$fit_neck)
lm_data$summary_trunk <- summary(lm_data$fit_trunk)

### Relevant coefficients to include in plots
# R-squared
lm_data$r2_head <-
  paste0("R\u00B2 = ", round(lm_data$summary_head$r.squared, 4))
lm_data$r2_neck <-
  paste0("R\u00B2 = ", round(lm_data$summary_neck$r.squared, 4))
lm_data$r2_trunk <-
  paste0("R\u00B2 = ", round(lm_data$summary_trunk$r.squared, 4))

# Slopes
lm_data$slope_head <- round(lm_data$fit_head$coefficients[2], 2)
lm_data$slope_neck <- round(lm_data$fit_neck$coefficients[2], 2)
lm_data$slope_trunk <- round(lm_data$fit_trunk$coefficients[2], 2)

# Confidence intervals for slope
lm_data$slope_95_ci_head <- paste0("Slope = ", lm_data$slope_head, " \u00B1 ",
                                   round((
                                     lm_data$confint_head[2, 2] - lm_data$confint_head[2, 1]
                                   ) / 2, 2),
                                   " min")
lm_data$slope_95_ci_neck <- paste0("Slope = ", lm_data$slope_neck, " \u00B1 ",
                                   round((
                                     lm_data$confint_neck[2, 2] - lm_data$confint_neck[2, 1]
                                   ) / 2, 2),
                                   " min")
lm_data$slope_95_ci_trunk <- paste0("Slope = ", lm_data$slope_trunk, " \u00B1 ",
                                    round((
                                      lm_data$confint_trunk[2, 2] - lm_data$confint_trunk[2, 1]
                                    ) / 2, 2),
                                    " min")

# p-value of the fit formatC(numb, format = "e", digits = 2)
lm_data$pval_head <-
  paste0("p-value = ",
         formatC(
           lm_data$summary_head$coef[2, 4],
           format = "e",
           digits = 2
         ))
lm_data$pval_neck <-
  paste0("p-value = ",
         formatC(
           lm_data$summary_neck$coef[2, 4],
           format = "e",
           digits = 2
         ))
lm_data$pval_trunk <-
  paste0("p-value = ",
         formatC(
           lm_data$summary_trunk$coef[2, 4],
           format = "e",
           digits = 2
         ))

#### Linear modeling plot | Early somites

# Open the ggplot canvas
bind_rows(lm_data$head, lm_data$neck) %>%
  ggplot(., aes(x = nr_of_somites,
                y = mean_start_time)) -> lm_data$plots$early

# Add points
lm_data$plots$early +
  geom_point(
    aes(color = region),
    shape = 16,
    size = 3.5,
    alpha = 0.5,
    show.legend = FALSE
  ) +
  scale_color_manual (values = c("deepskyblue1", "orange")) +
  geom_errorbar(
    aes(
      ymin = mean_start_time - sd_start_time,
      ymax = mean_start_time + sd_start_time
    ),
    width = .1,
    color = c(rep("deepskyblue", 4), rep("orange", 4))
  ) -> lm_data$plots$early_points

# Add regression lines
lm_data$plots$early_points +
  geom_smooth(
    data = lm_data$head,
    method = "lm",
    color = "deepskyblue",
    se = TRUE,
    linetype = "solid",
    size = 0.8,
    alpha = 0.2
  ) +
  geom_smooth(
    data = lm_data$neck,
    method = "lm",
    color = "orange",
    se = TRUE,
    linetype = "solid",
    size = 0.8,
    alpha = 0.2
  ) -> lm_data$plots$early_points_lm

# Add text annotations with lm results for head
lm_data$plots$early_points_lm +
  annotate(
    "text",
    x = 2,
    y = 310,
    label = lm_data$slope_95_ci_head,
    hjust = 0,
    vjust = 1,
    size = 3.5,
    colour = "deepskyblue"
  ) +
  annotate(
    "text",
    x = 2,
    y = 270,
    label = lm_data$r2_head,
    hjust = 0,
    vjust = 1,
    size = 3.5,
    colour = "deepskyblue"
  ) +
  annotate(
    "text",
    x = 2,
    y = 230,
    label = "(n = 11)",
    hjust = 0,
    vjust = 1,
    size = 3.5,
    colour = "deepskyblue"
  ) -> lm_data$plots$early_points_lm_annot1

# Add text annotations with lm results for neck
lm_data$plots$early_points_lm_annot1 +
  annotate(
    "text",
    x = 6.5,
    y = 390,
    label = lm_data$slope_95_ci_neck,
    hjust = 0,
    vjust = 1,
    size = 3.5,
    colour = "orange"
  ) +
  annotate(
    "text",
    x = 6.5,
    y = 350,
    label = lm_data$r2_neck,
    hjust = 0,
    vjust = 1,
    size = 3.5,
    colour = "orange"
  ) +
  annotate(
    "text",
    x = 6.5,
    y = 310,
    label = "(n = 11)",
    hjust = 0,
    vjust = 1,
    size = 3.5,
    colour = "orange"
  ) -> lm_data$plots$early_points_lm_annot2

# Final customization of axis and labels
(
  lm_data$plots$early_points_lm_annot2 +
    labs(x = "Somites", y = "Time from somite 1 (min)") +
    scale_x_continuous(breaks = 1:9) +
    scale_y_continuous(limits = c(0, 700), breaks = seq(0, 700, by = 60)) +
    theme_classic() -> lm_data$plots$early_final
)

# Save plot to file
ggsave(
  path = output_path,
  filename = "lm_early_somites.pdf",
  plot = lm_data$plots$early_final,
  device = "pdf",
  width = 150,
  height = 100,
  units = "mm"
)

#### Linear modeling plot | Late somites

# Open the ggplot canvas
ggplot(lm_data$trunk, aes(x = nr_of_somites,
                          y = mean_start_time)) -> lm_data$plots$late

# Add points
lm_data$plots$late +
  geom_point(
    aes(color = region),
    shape = 16,
    size = 3.5,
    alpha = 0.5,
    show.legend = FALSE
  ) +
  scale_color_manual (values = "springgreen3") +
  geom_errorbar(
    aes(
      ymin = mean_start_time - sd_start_time,
      ymax = mean_start_time + sd_start_time
    ),
    width = .1,
    color = "springgreen3"
  ) -> lm_data$plots$late_points

# Add regression lines
lm_data$plots$late_points +
  geom_smooth(
    data = lm_data$trunk,
    method = "lm",
    color = "springgreen3",
    se = TRUE,
    linetype = "solid",
    size = 0.8,
    alpha = 0.2
  ) -> lm_data$plots$late_points_lm

# Add text annotations with lm results for head
lm_data$plots$late_points_lm +
  annotate(
    "text",
    x = 17.1,
    y = 250,
    label = lm_data$slope_95_ci_trunk,
    hjust = 0,
    vjust = 1,
    size = 3.5,
    colour = "springgreen3"
  ) +
  annotate(
    "text",
    x = 17.1,
    y = 210,
    label = lm_data$r2_trunk,
    hjust = 0,
    vjust = 1,
    size = 3.5,
    colour = "springgreen3"
  ) +
  annotate(
    "text",
    x = 17.1,
    y = 170,
    label = "(n = 4)",
    hjust = 0,
    vjust = 1,
    size = 3.5,
    colour = "springgreen3"
  ) -> lm_data$plots$late_points_lm_annot

# Final customization of axis and labels
(
  lm_data$plots$late_points_lm_annot +
    labs(x = "Somites", y = "Time from somite 14 (min)") +
    scale_x_continuous(breaks = 15:20) +
    scale_y_continuous(limits = c(0, 700), breaks = seq(0, 700, by = 60)) +
    theme_classic() -> lm_data$plots$late_final
)

# Save plot to file
ggsave(
  path = output_path,
  filename = "lm_late_somites.pdf",
  plot = lm_data$plots$late_final,
  device = "pdf",
  width = 150,
  height = 100,
  units = "mm"
)

## Tables for publication

#
##
### Tables for Publication
##
#

### ### ### ### ### ### ### ### ### ### ### ###
#### Table 1 | Time and Length per Somite  ####
### ### ### ### ### ### ### ### ### ### ### ###

somite_periods %>%
  ungroup() %>%
  select(embryo_id, somite_id, somite_period, somite_length) %>%
  group_by(somite_id) %>%
  summarise(
    mean_period = round(mean(somite_period, na.rm = TRUE), 2),
    sd_period = round(sd(somite_period, na.rm = TRUE), 2),
    mean_length = round(mean(somite_length, na.rm = TRUE), 2),
    sd_length = round(sd(somite_length, na.rm = TRUE), 2)
  ) -> table1_somite_summary1

## Find the nr of embryos measured per somite
somite_periods %>%
  ungroup() %>%
  select(embryo_id, somite_id) %>%
  count(somite_id) -> table1_somite_summary2

## Merge both datasets
left_join(table1_somite_summary1,
          table1_somite_summary2,
          by = "somite_id") %>%
  rename(n_embryos = n) -> table1_somite_summary3

## Clean up
rm(table1_somite_summary1, table1_somite_summary2)

## Export to file
write.table(
  table1_somite_summary3,
  file = paste0(output_path, "table1_somite_summary.csv"),
  quote = FALSE,
  sep = ";",
  na = "NA",
  dec = ".",
  row.names = FALSE,
  col.names = TRUE
)

## Look at table 1
table1_somite_summary3

### ### ### ### ### ### ### ### ### ### ### ###
#### Table 2 | Time and Length per Embryo  ####
### ### ### ### ### ### ### ### ### ### ### ###

somite_periods %>%
  ungroup() %>%
  select(embryo_id, somite_id, somite_period, somite_length) %>%
  group_by(embryo_id) %>%
  summarise(
    mean_period = round(mean(somite_period, na.rm = TRUE), 2),
    sd_period = round(sd(somite_period, na.rm = TRUE), 2),
    mean_length = round(mean(somite_length, na.rm = TRUE), 2),
    sd_length = round(sd(somite_length, na.rm = TRUE), 2)
  ) -> table2_embryo_summary1


## Find the nr of somites measured per embryo
somite_periods %>%
  ungroup() %>%
  select(embryo_id, somite_id) %>%
  count(embryo_id) -> table2_embryo_summary2

## Merge both datasets
left_join(table2_embryo_summary1,
          table2_embryo_summary2,
          by = "embryo_id") %>%
  rename(n_somites = n) -> table2_embryo_summary3

## Clean up
rm(table2_embryo_summary1, table2_embryo_summary2)

## Export to file
write.table(
  table2_embryo_summary3,
  file = paste0(output_path, "table2_embryo_summary.csv"),
  quote = FALSE,
  sep = ";",
  na = "NA",
  dec = ".",
  row.names = FALSE,
  col.names = TRUE
)
