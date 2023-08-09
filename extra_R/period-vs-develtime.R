library(tidyverse)
library(SomiteExploreR)
library(car)
library(ggbeeswarm)

somite_periods2 <-
  somite_periods |>
  dplyr::ungroup() |>
  dplyr::mutate(DevelTime = as.factor(DevelTime)) |>
  dplyr::select(DevelTime, somite_period) |>
  tidyr::drop_na()

# Brown–Forsythe test (because `center = median`).
# https://en.wikipedia.org/wiki/Brown%E2%80%93Forsythe_test
early_vs_late_period <- car::leveneTest(somite_period ~ DevelTime,
                                        data = somite_periods2,
                                        center=median)
print(early_vs_late_period)

## Data visualization
somite_periods2 |>
  ggplot(aes(x=DevelTime, y=somite_period)) +
  # geom_beeswarm(cex=3) +
  # geom_boxplot(notch=TRUE) +
  geom_violin(aes(fill=DevelTime), colour="grey30", alpha=0.5,
              draw_quantiles=0.5, show.legend = FALSE) +
  geom_dotplot(fill="grey30", binaxis = "y", stackdir="center", dotsize=0.5) +
  scale_y_continuous(breaks=seq(0, 150, 15), limits=c(0, 150)) +
  labs(title="Period variance | Brown-Forsythe Test",
       x="Development time",
       y="Somite period") +
  theme_minimal() +
  theme(panel.grid.minor = element_blank())



