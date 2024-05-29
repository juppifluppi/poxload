# POxload

POxload is a web tool to evaluate the amount of drug solubilized by amphiphilic, triblock copolymeric poly(oxazoline)/poly(oxazine) (pOx/pOzi) micelles.
It is based on predictions for loading efficiency (LE) and loading capacity (LC) using four different thresholds for each parameter (LC 10/20/30/40%, LE 20/40/60/80%).
The formulations are assumed to be made via thin-film hydration using ethanol as solvent and an elevated temperature of 55 °C during re-hydration.

Details can be found in our [publication](https://pubs.acs.org/doi/10.1021/acs.molpharmaceut.4c00086) or the open-access [preprint](https://doi.org/10.26434/chemrxiv-2024-l5kvc) of it.

## Web application

The recommended way to use the program is the streamlit web app ```poxload_streamlit.py```, accessible at:

https://poxload.streamlit.app/

## Self-hosting application

Given all required python, R and debian packages are installed on any local machine or server (listed in ```requirements.txt``` and ```packages.txt```), users can also download the repository to host the app independently from the streamlit cloud, by running the executable ```app.sh``` file.

## Local command-line tool

The models can be installed as program in a new conda environment with all necessary packages, but currently with limited functionalities compared to the web application (no GUI, supports loading prediction for single drugs and batch mode only for the final models):

1. (go to your local ~/anaconda3/envs/ directory)
2. ```git clone https://github.com/juppifluppi/poxload.git```
3. ```cd poxload```
4. ```conda env create -f env.yml```
5. ```conda activate poxload```
6. ```pip install -e .```

In addition, R and the packages ```caret```, ```randomForest```, ```kernlab```, ```devtools``` and ```proxy``` need to be installed.

You can then use the alias poxload:
```
poxload "SMILESCODE" 
```

A batch mode is available to compute predictions for a list of compounds. Prepare a comma-separated CSV file with two comma-separated columns named "name" and "smiles"

```
poxload_batch CSVFILE 
```

The ```xgboost``` package is included in the repository and loaded via devtools, as it is necessary for usage of the web application in the streamlit cloud. Installing ```xgboost``` locally for the command-line tool and then loading the package normally can speed up computation. In order to do this, simply replace the lines ```devtools::load_all("xgboost"...``` in the ```predict2.R``` and ```predict4.R``` files in your anaconda environment directory with ```library("xgboost")``` after installation.

## Please cite

[Kehrein et al. "POxload: Machine Learning Estimates Drug Loadings of Polymeric Micelles." Mol. Pharmaceutics 2024](https://pubs.acs.org/doi/10.1021/acs.molpharmaceut.4c00086)
