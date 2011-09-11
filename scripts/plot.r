library(ape)

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

#This is really stupid, but don't enough R to
#do it better...
assign_colour <- function(s) {
  if (s == "Pinus   radiata"){
    return('#A52A2A')
    }
  else if (s == "Nothofagus   menziesii"){
    return('#006D2C')
  }
    else if (s == "Nothofagus   fusca"){
    return('#31A354')
  }
    else if (s == "Nothofagus   solandri"){
    return('#74C476')
  }
    else if (s == "Nothofagus   truncata"){
    return('#BAE4B3')
  }
    else if (s == "Nothofagus   sp."){
    return('#EDF8E9')
  }
    else{ print('say wha?')}
}


d <- read.dna('../trees/filtered_renamed_ali.fasta', 'fasta')
tr <- nj(dist.dna(d, 'K81'))

ids <- unlist(with(tr, lapply(tip.label, get_id)))
genera <- unlist(with(tr, lapply(tip.label, get_genus)))
species <- unlist(with(tr, lapply(tip.label, get_species)))

c.gen <- ifelse(genera=="Nothofagus", "#1B9E77", "#D95F02")
c.species <- unlist(lapply(species, assign_colour))

write.csv(cbind(ids, c.species), "species.csv", row.names=F, quote=F)
write.csv(cbind(ids, c.gen), "genera.csv", row.names=F, quote=F)


plot(tr, x.lim = 3, show.tip.label=F) 
x <- rep(1, length(species))
barplot(c(NA, x), add = TRUE, horiz = TRUE, space = 0, offset = 1, axes=F, col=c.species, border=NA)

