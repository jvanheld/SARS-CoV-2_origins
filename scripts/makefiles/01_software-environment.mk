################################################################
## Makefile to run the different scripts for the analysis of
## SARS-CoV-2 sequences and their comparison with HIV sequences.

targets:
	@echo "Targets:"
	@echo "	links			list relevant links for this analysis"
	@echo "	install_env		install the conda environment"
	@echo "	update_env		update the conda environment"
	@echo "	start_env		start the conda environment"

################################################################
## Relevant links
links:
	@echo "Links"
	@echo "	Shared folder (password-protected)"
	@echo "		https://drive.google.com/drive/folders/1-4n6cLKPISuZw9HM77R6Ma9ktFE1jnwI"
	@echo " Spike protein analysis on Drive"
	@echo "		https://drive.google.com/drive/folders/1obOSIGl5r-xTT0J7fGt54V2C5gnkeaXf"
	@echo "	Github repository"
	@echo "		https://github.com/jvanheld/coronavirus_insertions"
	@echo "	Git pages"
	@echo "		https://jvanheld.github.io/coronavirus_insertions/"

################################################################
## Conda environment

install_env:
	@echo "Installing conda environment"
	conda env create --file scripts/conda-environment.yml

update_env:
	@echo "Updating conda environment"
	conda env update --file scripts/conda-environment.yml

CONDA_BASE=`conda info --base`
start_env:
	@echo "To start the conda environment, please type the following commands"
	@echo "source ${CONDA_BASE}/etc/profile.d/conda.sh"
	@echo "conda activate covid-19"

################################################################
## There is an issue with the conda app on Mac OS X
## https://github.com/tensorflow/swift/issues/177
## https://github.com/tensorflow/swift/pull/352
## To circumvent it, we recommend to install it with homebrew.
pymol_for_mac:
	@echo "Installing PuMol on Mac OS X with brew"
	brew install brewsci/bio/pymol
	which pymol
