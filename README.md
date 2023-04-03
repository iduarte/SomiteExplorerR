# SomiteExploreR

This RData package contains the data collected from an experimental study designed to infer the time/period of formation of the first somites in the chick embryo. It also provides the algorithm used to infer the individual somite formation period.

These data were provided by Prof. Raquel P. Andrade (rgandrade@ualg.pt), and
Ana Cristina Maia-Fernandes (ac.maia.fernandes@gmail.com), 
from Universidade do Algarve, Faro, Portugal.


### Citation | miRNA-seq

**Paper describing and discussing the data**

Ana Cristina Maia-Fernandes, Ana Martins-Jesus, Tomás Pais-de-Azevedo, Ramiro Magno, Isabel Duarte, Raquel P. Andrade. Spatio-Temporal Dynamics of Early Somite Segmentation in the Chicken Embryo. 2023. (DOI: To be added after publication).
(*Submitted*)   


### Dataset repositories
Figshare dataset: [Chick Embryo Segmented Region Length](https://doi.org/10.6084/m9.figshare.22341070.v3)


### Installation

If you do not have the package `remotes` install it first:

```R
install.packages("remotes")
```

Then install the package `SomiteExplorerR`:

```R
remotes::install_github('iduarte/SomiteExplorerR')
```


## Description

This package provides access to datasets derived from an experimental study on the formation periods of early somites in chick embryos. Thirteen wild-type chick embryos were grown in EC culture under a Lumar microscope, and live images were acquired every 3 minutes for up to 53 hours of embryo development, covering development stages HH7 to HH13+ (between 1 to 20 somites).

The package contains the raw data collected by the researchers in the lab, as well as the algorithm used to infer individual somite formation periods using the length (in micrometers) from the whole segmented region. Additionally, it provides the data retrieved from the automated analysis, i.e., the periods and lengths for individual somites. 

This package provides 4 data-frames:

- `embryo_lengths` | Contains the `time`(min), `length` (micrometers), `DevelTime` (Early or Late development, corresponding to somites 01-09, and somites 14-20, respectively), and `somite_id` per `embryo_id`.     
- `somite_periods` | Contains the `somite_id`, `DevelTime`, `start_time` (time, in minutes, of the first frame where the new somite appears in the global development), `somite_position_mean` (the mean of the whole segmented region length (in micrometers) for all frames where each somite is visible - from the first frame where somite_n appears, to the last frame before somite_n+1 appears), and `somite_position_sd`, per `embryo_id`.     
- `summary_stats_per_embryo` | Contains the summary statistics (mean, median, and standard deviation) for the period and length of individual somites *grouped by embryo* (`embryo_id`, `avg_somite_length`, `avg_somite_period`, `median_somite_length`, `median_somite_period`, `stdev_somite_length`, and `stdev_somite_period`).     
- `summary_stats_per_somite` | Contains the summary statistics (mean, median, and standard deviation) for the period and length of individual somites *grouped by somite* (`somite_id`, `avg_somite_length`, `avg_somite_period`, `median_somite_length`, `median_somite_period`, `stdev_somite_length`, and `stdev_somite_period`).       


## Usage

```R
library(SomiteExplorerR)
```

After loading the package, the 4 data tables will be available to the user, and visible in the global environment when called for the first time.


## Data | Raw datasets present in this repository

In the `data-raw` folder, there are 3 files containing the raw data used to produce the data-frames provided by the `SomiteExplorerR` package (*"embryo-measures-input-metadata.csv" "embryo-measures-input.csv", and "embryo-measures-input.xlsx"*)

*Note | Only the `.csv` files are used for the data analysis developed in this package.* 


## Extra R code present in this repository

In the folder `extra_R` there is an R script (*"plot_somite_data.R"*) that creates several plots and visualizations to explore the datasets provided by the package.    
It also has the R code used to produce the figures presented in the paper (see citation above).



