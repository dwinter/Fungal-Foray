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

# I do ;-)

my_colours <- c(

  `Pinus   radiata` = '#A52A2A',
  `Nothofagus   menziesii` = '#006D2C',
  `Nothofagus   fusca` = '#31A354',
  `Nothofagus   solandri` = '#74C476',
  `Nothofagus   truncata` = '#BAE4B3',
  `Nothofagus   sp.` = '#EDF8E9'
)

assign_colour <- function(s) return(my_colours[s])

# nb (I'd also use rgb() rather than direct hex values)

d <- read.dna('filtered_renamed_ali.fasta', 'fasta')
tr <- nj(dist.dna(d, 'K81'))

ids <- unlist(with(tr, lapply(tip.label, get_id)))
genera <- unlist(with(tr, lapply(tip.label, get_genus)))
species <- unlist(with(tr, lapply(tip.label, get_species)))

write.csv(cbind(ids, c.species), "species.csv", row.names=F, quote=F)
write.csv(cbind(ids, c.gen), "genera.csv", row.names=F, quote=F)

c.gen <- ifelse(genera=="Nothofagus", "347235", "brown")
c.species <- unlist(lapply(species, assign_colour))
plot(tr, x.lim = 3, show.tip.label=F) 
x <- rep(1, length(species))
barplot(c(NA, x), add = TRUE, horiz = TRUE, space = 0, offset = 1, axes=F, col=c.species, border=NA)

