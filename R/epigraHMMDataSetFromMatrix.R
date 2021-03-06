#' Create a epigraHMMDataSet from matrices of counts
#'
#' This function creates a \code{\link[SummarizedExperiment]{RangedSummarizedExperiment}} object from matrices of counts.
#' It is used to store the input data, the model offsets, and the results from the peak calling algorithms.
#'
#' @param countData a matrix (or a list of matrices). If countData is a list of matrices,
#' matrices must be named, have the same dimensions, and, at least, a matrix with name 'counts' must exist (see details).
#' @param colData a \code{data.frame} with columns \code{condition} and \code{replicate}.
#' \code{condition} refers to the experimental condition identifier (e.g. cell line name). \code{replicate} refers to the replicate identification number (unique for each condition).
#' @param rowRanges an optional GRanges object with the genomic coordinates of the \code{countData}
#'
#' @details
#'
#' Additional columns included in the colData input will be passed to the resulting epigraHMMDataSet assay and can be acessed via \code{colData()} function.
#'
#' @return An epigraHMMDataSet object with sorted colData regarding conditions and replicates.
#' Experimental counts will be stored in the 'counts' assay in the resulting epigraHMMDataSet object.
#' If `countData` is a list of matrices, the resulting 'counts' assay will be equal to `countData[['counts']]`.
#'
#' Additional matrices can be included in the epigraHMMDataSet. For example, if one wants to include counts from an
#' input control experiment from `countData[['controls']]`, an assay 'control' will be added to the resulting epigraHMMDataSet..
#'
#' @author Pedro L. Baldoni, \email{pedrobaldoni@gmail.com}
#'
#' @references
#' \url{https://github.com/plbaldoni/epigraHMM}
#'
#' @importFrom  methods is
#' @importFrom SummarizedExperiment SummarizedExperiment rowRanges assay colData
#' @importFrom Matrix Matrix
#'
#' @examples
#'
#' countData <- list('counts' = matrix(rpois(4e5,10),ncol = 4),
#' 'controls' = matrix(rpois(4e5,5),ncol = 4))
#' colData <- data.frame(condition = c('A','A','B','B'), replicate = c(1,2,1,2))
#' object <- epigraHMMDataSetFromMatrix(countData,colData)
#'
#' @export
epigraHMMDataSetFromMatrix <- function(countData,colData,rowRanges = NULL){

    condition = replicate = NULL

    # Checking input matrix
    countData <- checkInputMatrix(countData,colData,rowRanges)

    # Saving final output
    epigraHMMDataSet <- SummarizedExperiment(assays = list(counts = matrix(countData[['counts']],
                                                                           byrow = FALSE,
                                                                           nrow = nrow(countData[['counts']]),
                                                                           ncol = ncol(countData[['counts']]),
                                                                           dimnames = list(NULL,paste(colData$condition,colData$replicate,sep='.')))),
                                             colData = colData)

    # Adding offsets
    epigraHMMDataSet <- addOffsets(epigraHMMDataSet,Matrix(0,nrow = nrow(epigraHMMDataSet),
                                                           ncol = ncol(epigraHMMDataSet),
                                                           sparse = TRUE))
    
    # Adding rowRanges
    if(!is.null(rowRanges)) SummarizedExperiment::rowRanges(epigraHMMDataSet) <- rowRanges

    # Adding additional matrices
    if(!is.matrix(countData)){
        for(idx in names(countData)[-which(names(countData)=='counts')]){
            dimnames(countData[[idx]]) <- dimnames(SummarizedExperiment::assay(epigraHMMDataSet,'counts'))
            SummarizedExperiment::assay(epigraHMMDataSet,idx) <- countData[[idx]]
        }
    }
    
    # Returning sorted the object
    return(sortObject(epigraHMMDataSet))
}
