% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/callPeaks.R
\name{callPeaks}
\alias{callPeaks}
\title{Summarize peak calls and optionally create a BED 6+3 file in broadPeak format for visualization}
\usage{
callPeaks(
  object,
  hdf5 = metadata(object)$output,
  method = "viterbi",
  saveToFile = FALSE,
  control = NULL
)
}
\arguments{
\item{object}{an epigraHMMDataSet}

\item{hdf5}{a character with the location of the epigraHMM HDF5 output file}

\item{method}{either 'viterbi' or a numeric FDR control threshold (e.g. 0.05). Default is 'viterbi'.}

\item{saveToFile}{a logical indicating whether or not to save the results to file.
Output files are always saved with peaks of interest defined on the region level. Default is FALSE.}

\item{control}{list of control arguments from controlEM(). This is an optional parameter and it is
only required when `saveToFile = TRUE` so that the output directory can be obtained. Default is NULL.}
}
\value{
A GRanges object with differential peak calls in BED 6+3 format
}
\description{
This function imports the output from `epigraHMM` and outputs a set of
peaks (consensus or differential) for a given FDR control threshold or Viterbi sequence.
}
\examples{

# Creating dummy object
countData <- rbind(matrix(rnbinom(1e3,mu = 2,size = 10),ncol = 1),
                   matrix(rnbinom(2e3,mu = 7.5,size = 5),ncol = 1),
                   matrix(rnbinom(1e3,mu = 2,size = 10),ncol = 1))

colData <- data.frame(condition = 'A', replicate = 1)

rowRanges <- GenomicRanges::GRanges('chrA',
IRanges::IRanges(start = seq(from = 1, length.out = 4e3,by = 250),width = 250))

object <- epigraHMMDataSetFromMatrix(countData,colData,rowRanges)

# Initializing
object <- initializer(object,controlEM())

# Running epigraHMM
object <- epigraHMM(object,controlEM(),type = 'consensus',dist = 'nb')

# Calling peaks
peaks <- callPeaks(object = object,
                   hdf5 = S4Vectors::metadata(object)$output,
                   method = 'viterbi')

}
\references{
\url{https://github.com/plbaldoni/epigraHMM}
}
\author{
Pedro L. Baldoni, \email{pedrobaldoni@gmail.com}
}
