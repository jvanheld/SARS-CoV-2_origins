
#' @title Plot profile of  Percent Identical Positions (PIP)
#' @author Jacques.van-Helden@france-bioinformatique.fr
#' @param alignments a list of pairwise alignments produced by Biostrings::pairwiseAlignment
#' @param reversePlots=TRUE plot the profiles in reverse order, to avoid for the first profiles to be masked by the last ones. Note that the legend order is always from the first to the last element of provided set of alignments. 
#' @param windowSize=100 size of the sliding window to compute the rolling average PIP
#' @param vgrid1=windowSize*5 Interval between main vertical grid bars (sequence positions)
#' @param vgrid2=windowSize Interval between secondary vertical grid bars (sequence positions)
#' @param hgrid1=10 Interval between main horizontal grid bars (percents)
#' @param hgrid2=5 Interval between secondary horizontal grid bars (percents)
#' @param leftLimit=NULL specify the starting position of the region to be displayed. If not specified use the beginning of the sequence
#' @param rightLimit=NULL specify the ending position of the region to be displayed. If not specified use the end of the sequence
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
                             vgrid1 = windowSize * 5,
                             vgrid2 = windowSize,
                             hgrid1 = 10,
                             hgrid2 = 5,
                             reversePlot = TRUE,
                             leftLimit = NULL,
                             rightLimit = NULL,
                             legend = NULL,
                             colors = NULL,
                             legendMargin = 0.25,
                             legendCorner = "topright",
                             legendCex = 0.7,
                             ylim = c(50,100),
                             ... ) {
  ## Initialise variables  
  meanPIPs <- vector() ## Mean PIP per sequence
  i <- 1 # 
  nbAlignments <- length(alignments)
  
  ## Color palette
  if (is.null(colors)) {
    colors <- rainbow(n = length(alignments))
    names(colors) <- names(alignments)
  }
  
  
  ## Plot PIP profiles
  i <- 1
  for (i in 1:length(alignments)) {
    if (reversePlot) {
      j <- length(alignments) - i + 1
    } else {
      j <- i
    }
    
    subject <- names(alignments)[j]
    alignment <- alignments[[j]]
    
    ## Get the aligned reference and query sequences 
    refSeq <- unlist(strsplit(as.character(pattern(alignment)), split = "")) 
    subjectSeq <- unlist(strsplit(as.character(subject(alignment)), split = "")) 
    # compareStrings(genomesNto1$alignments[[1]]) ## TO TEST: is this fastest ? Does it give the same result ?
    # length(refSeq)
    # table(refSeq)
    # sum(is.na(refSeq))
    
    # ## Only keep the positions corresponding to the reference sequence (no gap in ref)
    refPositions <- refSeq != "-"
    table(refPositions)
    # table(refPositions)
    
    ## Compute identity per position
    identityProfile <- refSeq[refPositions] == subjectSeq[refPositions]
    # table(identityProfile)
    #    identityProfile <- refSeq == querySeq
    
    ## Compute PIP profile
    pipProfile <- 100 * filter(identityProfile, filter = rep(1/windowSize, windowSize))

    
    ## Compute PIP limits
    if (is.null(leftLimit)) {
      pipStart <- 1
    } else {
      pipStart <- leftLimit
    }
    if (is.null(rightLimit)) {
      pipEnd <- length(identityProfile)
    } else {
      pipEnd <- rightLimit
    }
    
    ## Compute mean PIP over the specified limits (pipStart, pipEnd)
    ## leftLimit <- NULL
    ## pipEnd <- NULL
    ## class(pipProfile)
    ## table(identityProfile)
    meanPIP <- round(digits = 3, 100 * sum(identityProfile[pipStart:pipEnd],na.rm = TRUE) / length(identityProfile))
    meanPIPs <- c(meanPIPs, meanPIP)
    
    
    message("\t", i, "/", nbAlignments,
            "\tpid = ", round(digits = 2, pid(alignment)), 
            "\t", subject,
            "\tfrom ", pipStart,
            "\tto ", pipEnd,
            "\tmeanPIP = ", meanPIP
    )
    
    ## Sequence color
    if (is.null(colors[subject])) {
      seqColor <- colors[j]
    } else {
      seqColor <- colors[subject]
    }
    
    ## Plot PIP profiles
    if (i == 1) {
      plot(pipStart:pipEnd,
           pipProfile[pipStart:pipEnd], 
           type = "l",
           xlab = "Position", 
           ylab = paste0("PIP (", windowSize," bp-averaged)"),
           las = 1,
           ylim = ylim,
           xlim = c(0, length(refPositions) * (1 + legendMargin)),
           panel.first = c(
             abline(h = seq(0, 100, hgrid2), col = "#DDDDDD"),
             abline(h = seq(0, 100, hgrid1), col = "#BBBBBB"),
             abline(h = c(0,100), col = "black"),
             abline(v = seq(0, length(refPositions), vgrid2), col = "#DDDDDD"),
             abline(v = seq(0, length(refPositions), vgrid1), col = "#888888")),
           col = seqColor,
           ...
      ) 
      
    } else {
      lines(pipStart:pipEnd,
            pipProfile[pipStart:pipEnd], 
            type = "l",
            col = seqColor,
            ...
      )
      
    }
  }
  
  
  ## Default legend
  if (is.null(legend)) {
    if (reversePlot) {
      legend <- paste0(names(alignments), " (", round(digits = 1, rev(meanPIPs)), "%)")
      
    } else {
      legend <- paste0(names(alignments), " (", round(digits = 1, meanPIPs), "%)")
      
    }
    names(legend) <- names(alignments)
  }
  
  ## Draw the legend
  legend(legendCorner, 
         legend = legend, 
         col = colors[names(legend)], 
         cex = legendCex,
         lwd = 2)
}
