% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/name_chunks.R
\name{name_chunks_mlr3website}
\alias{name_chunks_mlr3website}
\title{Name all chunks}
\usage{
name_chunks_mlr3website(collection = "gallery", file = NULL)
}
\arguments{
\item{collection}{(\code{character(1)})\cr
Collection to be named. Default \code{gallery}, names all chunks of gallery posts.}

\item{file}{(\code{character(1)})\cr
Single file to be named.}
}
\description{
Names all chunks of all Rmd files using the pattern \verb{[file-name]-[number]}.
}
