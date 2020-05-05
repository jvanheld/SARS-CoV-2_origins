################################################################
## Analysis of the Receptor Binding Domain of spike Spike protein in
## different coronaviruses.
##
## Authors
## - Jacques van Helden
## - Erwan Sallard
##
## This includes the analysis of different regions of interest of the spike protein
##    336-525    RBD domain coordinates
##    437-510    RBD fraction putatively resulting from a Pangolin recombination (Xiao et al., 2020, DOI: 10.1101/2020.02.17.951335)

# include scripts/makefiles/03_protein-alignments.mk

targets:
	@echo "Targets"
	@echo "	extract_SARS2_RBD		extract the sequence of the RBD from SARS-CoV-2 skipe protein"
	@echo "	extract_pangolin_conserved	extract the domain of the spike sequence showing similarity to pangolin sequence"
	@echo "	blastdb				"
	@echo "	rbd_blast_selected		Search sequences similar to SARS2 RBD in selected spike proteins"

SPIKE_PROT=data/spike_proteins/SPIKE_SARS2_uniprot_seq.fasta
RBD_DATA_DIR=data/RBD
RBD_RES_DIR=results/RBD_analysis
RBD_SARS2_SEQ=${RBD_DATA_DIR}/${RBD_SARS2_PREFIX}.fasta
RBD_REGION=336-525
RBD_SARS2_PREFIX=SARS2_RBD
extract_SARS2_RBD:
	@echo "Extracting RBD sequence from SARS-CoV-2 spike protein"
	@echo "	RBD_DATA_DIR		${RBD_DATA_DIR}"
	@mkdir -p ${RBD_DATA_DIR}
	@echo "	RBD_RES_DIR		${RBD_RES_DIR}"
	@mkdir -p ${RBD_RES_DIR}
	extractseq -sequence ${SPIKE_PROT} -regions ${RBD_REGION} -outseq ${RBD_SARS2_SEQ}
	@echo "	RBD_SARS2_SEQ		${RBD_SARS2_SEQ}"

extract_pangolin_conserved:
	@${MAKE} extract_SARS2_RBD RBD_REGION=437-510 RBD_SARS2_PREFIX=SARS2_spike_pangolin-like-region

################################################################
## Format spike protein sequences as BLAST database
SELECTED_SEQ=data/spike_proteins/selected_coronavirus_spike_proteins.fasta
SELECTED_DB=data/spike_proteins/selected_coronavirus_spike_proteins_blastdb
blastdb:
	@echo "formating sequences for BLAST"
	blastdbcmd -entry all -db ${SELECTED_SEQ} -out ${SELECTED_DB}

################################################################
## Search sequences similar to SARS2 RBD in selected spike proteins
rbd_blast_selected:
	@echo "Searching sequences similar to SARS2 RBD in selected spike proteins"
