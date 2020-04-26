## Makefile to run the different scripts for the analysis of
## SARS-CoV-2 sequences and their comparison with HIV sequences.

MAKEFILE=scripts/makefiles/02_genome-blast.mk
MAKE=make -f ${MAKEFILE}

################################################################
## List targets
targets:
	@echo "Targets:"
	@echo "	download_betacov_db	download BLAST-formated Betacoronavirus genomes"
	@echo "	download_virus_db	download BLAST-formated virus reference genomes"
	@echo "	blastdb			format a viral genome for BLAST searches"
	@echo "	genome_blast		search similarities between two viral genomes as query"
	@echo "	cov2_vs_hiv		search HIV genome with SARS-CoV-2 genome as query"
	@echo "	hiv_vs_cov2		search SARS-CoV-2 genome with HIV genome as query"
	@echo "	betacov_vs_hiv		search HIV virus for matches against all Betacoronavirus genomes"
	@echo "	hiv_vs_betacov		search Betacoronavirus genomes with HIV genome as query"

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
