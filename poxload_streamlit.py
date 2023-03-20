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
for different amphiphilic ABA-triblock poly(2-oxazoline)/poly(2-oxazine)-based micelles are listed, given a polymer feed of 10 g/L and drug feeds of
10, 8, 6, 4 or 2 g/L (A blocks: A = pMeOx, A* = pEtOx). The prediction is based on a cubist regression model with an RMSE value of 15 % for a validation set.""")

SMI = st.text_input('Enter SMILES code of drug to load', '')  

with st.spinner('Computing loading efficiencies, please wait...'):
    
    try:
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
        df = df.rename(columns={0: "Polymer", 1: "LE10", 2: "LE8", 3: "LE6", 4: "LE4", 5: "LE2"})
        df = df.sort_values('LE10',ascending=False)
        
        # CSS to inject contained in a string
        hide_table_row_index = """
            <style>
            thead tr th:first-child {display:none}
            tbody th {display:none}
            </style>
            """
        
        # Inject CSS with Markdown
        st.markdown(hide_table_row_index, unsafe_allow_html=True)
        
        col1, col2 = st.columns(2)
        with col1:
            #st.dataframe(df)
            st.table(df)
        with col2:
            st.image(im)
    
    except:
        st.write("Please enter a valid SMILES code in order to proceed.")
        
# reference

st.caption("[github page](https://github.com/juppifluppi/poxload)")
