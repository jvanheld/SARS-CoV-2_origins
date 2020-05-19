#### Define a function to load a tree ####

#' @title Load a tree and prepare if for the plot
#' @author Jacques van Helden
#' @param treeFile file containing the tree (must  be  format supported by ape::read.tree)
#' @param outgroup=NULL out group used to define the root. Should be a vector of tip labels.
#' @param rootNode=NULL alternative to outgroup: define the root based on an internal node number
#' @param nodesToRotate=NULL a vector of internal node numbers to rotate for the plot
#' @param tipColor=NULL a vector with a color assigned to tips (specified as names of the vector)
#' @param ... additional parameters are passed to ape::read.tree
loadTree <- function(treeFile, 
                     outgroup = NULL,
                     rootNode = NULL,
                     nodesToRotate = NULL, 
                     speciesPalette=NULL,
                     tipColor = NULL,
                     ...
) {
  
  
  ## Load the tree with phytools
  message("\tLoading tree from file ", treeFile)
  tree <- ape::read.tree(file = treeFile, ...)
  # tree <- phytools::read.newick(file = treeFile)
  # plot(tree)
  # nodelabels()
  # Ntip(tree)
  # Nnode(tree)
  
  ## Define the root
  if (!is.null(outgroup)) {
    tree <- root(tree, outgroup = outgroup, resolve.root = TRUE)
    message("\tRooted on outgroup ", paste(collapse = ", ", outgroup))
  } else if (!is.null(rootNode)) {
    tree <- reroot(tree, node = rootNode)  
    message("\tRooted on node ", rootNode)
  } else {
    message("\tNo root specified")
  }
  
  # Rotate user-specified nodes
  if (!is.null(nodesToRotate)) {
    for (node in nodesToRotate) {
      tree <- rotate(tree, node)
    }
  }

  ## Tree type
  if (is.binary(tree)) {
    treeType <- "binary"
  } else {
    treeType <- "non-binary"
  }
  message("\tLoaded ", treeType, " genome tree", 
          " with ", Ntip(tree), " tips",
          " and ", Nnode(tree), " internal nodes")
  
  ## Check theinternal structure of the tree
  # str(tree)
  # tree$node.label
  #  dim(tree$edge)
  #  tree$tip.label
  #  class(tree)
  
  ## Tip parameters
  tipParam <- data.frame(
    row.names = tree$tip.label,
    color = rep(x = "grey", length.out = length(tree$tip.label)))
  tipParam$species <- "NONE"
  
  
  ## Identify species per tip
  for (prefix in names(speciesPrefix)) {
    tipParam[grep(pattern = paste0("^", prefix), x = row.names(tipParam), perl = TRUE), "species"] <- speciesPrefix[prefix]
    
  }

  ## Assign tip color accoding to species
  if (is.null(speciesPalette)) {
    tipParam$color <- "black"
  } else {
    tipParam$color <- unlist(speciesPalette[tipParam$species])
  }
  
  ## Assign a specific color to tips (this overwrites the species color)
  if (!is.null(tipColor)) {
    for (tipPattern in names(tipColor)) {
      tipParam[grep(pattern = tipPattern, 
                      x = tree$tip.label, perl = TRUE), "color"] <- tipColor[tipPattern]
      
    }
    # tipPattern <- paste0("(", paste0(collapse = ")|(", names(tipColor)), ")")
    # tipsToColor <- grep(pattern = tipPattern, x = tree$tip.label)
    # tipParam[tipsToColor, "color"] <- tipColor[tipsToColor]
  }
  
  # ## Identify CoV2 tips
  # cov2Tips <- grep(pattern = "CoV2", x = tree$tip.label, perl = TRUE, value = TRUE)
  result <- list(tree = tree, 
                 tipParam = tipParam)
  # plot(result$tree)
  return(result)
}
