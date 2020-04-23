#open the model
cmd.load('/home/erwan/BigBazar/Documents/coronavacances/spike/model3.pdb')
cmd.color('wheat',selection='all',quiet=1)

# coloration des insertions
select a, resi 247+248+249+250+251+252
color red, a
# pymol numérote les résidus à partir de 1, pas 0

# à moins d'utiliser API, il faut répéter ces lignes de code pour
# chaque insertion en variant les positions et les couleurs...

# save spike3.pse
