################################################################
## Makefile to run the different scripts for the analysis of
## SARS-CoV-2 sequences and their comparison with HIV sequences.

MAKEFILE=scripts/makefiles/02_protein-alignments.mk
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

################################################################
## Retrieve sequences from Uniprot
#TAXID=11118
#TAXID=2509511
#TAXNAME=sarbecovirus
TAXID=694009
TAXNAME=SARS
UNIPROT_FORMAT=tab
UNIPROT_FIELDS=id,reviewed,length,protein%20names,sequence
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
	@make -f scripts/makefiles/03_protein-alignments.mk uniprot_seq TAXID=11118 TAXNAME=coronaviridae

uniprot_betacoronaviridae:
	@make -f scripts/makefiles/03_protein-alignments.mk uniprot_seq TAXID=694002 TAXNAME=betacoronavirus

uniprot_sarbecovirus:
	@make -f scripts/makefiles/03_protein-alignments.mk uniprot_seq TAXID=2509511 TAXNAME=sarbecovirus

uniprot_sars:
	@make -f scripts/makefiles/03_protein-alignments.mk uniprot_seq TAXID=694009 TAXNAME=SARS


################################################################
## Multiple alignment of spike protein sequences
#DATA_DIR=analyses/spike_protein/data_spike-proteins/
DATA_DIR=data/spike_proteins
SPIKE_PREFIX=${TAXNAME}_${TAXID}_prot.fasta
#SPIKE_PREFIX=SARS-CoV-2_spike_prot
SPIKE_SEQ=${DATA_DIR}/${SPIKE_PREFIX}
#MUSCLE_DIR=analyses/spike_protein/muscle_alignments/
MUSCLE_DIR=results/spike_protein/muscle_alignments/
MUSCLE=${MUSCLE_DIR}/${SPIKE_PREFIX}_aligned_muscle
MUSCLE_FORMAT=msf
MUSCLE_LOG=${MUSCLE}_${MUSCLE_FORMAT}_log.txt
MUSCLE_OPT=-quiet
align_muscle:
	@echo "Spike proteins: multiple alignemnt with MUSCLE"
	@echo "	Result directory"
	@echo "	${MUSCLE_DIR}"
	@mkdir -p ${MUSCLE_DIR}
	@${MAKE} _align_muscle_one_format MUSCLE_FORMAT=msf
	@make -f scripts/makefiles/02_protein-alignments.mk  _align_muscle_one_format MUSCLE_FORMAT=html
	@make -f scripts/makefiles/02_protein-alignments.mk _align_muscle_one_format MUSCLE_FORMAT=clw

_align_muscle_one_format:
	muscle -in ${SPIKE_SEQ}.fasta -${MUSCLE_FORMAT} ${MUSCLE_OPT} -log ${MUSCLE_LOG} -out ${MUSCLE}.${MUSCLE_FORMAT}
	@echo "	${MUSCLE}.${MUSCLE_FORMAT}"

align_uniprot_seq:
	@echo "Aligning spike sequences from Uniprot"
	@make align_muscle SPIKE_PREFIX=uniprot_SARS_spike_taxid-694009_complete-seq_174_proteins


