#' @title Perform pairwise alignments between a set of query sequence and a single reference sequence
#' @author Jacques.van-Helden@france-bioinformatique.fr
#' @param refSequence reference sequence. Must be an object of class Biostrings::DNAStringSet
#' @param querySequences query sequences. Must be an object of class Biostrings::DNAStringSet
#' @param type="global-local" alignment type, passed to Biostrings::pairwiseAlignment()
#' @param outfile=NULL if specified, the alignments are savec in the speficied file
#' @param ... other arguments are passed to  Biostrings::pairwiseAlignment()
#' @export
alignNtoOne <- function(refSequence, 
                        querySequences, 
                        type = "global-local",
                        outfile = NULL, 
                        ...) {
  ## Prepare a table for the matching statistics
  stats <-  c("pid", "nchar", "insertNb", "insertLen", "delNb", "delLen",  "score")
  alignmentStats <- data.frame(matrix(nrow = length(querySequences), ncol = length(stats)))
  rownames(alignmentStats) <- names(querySequences)
  colnames(alignmentStats) <- stats
  alignments <- list()
  
  ## Get parameters of the analysis
  seqNb <- length(querySequences)
  seqNames <- names(querySequences)
  
  i <- 1
  for (i in 1:seqNb) {
    subjectName <- seqNames[i]
    message("\tAligning sequence ", i, "/", seqNb,  "\t", subjectName)
    alignment <- pairwiseAlignment(pattern = refSequence, 
                                   subject = querySequences[i],
                                   type = type, ...)
    
    alignmentStats[subjectName, "pid"] <- pid(alignment)
    alignmentStats[subjectName, "nchar"] <- nchar(alignment)
    alignmentStats[subjectName, "insertNb"] <- insertion(nindel(alignment))[1]
    alignmentStats[subjectName, "insertLen"] <- insertion(nindel(alignment))[2]
    alignmentStats[subjectName, "delNb"] <- deletion(nindel(alignment))[1]
    alignmentStats[subjectName, "delLen"] <- deletion(nindel(alignment))[2]
    alignmentStats[subjectName, "score"] <- score(alignment)
    alignments[[subjectName]] <- alignment
  }
  result <- list(alignments = alignments,
                 stats = alignmentStats)
  
  if (!is.null(outfile)) {
    message("\talignNtoOne()",
            "\tExporting multiple alignments to file\n\t\t", outfile)
  }
  
  return(result)
}
# View(alignmentStats)
