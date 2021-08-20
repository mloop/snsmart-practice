output/02_bjsm.rds: scripts/02_bjsm.R scripts/02_bjsm.stan data/01_generated_data.rds
	cd scripts/ && Rscript 02_bjsm.R

data/01_generated_data.rds: scripts/01_generate_trial_data.R
	mkdir data/ && cd scripts/ && Rscript 01_generate_trial_data.R