% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summary_stats_per_somite_doc.R
\docType{data}
\name{summary_stats_per_somite}
\alias{summary_stats_per_somite}
\title{Summary Statistics per Somite}
\format{
A \code{data-frame} with 7 variables:
\describe{
\item{\code{somite_id}}{Categorial variable indicating the somite number. Early somites: 01-09. Late somites: 14-20.}
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
summary_stats_per_somite
}
\description{
\describe{
\item{\bold{DATA DESCRIPTION:}}{
Period and Length summary statistics data grouped by somite.
Visit the help pages for the embryo_lengths and the somite_periods datasets
for further details about the experimental setting and period inference.
NOTE: For somites 1 and 14, the period cannot be inferred using our whole segmented
region length method. In those slots, NA and NaN are displayed. See the associated
publication for further details.}
}
}
\keyword{datasets}
