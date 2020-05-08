################################################################
## Makefile to run the different scripts for the analysis of
## SARS-CoV-2 sequences and their comparison with HIV sequences.

MAKEFILE=scripts/makefiles/03_protein-alignments.mk
MAKE=make -f ${MAKEFILE}

targets:
	@echo "Targets:"
	@echo
	@echo "	all				run all targets"
	@echo
	@echo "	uniprot_seq			automatically retrieve spike protein sequences from Uniprot"
	@echo "	uniprot_seq_sars		get spike sequences from Uniprot for SARS"
#	@echo "	uniprot_seq_sarbecovirus	get spike sequences from Uniprot for Sarbecovirus"
	@echo "	uniprot_seq_betacoronaviridae	get spike sequences from Uniprot for Betacoronaviridae"
	@echo "	uniprot_seq_coronaviridae	get spike sequences from Uniprot for Coronaviridae"
	@echo "	uniprot_seq_all			get spike sequences from Uniprot for all the groups defined above"
	@echo
	@echo "	nr				generate non-retundant sequences with cd-hit"
	@echo "	nr_selected			generate non-redundant sequences from selected spike proteins"
	@echo "	nr_sars				generate non-redundant sequences from Uniprot for SARS"
#	@echo "	nr_sarbecovirus			generate non-redundant sequences from Uniprot for Sarbecovirus"
	@echo "	nr_betacoronaviridae		generate non-redundant sequences from Uniprot for Betacoronaviridae"
	@echo "	nr_coronaviridae		generate non-redundant sequences from Uniprot for Coronaviridae"
	@echo "	nr_all				generate non-redundant sequences for all the groups avove"
	@echo
	@echo "	align_muscle			align spike protein sequences with muscle"
#	@echo "	align_uniprot			align spike proteins from Uniprot"
	@echo "	align_selected			align selection of representative sequences"
#	@echo "	align_genbank			align sequences from Genbank"
	@echo "	align_uniprot_sars		align spike sequences from Uniprot for SARS"
#	@echo "	align_uniprot_sarbecovirus	align spike sequences from Uniprot for Sarbecovirus"
	@echo "	align_uniprot_betacoronaviridae	align spike sequences from Uniprot for Betacoronaviridae"
	@echo "	align_uniprot_coronaviridae	align spike sequences from Uniprot for Coronaviridae"
	@echo "	align_muscle_all		align spike sequences from Uniprot for all the groups above"
	@echo
	@echo "	identify_insertions		locate the insertions in a chosen sequence"

################################################################
## Run all targets
all: uniprot_seq_all nr_all align_muscle_all identify_insertions

################################################################
## Retrieve sequences from Uniprot
#TAXID=11118
#TAXID=2509511
#TAXNAME=sarbecovirus
TAXID=694009
TAXNAME=SARS
UNIPROT_FORMAT=tab
UNIPROT_FIELDS=id,entry%20name,reviewed,length,protein%20names,genes,organism,length,virus%20hosts,sequence
UNIPROT_QUERY_TAB=taxonomy:${TAXID}+AND+name:spike+AND+fragment:no&format=${UNIPROT_FORMAT}&columns=${UNIPROT_FIELDS}
UNIPROT_QUERY_SEQ=taxonomy:${TAXID}+AND+name:spike+AND+fragment:no&format=fasta
UNIPROT_URL_TAB=https://www.uniprot.org/uniprot/?query=${UNIPROT_QUERY_TAB}
UNIPROT_URL_SEQ=https://www.uniprot.org/uniprot/?query=${UNIPROT_QUERY_SEQ}
SPIKE_SEQ_DIR=data/spike_proteins
SPIKE_PREFIX=${TAXNAME}_${TAXID}_spike-proteins_uniprot
SPIKE_SEQ=${DATA_DIR}/${SPIKE_PREFIX}
UNIPROT_PREFIX=${SPIKE_SEQ_DIR}/${SPIKE_PREFIX}
UNIPROT_TAB=${UNIPROT_PREFIX}.tsv
UNIPROT_SEQ=${UNIPROT_PREFIX}.fasta
UNIPROT_SEQ_NB=`grep '^>' ${UNIPROT_SEQ} | wc -l`
uniprot_seq:
	@echo "Retrieving spike protein sequences from Uniprot"
	@echo "	TAXNAME	${TAXNAME}"
	@echo "	TAXID	${TAXID}"
	@mkdir -p ${SPIKE_SEQ_DIR}
	@echo "	UNIPROT_PREFIX		${UNIPROT_PREFIX}"
	@echo "	UNIPROT_URL_TAB		${UNIPROT_URL_TAB}"
	@curl "${UNIPROT_URL_TAB}" > ${UNIPROT_TAB}
	@echo "	UNIPROT_TAB		${UNIPROT_TAB}"
	@echo "	UNIPROT_URL_SEQ		${UNIPROT_URL_SEQ}"
	@curl "${UNIPROT_URL_SEQ}" > ${UNIPROT_SEQ}
	@echo "	UNIPROT_SEQ		${UNIPROT_SEQ}"
	@echo "	UNIPROT_SEQ_NB		${UNIPROT_SEQ_NB}"

uniprot_seq_sars:
	@${MAKE} uniprot_seq TAXID=694009 TAXNAME=SARS

# uniprot_seq_sarbecovirus:
# 	@${MAKE} uniprot_seq TAXID=2509511 TAXNAME=sarbecovirus

uniprot_seq_betacoronaviridae:
	@${MAKE} uniprot_seq TAXID=694002 TAXNAME=betacoronavirus

uniprot_seq_coronaviridae:
	@${MAKE} uniprot_seq TAXID=11118 TAXNAME=coronaviridae

uniprot_seq_all: uniprot_seq_sars uniprot_seq_betacoronaviridae uniprot_seq_coronaviridae 

################################################################
## Generate non-redundant collections of protein sequences
NR_IDENTITY=1.00
NR_THREADS=4
NR_MEM=8000
NR_SUFFIX=NR_${NR_IDENTITY}
SPIKE_PREFIX_NR=${SPIKE_PREFIX}_${NR_SUFFIX}
SEQ_PREFIX=${UNIPROT_PREFIX}
SEQ=${SEQ_PREFIX}.fasta
NR_PREFIX=${SEQ_PREFIX}_${NR_SUFFIX}
NR_SEQ=${NR_PREFIX}.fasta
SEQ_NB=`grep '^>' ${SEQ} | wc -l`
NR_SEQ_NB=`grep '>' ${NR_SEQ} | wc -l`
nr:
	@echo "Generating non-redundant sequences"
	@echo "	SEQ		${SEQ}"
	@echo "	NR_IDENTITY	${NR_IDENTITY}"
	time cd-hit -i ${SEQ} \
		-d 0 -c ${NR_IDENTITY} -n 5 -G 1 -g 1 -b 20 -l 10 -s 0.0 -aL 0.0 -aS 0.0 -M ${NR_MEM} -T ${NR_THREADS} \
		-o ${NR_SEQ}
	@echo "	NR_SEQ		${NR_SEQ}"
	@echo "		before filtering	${SEQ_NB}"
	@echo "		after filtering		${NR_SEQ_NB}"

nr_selected:
	@${MAKE} nr SPIKE_PREFIX=selected_coronavirus_spike_proteins

nr_sars:
	@${MAKE} nr TAXID=694009 TAXNAME=SARS

# nr_sarbecovirus:
# 	@${MAKE} nr TAXID=2509511 TAXNAME=sarbecovirus

nr_betacoronaviridae:
	@${MAKE} nr TAXID=694002 TAXNAME=betacoronavirus

nr_coronaviridae:
	@${MAKE} nr TAXID=11118 TAXNAME=coronaviridae

#-c ${NR_IDENTITY} -n ${NR_WSIZE} -M ${NR_MEM} –d 1 -T ${NR_THREADS} \

nr_all: nr_selected nr_sars nr_betacoronaviridae nr_coronaviridae 

################################################################
## Multiple alignment of spike protein sequences
#DATA_DIR=analyses/spike_protein/data_spike-proteins/
DATA_DIR=data/spike_proteins
#MUSCLE_DIR=analyses/spike_protein/muscle_alignments/
MUSCLE_IN=${SPIKE_SEQ}
MUSCLE_DIR=results/spike_protein/muscle_alignments/
MUSCLE_PREFIX=${MUSCLE_DIR}/${SPIKE_PREFIX}_aligned_muscle
MUSCLE_FORMAT=msf
MUSCLE_EXT=${MUSCLE_FORMAT}
MUSCLE_LOG=${MUSCLE_PREFIX}_${MUSCLE_FORMAT}_log.txt
MUSCLE_MAXHOURS=1
MUSCLE_OPT=-quiet -maxhours ${MUSCLE_MAXHOURS}
align_muscle:
	@echo "Spike proteins: multiple alignemnt with MUSCLE"
	@echo "	Result directory"
	@echo "	DATA_DIR		${DATA_DIR}"
	@echo "	MUSCLE_DIR		${MUSCLE_DIR}"
	@echo "	MUSCLE_PREFIX		${MUSCLE_PREFIX}"
	@echo "	MUSCLE_LOG		${MUSCLE_LOG}"
	@mkdir -p ${MUSCLE_DIR}
	@${MAKE} _align_muscle_one_format MUSCLE_FORMAT= MUSCLE_EXT=fa
	@${MAKE} _align_muscle_one_format MUSCLE_FORMAT=-clw MUSCLE_EXT=aln
	@${MAKE} _align_muscle_one_format MUSCLE_FORMAT=-msf
	@${MAKE} _align_muscle_one_format MUSCLE_FORMAT=-html

_align_muscle_one_format:
	time muscle -in ${MUSCLE_IN}.fasta ${MUSCLE_FORMAT} ${MUSCLE_OPT} \
		-seqtype protein \
		-log ${MUSCLE_LOG} \
		-out ${MUSCLE_PREFIX}.${MUSCLE_EXT}
	@echo "	${MUSCLE_PREFIX}.${MUSCLE_EXT}"

################################################################
## Generate a species tree from the aligned genomes
tree_from_muscle:
	@echo "Generating tree from aligned spike proteins with Neighbour-Joining method"
	time clustalw -tree \
		-infile=${MUSCLE_PREFIX}.aln -type=dna \
		-clustering=NJ
	time clustalw -bootstrap=100 \
		-infile=${MUSCLE_PREFIX}.aln -type=dna \
		-clustering=NJ 
	@echo "	${CLUSTALW_PREFIX}.ph"

align_selected:
	@echo "Aligning selected spike sequences"
	@${MAKE} align_muscle SPIKE_PREFIX=selected_coronavirus_spike_proteins

align_uniprot_sars:
	@echo "Aligning all Uniprot SARS spike sequences"
	@${MAKE} align_muscle TAXID=694009 TAXNAME=SARS

align_uniprot_betacoronaviridae:
	@echo "Aligning all Uniprot Betacoronaviridae spike sequences"
	@${MAKE} align_muscle TAXID=694002 TAXNAME=betacoronavirus

align_uniprot_coronaviridae:
	@echo "Aligning all Uniprot Coronaviridae spike sequences"
	@${MAKE} align_muscle TAXID=11118 TAXNAME=coronaviridae

# align_genbank:
# 	@echo "Aligning selected sequences from Genbank"
# 	@${MAKE} align_muscle SPIKE_PREFIX=genbank_CoV_spike_sequences

align_muscle_all: align_selected align_uniprot_sars align_uniprot_betacoronaviridae align_uniprot_coronaviridae 

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

