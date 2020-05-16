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
	@echo "Download genomes from Genbank"
	@echo "	download_betacov_db		download BLAST-formated Betacoronavirus genomes"
	@echo "	download_virus_db		download BLAST-formated virus reference genomes"
	@echo
	@echo "Blast searches"
	@echo "	blastdb				format a viral genome for BLAST searches"
	@echo "	genome_blast			search similarities between two viral genomes as query"
	@echo "	cov2_vs_hiv			search HIV genome with SARS-CoV-2 genome as query"
	@echo "	hiv_vs_cov2			search SARS-CoV-2 genome with HIV genome as query"
	@echo "	betacov_vs_hiv			search HIV virus for matches against all Betacoronavirus genomes"
	@echo "	hiv_vs_betacov			search Betacoronavirus genomes with HIV genome as query"
	@echo
	@echo "Multipe alignment"
	@echo "	multalign_muscle		multiple alignment between reference genomes with muscle"
	@echo "	multialign_clustalw		multiple alignment between reference genomes with clustalw"
	@echo
	@echo "Phylogeny inference methods"
	@echo "	gblocks_clean			clearn the multiple alignments with gblocks"
	@echo "	nj_tree				generate a species tree from the aligned genomes with clustalw NJ"
	@echo "	run_phyml			generate species tree from aligned genomes with PhyML"
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


################################################################
## List parameters

# GENOME_DIR=data/genomes
#GENOME_PREFIX=coronavirus_${COLLECTION}_genomes
#GENOME_SEQ=${GENOME_DIR}/${GENOME_PREFIX}.fasta
#SGENE_DIR=data/S-gene
#SGENE_PREFIX=coronavirus_${COLLECTION}_S-genes

#FEATURE=genomes
FEATURE=S-gene
COLLECTION=around-CoV-2
GISAID_DIR=data/GISAID_genomes
INSEQ_DIR=data/${FEATURE}
INSEQ_PREFIX=${FEATURE}_${COLLECTION}
INSEQ_FILE=${INSEQ_DIR}/${INSEQ_PREFIX}.fasta
INSEQ_NB=`grep '^>' ${INSEQ_FILE} | wc -l | awk '{print $$1}'`
PHYLO_TASKS=multialign_clustalw gblocks_clean run_phyml
PHYLO_DIR=results/${FEATURE}_${COLLECTION}/

list_param:
	@echo
	@echo "Generic parameters"
	@echo "	FEATURE			${FEATURE}"
	@echo "	COLLECTION		${COLLECTION}"
	@echo
	@echo "Input sequences"
	@echo "	INSEQ_DIR		${INSEQ_DIR}"
	@echo "	GISAID_DIR		${GISAID_DIR}"
	@echo "	INSEQ_PREFIX		${INSEQ_PREFIX}"
	@echo "	INSEQ_FILE		${INSEQ_FILE}"
	@echo "	INSEQ_NB		${INSEQ_NB}"
	@echo
	@echo "Similarity searches with blastn"
	@echo "	DB_TAXON_NAME		${DB_TAXON_NAME}"
	@echo "	DB_TAXON_DIR		${DB_TAXON_DIR}"
	@echo "	DB_TAXON_DB		${DB_TAXON_DB}"
	@echo "	DB_TAXON_SEQ		${DB_TAXON_SEQ}"
	@echo
	@echo "Multiple alignments"
	@echo "	MUSCLE_DIR		${MUSCLE_DIR}"
	@echo "	MUSCLE_PREFIX		${MUSCLE_PREFIX}"
	@echo "	CLUSTALW_PREFIX		${CLUSTALW_PREFIX}"
	@echo "	MALIGN_SOFT		${MALIGN_SOFT}"
	@echo "	MALIGN_DIR		${MALIGN_DIR}"
	@echo "	MALIGN_PEFIX		${MALIGN_PREFIX}"
	@echo
	@echo "Alignemtn cleaning with gblocks"
	@echo "	GBLOCKS_PREFIX		${GBLOCKS_PREFIX}"
	@echo
	@echo "Molecular phylogeny"
	@echo "	PHYLO_DIR		${PHYLO_DIR}"
	@echo "	PHYLO_TASKS		${PHYLO_TASKS}"
	@echo
	@echo "PhyML parameters"
	@echo "	PHYML_THREAD  		${PHYML_THREADS}"
	@echo "	PHYML_OPT		${PHYML_OPT}"
	@echo "	PHYML_TREE		${PHYML_TREE}"
	@echo


################################################################
## Download blast-formatted database of Betacoronavirus genomes from NCBI
DB_TAXON_NAME=Betacoronavirus
DB_TAXON_DIR=${GENOME_DIR€/${DB_TAXON_NAME}
DB_TAXON_DB=${DB_TAXON_DIR}/${DB_TAXON_NAME}
DB_TAXON_SEQ=${DB_TAXON_DIR}/${DB_TAXON_NAME}.fasta
DOWNLOAD_NAME=Betacoronavirus
DOWNLOAD_DIR=${GENOME_DIR€/${DOWNLOAD_NAME}
DOWNLOAD_DB=${DOWNLOAD_DIR}/${DOWNLOAD_NAME}
DOWNLOAD_SEQ=${DOWNLOAD_DIR}/${DOWNLOAD_NAME}.fasta
download_db:
	@echo "Downloading ${DOWNLOAD_DB} genomes from NCBI"
	@mkdir -p ${DOWNLOAD_DIR}
	(cd ${DOWNLOAD_DIR}; update_blastdb.pl --decompress ${DOWNLOAD_NAME}; blastdbcmd -entry all -db ${DOWNLOAD_NAME} -out ${DOWNLOAD_NAME}.fasta)
	@echo "	DOWNLOAD_DIR	${DOWNLOAD_DIR}"
	@ls -lt ${DOWNLOAD_DIR}

## Download BLAST database of Betacoronavirus from NCBI
download_betacov_db:
	@${MAKE} download_db DOWNLOAD_NAME=Betacoronavirus

## Download BLAST database of reference virus from NCBI
download_virus_db:
	@${MAKE} download_db DOWNLOAD_NAME=ref_viruses_rep_genomes


################################################################
## Format a viral genome for blast searches
DB_ORG=SARS-CoV-2
DB_DIR=${GENOME_DIR}/${DB_ORG}/
DB_SEQ=${DB_DIR}/${DB_ORG}_genome_seq.fasta
blastdb:
	@echo "Formating genome	for virus	${DB_ORG}"
	@echo "	DB_ORG		${DB_ORG}"
	makeblastdb -in ${DB_SEQ}  -dbtype nucl
	@echo "	DB_DIR		${DB_DIR}"
	@echo "	DB_SEQ		${DB_SEQ}"

################################################################
## Search similarities between two viral genomes
QUERY_ORG=HIV
QUERY_DIR=${GENOME_DIR}/${QUERY_ORG}
QUERY_SEQ=${QUERY_DIR}/${QUERY_ORG}_genome_seq.fasta
BLAST_PREFIX=${QUERY_ORG}_vs_${DB_ORG}
BLAST_DIR=results/genome_blast/${BLAST_PREFIX}
BLAST_EXT=.txt
BLAST_RESULT=${BLAST_DIR}/${BLAST_PREFIX}_blastn${BLAST_EXT}
BLAST_TASK=blastn
OUTFMT=2
genome_blast:
	@echo "Searching similarities between genomes"
	@echo "	QUERY_ORG	${QUERY_ORG}"
	@echo "	DB_ORG		${DB_ORG}"
	@echo "	BLAST_DIR	${BLAST_DIR}"
	@mkdir -p ${BLAST_DIR}
	blastn -db ${DB_SEQ} -query ${QUERY_SEQ} -task ${BLAST_TASK} -outfmt ${OUTFMT} -out ${BLAST_RESULT}
	@echo "	BLAST_RESULT		${BLAST_RESULT}"

cov2_vs_hiv:
	@${MAKE} DB_ORG=HIV QUERY_ORG=SARS-CoV-2 blastdb genome_blast

hiv_vs_cov2:
	@${MAKE} DB_ORG=SARS-CoV-2 QUERY_ORG=HIV blastdb genome_blast

betacov_vs_hiv:
	@${MAKE} QUERY_ORG=Betacoronavirus QUERY_SEQ=${DB_TAXON_SEQ} DB_ORG=HIV genome_blast OUTFMT=6 BLAST_EXT=.tsv

hiv_vs_betacov:
	@${MAKE} DB_ORG=Betacoronavirus DB_SEQ=${DB_TAXON_DB} QUERY_ORG=HIV genome_blast OUTFMT=6 BLAST_EXT=.tsv



################################################################
## Align reference genomes with MUSCLE
MUSCLE_DIR=results/genome_phylogeny/muscle_alignments/
MUSCLE_PREFIX=${MUSCLE_DIR}/${GENOME_PREFIX}_aligned_muscle
MUSCLE_FORMAT=clw
MUSCLE_EXT=aln
MUSCLE_LOG=${MUSCLE_PREFIX}_${MUSCLE_FORMAT}_log.txt
MUSCLE_MAXHOURS=3
MUSCLE_OPT=-maxhours ${MUSCLE_MAXHOURS}
MUSCLE_LOG=${MUSCLE_PREFIX}_${MUSCLE_FORMAT}_log.txt
multalign_muscle: list_param
	@echo "Aligning reference genomes wih muscle"
	@echo "	GENOME_SEQ	${GENOME_SEQ}"
	@echo "	MUSCLE_DIR	${MUSCLE_DIR}"
	@mkdir -p ${MUSCLE_DIR}
	${TIME} muscle -in ${GENOME_SEQ} -${MUSCLE_FORMAT} ${MUSCLE_OPT} \
		-log ${MUSCLE_LOG} \
		-out ${MUSCLE_PREFIX}.${MUSCLE_EXT}
	@echo "	${MUSCLE_PREFIX}.${MUSCLE_EXT}"


################################################################
## Align reference genomes with clustalw
CLUSTALW_PREFIX=${PHYLO_DIR}/${INSEQ_PREFIX}_clustalw
CLUSTALW_FILE=${CLUSTALW_PREFIX}.aln
multialign_clustalw: 
	@echo "Aligning reference genomes wih clustalw"
#	@echo "	INSEQ_DIR	${INSEQ_DIR}"
#	@echo "	INSEQ_PREFIX	${INSEQ_PREFIX}"
	@echo "	INSEQ_FILE	${INSEQ_FILE}"
	@echo "	PHYLO_DIR	${PHYLO_DIR}"
	@echo "	CLUSTALW_PREFIX	${CLUSTALW_PREFIX}"
	@mkdir -p ${PHYLO_DIR}
	${TIME} clustalw -infile=${INSEQ_FILE} \
		-align -type=dna -quicktree \
		-outfile=${CLUSTALW_FILE}
	@echo "	${CLUSTALW_FILE}"
	@echo
	@echo "Converting alignment to fasta format"
	seqret -sequence ${CLUSTALW_FILE} -sformat aln -osformat fasta -outseq ${CLUSTALW_PREFIX}.fasta
	@echo "	${CLUSTALW_PREFIX}.fasta"
	@${MAKE} nj_tree

################################################################
## Clean the multiple alignments with gblocks
MALIGN_SOFT=clustalw
MALIGN_DIR=${PHYLO_DIR}
MALIGN_PREFIX=${CLUSTALW_PREFIX}
GBLOCKS_OPT=-t=d -b3=8 -b4=10 -g -q -boum
GBLOCKS_PREFIX=${MALIGN_PREFIX}.pir-gb
GBLOCKS_LOG=${GBLOCKS_PREFIX}_logs.txt
_gblocks_clean:
	gblocks ${MALIGN_PREFIX}.pir ${GBLOCKS_OPT} >& ${GBLOCKS_LOG}

gblocks_clean:
	@echo
	@echo "Converting alignment to PIR/PIR format"
	@echo "	CLUSTALW_PREFIX	${CLUSTALW_PREFIX}"
	seqret -sequence ${CLUSTALW_FILE} -sformat aln -osformat pir -outseq ${CLUSTALW_PREFIX}.pir
	@echo "	${CLUSTALW_PREFIX}.pir"
	@echo
	@echo "Cleaning ${MALIGN_SOFT} alignments with gblocks"
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
		-infile=${MALIGN_PREFIX}.aln -type=dna \
		-clustering=NJ
	${TIME} clustalw -bootstrap=100 \
		-infile=${MALIGN_PREFIX}.aln -type=dna \
		-clustering=NJ 
	@echo "	${MALIGN_PREFIX}.ph"
	@echo "	${MALIGN_PREFIX}.phb"

# ################################################################
# ## Convert sequences from clustalw format (aln extension) to phylip
# ## format (phy extension).
# aln2phy:
# 	@echo "Converting sequence from aln to phy"
# 	seqret -auto -stdout \
# 		-sequence ${MALIGN_PREFIX}.aln \
# 		-snucleotide1 \
# 		-sformat1 clustal \
# 		-osformat2 phylip \
# 		>  ${MALIGN_PREFIX}.phy
# 	@echo "	${MALIGN_PREFIX}.phy"

################################################################
## Infer a phylogenetic tree of coronaviruses from their aligned
## genomes, using maximum-likelihood approach (phyml tool).
PHYML_THREADS=5
PHYML_BOOTSTRAP=100
PHYML_OPT=--datatype nt --bootstrap ${PHYML_BOOTSTRAP} --model HKY85
PHYML_PREFIX=${MALIGN_PREFIX}_gblocks.phy_phyml_tree
PHYML_TREE=${MALIGN_PREFIX}_gblocks.phy_phyml_tree.phb
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
		>  ${MALIGN_PREFIX}_gblocks.phy
	@echo "	${MALIGN_PREFIX}_gblocks.phy"
	@echo
	@echo "Inferring phylogeny with phyml"
	${TIME} mpirun -n ${PHYML_THREADS} phyml-mpi --input ${MALIGN_PREFIX}_gblocks.phy ${PHYML_OPT}
	cp ${PHYML_PREFIX}.txt ${PHYML_TREE}
	@echo "	"
	@echo "	PHYLO_DIR		${PHYLO_DIR}"
	@echo "	PHYML_TREE		${PHYML_TREE}"
	@echo "Job done	`date`"

################################################################
## Phylogey inference for all the genomes downloaded from Genbank.
all_genomes:
	@${MAKE} ${PHYLO_TASKS} \
		INSEQ_DIR=${GENOME_DIR}/ \
		INSEQ_PREFIX=coronavirus_all_genomes \

################################################################
## Phylogeny inference for selected genomes from Genbank
selected_genomes:
	@${MAKE} ${PHYLO_TASKS}\
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
	@${MAKE} ${PHYLO_TASKS} \
		INSEQ_DIR=${GISAID_DIR} \
		COLLECTION=selected-plus-GISAID FEATURE=genomes

################################################################
## Close selection around CoV-2 from Genbank + GISAID
around-cov2-gisaid_genomes:
	@${MAKE} ${PHYLO_TASKS} \
		INSEQ_DIR=${GISAID_DIR}/ \
		COLLECTION=around-CoV-2-plus-GISAID FEATURE=genomes

################################################################
## S-gene phylogeny for selected genomes from Genbank
_Sgenes:
	@${MAKE} ${PHYLO_TASKS} FEATURE=S-gene
# \
# 		INSEQ_PREFIX=S-gene_${COLLECTION} \
# 		PHYLO_DIR=results/S-gene/clustalw_alignments \
# 		CLUSTALW_PREFIX=results/S-gene/clustalw_alignments/S-gene_${COLLECTION}

Sgenes_around-cov2:
	@${MAKE} _Sgenes COLLECTION=around-CoV-2

Sgenes_selected:
	@${MAKE} _Sgenes COLLECTION=selected 

# ${PHYLO_TASKS}\
# 	INSEQ_DIR=${SGENE_DIR} \
# 	INSEQ_PREFIX=S-gene_selected \
# 	PHYLO_DIR=results/S-gene/clustalw_alignments \
# 	CLUSTALW_PREFIX=results/S-gene/clustalw_alignments/S-gene_selected

################################################################
## S-gene phylogeny for selected genomes from Genbank + GISAID
Sgenes_selected_gisaid:
	@${MAKE} _Sgenes \
		INSEQ_DIR=${GISAID_DIR}	\
		COLLECTION=selected-plus-GISAID

# @${MAKE} ${PHYLO_TASKS}\
# 	INSEQ_DIR=${GISAID_DIR} \
# 	INSEQ_PREFIX=S-gene_selected-plus-GISAID \
# 	PHYLO_DIR=results/S-gene/clustalw_alignments \
# 	CLUSTALW_PREFIX=results/S-gene/clustalw_alignments/S-gene_selected-plus-GISAID

################################################################
## S-gene phylogeny for genomes from Genbank + GISAID around-cov-2
Sgenes_around-cov-2_gisaid:
	@${MAKE} _Sgenes \
		INSEQ_DIR=${GISAID_DIR}	\
		COLLECTION=around-CoV-2-plus-GISAID

#	@${MAKE} ${PHYLO_TASKS}\
#		INSEQ_DIR=${GISAID_DIR} \
#		INSEQ_PREFIX=S-gene_around-cov-2-plus-GISAID \
#		PHYLO_DIR=results/S-gene/clustalw_alignments \
#		CLUSTALW_PREFIX=results/S-gene/clustalw_alignments/S-gene_around-cov-2-plus-GISAID
