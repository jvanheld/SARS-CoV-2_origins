## Makefile to run the different scripts for the analysis of
## SARS-CoV-2 sequences and their comparison with HIV sequences.

MAKEFILE=scripts/makefiles/02_genome-blast.mk
MAKE=make -f ${MAKEFILE}

targets:
	@echo "Targets:"
	@echo "	blastdb			format a viral genome for BLAST searches"
	@echo "	genome_blast		search similarities between two viral genomes"
	@echo "	cov2_vs_hiv		search HIV genome with SARS-CoV-2 genome"
	@echo "	hiv_vs_cov2		search SARS-CoV-2 genome with HIV genome"


################################################################
## Format a viral genome for blast searches
GENOME_DIR=data/virus_genomes
DB_ORG=HIV
DB_DIR=${GENOME_DIR}/${DB_ORG}/
DB_SEQ=${DB_DIR}/${DB_ORG}_genome_seq.fasta
blastdb:
	@echo "Formating genome	for virus	${DB_ORG}"OB
	@echo "	DB_ORG		${DB_ORG}"
	makeblastdb -in ${DB_SEQ}  -dbtype nucl
	@echo "	DB_DIR		${DB_DIR}"
	@echo "	DB_SEQ		${DB_SEQ}"

################################################################
## Search similarities between two viral genomes
QUERY_ORG=SARS-CoV-2
QUERY_DIR=${GENOME_DIR}/${QUERY_ORG}
QUERY_SEQ=${QUERY_DIR}/${QUERY_ORG}_genome_seq.fasta
ALIGN_PREFIX=${QUERY_ORG}_vs_${DB_ORG}
ALIGN_DIR=results/genome_blast/${ALIGN_PREFIX}
ALIGN=${ALIGN_DIR}/${ALIGN_PREFIX}_alignment.txt
BLAST_TASK=blastn
genome_blast:
	@echo "Searching similarities between genomes"
	@echo "	QUERY_ORG	${QUERY_ORG}"
	@echo "	DB_ORG		${DB_ORG}"
	@echo "	ALIGN_DIR	${ALIGN_DIR}"
	@mkdir -p ${ALIGN_DIR}
	blastn -db ${DB_SEQ} -query ${QUERY_SEQ} -task ${BLAST_TASK} -out ${ALIGN}
	@echo "	ALIGN		${ALIGN}"

cov2_vs_hiv:
	@${MAKE} DB_ORG=HIV QUERY_ORG=SARS-CoV-2 blastdb genome_blast

hiv_vs_cov2:
	@${MAKE} DB_ORG=SARS-CoV-2 QUERY_ORG=HIV blastdb genome_blast
