## Makefile to run the different scripts for the analysis of
## SARS-CoV-2 sequences and their comparison with HIV sequences.

MAKEFILE=scripts/makefiles/02_genome-analysis.mk
MAKE=make -s -f ${MAKEFILE}
TIME=time

################################################################
## List targets
targets:
	@echo "Targets:"
	@echo "	list_param			list parameters"
	@echo
	@echo "Multipe alignment"
	@echo "	multalign_muscle		multiple alignment between reference genomes with muscle"
	@echo "	multialign_clustalw		multiple alignment between reference genomes with clustalw"
	@echo
	@echo "Phylogeny inference methods"
	@echo "	gblocks_clean			clear the multiple alignments (suppress gap-containing columns) with gblocks"
	@echo "	nj_tree				generate a species tree from the aligned genomes with clustalw NJ"
	@echo "	run_phyml			generate phylogenetic tree from aligned sequences with PhyML"
	@echo
	@echo "Genome phylogeny"
	@echo "	all_genomes			Phylogeny inference for all genomes from Genbank"
	@echo "	selected_genomes		Phylogeny inference for selected genomes from Genbank"
	@echo "	merge_gisaid			merge genome sequences from Genbank and GISAID"
	@echo "	selected-gisaid_genomes		Phylogeny inference for selected genomes from Genbank + GISAID"
	@echo "	around-cov2-gisaid_genomes	Close selection around CoV-2 from Genbank + GISAID"
	@echo
	@echo "S-gene phylogeny"
	@echo "	Sgenes_around-cov2		S-gene phylogeny inference for strains from Genbank around SARS-CoV-2"
	@echo "	Sgenes_selected			S-gene phylogeny inference for selected strains from Genbank"
	@echo "	Sgenes_around-cov-2_gisaid	S-gene phylogeny inference for strains from Genbank + GISAID around SARS-CoV-2"
	@echo "	Sgenes_selected_gisaid		S-gene phylogeny inference for selected strains from Genbank + GISAID"
	@echo
	@echo "Genomic features"
	@echo "	one_feature			phylogeny of a given genomic feature in a given collection"
	@echo "	phylo_from_traligned_dna	infer a feature phylogeny from its translation-based multiple alignment of DNA"
	@echo "	all_features_one_collection	phylogeny of all genomic features in a given collection"
	@echo "	all_features_all_collections	phylogeny of all genomic features in all collections"


################################################################
## List parameters

## Genomic features
CDS_FEATURES= \
	S1 		\
	S2 		\
	RBD 		\
	S-gene 		\
	CDS-S		\
	CDS-E		\
	CDS-M 		\
	CDS-N		\
	CDS-ORF10	\
	CDS-ORF1ab	\
	CDS-ORF3a	\
	CDS-ORF6	\
	CDS-ORF7a	\
	CDS-ORF8

OTHER_FEATURES= 	\
	Ins1-pm120	\
	Ins2-pm120	\
	Ins3-pm120	\
	Ins4-pm120	\
	Ins4-m240	\
	Recomb-reg-1 	\
	Recomb-reg-2 	\
	Recomb-reg-3
FEATURES=${CDS_FEATURES} ${OTHER_FEATURES}
FEATURE=S1

## Collections of genomes
COLLECTIONS=around-CoV-2-plus-GISAID selected-plus-GISAID around-CoV-2 selected
COLLECTION=around-CoV-2-plus-GISAID


## Directories and input sequence file
GISAID_DIR=data/GISAID_genomes
INSEQ_DIR=data/${FEATURE}
INSEQ_PREFIX=${FEATURE}_${COLLECTION}
INSEQ_FILE=${INSEQ_DIR}/${INSEQ_PREFIX}.fasta
INSEQ_NB=`grep '^>' ${INSEQ_FILE} | wc -l | awk '{print $$1}'`

## Parameters for the phylogenetic analysis
ALL_TASKS=multialign_clustalw ${PHYLO_TASKS}
PHYLO_TASKS=gblocks_clean run_phyml
PHYLO_DIR=results/${FEATURE}_${COLLECTION}/

list_param:
	@echo
	@echo "Generic parameters"
	@echo "	COLLECTIONS		${COLLECTIONS}"
	@echo "	COLLECTION		${COLLECTION}"
	@echo "	CDS_FEATURES		${CDS_FEATURES}"
	@echo "	OTHER_FEATURES		${OTHER_FEATURES}"
	@echo "	FEATURES		${FEATURES}"
	@echo "	FEATURE			${FEATURE}"
	@echo "	FEATURE_TASKS		${FEATURE_TASKS}"
	@echo
	@echo "Input sequences"
	@echo "	INSEQ_DIR		${INSEQ_DIR}"
	@echo "	GISAID_DIR		${GISAID_DIR}"
	@echo "	INSEQ_PREFIX		${INSEQ_PREFIX}"
	@echo "	INSEQ_FILE		${INSEQ_FILE}"
	@echo "	INSEQ_NB		${INSEQ_NB}"
	@echo
	@echo "Multiple alignments"
	@echo
	@echo "	MUSCLE_DIR		${MUSCLE_DIR}"
	@echo "	MUSCLE_SUFFIX		${MUSCLE_SUFFIX}"
	@echo "	MUSCLE_BASENAME		${MUSCLE_BASENAME}"
	@echo "	MUSCLE_PATH		${MUSCLE_PATH}"
	@echo "	MUSCLE_FILE		${MUSCLE_FILE}"
	@echo
	@echo "	CLUSTALW_DIR		${CLUSTALW_DIR}"
	@echo "	CLUSTALW_SUFFIX		${CLUSTALW_SUFFIX}"
	@echo "	CLUSTALW_BASENAME	${CLUSTALW_BASENAME}"
	@echo "	CLUSTALW_PATH		${CLUSTALW_PATH}"
	@echo "	CLUSTALW_FILE		${CLUSTALW_FILE}"
	@echo
	@echo "	MALIGN_SOFT		${MALIGN_SOFT}"
	@echo "	MALIGN_DIR		${MALIGN_DIR}"
	@echo "	MALIGN_SUFFIX		${MALIGN_SUFFIX}"
	@echo "	MALIGN_BASENAME		${MALIGN_BASENAME}"
	@echo "	MALIGN_PATH		${MALIGN_PATH}"
	@echo "	MALIGN_FORMAT		${MALIGN_FORMAT}"
	@echo "	MALIGN_EXT		${MALIGN_EXT}"
	@echo "	MALIGN_FILE		${MALIGN_FILE}"
	@echo
	@echo "Alignement cleaning with gblocks"
	@echo "	GBLOCKS_DIR		${GBLOCKS_DIR}"
	@echo "	GBLOCKS_PATH		${GBLOCKS_PATH}"
	@echo
	@echo "Molecular phylogeny"
	@echo "	PHYLO_DIR		${PHYLO_DIR}"
	@echo "	PHYLO_TASKS		${PHYLO_TASKS}"
	@echo "	ALL_TASKS		${ALL_TASKS}"
	@echo
	@echo "PhyML parameters"
	@echo "	PHYML_INPATH  		${PHYML_INPATH}"
	@echo "	PHYML_OUTPATH  		${PHYML_OUTPATH}"
	@echo "	PHYML_MODEL		${PHYML_MODEL}"
	@echo "	PHYML_ADDOPT		${PHYML_ADDOPT}"
	@echo "	PHYML_OPT		${PHYML_OPT}"
	@echo "	PHYML_TREE		${PHYML_TREE}"
	@echo


################################################################
## Align reference genomes with MUSCLE
MUSCLE_DIR=results/${FEATURE}_${COLLECTION}/muscle_alignments/
MUSCLE_SUFFIX=_aligned_muscle
MUSCLE_BASENAME=${INSEQ_PREFIX}${MUSCLE_SUFFIX}
MUSCLE_PATH=${MUSCLE_DIR}/${MUSCLE_BASENAME}
MUSCLE_FORMAT=clw
MUSCLE_EXT=aln
MUSCLE_LOG=${MUSCLE_PATH}_${MUSCLE_FORMAT}_log.txt
MUSCLE_MAXHOURS=3
MUSCLE_OPT=-maxhours ${MUSCLE_MAXHOURS}
MUSCLE_LOG=${MUSCLE_PATH}_${MUSCLE_FORMAT}_log.txt
MUSCLE_FILE=${MUSCLE_PATH}.${MUSCLE_EXT}
multalign_muscle: list_param
	@echo "Aligning reference genomes wih muscle"
	@echo "	GENOME_SEQ	${GENOME_SEQ}"
	@echo "	MUSCLE_DIR	${MUSCLE_DIR}"
	@mkdir -p ${MUSCLE_DIR}
	${TIME} muscle -in ${GENOME_SEQ} -${MUSCLE_FORMAT} ${MUSCLE_OPT} \
		-log ${MUSCLE_LOG} \
		-out ${MUSCLE_PATH}.${MUSCLE_EXT}
	@echo "	${MUSCLE_PATH}.${MUSCLE_EXT}"


################################################################
## Align reference genomes with clustalw
CLUSTALW_DIR=results/${FEATURE}_${COLLECTION}
CLUSTALW_SUFFIX=_clustalw
CLUSTALW_BASENAME=${INSEQ_PREFIX}${CLUSTALW_SUFFIX}
CLUSTALW_PATH=${CLUSTALW_DIR}/${CLUSTALW_BASENAME}
CLUSTALW_FILE=${CLUSTALW_PATH}.aln
multialign_clustalw: 
	@echo "Aligning reference genomes wih clustalw"
#	@echo "	INSEQ_DIR	${INSEQ_DIR}"
#	@echo "	INSEQ_PREFIX	${INSEQ_PREFIX}"
	@echo "	INSEQ_FILE	${INSEQ_FILE}"
	@echo "	PHYLO_DIR	${PHYLO_DIR}"
	@echo "	CLUSTALW_PATH	${CLUSTALW_PATH}"
	@mkdir -p ${PHYLO_DIR}
	${TIME} clustalw -infile=${INSEQ_FILE} \
		-align -type=dna -quicktree \
		-outfile=${CLUSTALW_FILE}
	@echo "	${CLUSTALW_FILE}"
	@echo
	@echo "Converting alignment to fasta format"
	seqret -sequence ${CLUSTALW_FILE} -sformat aln -osformat fasta -outseq ${CLUSTALW_PATH}.fasta
	@echo "	${CLUSTALW_PATH}.fasta"
	@${MAKE} nj_tree

################################################################
## Clean the multiple alignments with gblocks
MALIGN_SOFT=clustalw
MALIGN_DIR=${CLUSTALW_DIR}
MALIGN_SUFFIX=${CLUSTALW_SUFFIX}
MALIGN_BASENAME=${INSEQ_PREFIX}${MALIGN_SUFFIX}
MALIGN_PATH=${MALIGN_DIR}/${MALIGN_BASENAME}
MALIGN_FORMAT=aln
MALIGN_EXT=.${MALIGN_FORMAT}
MALIGN_FILE=${MALIGN_PATH}${MALIGN_EXT}
GBLOCKS_EXT=.gb
GBLOCKS_OPT=-t=d -b3=8 -b4=10 -g -e=${GBLOCKS_EXT}
GBLOCKS_PATH=${MALIGN_PATH}.pir${GBLOCKS_EXT}
GBLOCKS_LOG=${GBLOCKS_PATH}_logs.txt
_gblocks_clean:
	Gblocks ${MALIGN_PATH}.pir ${GBLOCKS_OPT} >& ${GBLOCKS_LOG}

gblocks_clean:
	@echo
	@echo "Converting alignment to PIR/PIR format"
	@echo "	MALIGN_PATH	${MALIGN_PATH}"
	seqret -sequence ${MALIGN_FILE} -sformat ${MALIGN_FORMAT} -osformat pir -outseq ${MALIGN_PATH}.pir
	@echo "	${MALIGN_PATH}.pir"
	@echo
	@echo "Cleaning ${MALIGN_SOFT} alignments with gblocks"
	@echo ""
	@${MAKE} -i _gblocks_clean 2> /dev/null
	@echo "	GBLOCKS_PATH	${GBLOCKS_PATH}"
	@echo "	GBLOCKS_LOG	${GBLOCKS_LOG}"
	@echo

################################################################
## Convert input sequence to clustalw format (.aln)
to_aln:
	@echo
	@echo "Converting alignment from ${MALIGN_FORMAT} to aln format"
	seqret -sequence ${MALIGN_FILE} -sformat ${MALIGN_FORMAT} -osformat aln -outseq ${MALIGN_PATH}.aln
	@echo "	${MALIGN_PATH}.aln"


################################################################
## Generate a species tree from the aligned genomes
nj_tree:
	@echo
	@echo "Generating species tree from aligned genomes with Neighbour-Joining method"
	${TIME} clustalw -tree \
		-infile=${MALIGN_PATH}.aln -type=dna \
		-clustering=NJ
	${TIME} clustalw -bootstrap=1000 \
		-infile=${MALIGN_PATH}.aln -type=dna \
		-clustering=NJ 
	@echo "	${MALIGN_PATH}.ph"
	@echo "	${MALIGN_PATH}.phb"

# ################################################################
# ## Convert sequences from clustalw format (aln extension) to phylip
# ## format (phy extension).
# aln2phy:
# 	@echo "Converting sequence from aln to phy"
# 	seqret -auto -stdout \
# 		-sequence ${MALIGN_PATH}.aln \
# 		-snucleotide1 \
# 		-sformat1 clustal \
# 		-osformat2 phylip \
# 		>  ${MALIGN_PATH}.phy
# 	@echo "	${MALIGN_PATH}.phy"

################################################################
## Infer a phylogenetic tree of coronaviruses from their aligned
## genomes, using maximum-likelihood approach (phyml tool).
PHYML_THREADS=5
PHYML_BOOTSTRAP=100
PHYML_MODEL=GTR
PHYML_ADDOPT=
PHYML_OPT=--datatype nt --bootstrap ${PHYML_BOOTSTRAP} --model ${PHYML_MODEL} ${PHYML_ADDOPT}
PHYML_INPATH=${MALIGN_PATH}_gblocks_${PHYML_MODEL}
PHYML_OUTPATH=${PHYML_INPATH}.phy_phyml_tree
PHYML_TREE=${PHYML_OUTPATH}.phb
run_phyml:
	@echo "Shortening sequence names"
	@perl -pe 's|^>(.{12}).*|>$$1|' ${GBLOCKS_PATH} > ${GBLOCKS_PATH}_shortnames
	@echo "	${GBLOCKS_PATH}_shortnames"
	@echo
	@echo "Converting gblocks result to phylip format"
	seqret -auto -stdout \
		-sequence ${GBLOCKS_PATH}_shortnames \
		-sformat1 pir \
		-snucleotide1 \
		-osformat2 phylip \
		>  ${PHYML_INPATH}.phy
	@echo "	${MALIGN_PATH}_gblocks.phy"
	@echo
	@echo "Inferring phylogeny with phyml"
	${TIME} mpirun -n ${PHYML_THREADS} phyml-mpi --input ${PHYML_INPATH}.phy ${PHYML_OPT}
	cp ${PHYML_OUTPATH}.txt ${PHYML_TREE}
	@echo "	"
	@echo "	PHYLO_DIR		${PHYLO_DIR}"
	@echo "	PHYML_TREE		${PHYML_TREE}"
	@echo "Job done	`date`"

################################################################
## Phylogey inference for all the genomes downloaded from Genbank.
all_genomes:
	@${MAKE} ${ALL_TASKS} \
		INSEQ_DIR=${GENOME_DIR}/ \
		INSEQ_PREFIX=coronavirus_all_genomes \

################################################################
## Phylogeny inference for selected genomes from Genbank
selected_genomes:
	@${MAKE} ${ALL_TASKS}\
		INSEQ_DIR=${GENOME_DIR} \
		INSEQ_PREFIX=coronavirus_${COLLECTION}_genomes


################################################################
## Phylogeny inference for selected genomes from Genbank + a few
## genomes imported from GISAID (login required to download them,
## cannot be redistributed in the github).
_merge_gisaid:
	@echo
	@echo "Merging Genbank and GISAID sequences"
	@echo "	COLLECTION	${COLLECTION}"
	@echo "	FEATURE		${FEATURE}"
	@cat ${INSEQ_FILE} \
		${GISAID_DIR}/coronavirus-genomes_from_GISAID_DO_NOT_REDISTRIBUTE.fasta \
		> ${GISAID_DIR}/${FEATURE}_${COLLECTION}-plus-GISAID.fasta
	@echo "	${GISAID_DIR}/${FEATURE}_${COLLECTION}-plus-GISAID.fasta"
	@echo "	`grep '^>' ${GISAID_DIR}/${FEATURE}_${COLLECTION}-plus-GISAID.fasta | wc -l` sequences"

merge_gisaid:
	@for collection in around-CoV-2 selected all; do \
		${MAKE} _merge_gisaid COLLECTION=$${collection} FEATURE=genomes; \
		${MAKE} _merge_gisaid COLLECTION=$${collection} FEATURE=S-gene; \
	done

################################################################
## Selected from Genbank + GISAID
selected-gisaid_genomes:
	@${MAKE} ${ALLTASKS} \
		INSEQ_DIR=${GISAID_DIR} \
		COLLECTION=selected-plus-GISAID FEATURE=genomes

################################################################
## Close selection around CoV-2 from Genbank + GISAID
around-cov2-gisaid_genomes:
	@${MAKE} ${ALL_TASKS} \
		INSEQ_DIR=${GISAID_DIR}/ \
		COLLECTION=around-CoV-2-plus-GISAID FEATURE=genomes

################################################################
## S-gene phylogeny for selected genomes from Genbank
_Sgenes:
	@${MAKE} ${ALL_TASKS} FEATURE=S-gene
# \
# 		INSEQ_PREFIX=S-gene_${COLLECTION} \
# 		PHYLO_DIR=results/S-gene/clustalw_alignments \
# 		CLUSTALW_PATH=results/S-gene/clustalw_alignments/S-gene_${COLLECTION}

Sgenes_around-cov2:
	@${MAKE} _Sgenes COLLECTION=around-CoV-2

Sgenes_selected:
	@${MAKE} _Sgenes COLLECTION=selected 

# ${ALL_TASKS}\
# 	INSEQ_DIR=${SGENE_DIR} \
# 	INSEQ_PREFIX=S-gene_selected \
# 	PHYLO_DIR=results/S-gene/clustalw_alignments \
# 	CLUSTALW_PATH=results/S-gene/clustalw_alignments/S-gene_selected

################################################################
## S-gene phylogeny for selected genomes from Genbank + GISAID
Sgenes_selected_gisaid:
	@${MAKE} _Sgenes \
		INSEQ_DIR=${GISAID_DIR}	\
		COLLECTION=selected-plus-GISAID

# @${MAKE} ${ALL_TASKS}\
# 	INSEQ_DIR=${GISAID_DIR} \
# 	INSEQ_PREFIX=S-gene_selected-plus-GISAID \
# 	PHYLO_DIR=results/S-gene/clustalw_alignments \
# 	CLUSTALW_PATH=results/S-gene/clustalw_alignments/S-gene_selected-plus-GISAID

################################################################
## S-gene phylogeny for genomes from Genbank + GISAID around-cov-2
Sgenes_around-cov-2_gisaid:
	@${MAKE} _Sgenes \
		INSEQ_DIR=${GISAID_DIR}	\
		COLLECTION=around-CoV-2-plus-GISAID

#	@${MAKE} ${ALL_TASKS}\
#		INSEQ_DIR=${GISAID_DIR} \
#		INSEQ_PREFIX=S-gene_around-cov-2-plus-GISAID \
#		PHYLO_DIR=results/S-gene/clustalw_alignments \
#		CLUSTALW_PATH=results/S-gene/clustalw_alignments/S-gene_around-cov-2-plus-GISAID

################################################################
## Run phylogenic analysis on genomic regions obtained by one-to-N
## alignment with selected h-CoV-2 features
one_feature:
	@echo
	@echo "Running phylogenetic analysis for feature ${FEATURE} in collection ${COLLECTION}"
#	@echo "	FEATURE		 ${FEATURE}"
#	@echo "	COLLECTION	 ${COLLECTION}"
	@${MAKE} ${ALL_TASKS}


FEATURE_TASKS=one_feature
all_features_one_collection:
	@echo
	@echo "Running phylogenetic analysis for all genomic features"
	@echo "	FEATURES	${FEATURES}"
	@echo "	COLLECTION	${COLLECTION}"
	@for feature in ${FEATURES} ; do \
		${MAKE} FEATURE=$${feature} ${FEATURE_TASKS} ; \
	done

all_features_all_collections:
	@echo
	@echo "Running phylogenetic analysis for all genomic features"
	@echo "	COLLECTIONS	${COLLECTIONS}"
	@echo "	FEATURES	${FEATURES}"
	@for collection in ${COLLECTIONS} ; do \
		${MAKE} COLLECTION=$${collection} all_features_one_collection; \
	done;


## Infer a feature phylogeny from its translation-based multiple alignment of DNA
phylo_from_traligned_dna:
	@echo
	@echo "Inferring feature phylogeny from translation-based multiple alignment of DNA"	
	${MAKE} MALIGN_SOFT=R MALIGN_FORMAT=fasta MALIGN_EXT=.fasta MALIGN_SUFFIX=_tralignedDNA ${PHYLO_TASKS}

cds_features_one_collection:
	${MAKE} FEATURE_TASKS=phylo_from_traligned_dna FEATURES='${CDS_FEATURES}' all_features_one_collection

