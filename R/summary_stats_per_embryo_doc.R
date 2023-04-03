#' Summary Statistics per Embryo
#'
#' \describe{
#' \item{\bold{DATA DESCRIPTION:}}{
#' Period and Length summary statistics data grouped by embryo.
#' Visit the help pages for the embryo_lengths and the somite_periods datasets
#' for further details about the experimental setting and period inference.}
#'}
#'
#' @format A \code{data-frame} with 7 variables:
#' \describe{
#' \item{\code{embryo_id}}{Categorical variable identifying the embryo. Thirteen embryos were measured (EmbryoA-EmbryoM). Note: EmbryoJ and EmbryoK were separately measured for the early and late somites, labeled EmbryoJ1, EmbryoJ2, EmbryoK1, and EmbryoK2.}
#' \item{\code{avg_somite_length}}{Mean individual somite length, in micrometers (individual somite size).}
#' \item{\code{avg_somite_period}}{Mean individual somite period, in minutes, inferred from the raw segmented length data.}
#' \item{\code{median_somite_length}}{Median individual somite length, in micrometers (individual somite size).}
#' \item{\code{median_somite_period}}{Median individual somite period, in minutes.}
#' \item{\code{stdev_somite_length}}{Standard deviation of individual somite length.}
#' \item{\code{stdev_somite_period}}{Standard deviation of individual somite period.}
#' }
#'
#' For further details contact Isabel Duarte (\email{iduarte.scientist@@gmail.com}).
#'
"summary_stats_per_embryo"
