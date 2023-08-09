library(tidyverse)
library(SomiteExploreR)
library(car)
library(ggbeeswarm)

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
# geom_beeswarm(cex = 3) +
# geom_boxplot(notch = TRUE) +
  geom_violin(aes(fill=DevelTime), colour="grey30", alpha=0.5,
              draw_quantiles=0.5, show.legend = FALSE) +
  geom_dotplot(fill="grey30", binaxis = "y", stackdir="center", dotsize=0.5) +
  scale_y_continuous(breaks = seq(0, 280, 20), limits = c(0, 280)) +
  labs(title = "Length variance | Brown-Forsythe Test",
       x="Development time",
       y="Somite length") +
  theme_minimal() +
  theme(panel.grid.minor = element_blank())





