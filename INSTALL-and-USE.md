# Installation and usage

This page provds the instructions to install the software environment used for the analysis of SARS-CoV-2 origins, and some basic instructions to run the analyses. 

## Collaborators

- Etienne Decroly
- Jacques van Helden (<https://orcid.org/0000-0002-8799-8584>)
- Erwan Sallard	(<erwan.sallard@ens.psl.eu>)
- José Halloy
- Didier Casane



## Installation

### Getting a clone of the github repository

```{bash}
git clone https://github.com/jvanheld/coronavirus_insertions.git
```

The code can then be updated as follows

```{bash}
cd coronavirus_insertions
git pull
```


### Installing the software environment

The whole software environment required to reproduce these analyses can be easily installed with `miniconda`, whcih needs to be installed beforehand.


```{bash}
## List the targets
make -f scripts/makefiles/01_software-environment.mk

## Install the environment
make -f scripts/makefiles/01_software-environment.mk install_env

```

The software environment can then be loaded with the command

```{bash}
conda activate covid-19
```

Additional tasks are described in the help message

```{bash}
make -f scripts/makefiles/01_software-environment.mk 
```


## Running the analyses

The analyses can be redone by combining 

1. A series of scripts in the `makefiles` folder. The makefiles are numbered to indicate their order (there are some dependencies between scripts). Running a makefile without specifying a target will list the available targets and their short description.


2. Some R markdown notebooks in the `reports` folder. The name of each Rmd file indicates its goal. 



### Starting the conda environment

Before each working session, you need to restart the `conda` environment. 

First, list the targets: 

```{bash}
make -f makefiles/01_software-environment.mk

Targets:
        links                   list relevant links for this analysis
        install_env             install the conda environment
        update_env              update the conda environment
        start_env               start the conda environment

```

**Beware**: the target `start_env` does not actually start the environment, but indicates the commands required to start it. 

```{bash}
## List the commands required to start the environment
make -f makefiles/01_software-environment.mk start_env

## Run these commands
source /Users/jvanheld/miniconda3/etc/profile.d/conda.sh
conda activate covid-19

```

### Finding matches between HIV and Betacoronavirus genomes

This scripts runs  `blastn` to find matches between the HIV genome and all the Betacoronaviruses available at NCBI. The goal is to evaluate hte claim made on some media that SARS-CoV-2 contains insertions from HIV genome. We showed that these matches are not statistically significant (all of them have an e-value higher than 1). 




### Phylogenetic inference

The commands to run the phylogenetic analysis of coronavirus genomic sequences can be listed as follows. 

```{bash}
make -f scripts/makefiles/02_genome-analysis.mk
```

The script includes parameters that can be modified to address specific querries or to tune the computing according to your local configurtion. 


```{bash}
make -f scripts/makefiles/02_genome-analysis.mk  list_param
```

In particular the variable `PHYML_THREADS` should be adapted to the number of CPUs of your computer. 


#### Inferring the tree of virus strains from full genome alignments

```{bash}

```


### Analysis of the spike protein sequences

The aim of this program is to retrieve from uniprot all the available sequences of spike proteins belonging to the specified taxa, to align them and to identify the insertions in one of these proteins (by default the spike of SARS-CoV-2).

The commands are specified in the make file `make -f scripts/makefiles/03_protein-alignments.mk`. 

The list of targets can be obtained with the following command.

```{bash}
make -f scripts/makefiles/03_protein-alignments.mk
```

You should first run one of the "uniprot_" functions, then "align_muscle" and finally "identify_insertion". For example:

```{bash}
make -f scripts/makefiles/03_protein-alignments.mk uniprot_sarbecovirus
make -f scripts/makefiles/03_protein-alignments.mk align_muscle
make -f scripts/makefiles/03_protein-alignments.mk identify_insertion
```

Results will be found in the "results/spike_protein" folder (namely the multiple alignment file in several formats, and a .csv file describing the position of the insertions in the reference protein).

#### Colorizing the inserts on the 3D structural model

The color_insertions.pml program enables to visualize the insertions in SARS-CoV-2 spike on a 3D structural model.

```{bash}
pymol scripts/pymol/color_insertions.pml
```

#### Comparing ACE2 proteins

ACE2 is the receptor of SARS-CoV-2. To determine which animals are susceptible to be infected by SARS-CoV-2 or similar viruses, we gathered the ACE2 sequences of numerous animals in the data/ACE2/ACE2.fa file. Our aim is to align them, construct a phylogenetic tree, and to determine the similarity of each protein with the human protein on the residues involved in spike binding.

To build the multiple alignment (saved in fasta and phylip format) between the ACE2 sequences:

```{bash}
make -f scripts/makefiles/05_ACE2_analysis.mk align_muscle_fasta_phylip
```

Once this is done, the corresponding tree can be built with:

```{bash}
make -f scripts/makefiles/05_ACE2_analysis.mk phyml_ACE2
```

and the comparison with the human protein can be performed with:

```{bash}
make -f scripts/makefiles/05_ACE2_analysis.mk compare_ACE2_with_human
```


## Running the scripts on the IFB core cluster


### Opening the connection 

```{bash}
## Define your login on the IFB-core cluster
IFB_LOGIN=[your_login]

## open a connection to the cluster
ssh ${IFB_LOGIN}@core.cluster.france-bioinformatique.fr

cd coronavirus_insertions

```

### Loading the environment


```{bash}
module load conda 
conda activate covid-19

```

### Running a single task via srun

**Never run the tasks on the login node!**


```{bash}
## Run genome alignments
srun --cpus=50  --mem=32GB   --partition=fast  \
  make -f scripts/makefiles/02_genome-analysis.mk  \
      PHYML_THREADS=50 TIME='' \
      Sgenes_around-cov2
```

