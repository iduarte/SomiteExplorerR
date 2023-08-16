library(tidyverse)
library(SomiteExploreR)
library(car)
library(ggbeeswarm)
library(RColorBrewer)

somite_lengths <-
  somite_periods |>
  dplyr::ungroup() |>
  dplyr::mutate(DevelTime = as.factor(DevelTime)) |>
  dplyr::select(DevelTime, somite_length) |>
  tidyr::drop_na()

# Brown–Forsythe test (because `center = median` which is more robust).
# https://en.wikipedia.org/wiki/Brown%E2%80%93Forsythe_test
early_vs_late_length <- car::leveneTest(somite_length ~ DevelTime,
                                        data = somite_lengths,
                                        center=median)

print(early_vs_late_length)


## Data visualization
somite_lengths |>
  ggplot(aes(x = DevelTime, y = somite_length)) +
  geom_violin(aes(fill=DevelTime), colour="grey40", alpha=0.5,
              draw_quantiles=0.5, show.legend = FALSE) +
  geom_dotplot(fill="grey40", binaxis = "y", stackdir="center", dotsize=0.5) +
  scale_y_continuous(breaks = seq(0, 280, 20), limits = c(0, 290)) +
  labs(x="Developmental stages", y="Somite length (micrometre)") +
  scale_fill_manual (values = brewer.pal(8, "Set2")[c(1,4)]) +
  # add the p-value
  annotate(geom="text", x=1.5, y=290, color = "grey20", size = 4,
           label=paste0("P-value = ",
                        round(early_vs_late_length[[3]][1], digits = 5))) +
  # add horizontal line
  annotate(geom="segment", color = "grey20",
           x="Early", xend="Late", y=280, yend=280) +
  # add left vertical tick
  annotate(geom="segment", color = "grey20",
           x="Early", xend="Early", y=270, yend=280) +
  # add right vertical tick
  annotate(geom="segment", color = "grey20",
           x="Late", xend="Late", y=270, yend=280) +
  theme(panel.grid.minor = element_blank())





