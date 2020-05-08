#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May  5 12:49:25 2020

@author: Erwan Sallard   erwan.sallard@ens.psl.eu
"""

'''goal: this program compares the ACE2 proteins of various organisms with a
reference ACE2 (one of the sequences in the alignment) and identify their level
of similarity on the residues important for SARS-CoV-2 spike binding
(identified in Yan et al 2020 science). The program takes as an input a
multifasta file describing the alignment between the ACE2 proteins studied and
the name of the reference sequence (for example 'HUMAN_Homo_sapiens'), and the
name of the output file. The output is a .csv file'''

import sys
alignment_file = sys.argv[1]
name_reference = sys.argv[2]
output_name=sys.argv[3]

importants=[24,30,34,41,42,82,353,357]
# the list of the most important residues for SARS-CoV-2 spike binding in human
# ACE2 protein
n_importants=len(importants)
for k in range(n_importants):
    importants[k]-=1
# python counts from 0 while residues are indexed from 1, so the list must be
# reindexed

alignment=open(alignment_file,'r')
# the multifasta file of ACE2 proteins multiple alignment is open
lines=alignment.readlines()
alignment.close()
sequences=dict()
# sequences will be a dictionary with the format 'sequence_name':sequence
# for each ACE2 sequence in the alignment (including the '-' signs)

for line in lines:
    if line[0]=='>' or line[0]=='\ufeff':
        # if the line corresponds to a new sequence name
        mots=line.split('_')
        nom=mots[1]+'_'+mots[2]+'_'+mots[3][:-1]
        sequences[nom]=''
    else:
        # if the line corresponds to the sequence itself
        sequences[nom]=sequences[nom]+line[:-1]

speciesnames=list(sequences.keys())
import pandas as pd
species=pd.DataFrame()
# species will be a dataframe indicating, for each species, the number of
# differences with reference ACE2 in important residues
species['number of important residues']=[n_importants]

reference=sequences[name_reference]
# Because of '-' signs in the alignment, the position of important residues
# does not correspond to their index in the string. They must be reindexed.
counter=0
for k in reference:
    if k=='-':
        # all residues after this sign must be reindexed
        for j in range(n_importants):
            if importants[j]>=counter:
                importants[j]+=1
    else:
        counter+=1

# The comparison proper with reference sequence:
for name in speciesnames:
    sequence=sequences[name]
    differences=0
    for k in importants:
        if sequence[k]!=reference[k]:
            differences+=1
    species[name]=[differences]

species=species.transpose()
species.columns=['number of differences with human on the important residues']
species.to_csv(output_name)
