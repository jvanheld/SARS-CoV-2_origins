################################################################
## Makefile to run the different scripts for the analysis of
## SARS-CoV-2 sequences and their comparison with HIV sequences.

MAKEFILE=scripts/makefiles/03_protein-alignments.mk
MAKE=make -f ${MAKEFILE}

targets:
	@echo "Targets:"
	@echo "	uniprot_seq			automatically retrieve spike protein sequences from Uniprot"
	@echo "	uniprot_coronaviridae		run uniprot_seq with coronaviridae"
	@echo "	uniprot_betacoronaviridae	run uniprot_seq with betacoronaviridae"
	@echo "	uniprot_sarbecovirus		run uniprot_seq with Sarbecovirus"
	@echo "	uniprot_sars			run uniprot_seq with SARS"
	@echo "	align_muscle			align spike protein sequences with muscle"
	@echo "	align_uniprot_seq		align spike proteins from Uniprot"
	@echo "	align_uniprot_seq		align 22 selected sequences"
	@echo "	identify_insertions		locate the insertions in a chosen sequence"
	@echo "	align_selected_seq		align selection of representative sequences"
	@echo "	align_genbank_seq		align sequences from Genbank"

################################################################
## Retrieve sequences from Uniprot
#TAXID=11118
#TAXID=2509511
#TAXNAME=sarbecovirus
TAXID=694009
TAXNAME=SARS
UNIPROT_FORMAT=tab
UNIPROT_FIELDS=id,entry%20name,reviewed,length,protein%20names,genes,organism,length,virus%20hosts,sequence
UNIPROT_QUERY=taxonomy:${TAXID}+AND+name:spike+AND+fragment:no&format=${UNIPROT_FORMAT}&columns=${UNIPROT_FIELDS}
UNIPROT_URL=https://www.uniprot.org/uniprot/?query=${UNIPROT_QUERY}
SPIKE_SEQ_DIR=data/spike_proteins
uniprot_seq:
	@echo "Retrieving spike protein sequences from Uniprot"
	@echo "	TAXNAME	${TAXNAME}"
	@echo "	TAXID	${TAXID}"
	@mkdir -p ${SPIKE_SEQ_DIR}
	@echo "	UNIPROT_URL"
	@echo "	${UNIPROT_URL}"

uniprot_coronaviridae:
	@${MAKE} uniprot_seq TAXID=11118 TAXNAME=coronaviridae

uniprot_betacoronaviridae:
	@${MAKE} uniprot_seq TAXID=694002 TAXNAME=betacoronavirus

uniprot_sarbecovirus:
	@${MAKE} uniprot_seq TAXID=2509511 TAXNAME=sarbecovirus

uniprot_sars:
	@${MAKE} uniprot_seq TAXID=694009 TAXNAME=SARS


################################################################
## Multiple alignment of spike protein sequences
#DATA_DIR=analyses/spike_protein/data_spike-proteins/
DATA_DIR=data/spike_proteins
SPIKE_PREFIX=${TAXNAME}_${TAXID}_spike_prot
SPIKE_SEQ=${DATA_DIR}/${SPIKE_PREFIX}
#MUSCLE_DIR=analyses/spike_protein/muscle_alignments/
MUSCLE_DIR=results/spike_protein/muscle_alignments/
MUSCLE_PREFIX=${MUSCLE_DIR}/${SPIKE_PREFIX}_aligned_muscle
MUSCLE_FORMAT=msf
MUSCLE_LOG=${MUSCLE_PREFIX}_${MUSCLE_FORMAT}_log.txt
MUSCLE_OPT=-quiet
align_muscle:
	@echo "Spike proteins: multiple alignemnt with MUSCLE"
	@echo "	Result directory"
	@echo "	DATA_DIR		${DATA_DIR}"
	@echo "	SPIKE_PREFIX		${SPIKE_PREFIX}"
	@echo "	MUSCLE_DIR		${MUSCLE_DIR}"
	@echo "	MUSCLE_PREFIX		${MUSCLE_PREFIX}"
	@echo "	MUSCLE_LOG		${MUSCLE_LOG}"
	@mkdir -p ${MUSCLE_DIR}
	@${MAKE} _align_muscle_one_format MUSCLE_FORMAT=msf
	@${MAKE} _align_muscle_one_format MUSCLE_FORMAT=html
	@${MAKE} _align_muscle_one_format MUSCLE_FORMAT=clw

_align_muscle_one_format:
	muscle -in ${SPIKE_SEQ}.fasta -${MUSCLE_FORMAT} ${MUSCLE_OPT} -log ${MUSCLE_LOG} -out ${MUSCLE_PREFIX}.${MUSCLE_FORMAT}
	@echo "	${MUSCLE_PREFIX}.${MUSCLE_FORMAT}"

align_uniprot_seq:
	@echo "Aligning spike sequences from Uniprot"
	@${MAKE} align_muscle SPIKE_PREFIX=uniprot_SARS_spike_taxid-694009_complete-seq_174_proteins

align_selected_seq:
	@echo "Aligning selected sequences"
	@${MAKE} align_muscle SPIKE_PREFIX=selected_coronavirus_spike_proteins

align_genbank_seq:
	@echo "Aligning selected sequences from Genbank"
	@${MAKE} align_muscle SPIKE_PREFIX=genbank_CoV_spike_sequences

################################################################
## Identification of insertions
CLW_FILE=${MUSCLE_PREFIX}.clw
REFERENCE='sp|P0DTC2|SPIKE_SARS2'
OUTPUT_DIR=results/spike_protein/insertion_data/
CSV_NAME=${OUTPUT_DIR}${SPIKE_PREFIX}.csv

identify_insertions:
	@echo "Identification of the insertions in the sequence: "
	@echo "${REFERENCE}"
	@echo "	Result directory: "
	@echo "${OUTPUT_DIR}"
	@mkdir -p ${OUTPUT_DIR}
	python scripts/python/detection_insertion.py ${CLW_FILE} ${REFERENCE} ${CSV_NAME}
