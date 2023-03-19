import streamlit as st
from rdkit import Chem
from rdkit.Chem import AllChem
from rdkit import DataStructs
from rdkit.Chem.Fingerprints import FingerprintMols
from dimorphite_dl import DimorphiteDL
from rdkit.Chem.Fingerprints import FingerprintMols
from scopy.ScoPretreat import pretreat
import scopy.ScoDruglikeness
from padelpy import from_smiles
import sys, os
from mordred import Calculator, descriptors
from rdkit.Chem import Draw
import subprocess
import pandas as pd
from PIL import Image

try:
    os.remove("descriptors_padel_fda.csv")
    os.remove("descriptors_mordred_fda.csv")
except:
    pass

calc = Calculator(descriptors, ignore_3D=True)

dimorphite_dl = DimorphiteDL(
    min_ph = 6.4,
    max_ph = 6.6,
    max_variants = 1,
    label_states = False,
    pka_precision = 0.1
)

st.image('logo.png')

#st.title('POxload prediction model')

st.caption("*** WORK IN PROGRESS ***")

st.caption("""Input a [molecule SMILES code](https://pubchem.ncbi.nlm.nih.gov/edit3/index.html). Predictions for loading efficencies (in %) 
for different amphiphilic ABA-triblock poly(2-oxazoline)/poly(2-oxazine)-based micelles are listed, given drug and polymer feeds of 10 g/L 
(A blocks: A = pMeOx, A* = pEtOx). The prediction is based on a cubist regression model with an RMSE value of 15 % for a validation set.""")

with st.spinner('Computing loading efficiencies...'):
    
    try:
        SMI = st.text_input('Enter SMILES code of drug to load', 'CC1=C2[C@@]([C@]([C@H]([C@@H]3[C@]4([C@H](OC4)C[C@@H]([C@]3(C(=O)[C@@H]2OC(=O)C)C)O)OC(=O)C)OC(=O)c5ccccc5)(C[C@@H]1OC(=O)[C@H](O)[C@@H](NC(=O)c6ccccc6)c7ccccc7)O)(C)C')  
        # SMI = str(dimorphite_dl.protonate(SMI)[0])    
        mol = Chem.MolFromSmiles(SMI)
        sdm = pretreat.StandardizeMol()
        mol = sdm.disconnect_metals(mol)    
        SMI = str(Chem.MolToSmiles(mol))
        im = Draw.MolToImage(mol,fitImage=True)    
        
        descriptors = from_smiles(SMI)
        items = list(descriptors.items())
        items.insert(0, ('Name', str(SMI)))
        descriptors = dict(items)
        ax=calc(mol)
        items = list(ax.items())
        items.insert(0, ('Name', str(SMI)))
        ax = dict(items)
        
        with open("descriptors_padel_fda.csv","a") as f:
            for o in descriptors.keys():
                f.write(str(o)+",")
                f.write("\n")
        with open("descriptors_mordred_fda.csv","a") as f:
            for o in ax.keys():
                f.write(str(o)+",")
                f.write("\n")
        with open("descriptors_padel_fda.csv","a") as f:
            for o in descriptors.values():
                f.write(str(o)+",")
                f.write("\n")  
        with open("descriptors_mordred_fda.csv","a") as f:
           for o in ax.values():
                f.write(str(o)+",")
                f.write("\n")
        
            
       
        process1 = subprocess.Popen(["Rscript", "create_formulations.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        result1 = process1.communicate()
        #st.write(result1)
        
        process2 = subprocess.Popen(["Rscript", "predict.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        result2 = process2.communicate()
        #st.write(result2)         
        
        df = pd.read_csv(r'fx.csv')
        df = df.rename(columns={'axb': 'Polymer', 'fx': 'LE'})
        df = df.sort_values('LE',ascending=False)
        
        col1, col2 = st.columns(2)
        with col1:
            st.dataframe(df)
        with col2:
            st.image(im)
    
    except:
        pass
        
# reference

st.caption("[github page](https://github.com/juppifluppi/poxload)")
