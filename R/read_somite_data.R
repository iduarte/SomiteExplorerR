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

library(tidyverse)
library(here)

#### Data tidying and Initial Analysis ####

## Path to time series
data_path <- here('data-raw/embryo-measures-input.csv')
data_path_metadata <-
  here('data-raw/embryo-measures-input-metadata.csv')

## Import data and tidy up
emb_length <-
  read_delim(file = data_path, delim = ';') %>%
  gather(starts_with('Video'),
         key = 'embryo_id',
         value = 'length') %>%                       # Tidy up.
  rename(time = Time) %>%                            # Make lowercase.
  select(embryo_id, time, length) %>%                # Using select() to reorder the columns.
  drop_na(length) %>%                                # Remove NA values, there's no use for them here.
  mutate(time = time * 60, length = length * 1000)   # Convert time to min, and length to micron.

## Import the metadata file with info about early and late somites
emb_length_metadata <-
  read_delim(file = data_path_metadata, delim = ';') %>%
  rename(embryo_id = Video)

## Add metadata column to data file
emb_length <- left_join(emb_length, emb_length_metadata)


## FUNCTION: Using an heuristic based on consecutive differences between lengths
## A length difference between two consecutive points greater than the
## delta_threshold is used to delimit a somite.

segment <-
  function(df,
           delta_threshold = 50.,
           x = 'time',
           y = 'length') {
    cutpoints <- c(-Inf, df[[x]][diff(df[[y]]) > delta_threshold], Inf)
    labels <- sprintf("%02d", seq_len(length(cutpoints) - 1L))
    group <-
      as.character(cut(df[[x]], breaks = cutpoints, labels = labels))
    df2 <- mutate(df, somite_id = group)
    return(df2)
  }

## Apply the segment function to the embryo length data
emb_length %>%
  group_split(embryo_id) %>%
  map_dfr(segment) %>%
  mutate(embryo_id = str_extract(embryo_id, 'Embryo.*')) %>%
  ## correct the somite number
  mutate (somite_id = case_when(
    # changed early somite nr to keep original numbering (from +1 to +0)
    DevelTime == 'Early' ~ sprintf("%02d", as.numeric(somite_id) + 0),
    DevelTime == 'Late' ~ sprintf("%02d", as.numeric(somite_id) + 13)
  )) -> emb_length2

## Summarize data
somite_periods <-
  emb_length2 %>%
  group_by(embryo_id, somite_id) %>%
  summarise(
    DevelTime = first(DevelTime),
    start_time = first(time),
    somite_position_mean = mean(length),
    somite_position_sd = sd(length)
  ) %>%
  mutate(
    somite_period = start_time - lag(start_time),
    somite_length = somite_position_mean - lag(somite_position_mean, default = 0),
    somite_length_sd = sqrt(somite_position_sd ^ 2 + lag(somite_position_sd, default = 0) ^
                              2)
  )

## Summary statistics for somite length and somite period (per somite and per embryo)
## Average somite length and average somite period PER EMBRYO
somite_periods %>%
  ungroup() %>%
  group_by(embryo_id) %>%
  summarise(
    avg_somite_length = mean(somite_length),
    avg_somite_period = mean(somite_period, na.rm = TRUE),
    median_somite_length = median(somite_length),
    median_somite_period = median(somite_period, na.rm = TRUE),
    stdev_somite_length = sd(somite_length),
    stdev_somite_period = sd(somite_period, na.rm = TRUE)
  )  -> summary_stats_per_embryo


## Average somite length and average somite period PER SOMITE
somite_periods %>%
  ungroup() %>%
  group_by(somite_id) %>%
  summarise(
    avg_somite_length = mean(somite_length),
    avg_somite_period = mean(somite_period, na.rm = TRUE),
    median_somite_length = median(somite_length),
    median_somite_period = median(somite_period, na.rm = TRUE),
    stdev_somite_length = sd(somite_length),
    stdev_somite_period = sd(somite_period, na.rm = TRUE)
  ) -> summary_stats_per_somite


## Rename the final data-frames to export
embryo_lengths <- emb_length2

## Clean-up
rm(emb_length, emb_length_metadata, emb_length2,
   data_path, data_path_metadata)

## Export the final datasets
usethis::use_data(embryo_lengths, overwrite = TRUE)
usethis::use_data(somite_periods, overwrite = TRUE)
usethis::use_data(summary_stats_per_embryo, overwrite = TRUE)
usethis::use_data(summary_stats_per_somite, overwrite = TRUE)
