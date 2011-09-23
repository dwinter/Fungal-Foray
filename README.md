#An online Fungal Foray

This is documentation of my attempts to do a better job of using Genbank to
explore the diversity of fungi in different forests in New Zealand [than I 
did last time](http://sciblogs.co.nz/the-atavism/2011/09/04/sunday-spinelessness-an-online-fungal-foray/). 
We are starting of with a file `fungal.gb` which  is sitting in `raw_seqs` and is the result 
of an Entrez search for `Fungi[Organism]` "host" and "New Zealand" hiding somewhere.
So what can this data tell us?

##First glance (what hosts are in there?)

`scripts/Fungi/FungalRecord` has a version of Biopython's SeqRecord that makes
picking through the data in each record a lot easier to read tan the 

    >>>from Bio import SeqIO
    >>>from scripts.Fungi import FungalRecord
    >>>f_records = (FungalRecord(r) for r in SeqIO.parse('raw_seqs/fungal.gb', 'gb'))
    >>>hosts = set([r.host for r in f_records])
    >>>len(hosts)
    262

No concerns about having too few hosts then! 

##Are Nothofagus and Pine communities different?

I'm most interested in _Nothofagus_ and Pine forests, and only those with ITS sequences 
since I want to make a tree from them. So lets get those
    
    >>> def on_target(record):
    ...   if ("Nothofagus" record.host) or ("Pinus" in record.host):
    ...     continue
    ...   else:
    ...     return False
    ...   if record.country != "New Zealand":
    ...     return False
    ...   return record.ITS
    >>> f_records = (FungalRecord(r) for r in SeqIO.parse('raw_seqs/fungal.gb', 'gb'))
    >>> filtered = [r for r in f_records if on_target(r)]
    >>> len(filtered)
    207
    >>> set([r.host for r in filtered])
    set(['Nothofagus fusca', 'Nothofagus solandri', 'Nothofagus truncata', 'Pinus radiata', 'Nothofagus menziesii', 'Nothofagus sp.'])
    
207 records from Pine or _Nothofagus_... let's save those a file first
The idea of subclassing SeqRecord for the FungalRecord was to be able
to use SeqIO...
  
    >>> SeqIO.write(filtered, 'seqs/filtered.gb', 'genbank') 
    207

Magic! 
I'm to make a tree from these, so make the names smaller (readable) and
point them towards a host
    
    >>> to_rename = filtered[:]
    >>> for record in to_rename:
    ...   record.description = record.host
    >>> SeqIO.write(filtered, 'trees/filtered_renamed.fasta', 'fasta')
    207
     
Alright, let's make some trees from the fungal sequences, and see what
they show about the distribution of their hosts

    $ mkdir trees
    $ mv filtered_host.fasta trees/
    $ muscle -in filtered_renamed.fasta -out filtered_renamed_ali.fasta

This allignment is _not_ final, it includes lots of dubious gappy regions
but it also includes a lot of taxonomically diverse fungi and I'm not 
aiming to represent the One True Tree of Fungi, so much as use a tree
to plot the hosts (the way `muscle` works the alignment will be better
within closely related sequences that between them, which is the more
interesting bits). 

So I went on an made a NJ tree and tooledaround in `R` and using `ape` and
(the file `scripts/plot.r`) which gave me this:

![Smaverage Tree](https://github.com/dwinter/Fungal-Foray/raw/master/tree.png)

Which was... OK. But I reckon I can do better with iTOL so I wrote CSV files to upload there. 
This one [looks pretty cool](http://itol.embl.de/external.cgi?tree=119224961033146313154072750&restore_saved=1&cT=4689)and it does look like each community is quite distinct.

##More Trees

Ok, so that's a proof of concept. Can we see similar patterns when we include more host trees. A new function in /scripts makes slecting a little clearer

    >>> from scripts.Fungi import match_record
    >>> spp = [r for r in f_records if match_record(r, 'host', ['Pinus', 'Pine', 'Nothofagus', 'Kunzea'])]
    >>> on_target = [r for r in spp if (r.ITS) and (r.country == 'New Zealand')]
    
Which gets a broader sample
    
    >>> from collections import Counter
    >>> Counter([r.host for r in on_target])
    Counter({'Nothofagus menziesii': 114, 'Pinus radiata': 86, 'Nothofagus fusca': 29, 'Nothofagus solandri': 28, 'Kunzea ericoides': 22, 'Nothofagus sp.': 14,    'Nothofagus': 11, 'Kunzea ericoides var. microflora': 4, 'Nothofagus truncata': 4, 'Pinus sp.': 3, 'Nothofagus solandri var. cliffortioides': 1, 'Pinus nigra': 1, 'Leptospermum scoparium': 1, 'Pinus radiata after Sirex noctilio attack': 1, 'Nothofagus meniesii': 1, 'Pinus': 1, 'Pinus pinaster': 1}
    >>> for r in on_target:
    ...     r.id = r.tax_id
    ...     r.description = r.host
    ... 
    >>> SeqIO.write(on_target, 'seqs/broader_renamed.fasta', 'fasta')
    322


