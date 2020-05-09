################################################################
## Analysis of ACE2 proteins in coronavirus hosts

MAKEFILE=scripts/makefiles/05_ACE2_analysis.mk
MAKE=make -f ${MAKEFILE}

targets:
	@echo "Targets:"
	@echo "align_muscle_fasta_phylip:	align ACE2 protein sequences with muscle. Outputs given in fasta and phylip formats"
	@echo "phyml_ACE2:			constructs a tree from the muscle alignment"
	@echo "compare_ACE2_with_human:		calculates the number of differences of each aligned ACE2 protein with human ACE2 on the residues important for SARS-CoV-2 binding"

## Multiple alignment of the selected ACE2 protein sequences
MUSCLE_IN = data/ACE2/ACE2.fa
MUSCLE_DIR = results/ACE2_protein
MUSCLE_PREFIX=${MUSCLE_DIR}/ACE2_aligned_muscle

align_muscle_fasta_phylip:
	@echo "ACE2 proteins: multiple alignemnt with MUSCLE"
	@echo "	Result directory"
	@echo "	MUSCLE_DIR		${MUSCLE_DIR}"
	@echo "	MUSCLE_PREFIX		${MUSCLE_PREFIX}"
	@mkdir -p ${MUSCLE_DIR}
	@ muscle -in ${MUSCLE_IN} -fastaout ${MUSCLE_PREFIX}.fa -phyiout ${MUSCLE_PREFIX}.phy

## Construction of the ACE2 phylogenetic tree from the multiple alignment with phyML
NUMBER_BOOTSTRAP=50

phyml_ACE2:
	@ phyml -i ${MUSCLE_PREFIX}.phy -d aa -b ${NUMBER_BOOTSTRAP}

## identification of the similarity of each ACE2 protein with the human ACE2 on residues critical for SARS-CoV-2 spike binding
MULTIPLE_ALIGNMENT=${MUSCLE_PREFIX}.fa
OUTPUT=${MUSCLE_DIR}/ACE2_comparison_with_${REFERENCE}.csv

_compare_ACE2:
	@echo "comparison of the important residues in "
	@echo "${MULTIPLE_ALIGNMENT}"
	@echo " with the sequence "
	@echo "${REFERENCE}"
	@echo ". Output file: "
	@echo "${OUTPUT}"
	python scripts/python/ACE2.py ${MULTIPLE_ALIGNMENT} ${REFERENCE} ${OUTPUT}

compare_ACE2_with_human:
	@${MAKE} _compare_ACE2 REFERENCE=HUMAN_Homo_sapiens
