## Pymol scripts for the coloration of SARS-CoV-2 spike protein


**Author: ** Erwan Sallard	erwan.sallard@ens.psl.eu

Folder contents

| Script | Goal | Notes |
|----------------|---------------------------|----------------|
| `color_insertions.pml` | displays the structure of the SARS-CoV-2 spike (predicted by SWISSmodel on the basis of the 6acc structure of SARS-CoV-1) with the insertions of SARS-CoV-2 highlighted in colours |red = insertion present only in SARS-CoV-2\nyellow = in SARS-CoV-2 + 1 or 2 SARS-like viruses\ngreen = in SARS-CoV-2 + 34 or 35 SARS-like viruses\nblue = in SARS-CoV-2 + 135 to 152 other SARS-like viruses\nmagenta = in all 175 SARS-like viruses except 1, 2 or 3|
| `RBD_ACE2.pml` | displays the interface between SARS-CoV-2 spike and ACE2, with insertions colorised as in `color_insertions.pml` | no model is currently available showing the whole spike protein interacting with ACE2, so in this script, a model of the whole spike (transparent) is superposed with the RBD(orange)-ACE2(silver) complex |
| `superposition.pml` | compares the structures of the spikes of SARS-CoV-2 (orange) and SARS-CoV-1 (magenta) and their interface with ACE2 (silver) |  |

how to execute the programs:
`pymol scripts/pymol/color_insertions.pml`
`pymol scripts/pymol/RBD_ACE2.pml`
`pymol scripts/pymol/superposition.pml`
