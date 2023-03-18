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


calc = Calculator(descriptors, ignore_3D=True)

dimorphite_dl = DimorphiteDL(
    min_ph = 6.4,
    max_ph = 6.6,
    max_variants = 1,
    label_states = False,
    pka_precision = 0.1
)

#try:
SMI = st.text_input('Enter SMILES code', 'CC(C)NCC(COC1=CC=C(C=C1)CCOC)O')  
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
ax.insert(0,("Name",str(SMI)))
#items = list(ax.items())
#items.insert(0, ('Name', str(SMI))) 
#ax = dict(items)       
st.write(ax)  
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
    
st.image(im)

#except:
#    st.write("Something is wrong with your SMILES code.")
#    st.stop()

process1 = subprocess.Popen(["Rscript", "create_formulations.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
result1 = process1.communicate()
st.write(result1)


process2 = subprocess.Popen(["Rscript", "predict.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
result2 = process2.communicate()
st.write(result2)         
