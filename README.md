*And online Fungal Foray

This is documentation of my attempts to do a better job of using Genbank to
explore the diversity of fungi in different forests in New Zealand. 

We are starting of with a file `fungal.gb` which contains sequence records
and trying to get something interesting form that

** First glance (what hosts are in there?)

    >>>from Bio import SeqIO
    >>>from scripts.Fungi import Fungi
    >>>f_records = (Fungi(r) for r in SeqIO.parse('fungal.gb', 'gb'))
    >>>hosts = set([r.host for r in f_records])
    >>>len(hosts)
    262

No concerns about having too few hosts then. I'm most interested in Nothofagus 
and Pine forests, and only those with ITS sequences (alignable). So lets
get those
    
    >>> def on_target(record):
    ...   if not "Nothofagus" or "Pinus" in record.host:
    ...     return False
    ...   if record.country != "New Zealand":
    ...     return False
    ...   return record.ITS
    >>> f_records = (Fungi(r) for r in SeqIO.parse('fungal.gb', 'gb'))
    >>> filtered = [r for r in f_records if on_target(r)]
    >>> len(filtered)
    387
    
387 records from Pine or Nothofagus... let's save those a file first


