from Bio import SeqIO
from Bio.SeqRecord import SeqRecord

"""
Functions to help subselect sequences matching certain criteria

Every here has a unique enough name that 'import *' should be safe
"""

ITS_string = '18S ribosomal RNA gene, partial sequence; internal transcribed spacer 1, 5.8S ribosomal RNA gene, and internal transcribed spacer 2, complete sequence; and 28S ribosomal RNA gene, partial sequence'



class Fungi(SeqRecord):
  
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
  
