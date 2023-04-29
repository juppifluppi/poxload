# POxload prediction tool
*** WORK IN PROGRESS ***

POxload predicts the loading efficiney (LE) and loading capacity (LC) of poly(2-oxazoline)-based micelles for small molecules. Random forest classification models assess different thresholds for both properties.

## Web application

Streamlit web app ```poxload_streamlit.py``` is accessible at:

https://poxload.streamlit.app/

## Local command-line tool

The model can be installed as program in a new conda environment with all the necessary packages in the following way:

1. (go to your local ~/anaconda3/envs/ directory)
2. ```git clone https://github.com/juppifluppi/poxload.git```
3. ```cd poxload```
4. ```conda env create -f env.yml```
5. ```conda activate poxload```
6. ```pip install -e .```

In addition, R and its packages caret and randomForest need to be installed.

You can then use the alias poxload:
```
poxload "SMILESCODE" 
```

A batch mode is available to compute predictions for a list of compounds. Prepare a CSV file with two columns named "name" and "smiles"

```
poxload_batch CSVFILE 
```
