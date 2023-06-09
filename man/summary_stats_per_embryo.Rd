% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summary_stats_per_embryo_doc.R
\docType{data}
\name{summary_stats_per_embryo}
\alias{summary_stats_per_embryo}
\title{Summary Statistics per Embryo}
\format{
A \code{data-frame} with 7 variables:
\describe{
\item{\code{embryo_id}}{Categorical variable identifying the embryo. Thirteen embryos were measured (EmbryoA-EmbryoM). Note: EmbryoJ and EmbryoK were separately measured for the early and late somites, labeled EmbryoJ1, EmbryoJ2, EmbryoK1, and EmbryoK2.}
\item{\code{avg_somite_length}}{Mean individual somite length, in micrometers (individual somite size).}
\item{\code{avg_somite_period}}{Mean individual somite period, in minutes, inferred from the raw segmented length data.}
\item{\code{median_somite_length}}{Median individual somite length, in micrometers (individual somite size).}
\item{\code{median_somite_period}}{Median individual somite period, in minutes.}
\item{\code{stdev_somite_length}}{Standard deviation of individual somite length.}
\item{\code{stdev_somite_period}}{Standard deviation of individual somite period.}
}

For further details contact Isabel Duarte (\email{iduarte.scientist@gmail.com}).
}
\usage{
summary_stats_per_embryo
}
\description{
\describe{
\item{\bold{DATA DESCRIPTION:}}{
Period and Length summary statistics data grouped by embryo.
Visit the help pages for the embryo_lengths and the somite_periods datasets
for further details about the experimental setting and period inference.}
}
}
\keyword{datasets}
