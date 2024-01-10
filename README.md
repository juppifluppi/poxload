# POxload

POxload is a tool to evaluate the amount of drug solubilized by amphiphilic, triblock copolymeric poly(oxazoline)/poly(oxazine) (pOx/pOzi) micelles.
It is based on predictions for loading efficiency (LE) and loading capacity (LC) using four differen thresholds for each parameter (LC10, LC20, LC30, LC40, LE20, LE40, LE60, LE80).
The formulations are assumed to be made via thin-film hydration using ethanol as solvent and an elevated temperature of 55 °C during re-hydration.

Details can be found in our [preprint](https://doi.org/10.26434/chemrxiv-2024-l5kvc).

## Web application

The streamlit web app ```poxload_streamlit.py``` is accessible at:

https://poxload.streamlit.app/

## Local command-line tool

The model can be installed as program in a new conda environment with all the necessary packages in the following way:

1. (go to your local ~/anaconda3/envs/ directory)
2. ```git clone https://github.com/juppifluppi/poxload.git```
3. ```cd poxload```
4. ```conda env create -f env.yml```
5. ```conda activate poxload```
6. ```pip install -e .```

In addition, R and the packages caret, randomForest, kernlab, devtools and proxy need to be installed.

You can then use the alias poxload:
```
poxload "SMILESCODE" 
```

A batch mode is available to compute predictions for a list of compounds. Prepare a comma-separated CSV file with two columns named "name" and "smiles"

```
poxload_batch CSVFILE 
```

## Please cite

[Kehrein et al. "POxload: Machine Learning Estimates Drug Loadings of Polymeric Micelles." ChemRxiv 2024](https://doi.org/10.26434/chemrxiv-2024-l5kvc)
