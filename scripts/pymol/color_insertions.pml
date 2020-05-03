# opening the model
PATH = 'data/pdb/model3.pdb'
cmd.load(PATH)
cmd.color('wheat',selection='all',quiet=1)
cmd.cartoon('automatic', selection='all')
show cartoon
hide lines

# colorate insertions
select magenta_insertions, i. 1-2|i. 13-14|i. 145|i. 150|i. 248|i. 259-261
color magenta, magenta_insertions
select blue_insertions, i. 146|i. 443-445|i. 452-453|i. 472-483|i. 486
color blue, blue_insertions
select green_insertions, i. 73-78
color green, green_insertions
select yellow_insertions, i. 19|i. 24|i. 153-158|i. 250-252
color yellow, yellow_insertions
select red_insertions, i. 72|i. 245-247|i. 485|i. 680-683
color red, red_insertions


