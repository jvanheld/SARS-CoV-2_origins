################################################################
## Makefile to run the different scripts for the analysis of
## SARS-CoV-2 sequences and their comparison with HIV sequences.

targets:
	@echo "Targets:"
	@echo "	align_muscle		align spike protein sequences with muscle"
	@echo "	align_uniprot_seq	align spike proteins from Uniprot"


################################################################
## Multiple alignment of spike protein sequences
DATA_DIR=analyses/spike_protein/data_spike-proteins/
SPIKE_PREFIX=SARS-CoV-2_spike_prot_seq
SPIKE_SEQ=${DATA_DIR}/${SPIKE_PREFIX}
MUSCLE_DIR=analyses/spike_protein/muscle_alignments/
MUSCLE=${MUSCLE_DIR}/${SPIKE_PREFIX}_aligned_muscle
MUSCLE_FORMAT=msf
MUSCLE_LOG=${MUSCLE}_${MUSCLE_FORMAT}_log.txt
MUSCLE_OPT=-quiet
align_muscle:
	@echo "Spike proteins: multiple alignemnt with MUSCLE"
	@echo "	Result directory"
	@echo "	${MUSCLE_DIR}"
	@mkdir -p ${MUSCLE_DIR}
	@make _align_muscle_one_format MUSCLE_FORMAT=msf
	@make _align_muscle_one_format MUSCLE_FORMAT=html
	@make _align_muscle_one_format MUSCLE_FORMAT=clw

_align_muscle_one_format:
	muscle -in ${SPIKE_SEQ}.fasta -${MUSCLE_FORMAT} ${MUSCLE_OPT} -log ${MUSCLE_LOG} -out ${MUSCLE}.${MUSCLE_FORMAT}
	@echo "	${MUSCLE}.${MUSCLE_FORMAT}"

align_uniprot_seq:
	@echo "Aligning spike sequences from Uniprot"
	@make align_muscle SPIKE_PREFIX=uniprot_SARS_spike_taxid-694009_complete-seq_174_proteins


