#' @title Plot profile of  Percent Identical Positions (PIP)
#' @author Jacques.van-Helden@france-bioinformatique.fr
#' @param alignment a set of aligned sequences in Biostrings::StringSet format
#' @param refSeqName index or ID of the reference sequence. If not provided, the first sequence is used
#' @param plotRefGaps=FALSE if TRUE, print each position of the alignment and indicate gaps in the reference with a blank. If FALSE, only print positions of the reference sequence
#' @param reversePlots=TRUE plot the profiles in reverse order, to avoid for the first profiles to be masked by the last ones. Note that the legend order is always from the first to the last element of provided set of alignment. 
#' @param windowSize=100 size of the sliding window to compute the rolling average PIP
#' @param vgrid1=windowSize*5 Interval between main vertical grid bars (sequence positions)
#' @param vgrid2=windowSize Interval between secondary vertical grid bars (sequence positions)
#' @param hgrid1=10 Interval between main horizontal grid bars (percents)
#' @param hgrid2=5 Interval between secondary horizontal grid bars (percents)
#' @param legend=names(alignment) legend labels
#' @param colors=rainbow(n=length(alignment)) color per line
#' @param legendMargin=0.25 proportion to add on the right side for the legend (sequence names)
#' @param legendCorner="topright" position of the legend
#' @param legendCex=0.7 legend character size
#' @param ylim=c(0,100) ordinate limits
#' @param ... additional parameters are passed to plot()
#' @export
PlotPIPprofiles <-  function(alignment, 
                             refSeqName,
                             plotRefGaps = FALSE,
                             windowSize = 100,
                             vgrid1 = windowSize * 5,
                             vgrid2 = windowSize,
                             hgrid1 = 10,
                             hgrid2 = 5,
                             reversePlot = TRUE,
                             legend = NULL,
                             colors = NULL,
                             legendMargin = 0.25,
                             legendCorner = "topright",
                             legendCex = 0.7,
                             ylim = c(0,100),
                             ... ) {
  
  #### Validity checks ####
  
  ## Check if the alignment were provided in a  suitable format
  if (!inherits(alignment, c("BStringSet", "AAStringSet", "RNAStringSet", "DNAStringSet"))) {
    stop("Invalid input type. Should be an object of class BStringSet, DNAStringSet, RNAStringSet or AAStringSet")
  }
  
  ## Check if the reference ID belongs to the alignment
  if (!(refSeqName %in% names(alignment))) {
    stop("Reference ID (", refSeqName, ") does not belong to the alignment names. ")  
  }

  #### Initialise variables ####
  nbSeq <- length(alignment)
  seqColors <- c()
  meanPIPs <- vector() ## Mean PIP per sequence
  legendText <- c()
  
  ## Color palette
  if (is.null(colors)) {
    colors <- rainbow(n = length(alignment))
    names(colors) <- names(alignment)
  }
  
  
  #### Treat reference sequence ####
  
  ## Get the aligned reference and query sequences 
  refSeq <- alignment[refSeqName]
  
  ## Split query sequence into letters
  refSeqLetters <- as.vector(unlist(strsplit(as.character(refSeq), split = "")))
  # View(refSeqLetters)

  ## Identify gap positions in reference sequence
  refNoGap <- refSeqLetters != "-"
  
  if (!plotRefGaps) {
    refSeqLetters <- refSeqLetters[refNoGap] ## Discard gaps in the reference sequence
  }
  
  i <- 2
  for (i in 1:length(alignment)) {
    
    ## Get the index of he query sequence
    if (reversePlot) {
      j <- length(alignment) - i + 1
    } else {
      j <- i
    }

    
    #### Compute and plot PIP profiles ####
    
    ## Split the query sequence into letters    
    querySeq <- alignment[j]
    # as.character(refSeq)
    # as.character(querySeq)
    querySeqName <- names(querySeq)
    querySeqLetters <- as.vector(unlist(strsplit(as.character(querySeq), split = "")))
    if (!plotRefGaps) {
      querySeqLetters <- querySeqLetters[refNoGap] # Discard gaps in the reference sequence
    }
    # refSeqLetters
    # querySeqLetters
    
    #### Identify gap positions ####
    queryNoGap <- querySeqLetters != "-"
    
    if (plotRefGaps) {
      noGap <- refNoGap & queryNoGap
    } else {
      noGap <- queryNoGap
    }
    # table(refNoGap, queryNoGap)
    # table(noGap)
    message("\tGap positions ", 
            "\tref: ", sum(!refNoGap),
            "\tquery: ", sum(!queryNoGap),
            "\t", querySeqName)
    
    
    ## Compute identity per position
    identityProfile <- noGap & (refSeqLetters == querySeqLetters)
    # identityProfile <- (refSeqLetters == querySeqLetters)
    # table(identityProfile)
    
    nbIdentities <- sum(identityProfile, na.rm = TRUE)
    meanPIP <- round(digits = 3, 100 *  nbIdentities / sum(noGap))
    meanPIPs <- c(meanPIPs, meanPIP)

    ## Compute PIP profile
    pipProfile <- 100 * filter(identityProfile, filter = rep(1/windowSize, windowSize))
    # length(pipProfile)
    
    ## Prepare text for legend
    if (is.null(legend)) {
      legendText <- append(
        legendText,
        paste0(querySeqName, " (", round(digits = 1, meanPIP), "%)"))
    }    
        
    message("\t", i, "/", nbSeq,
            #            "\tpid = ", round(digits = 2, pid(alignment)), 
            "\t", querySeqName,
            "\ttotal: ", length(identityProfile), 
            "\tgaps: ", sum(!noGap), 
            "\tgap-free: ", sum(noGap), 
            "\tidentical: ", nbIdentities,
            "\tmeanPIP = ", meanPIP
    )
    
    #### Sequence color ####
    if (is.null(colors[querySeqName]) || is.na(colors[querySeqName])) {
      seqColor <- as.vector(colors[j])
    } else {
      seqColor <- colors[querySeqName]
    }
    seqColors[querySeqName] <- seqColor
    
    ## Plot PIP profiles
    plotValues <- pipProfile
    plotValues[!noGap] <- NA
    
    if (plotRefGaps) {
      plotLimit <- length(refSeqLetters)
      plotPositions <- 1:plotLimit
    } else {
      plotLimit <- sum(refNoGap)
      plotPositions <- which(refNoGap)
    }
    # message("plotLimit = ", plotLimit)
    # plotLimit
    # sum(plotPositions)
    
    
    if (i == 1) {
      plot(plotPositions,
           plotValues[plotPositions], 
           type = "l", 
           col = seqColor,
           xlab = "Position", 
           ylab = paste0("PIP (", windowSize," bp-averaged)"),
           las = 1,
           ylim = ylim,
           xlim = c(0, length(plotPositions) * (1 + legendMargin)),
           panel.first = c(
             abline(h = seq(0, 100, hgrid2), col = "#DDDDDD"),
             abline(h = seq(0, 100, hgrid1), col = "#BBBBBB"),
             abline(v = seq(0, plotLimit, vgrid2), col = "#DDDDDD"),
             abline(v = seq(0, plotLimit, vgrid1), col = "#888888"),
             abline(h = c(0,100), col = "black"),
             abline(v = c(0,max(plotPositions)), col = "black")),
           ...
      )
      
    } else {
      lines(plotPositions,
            plotValues[plotPositions], 
            type = "l",
            col = seqColor,
            ...
      )
      
    }
  }
  
  
  ## Legend
  if (is.null(legend)) {
    legend <- legendText
  }
  
  if (reversePlot) {
    legend <- rev(legend)
    seqColors <- rev(seqColors)
  }
  
  ## Draw the legend
  legend(legendCorner, 
         legend = legend, 
         col = seqColors, 
         lwd = 2,
         cex = legendCex)
}
