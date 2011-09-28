library(ape)
library(RColorBrewer)
#take a tree, use
d <- read.dna('trees/broader_renamed_ali.fasta', 'fasta')
tr <- nj(dist.dna(d, 'K81'))

df0 <- data.frame()
for (i in 1:length(tr$tip.label)){
  df0[i,]  <- unlist(strsplit(tr$tip.label[i], " "))
}


make_iTol <- function(t){
  taxon_split <- unlist(lapply(tr$tip.label, function(s) unlist(strsplit(s, " "))[1:3]))
  taxa <- as.data.frame(matrix(taxon_split, ncol=3, byrow=TRUE))
  colnames(taxa) <- c("id", "genus", "species")
  u.genera <- unique(taxa$genus)
  g_colours <- brewer.pal(length(u.genera), "Dark2")
  names(g_colours) <- u.genera
  write.csv(cbind(ids, c.species), "species.csv", row.names=F, quote=F)
  
  
head  
}






####################################################
# Mainly an archive of interactive session plotting trees estimated
# from the sequences
####################################################

library(ape)
#Read in the aligned sequences, make a tree and write it out
d <- read.dna('broader_renamed_ali.fasta, 'fasta')
tr <- nj(dist.dna(d, 'K81'))
write.tree(tr, 'filtered_nj.tre')


#I'm going to use iTol to plot that tree, so need csv files assigning
#id to shade

#length(unique(unlist(lapply(tr1[[1]]$tip.label, get_genus)))) > 1
sub.tr <- subtrees(tr)

count_genera <- function(clade){
  count <- length(unique(lapply(clade$tip.label, get_genus)))  
  return(count)
}

calculate_index <- function(tr){
  sub.tr <- subtrees(tr)
  mongen <- sum(sapply(sub.tr, function(t) count_genera(t) < 2))
  return(mongen/length(sub.tr))
}



sapply(1:100, function(n) n*n)


get_id <- function(s)  {
  unlist(strsplit(s, ' '))[1]
}

get_genus <- function(s) {
   unlist(strsplit(s, ' '))[2]
}

get_species <- function(s) {
   f <- unlist(strsplit(s, ' '))
   paste(f[2], " ", f[3])
}

#Thanks Peter Green for more sensible way of doing this
#Colours are generated from RColorBrewer

my_colours <- c(

  `Pinus   radiata` = '#D95F02',
  `Nothofagus   menziesii` = '#006D2C',
  `Nothofagus   fusca` = '#31A354',
  `Nothofagus   solandri` = '#74C476',
  `Nothofagus   truncata` = '#BAE4B3',
  `Nothofagus   sp.` = '#EDF8E9'
)

assign_colour <- function(s) return(my_colours[s])
ids <- unlist(with(tr, lapply(tip.label, get_id)))
genera <- unlist(with(tr, lapply(tip.label, get_genus)))
species <- unlist(with(tr, lapply(tip.label, get_species)))

c.gen <- ifelse(genera=="Nothofagus", "#1B9E77", "#D95F02")
c.species <- unlist(lapply(species, assign_colour))

write.csv(cbind(ids, c.species), "species.csv", row.names=F, quote=F)
write.csv(cbind(ids, c.gen), "genera.csv", row.names=F, quote=F)

#I tried to use R to make a plot similar to the iTol one in R 
# it didn't work
plot(tr, x.lim = 3, show.tip.label=F) 
x <- rep(1, length(species))
barplot(c(NA, x), add = TRUE, horiz = TRUE, space = 0, offset = 1, axes=F, col=c.species, border=NA)

