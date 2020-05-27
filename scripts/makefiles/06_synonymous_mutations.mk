####################################
## Comparison of gene and protein sequences for counting of synonymous vs non synonymous mutations

MAKEFILE=scripts/makefiles/06_synonymous_mutations.mk
MAKE=make -f ${MAKEFILE}

targets:
	@echo "Targets:"
	@echo "compare_S_genes:	compares two specified S genes, performs an analysis of mutations (classification as indel, synonymous or non synonymous substitution) and draws a plot of cumulated mutation counts as a function of position in the protein"

NAME1 = 'HuCoV2_WIV04°2019'
NAME2 = 'BtRaTG13'
PLOT_FOLDER = results/synonymous_mutations
OUTPUT_PLOT = ${PLOT_FOLDER}/${NAME1}_and_${NAME2}.png

compare_S_genes:
	@echo "comparison of sequences: "
	@echo "${NAME1}"
	@echo "${NAME2}"
	@echo "output saved in: "
	@echo "${OUTPUT_PLOT}"
	mkdir -p ${PLOT_FOLDER}
	python scripts/python/mutation_analyser.py ${NAME1} ${NAME2} ${OUTPUT_PLOT}

