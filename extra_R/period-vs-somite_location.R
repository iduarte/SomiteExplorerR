library(tidyverse)
library(SomiteExploreR)
library(car)
library(ggbeeswarm)
library(RColorBrewer)

# Occipital somites 1-5 | Cervical somites 6-9 | Trunk somites 14-20.
somite_periods2 <-
  somite_periods |>
  dplyr::ungroup() |>
  dplyr::mutate(somite_location = case_when(
    somite_id %in% c("01", "02", "03", "04", "05") ~ "Somites 1-5",
    somite_id %in% c("06", "07", "08", "09") ~ "Somites 6-9",
    somite_id %in% c("14", "15", "16", "17", "18", "19", "20") ~ "Somites 14-20")) |>
  dplyr::mutate(somite_location = factor(somite_location,
                                         levels = c("Somites 1-5",
                                                    "Somites 6-9",
                                                    "Somites 14-20"))) |>
  dplyr::select(somite_location, somite_period) |>
  tidyr::drop_na()

# Brown–Forsythe test (i.e. the Levene's test with `center = median`).
# https://en.wikipedia.org/wiki/Brown%E2%80%93Forsythe_test

## Occipital_vs_cervical
occipital_vs_cervical_period <-
  somite_periods2 %>%
  filter(somite_location %in% c("Somites 1-5", "Somites 6-9")) %>%
  car::leveneTest(somite_period ~ somite_location,
                                        data = .,
                                        center=median)
print(occipital_vs_cervical_period)

## Occipital_vs_trunk
occipital_vs_trunk_period <-
  somite_periods2 %>%
  filter(somite_location %in% c("Somites 1-5", "Somites 14-20")) %>%
  car::leveneTest(somite_period ~ somite_location,
                  data = .,
                  center=median)
print(occipital_vs_trunk_period)

## Cervical_vs_trunk
cervical_vs_trunk_period <-
  somite_periods2 %>%
  filter(somite_location %in% c("Somites 6-9", "Somites 14-20")) %>%
  car::leveneTest(somite_period ~ somite_location,
                  data = .,
                  center=median)
print(cervical_vs_trunk_period)

#
##
### Data visualization | Three groups: Somite anatomical locations
##
#
somite_periods2 |>
  ggplot(aes(x=somite_location, y=somite_period)) +
  geom_violin(aes(fill=somite_location), colour="grey40", alpha=0.5,
              draw_quantiles=0.5, show.legend = FALSE) +
  geom_dotplot(fill="grey40", binaxis = "y", stackdir="center", dotsize=0.3) +
  scale_y_continuous(breaks=seq(0, 150, 25), limits=c(0, 165)) +
  theme(panel.grid.minor = element_blank(), text = element_text(size = 13)) +
  labs(x="Somite number", y="Somite period (min)") +
  ## Add p-value 1
  annotate(geom="text", x=1.5, y=145, color = "grey20", size = 4,
           label=paste0("P-value = ",
                        round(occipital_vs_cervical_period[[3]][1], digits = 4))) +
  # add horizontal line
  annotate(geom="segment", color = "grey20",
           x="Somites 1-5", xend="Somites 6-9", y=140, yend=140) +
  # add left vertical tick
  annotate(geom="segment", color = "grey20",
           x="Somites 1-5", xend="Somites 1-5", y=135, yend=140) +
  # add right vertical tick
  annotate(geom="segment", color = "grey20",
           x="Somites 6-9", xend="Somites 6-9", y=135, yend=140) +

  ## Add p-value 2
  annotate(geom="text", x=2.5, y=155, color = "grey20", size = 4,
           label=paste0("P-value = ",
                        round(occipital_vs_trunk_period[[3]][1], digits = 4))) +
  # add horizontal line
  annotate(geom="segment", color = "grey20",
           x="Somites 6-9", xend="Somites 14-20", y=150, yend=150) +
  # add left vertical tick
  annotate(geom="segment", color = "grey20",
           x="Somites 6-9", xend="Somites 6-9", y=145, yend=150) +
  # add right vertical tick
  annotate(geom="segment", color = "grey20",
           x="Somites 14-20", xend="Somites 14-20", y=145, yend=150) +

## Add p-value 3
annotate(geom="text", x=2, y=165, color = "grey20", size = 4,
         label=paste0("P-value = ",
                      round(cervical_vs_trunk_period[[3]][1], digits = 4))) +
  # add horizontal line
  annotate(geom="segment", color = "grey20",
           x="Somites 1-5", xend="Somites 14-20", y=160, yend=160) +
  # add left vertical tick
  annotate(geom="segment", color = "grey20",
           x="Somites 1-5", xend="Somites 1-5", y=155, yend=160) +
  # add right vertical tick
  annotate(geom="segment", color = "grey20",
           x="Somites 14-20", xend="Somites 14-20", y=155, yend=160)

###############################################################################

# Variance variability in Periods between somites 1-7 and 8-20
somite_periods3 <-
  somite_periods |>
  dplyr::ungroup() |>
  dplyr::mutate(somite_location = case_when(
    somite_id %in% c("01","02","03","04","05","06","07") ~ "Somites 1-7",
    somite_id %in% c("08","09","10","11","12","13","14","15","16","17","18","19","20") ~ "Somites 8-20")) |>
  dplyr::mutate(somite_location = as.factor(somite_location)) |>
  dplyr::select(somite_location, somite_period) |>
  tidyr::drop_na()

# Brown–Forsythe test
## Somites 1-7 vs 8-20
somites_1_7_vs_8_20_period <-
  car::leveneTest(somite_period ~ somite_location,
                  data = somite_periods3,
                  center=median)
print(somites_1_7_vs_8_20_period)

#
##
### Data visualization | Periods | Somites 1-7 vs 8-20
##
#
somite_periods3 |>
  ggplot(aes(x=somite_location, y=somite_period)) +
  geom_violin(aes(fill=somite_location), colour="grey40", alpha=0.5,
              draw_quantiles=0.5, show.legend = FALSE) +
  geom_dotplot(fill="grey40", binaxis = "y", stackdir="center", dotsize=0.3) +
  scale_y_continuous(breaks=seq(0, 150, 25), limits=c(0, 160)) +
  theme(panel.grid.minor = element_blank(), text = element_text(size = 13)) +
  scale_fill_manual (values = brewer.pal(8, "Set2")[c(1,4)]) +
  labs(x="Somite number", y="Somite period (min)", ) +
  ## Add p-value 1
  annotate(geom="text", x=1.5, y=145, color = "grey20", size = 4,
           label=paste0("P-value = ",
                        round(somites_1_7_vs_8_20_period[[3]][1], digits = 5))) +
  # add horizontal line
  annotate(geom="segment", color = "grey20",
           x="Somites 1-7", xend="Somites 8-20", y=137, yend=137) +
  # add left vertical tick
  annotate(geom="segment", color = "grey20",
           x="Somites 1-7", xend="Somites 1-7", y=130, yend=137) +
  # add right vertical tick
  annotate(geom="segment", color = "grey20",
           x="Somites 8-20", xend="Somites 8-20", y=130, yend=137)



