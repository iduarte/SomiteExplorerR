library(tidyverse)
library(SomiteExploreR)
library(car)
library(ggbeeswarm)
library(RColorBrewer)

somite_lengths <-
  somite_periods |>
  dplyr::ungroup() |>
  dplyr::mutate(somite_location1 = case_when(
    somite_id %in% c("01", "02", "03", "04", "05", "06", "07", "08", "09") ~ "Somites 1-9",
    somite_id %in% c("14", "15", "16") ~ "Somites 14-16",
    somite_id %in% c("17", "18", "19", "20") ~ "Somites 17-20")) |>
  dplyr::mutate(somite_location2 = case_when(
    somite_location1 %in% c("Somites 1-9", "Somites 14-16") ~ "Somites 1-16",
    somite_location1 == "Somites 17-20" ~ "Somites 17-20")) %>%
  dplyr::mutate(somite_location1 = as.factor(somite_location1),
                somite_location2 = as.factor(somite_location2)) %>%
  dplyr::select(somite_location1, somite_location2, somite_length) |>
  tidyr::drop_na()

# Brown–Forsythe test (because `center = median` which is more robust).
# https://en.wikipedia.org/wiki/Brown%E2%80%93Forsythe_test
somites_location1_length <- car::leveneTest(somite_length ~ somite_location1,
                                        data = somite_lengths,
                                        center=median)

print(somites_location1_length)

#
##
### Data visualization
##
#
somite_lengths |>
  ggplot(aes(x = somite_location1, y = somite_length)) +
  geom_violin(aes(fill=somite_location1), colour="grey40", alpha=0.5,
              draw_quantiles=0.5, show.legend = FALSE) +
  geom_dotplot(fill="grey40", binaxis = "y", stackdir="center", dotsize=0.3) +
  scale_y_continuous(breaks = seq(0, 300, 50), limits = c(0, 300)) +
  theme(panel.grid.minor = element_blank(), text = element_text(size = 13)) +
  labs(x="Somite number", y="Somite length (micrometre)") +
  ## Add the p-value
  annotate(geom="text", x=2, y=287, color = "grey20", size = 4,
           label=paste0("P-value = ",
                        round(somites_location1_length[[3]][1], digits = 5))) +
  # add horizontal line
  annotate(geom="segment", color = "grey20",
           x="Somites 1-9", xend="Somites 17-20", y=275, yend=275) +
  # add left vertical tick
  annotate(geom="segment", color = "grey20",
           x="Somites 1-9", xend="Somites 1-9", y=260, yend=275) +
  # add middle vertical tick
  annotate(geom="segment", color = "grey20",
           x="Somites 14-16", xend="Somites 14-16", y=260, yend=275) +
  theme(panel.grid.minor = element_blank()) +
  # add right vertical tick
  annotate(geom="segment", color = "grey20",
           x="Somites 17-20", xend="Somites 17-20", y=260, yend=275)


###############################################################################

# Variance variability in Periods between somites 1-16 and 17-20

# Brown–Forsythe test
somites_location2_length <-
  car::leveneTest(somite_length ~ somite_location2,
                  data = somite_lengths,
                  center=median)
print(somites_location2_length)

#
##
### Data visualization
##
#
somite_lengths |>
  ggplot(aes(x = somite_location2, y = somite_length)) +
  geom_violin(aes(fill=somite_location2), colour="grey40", alpha=0.5,
              draw_quantiles=0.5, show.legend = FALSE) +
  geom_dotplot(fill="grey40", binaxis = "y", stackdir="center", dotsize=0.3) +
  scale_y_continuous(breaks = seq(0, 300, 50), limits = c(0, 300)) +
  theme(panel.grid.minor = element_blank(), text = element_text(size = 13)) +
  scale_fill_manual (values = brewer.pal(8, "Set2")[c(1,4)]) +
  labs(x="Somite number", y="Somite length (micrometre)") +
  ## Add the p-value
  annotate(geom="text", x=1.5, y=287, color = "grey20", size = 4,
           label=paste0("P-value = ",
                        round(somites_location2_length[[3]][1], digits = 5))) +
  # add horizontal line
  annotate(geom="segment", color = "grey20",
           x="Somites 1-16", xend="Somites 17-20", y=275, yend=275) +
  # add left vertical tick
  annotate(geom="segment", color = "grey20",
           x="Somites 1-16", xend="Somites 1-16", y=260, yend=275) +
  # add right vertical tick
  annotate(geom="segment", color = "grey20",
           x="Somites 17-20", xend="Somites 17-20", y=260, yend=275)
