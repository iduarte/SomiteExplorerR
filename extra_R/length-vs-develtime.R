library(tidyverse)
library(SomiteExploreR)
library(car)

somite_lengths <-
  somite_periods |>
  dplyr::ungroup() |>
  dplyr::mutate(DevelTime = as.factor(DevelTime)) |>
  dplyr::select(DevelTime, somite_length) |>
  tidyr::drop_na()

somite_lengths |>
  ggplot(aes(x = DevelTime, y = somite_length)) +
  geom_beeswarm(cex = 3) +
  scale_y_continuous(breaks = seq(0, 260, 20), limits = c(0, 260))

# Brown–Forsythe test (because `center = median`).
# https://en.wikipedia.org/wiki/Brown%E2%80%93Forsythe_test
early_vs_late_length <- car::leveneTest(somite_length ~ DevelTime, data = somite_lengths)


