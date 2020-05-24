################################################################
## Phylogenetic inference for peptidic sequences
################################################################

MAKEFILE=scripts/makefiles/03b_protein_phylogeny.mk
MAKE=make -s -f ${MAKEFILE}


targets:
	@echo "Targets"
	@echo "	gblocks_clean	clean gaps in multiple alignments with Gblocks"
	@echo "	nj_tree		infer phylogenic tree with clustalw neightbour-joining algorithm"
	@echo "	run_phyml	generate phylogenetic tree from aligned sequences with PhyML"
	@echo "	one_feature	run all tasks for one feature"
	@echo "	all_features	run all tasks for all features"

FEATURES= \
	insertion1_30-120	\
	insertion2_120-217	\
	insertion3_223-310	\
	insertion5_440-540 	\
	insertion4_630-760	

TASKS=gblocks_clean nj_tree run_phyml
list_param:
	@echo
	@echo "Parameters"
	@echo "	FEATURES	${FEATURES}"
	@echo "	FEATURE		${FEATURE}"
	@echo "	TASKS		${TASKS}"
	@echo
	@echo "Sequences"
	@echo "	SEQ_DIR		${SEQ_DIR}"
	@echo "	SEQ_FILE	${SEQ_FILE}"
	@echo
	@echo "Phylogeny"
	@echo "	PHYMLMODEL	${PHYML_MODEL}"
	@echo "	PHYML_TREE	${PHYML_TREE}"

## Clean the multiple alignments with gblocks
FEATURE=insertion1_30-120
SEQ_DIR=data/GISAID_genomes/${FEATURE}
COLLECTION=around-CoV-2-plus-GISAID
SEQ_PREFIX=spike_proteins_${COLLECTION}_aligned_muscle_sorted_${FEATURE}
SEQ_EXT=aln
SEQ_PATH=${SEQ_DIR}/${SEQ_PREFIX}
SEQ_FILE=${SEQ_PATH}.${SEQ_EXT}
GBLOCKS_EXT=.gb
#GBLOCKS_OPT=-t=d -b1=8 -b2=13 -b3=8 -b4=10 -b5=n -b6=y -e=${GBLOCKS_EXT}
GBLOCKS_OPT=-t=p -e=${GBLOCKS_EXT}
GBLOCKS_PREFIX=${SEQ_PATH}.pir${GBLOCKS_EXT}
GBLOCKS_LOG=${GBLOCKS_PREFIX}_logs.txt
_gblocks_clean:
	Gblocks ${SEQ_PATH}.pir ${GBLOCKS_OPT} >& ${GBLOCKS_LOG}

gblocks_clean:
	@echo
	@echo "Converting alignment to fasta format"
	@echo "	SEQ_PREFIX	${SEQ_PREFIX}"
	seqret -sequence ${SEQ_FILE} -sformat aln -osformat fasta -outseq ${SEQ_PATH}.fasta
	@echo "	${SEQ_PATH}.fasta"
	@echo
	@echo "Converting alignment to PIR/PIR format"
	@echo "	SEQ_PREFIX	${SEQ_PREFIX}"
	seqret -sequence ${SEQ_FILE} -sformat aln -osformat pir -outseq ${SEQ_PATH}.pir
	@echo "	${SEQ_PATH}.pir"
	@echo
	@echo "Cleaning alignments with gblocks"
	@echo ""
	@${MAKE} -i _gblocks_clean 2> /dev/null
	@echo "	GBLOCKS_PREFIX	${GBLOCKS_PREFIX}"
	@echo "	GBLOCKS_LOG	${GBLOCKS_LOG}"
	@echo

################################################################
## Generate a species tree from the aligned genomes
nj_tree:
	@echo
	@echo "Generating species tree from aligned genomes with Neighbour-Joining method"
	${TIME} clustalw -tree \
		-infile=${SEQ_PATH}.aln -type=protein \
		-clustering=NJ
	${TIME} clustalw -bootstrap=1000 \
		-infile=${SEQ_PATH}.aln -type=protein \
		-clustering=NJ 
	@echo "	SEQ_FILE	${SEQ_FILE}"
	@echo "	tree		${SEQ_PATH}.ph"
	@echo "	bootstrap	${SEQ_PATH}.phb"


################################################################
## Infer a phylogenetic tree of coronaviruses from their aligned
## genomes, using maximum-likelihood approach (phyml tool).
PHYML_THREADS=5
PHYML_BOOTSTRAP=100
PHYML_MODEL=LG
PHYML_ADDOPT=
PHYML_OPT=--datatype aa --bootstrap ${PHYML_BOOTSTRAP} --model ${PHYML_MODEL} ${PHYML_ADDOPT}
PHYML_INPUT=${SEQ_PATH}_gblocks_${PHYML_MODEL}.phy
PHYML_PREFIX=${PHYML_INPUT}_phyml_tree
PHYML_OUTPUT=${PHYML_PREFIX}.txt
PHYML_TREE=${PHYML_PREFIX}.phb
run_phyml:
	@echo "Shortening sequence names"
	@perl -pe 's|^>(.{12}).*|>$$1|' ${GBLOCKS_PREFIX} > ${GBLOCKS_PREFIX}_shortnames
	@echo "	${GBLOCKS_PREFIX}_shortnames"
	@echo
	@echo "Converting gblocks result to phylip format"
	seqret -auto -stdout \
		-sequence ${GBLOCKS_PREFIX}_shortnames \
		-sformat1 pir \
		-snucleotide1 \
		-osformat2 phylip \
		>  ${PHYML_INPUT}
	@echo "	${SEQ_PATH}_gblocks.phy"
	@echo
	@echo "Inferring phylogeny with phyml"
	${TIME} mpirun -n ${PHYML_THREADS} phyml-mpi --input ${PHYML_INPUT} ${PHYML_OPT}
	cp ${PHYML_OUTPUT} ${PHYML_TREE}
	@echo "	"
	@echo "	PHYLO_DIR		${PHYLO_DIR}"
	@echo "	PHYML_TREE		${PHYML_TREE}"
	@echo "Job done	`date`"

################################################################
## Run all tasks for one feature
one_feature:
	@echo
	@echo "Analysing feature 	${FEATURE}"
	@${MAKE} ${TASKS}

################################################################
## Run all tasks for all features
all_features:
	@echo
	@echo "Analysing all features"
	@echo "	COLLECTION	${COLLECTION}"
	@echo "	FEATURES	${FEATURES}"
	@for feature in ${FEATURES}; do \
		${MAKE} one_feature FEATURE=$${feature}; \
	done

