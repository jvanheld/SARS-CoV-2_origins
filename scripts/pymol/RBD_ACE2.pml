# opening the models
PATH1 = 'data/pdb/model3.pdb'
PATH2 = 'data/pdb/6m0j.pdb'
cmd.load(PATH1)
cmd.load(PATH2)
align 'model3', '6m0j'

# colorating the structures
cmd.color('wheat',selection='model3',quiet=1)
cmd.color('orange', selection='6m0j',quiet=1)
cmd.color('gray70',selection='/6m0j//A', quiet=1)
cmd.cartoon('automatic',selection='all')
show cartoon
hide lines

set cartoon_transparency = 0.7, model3

# colorating the insertions
select blue_insertions, (model3 & c;A & i;443-445)|(model3 & c;A & i;452-453)|(model3 & c;A & i;472-483)|(model3 & c;A & i;486)|(6m0j & c;E & i;443-445)|(6m0j & c;E & i;452-453)|(6m0j & c;E & i;472-483)|(6m0j & c;E & i;486)
color blue, blue_insertions
select red_insertion, (model3 & c;A & i;485)|(6m0j & c;E:485)
color red, red_insertions

zoom (model3 & c;A & i;440-490)

