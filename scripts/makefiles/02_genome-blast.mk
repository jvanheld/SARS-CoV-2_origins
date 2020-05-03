## Makefile to run the different scripts for the analysis of
## SARS-CoV-2 sequences and their comparison with HIV sequences.

MAKEFILE=scripts/makefiles/02_genome-blast.mk
MAKE=make -f ${MAKEFILE}

################################################################
## List targets
targets:
	@echo "Targets:"
	@echo "	download_betacov_db		download BLAST-formated Betacoronavirus genomes"
	@echo "	download_virus_db		download BLAST-formated virus reference genomes"
	@echo "	blastdb				format a viral genome for BLAST searches"
	@echo "	genome_blast			search similarities between two viral genomes as query"
	@echo "	cov2_vs_hiv			search HIV genome with SARS-CoV-2 genome as query"
	@echo "	hiv_vs_cov2			search SARS-CoV-2 genome with HIV genome as query"
	@echo "	betacov_vs_hiv			search HIV virus for matches against all Betacoronavirus genomes"
	@echo "	hiv_vs_betacov			search Betacoronavirus genomes with HIV genome as query"
	@echo "	align_ref_genomes_muscle	multiple alignment between reference genomes with muscle"
	@echo "	align_ref_genomes_clustalw	multiple alignment between reference genomes with clustalw"
	@echo "	genome_tree			generate a species tree from the aligned genomes with clustalw NJ"


################################################################
## Download blast-formatted database of Betacoronavirus genomes from NCBI
BETACOV_NAME=Betacoronavirus
BETACOV_DIR=data/virus_genomes/${BETACOV_NAME}
BETACOV_DB=${BETACOV_DIR}/${BETACOV_NAME}
BETACOV_SEQ=${BETACOV_DIR}/${BETACOV_NAME}.fasta
DOWNLOAD_NAME=Betacoronavirus
DOWNLOAD_DIR=data/virus_genomes/${DOWNLOAD_NAME}
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
GENOME_DIR=data/virus_genomes
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
	@${MAKE} QUERY_ORG=Betacoronavirus QUERY_SEQ=${BETACOV_SEQ} DB_ORG=HIV genome_blast OUTFMT=6 BLAST_EXT=.tsv

hiv_vs_betacov:
	@${MAKE} DB_ORG=Betacoronavirus DB_SEQ=${BETACOV_DB} QUERY_ORG=HIV genome_blast OUTFMT=6 BLAST_EXT=.tsv


################################################################
## Align reference genomes
DATA_DIR=data/spike_proteins
REF_GENOMES_DIR=data/virus_genomes/
REF_GENOMES_PREFIX=coronavirus_54_genomes
REF_GENOMES_SEQ=${REF_GENOMES_DIR}/${REF_GENOMES_PREFIX}.fasta
MUSCLE_DIR=results/ref_genomes/muscle_alignments/
MUSCLE_PREFIX=${MUSCLE_DIR}/${REF_GENOMES_PREFIX}_aligned_muscle
MUSCLE_FORMAT=clw
MUSCLE_EXT=aln
MUSCLE_LOG=${MUSCLE_PREFIX}_${MUSCLE_FORMAT}_log.txt
MUSCLE_MAXHOURS=1
MUSCLE_OPT=-maxhours ${MUSCLE_MAXHOURS}
MUSCLE_LOG=${MUSCLE_PREFIX}_${MUSCLE_FORMAT}_log.txt
align_ref_genomes_muscle:
	@echo "Aligning reference genomes wih muscle"
	@echo "	REF_GENOMES_SEQ	${REF_GENOMES_SEQ}"
	@echo "	MUSCLE_DIR	${MUSCLE_DIR}"
	@mkdir -p ${MUSCLE_DIR}
	time muscle -in ${REF_GENOMES_SEQ} -${MUSCLE_FORMAT} ${MUSCLE_OPT} \
		-log ${MUSCLE_LOG} \
		-out ${MUSCLE_PREFIX}.${MUSCLE_EXT}
	@echo "	${MUSCLE_PREFIX}.${MUSCLE_EXT}"


################################################################
## Align reference genomes with clustalw
CLUSTALW_DIR=results/ref_genomes/clustalw_alignments/
CLUSTALW_PREFIX=${CLUSTALW_DIR}/${REF_GENOMES_PREFIX}_clustalw
align_ref_genomes_clustalw:
	@echo "Aligning reference genomes wih clustalw"
	@echo "	REF_GENOMES_SEQ	${REF_GENOMES_SEQ}"
	@echo "	CLUSTALW_DIR	${CLUSTALW_DIR}"
	@mkdir -p ${CLUSTALW_DIR}
	time clustalw -infile=${REF_GENOMES_SEQ} \
		-align -type=dna -quicktree \
		-outfile=${CLUSTALW_PREFIX}.aln
	@echo "	${CLUSTALW_PREFIX}.aln"
	@${MAKE} genome_tree

################################################################
## Generate a species tree from the aligned genomes
genome_tree:
	@echo "Generating species tree frm aligned genomes with Neighbour-Joining method"
	time clustalw -tree \
		-infile=${CLUSTALW_PREFIX}.aln -type=dna \
		-clustering=NJ
	time clustalw -bootstrap=100 \
		-infile=${CLUSTALW_PREFIX}.aln -type=dna \
		-clustering=NJ 
	@echo "	${CLUSTALW_PREFIX}.ph"


################################################################
## Convert sequences from clustalw format (aln extension) to phylip
## format (phy extension).
aln2phy:
	@echo "Converting sequence from aln to phy"
	seqret -auto -stdout \
		-sequence ${CLUSTALW_PREFIX}.aln \
		-sprotein1 \
		-sformat1 clustal \
		-osformat2 phylip \
		>  ${CLUSTALW_PREFIX}.phy
	@echo "	${CLUSTALW_PREFIX}.phy"

################################################################
## Infer a phylogenetic tree of coronaviruses from their aligned
## genomes, using maximum-likelihood approach (phyml tool).
run_phyml:
	@echo "Inferring phylogeny with phyml"
	phyml -i ${CLUSTALW_PREFIX}.phy  -d aa 

