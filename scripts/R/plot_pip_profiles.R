
#' @title Plot profile of  Percent Identical Positions (PIP)
#' @author Jacques.van-Helden@france-bioinformatique.fr
#' @param alignments a list of pairwise alignments produced by Biostrings::pairwiseAlignment
#' @param windowSize=100 size of the sliding window to compute the rolling average PIP
#' @param legend=names(alignments) legend labels
#' @param colors=rainbow(n=length(alignments)) color per line
#' @param legendMargin=0.25 proportion to add on the right side for the legend (sequence names)
#' @param legendCorner="topright" position of the legend
#' @param legendCex=0.7 legend character size
#' @param ylim=c(50,100) ordinate limits
#' @param ... additional parameters are passed to plot()
#' @export
plotPIPprofiles <-  function(alignments, 
                     windowSize = 100,
                     legend = names(alignments),
                     colors = rainbow(n = length(alignments)),
                     legendMargin = 0.25,
                     legendCorner = "topright",
                     legendCex = 0.7,
                     ylim = c(50,100),
                     ... ) {
  
  i <- 1
  for (i in 1:length(alignments)) {
    subject <- names(alignments)[i]
    alignment <- alignments[[i]]
    
    ## Get the aligned reference and query sequences 
    refSeq <- unlist(strsplit(as.character(pattern(alignment)), split = "")) 
    querySeq <- unlist(strsplit(as.character(subject(alignment)), split = ""))
    # compareStrings(genomesNto1$alignments[[1]]) ## TO TEST: is this fastest ? Does it give the same result ?
    
    ## Only keep the positions corresponding to the reference sequence (no gap in ref)
    refPositions <- refSeq != "-"
    
    ## Compute identity per position
    identityProfile <- refSeq[refPositions] == querySeq[refPositions]
    
    ## Compute PIP profile
    pipProfile <- 100 * filter(identityProfile, filter = rep(1/windowSize, windowSize))
    
    
    message("\t", i, "/", nbQueryGenomes,
            "\tpid = ", round(digits = 2, pid(alignment)), 
            "\t", subject
    )
    
    if (i == 1) {
      plot(1:length(identityProfile),
           pipProfile, 
           type = "l",
           xlab = "Position", 
           ylab = paste0("PIP (", windowSize," bp-averaged)"),
           las = 1,
           ylim = ylim,
           xlim = c(0, length(refPositions) * (1 + legendMargin)),
           panel.first = c(
             abline(h = seq(0, 100, 10), col = "#DDDDDD"),
             abline(h = c(0,100), col = "black"),
             abline(v = seq(0, length(refPositions), windowSize * 5), col = "#DDDDDD")),
           col = colors[i],
           ...
      ) 
      
    } else {
      lines(1:length(identityProfile),
            pipProfile, 
            type = "l",
            col = colors[i]
      )
      
    }
  }
  legend(legendCorner, 
         legend = legend, 
         col = colors, 
         cex = legendCex,
         lwd = 2)
}
