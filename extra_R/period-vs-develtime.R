library(tidyverse)
library(SomiteExploreR)
library(car)

somite_periods2 <-
  somite_periods |>
  dplyr::ungroup() |>
  dplyr::mutate(DevelTime = as.factor(DevelTime)) |>
  dplyr::select(DevelTime, somite_period) |>
  tidyr::drop_na()

somite_periods2 |>
  ggplot(aes(x = DevelTime, y = somite_period)) +
  geom_beeswarm(cex = 3) +
  scale_y_continuous(breaks = seq(0, 135, 15), limits = c(0, 135))

# Brown–Forsythe test (because `center = median`).
# https://en.wikipedia.org/wiki/Brown%E2%80%93Forsythe_test
early_vs_late_period <- car::leveneTest(somite_period ~ DevelTime, data = somite_periods2)
