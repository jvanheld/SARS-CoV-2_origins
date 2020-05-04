# opening the models
PATH1 = 'data/pdb/6acc.pdb'
PATH2 = 'data/pdb/6m0j.pdb'
cmd.load(PATH1)
cmd.load(PATH2)
align '6acc', '6m0j'

# colorating the structures
cmd.color('magenta',selection='6acc',quiet=1)
cmd.color('orange', selection='6m0j',quiet=1)
cmd.color('gray70',selection='/6m0j//A', quiet=1)
cmd.cartoon('automatic',selection='all')
show cartoon
hide lines

set cartoon_transparency = 0.4, 6acc
set cartoon_transparency = 0.4, 6m0j

# showing the important residues in theinsertions
select insertions, (6m0j & c;E & i;453)|(6m0j & c;E & i;474)|(6m0j & c;E & i;486)|(6acc & c;A & i;440)|(6acc & c;A & i;461)|(6acc & c;A & i;472)
show sticks, insertions

zoom (6m0j & c;E & i;440-490)
