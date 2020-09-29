#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon May 25 21:38:57 2020

@author: erwan
"""

import sys
import matplotlib.pyplot as plt
from Bio import pairwise2
from Bio.Seq import Seq
from Bio.SubsMat import MatrixInfo as matlist

''' This program compares two nucleotide sequences, identifies indels,
synonymous and non synonymous mutations and draws a plot of cumulated counts
of each mutation type as a function of the position in the corresponding
proteins. The program takes as input the names of the two sequences, which will
be retrieved in the data files; and the name to be given to the output
figure.'''

name1=sys.argv[1]
name2=sys.argv[2]
output_name=sys.argv[3] # the path at which the output figure will be saved

### retrieving the sequences:
nucleotides=open('data/S-gene/S-gene_all.fasta','r')
lines=nucleotides.readlines()
nucleotides.close()
nt_sequence1,nt_sequence2='',''
for k in range(len(lines)-1):
    if name1 in lines[k]:
        nt_sequence1=lines[k+1][:-1] # we take the sequence without the final \n
    if name2 in lines[k]:
        nt_sequence2=lines[k+1][:-1]
if nt_sequence1=='':
    print('gene1 not found')
if nt_sequence2=='':
    print('gene2 not found')

### translating the sequences into proteins
genetic_code=dict({'ttt':'F','ttc':'F','ttg':'L','tta':'L','ctt':'L','ctc':'L',
                   'ctg':'L','cta':'L','att':'I','atc':'I','ata':'I','atg':'M',
                   'gtt':'V','gtc':'V','gta':'V','gtg':'V','tct':'S','tcc':'S',
                   'tca':'S','tcg':'S','agt':'S','agc':'S','cct':'P','ccc':'P',
                   'cca':'P','ccg':'P','act':'T','acc':'T','aca':'T','acg':'T',
                   'gct':'A','gcc':'A','gca':'A','gcg':'A','tat':'Y','tac':'Y',
                   'taa':'*','tag':'*','tga':'*','cat':'H','cac':'H','caa':'Q',
                   'cag':'Q','aat':'N','aac':'N','aaa':'K','aag':'K','gat':'D',
                   'gac':'D','gaa':'E','gag':'E','tgt':'C','tgc':'C','tgg':'W',
                   'cgt':'R','cgc':'R','cga':'R','cgg':'R','aga':'R','agg':'R',
                   'ggt':'G','ggc':'G','gga':'G','ggg':'G'})

def translate(seq):
    ''' translates a nucleotide into a protein sequence.'''
    seq=seq.lower()
    number_codons=len(seq)/3
    if number_codons!=int(number_codons):
        return('the sequence length is not a multiple of 3')
    number_codons=int(number_codons)
    protein=''
    for k in range(number_codons):
        protein+=genetic_code[seq[3*k:3*k+3]]
    if protein[len(protein)-1]=='*':
        return protein[:len(protein)-1] # we remove the final '*'
    return protein

protein1=translate(nt_sequence1)
protein2=translate(nt_sequence2)

### aligning the protein sequences
reformated_protein1=Seq(protein1)
reformated_protein2=Seq(protein2)
alignments = pairwise2.align.globalds(reformated_protein1,reformated_protein2,matlist.blosum62,-10,-1)
aligned_protein1=alignments[0][0]
aligned_protein2=alignments[0][1]

### counts
number_positions=len(aligned_protein1)
positions=[k for k in range(1,number_positions+1)] # will be the x axis in the final plot
position_in_protein1,position_in_protein2=0,0
indel_list,synonymous_list,non_synonymous_list=[],[],[]
indels,synonymous,non_synonymous=0,0,0
for k in range(number_positions):
    # residues are treated one after the other
    position_in_protein1+=1 # this is the position of the considered residue
    # in protein1; '-' signs are not counted
    position_in_protein2+=1
    residue1,residue2=aligned_protein1[k],aligned_protein2[k]
    if residue1=='-':
        position_in_protein1-=1 # '-' signs are not counted
        indels+=1 # the sign '-' indicates a deletion in protein1 compared with
        # protein 2
    elif residue2=='-':
        position_in_protein2-=1
        indels+=1
    elif residue1!=residue2:
        non_synonymous+=1 # the residues are different
    else:
        # we retrieve the codons corresponding to the considered residue
        codon1=nt_sequence1[3*position_in_protein1-3:3*position_in_protein1]
        codon2=nt_sequence2[3*position_in_protein2-3:3*position_in_protein2]
        if codon1!=codon2:
            synonymous+=1
    indel_list.append(indels)
    synonymous_list.append(synonymous)
    non_synonymous_list.append(non_synonymous)

### draws plot
p1=plt.plot(positions,indel_list)
p2=plt.plot(positions,synonymous_list)
p3=plt.plot(positions,non_synonymous_list)
plt.xlabel('position in the protein alignment')
plt.ylabel('cumulated mutation counts')
plt.title('comparison of '+name1+' and '+name2)
plt.legend(('indels','synonymous mutations','non synonymous mutations'))
plt.savefig(output_name,format='pdf')
plt.show()
