#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Apr 26 14:41:12 2020

@author: erwan
"""
import sys

alignment=sys.argv[1]
reference=sys.argv[2]
filename=sys.argv[3]

'''identifies the insertions in the sequence "reference" out of a multiple
alignment file in .clw format. Is considered an insertion every position
which is not a "-" in the reference sequence and where at least one other
sequence has a "-".
This function creates a .csv file in the path "filename", indicating the
positions of insertions in the reference protein (in first column) and, for
each position, the sequences having a '-' (in the other columns).
example: if "reference"= MART-PYLK and the 2 other sequences of the
alignment are seq1= MA-TVPYLK and seq2= MART-P-LK, the returned dictionary
is {3:['seq1'];6:['seq2']}'''
clwfile=open(alignment,'r')
lines=clwfile.readlines()
clwfile.close()

sequences=dict()
# sequences is a dictionary which will contain the different sequences
# separately
lines.remove(lines[0])
# we remove the first line, which is the title of the alignment

names=[] # the list of sequence names

for line in lines:
    if line[0] not in ['\n', ' ']:
        # meaning if the line is a sequence and not a spacer
        data=line.split(' ')
        name=data[0]
        sequence=data[len(data)-1][:-1]
        # sequence is the sequence of the line without the final \n
        if name in names:
            sequences[name]=sequences[name]+sequence
        else:
            names.append(name)
            sequences[name]=sequence

reference_sequence=sequences[reference]

names.remove(reference)
# names is the list of sequence names except the reference sequence

position=0 # a counter of position in the reference protein

f=open(filename,'w') # the output file
for k in range(len(reference_sequence)):
    if reference_sequence[k]!='-':
        position+=1
        is_insertion=False
        sequences_without_insertion=[]
        # if the position studied is an insertion, this list will contain
        # the names of the sequences without the insertion
        for name in names:
            if sequences[name][k]=='-':
                is_insertion=True
                sequences_without_insertion.append(name)
        if is_insertion:
            # we write a line in the .csv file, with the insertion position
            # and the names of sequences without this insertion
            line=str(position)
            for name in sequences_without_insertion:
                line+=','+name
            line+='\n'
            f.writelines(line)

f.close()
