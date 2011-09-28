exclusivity <- function(tr, nreps=100, plot=TRUE){
  sub_tr <- subtrees(tr)
  n <- length(sub_tr)
  index <- sum(sapply(sub_tr, function(t) length(unique(t$tip.label))==1))/n
  dist <- numeric()
  tmp <- tr
  for (i in 1:nreps){
      tmp$tip.label <- sample(tmp$tip.label, length(tmp$tip.label))
      sub_tmp <- subtrees(tmp)
      dist[i] <- sum(sapply(sub_tmp, function(t) length(unique(t$tip.label))==1))/n
      print(i)
  }
  #This is a one sided test i.e. more exlusive than permutation of the labels
  pval <- 1 - mean(dist > index)
  if (plot){
    hist(dist)
    abline(v=index, col='blue')
  }
  return(list(exclusivity=index, p.value=pval))
}

# For now this just makes a csv to print shade nodes by genus, but should
# extendible for species too. Returns a dataframe with species and genus

make_iTol <- function(tr){
  taxon_split <- unlist(lapply(tr$tip.label, function(s) unlist(strsplit(s, " "))[1:3]))
  taxa <- as.data.frame(matrix(taxon_split, ncol=3, byrow=TRUE))
  colnames(taxa) <- c("taxid", "genus", "species")
  u.genera <- unique(taxa$genus)
  #will break w/ > 8 genera
  g_colours <- brewer.pal(length(u.genera), "Dark2")
  names(g_colours) <- u.genera
  taxa$gen_shade <- with(taxa, g_colours[genus])
  return(taxa)
}









#libray(ape)
#data(bird.orders)
#grp <- sample(letters[1:3], length(bird.orders$tip.label), replace=TRUE)
#bird.orders$tip.label <- grp
#exclusivity(bird.orders, plot=FALSE)
#$exclusivity
#[1] 0.0909091
#
#$p.value
#[1] 0.56



