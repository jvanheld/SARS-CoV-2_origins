#' @title plotMyTree
#' @author Jacques van Helden
#' @param myTree a tree data containing a tree + tip parameters, as returne by LoadTree()
#' @param show.node.label=FALSE passed to ape::plot.phylo()
#' @param scaleLength=0.2 length of the scale bar, passed to add.scale.bar()
#' @param ... additional parameters are passed to ape::plot.phylo
plotMyTree <- function(myTree, 
                       show.node.label = FALSE, 
                       scaleLength = 0.2,
                       ...) {
  ## Plot the tree
  ape::plot.phylo(myTree$tree, 
                  type = "phylogram", 
                  show.node.label = show.node.label,
                  show.tip.label = TRUE,
                  edge.color = "grey",
                  tip.color = myTree$tipParam$color,
                  #         ftype = "off",
                  edge.width = 2,
                  label.offset = 0.1, 
                  lwd = 2,
                  # fsize = 0.7,
                  cex = 0.7,
                  color = speciesPalette$Bat, 
                  nomargin = FALSE,
                  font = 1, 
                  ...)
  add.scale.bar(cex = 1, font = 2, col = "blue", length = scaleLength, 
                lwd = 2, lcol = "blue")
  # add.arrow(myTree$tree, tip = cov2Tips, 
  #           arrl = 0.3, 
  #           col = speciesPalette$Human)
  
  # length(myTree$tree$node.label)
  # nodelabels(cex = 0.5)
  # sort(as.numeric(myTree$tree$node.label))
  # tiplabels()
  
}
