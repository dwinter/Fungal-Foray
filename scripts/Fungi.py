from Bio import SeqIO
from Bio.SeqRecord import SeqRecord

"""
Classes and functions to help me deal with sequence records representing
fungal DNA sequences and their hosts. 

At the moment, this is just FungalRecord, an object subclassed from 
Bio.SeqRecord by including some new attributes to make selecting particular
records cleaner and easier.
"""

ITS_string = '18S ribosomal RNA gene, partial sequence; internal transcribed spacer 1, 5.8S ribosomal RNA gene, and internal transcribed spacer 2, complete sequence; and 28S ribosomal RNA gene, partial sequence'



class FungalRecord(SeqRecord):
  
  def __init__(self, rec):
    SeqRecord.__init__(self, rec.seq, rec.id, rec.name, rec.description,
                        rec.dbxrefs,rec.features,rec.annotations)
  
  @property
  def _source(self):
    """ Find the 'source' feature, used to set host and country below """
    for feature in self.features:
      if feature.type == 'source':
        return feature
  
  @property
  def host(self):
    try:
      return self._source.qualifiers['host'][0]
    except KeyError:
      return ''

  @property
  def country(self):
    try:
      return self._source.qualifiers['country'][0]
    except KeyError:
      return ''

  @property
  def ITS(self):
    if ITS_string in self.description:
      return True
    else:
      return False
 
def match_record(record, attr, value):
  """ Tests if attributes of an object matchs a giveb value """
  if isinstance(value, list):
    #lots of values, so return True any of them are there
    for v in value:
      if v in getattr(record, attr):
        return True
    #will only make it here if True was returned above    
    return False
  else: 
    return value in getattr(record, attr) 
