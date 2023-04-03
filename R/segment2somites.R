#' Infer individual somite period and length
#'
#' This function takes as input consecutive measurements of the whole
#' segmented region from a vertebrate embryo and it finds the individual
#' somites.
#' Using an heuristic based on consecutive differences between lengths,
#' a length difference between two consecutive points greater than the
#' delta_threshold (default is 50.0 micrometers) is used to delimit a somite.
#'
#' @param df A data-frame with length for whole segmented region per embryo.
#' @param delta_threshold A numeric vector, with the "jump" in length when a new somite is formed.
#' @param x A numeric vector, indicating the time.
#' @param y A numeric vector, indicating the length.
#'
#' @return A data-frame with period and length for individual somites.
#'
#' @export
segment2somites <-
  function(df,
           delta_threshold = 50.,
           x = 'time',
           y = 'length') {
    cutpoints <- c(-Inf, df[[x]][diff(df[[y]]) > delta_threshold], Inf)
    labels <- sprintf("%02d", seq_len(length(cutpoints) - 1L))
    group <-
      as.character(cut(df[[x]], breaks = cutpoints, labels = labels))
    df2 <- mutate(df, somite_id = group)
    return(df2)
  }

