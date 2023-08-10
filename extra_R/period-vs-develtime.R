library(tidyverse)
library(SomiteExploreR)
library(car)
library(ggbeeswarm)
library(RColorBrewer)

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
  geom_violin(aes(fill=DevelTime), colour="grey40", alpha=0.5,
              draw_quantiles=0.5, show.legend = FALSE) +
  geom_dotplot(fill="grey40", binaxis = "y", stackdir="center", dotsize=0.5) +
  scale_y_continuous(breaks=seq(0, 150, 15), limits=c(0, 155)) +
  labs(x="Developmental stages", y="Somite period (min)") +
  scale_fill_manual (values=brewer.pal(8, "Set2")[c(1,4)]) +
  # add p-value
  annotate(geom="text", x=1.5, y=145, color = "grey20", size = 4,
           label=paste0("P-value = ",
                        round(early_vs_late_period[[3]][1], digits = 5))) +
  # add horizontal line
  annotate(geom="segment", color = "grey20",
           x="Early", xend="Late", y=140, yend=140) +
  # add left vertical tick
  annotate(geom="segment", color = "grey20",
           x="Early", xend="Early", y=135, yend=140) +
  # add right vertical tick
  annotate(geom="segment", color = "grey20",
           x="Late", xend="Late", y=135, yend=140) +
  theme(panel.grid.minor = element_blank())



