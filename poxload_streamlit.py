from rdkit import Chem
from rdkit.Chem import Draw
from rdkit.Chem import ChemicalFeatures
from rdkit.Chem import Crippen
from jazzy.api import molecular_vector_from_smiles
from jazzy.api import atomic_map_from_smiles
from jazzy.api import atomic_tuples_from_smiles
from jazzy.api import deltag_from_smiles
from jazzy.api import atomic_strength_vis_from_smiles
from jazzy.core import rdkit_molecule_from_smiles, kallisto_molecule_from_rdkit_molecule
from jazzy.core import get_covalent_atom_idxs, get_charges_from_kallisto_molecule, calculate_polar_strength_map
import numpy as np
from rdkit import Chem
from rdkit.Chem import AllChem
from rdkit import DataStructs
from rdkit.Chem.Fingerprints import FingerprintMols
from scopy.ScoPretreat import pretreat
import scopy.ScoDruglikeness
from padelpy import from_smiles
import sys, os
from io import StringIO
from rdkit import RDConfig
from jazzy.core import rdkit_molecule_from_smiles
from rdkit import Chem
from rdkit.Chem import AllChem
from rdkit import DataStructs
from rdkit.Chem.Fingerprints import FingerprintMols
from scopy.ScoPretreat import pretreat
import scopy.ScoDruglikeness
from padelpy import from_smiles
import sys, os
import pandas as pd
import time 

import streamlit as st
import time
import subprocess
from PIL import Image

st.image('logo.png')

st.caption("*** WORK IN PROGRESS ***")

st.caption("""Input a [molecule SMILES code](https://pubchem.ncbi.nlm.nih.gov/edit3/index.html). Predictions for loading efficencies (LE) and
loading capacities (LC) for different ABA-triblock poly(2-oxazoline)- and poly(2-oxazine)-based micelles are listed, given a polymer feed of 10 g/L.
Random forest classifications for different thresholds are listed (LE ≥ 20, 40, 60, 70 and 80%; LC ≥ 10, 20, 30, 35 and 40%).
Mixtures that exceed these thresholds are labeled "X1" and colored green.""")

col1, col2 = st.columns(2)
with col1:
   option = st.selectbox('Descriptor subset model to use:',
                         ('PaDEL (30 - 60s)', 'PaDEL+SiRMS (slower: around 10 min)'))
with col2:
   set_DF = st.selectbox('Drug feed (g/L):',
                         ('6', '4', '2', '8', '10', '12'))   

with st.form(key='my_form_to_submit'):
    SMI = st.text_input('Enter SMILES code of drug to load', '') 
    submit_button = st.form_submit_button(label='Submit')

if submit_button:

    try:
        
        if option == "PaDEL+SiRMS (slower: around 10 min)":
            with st.spinner('CALCULATING PADEL DESCRIPTORS FOR COMPOUND (STEP 1 OF 6)...'):
                NAME = "testcompound"
                
                mol = Chem.MolFromSmiles(SMI)
                sdm = pretreat.StandardizeMol()
                mol = sdm.disconnect_metals(mol)
                SMI = str(Chem.MolToSmiles(mol))
                im = Draw.MolToImage(mol,fitImage=True) 
                  
                descriptors = from_smiles(SMI)
                items = list(descriptors.items())
                descriptors = dict(items)
                items.insert(0, ('Name', NAME))
                
                with open("descriptors_padeltest.csv","w") as f:
                    for o in descriptors.keys():
                        f.write(str(o)+",")
                    f.write("\n")
                
                with open("descriptors_padeltest.csv","a") as f:
                    for o in descriptors.values():
                        f.write(str(o)+",")
                
                mols=[]
                sum_MW=[]
                sum_SMILES=[]
                sum_NAME=[]
                
                sum_SMILES.append(SMI)
                sum_NAME.append(NAME)
                
            with st.spinner('CALCULATING ATOMIC PROPERTIES FOR SiRMS (STEP 2 OF 6)...'):
                        
                mol = rdkit_molecule_from_smiles(SMI, minimisation_method="MMFF94")
                kallisto_mol = kallisto_molecule_from_rdkit_molecule(mol)
                atoms_and_nbrs = get_covalent_atom_idxs(mol)
                kallisto_charges = get_charges_from_kallisto_molecule(kallisto_mol, charge=0)  
                a = calculate_polar_strength_map(mol, kallisto_mol, atoms_and_nbrs, kallisto_charges)
                
                contribs = Crippen.rdMolDescriptors._CalcCrippenContribs( mol )    
                logps, mrs = zip( *contribs )
                    
                comp = 0
                for atom in mol.GetAtoms():
                    comp += 1
                
                for ji in ["eeq","alp","num_lp","sdc","sdx","sa"]:
                    for nmx in range(0,comp):
                        mol.GetAtomWithIdx(nmx).SetProp(ji,str(str(a[nmx][ji])+";"))
                        Chem.CreateAtomStringPropertyList(mol,ji,lineSize=99999)
                    for nmx in range(0,comp):
                        mol.GetAtomWithIdx(nmx).SetProp("at",str(str(a[nmx]["z"])+">"+str(a[nmx]["hyb"])+";"))
                        Chem.CreateAtomStringPropertyList(mol,"at",lineSize=99999)    
                    if str(a[nmx]["hyb"]) == "unspecified":
                        mol.GetAtomWithIdx(nmx).SetProp("at",str(str(a[nmx]["z"])+">s;"))
                        Chem.CreateAtomStringPropertyList(mol,"at",lineSize=99999)    
                            
                            
                for nmx in range(0,comp):            
                    mol.GetAtomWithIdx(nmx).SetProp("logp",str(str(logps[nmx])+";"))
                    Chem.CreateAtomStringPropertyList(mol,"logp",lineSize=99999)    
                for nmx in range(0,comp):            
                    mol.GetAtomWithIdx(nmx).SetProp("mr",str(str(mrs[nmx])+";"))
                    Chem.CreateAtomStringPropertyList(mol,"mr",lineSize=99999)
                        
                mol.SetProp('_Name',NAME)
                            
                mols.append(mol)
                
                mj = Chem.Descriptors.ExactMolWt(mol)
                sum_MW.append(mj)
                    
                with Chem.SDWriter('librarytest.sdf') as w:
                    for m in mols:
                        w.write(m)
                
                os.system("sed -i -e 's/atom.prop.//g' librarytest.sdf")
                os.system("sed -i -e 's/; /;/g' librarytest.sdf")
                os.system("cat librarytest.sdf library_pol.sdf > db_library_merged.sdf")
                
                dfx = pd.DataFrame(columns=['NAME', "SMILES","MW"])
                dfx["NAME"]=sum_NAME
                dfx["SMILES"]=sum_SMILES
                dfx["MW"]=sum_MW
                
                dfx.to_csv("db_molstest.csv",index=False)
                
            with st.spinner('CREATING FORMULATIONS (STEP 3 OF 6)...'):
                
                process1 = subprocess.Popen(["Rscript", "cxdb.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
                result1 = process1.communicate()
                                
                os.system("sed -i -e 's/\"//g' formulations3test_db.csv")
                
                try:
                    os.remove("mixture_test.txt")
                except:
                    pass
                
                with open("formulations3test_db.csv","r") as f:
                    lines=f.readlines()
                    for o in lines[1:]:
                        o=o.split("\t")
                        with open("mixture_test.txt", "a") as file:
                            file.write(str(o[-6])+"\t"+str(o[-5]))
                            if str(o[-4]) != "None":
                                file.write("\t"+str(o[-4]))
                            file.write("\t"+str(o[-3])+"\t"+str(o[-2]))
                            if float(o[-1]) > 0:
                                file.write("\t"+str(o[-1]))
                            else:
                                file.write("\n")
                
                tune_DF=str("sed -i -e 's/10\\t6\t/10\\t"+set_DF+"\\t/g' formulations3test_db.csv")
                os.system(tune_DF)
                
            with st.spinner('CALCULATING SiRMS DESCRIPTORS (STEP 4 OF 6)...'):
                
                os.system("sirms -i db_library_merged.sdf -a mr logp eeq alp sa sdx sdc at -o sirms_test.txt -m mixture_test.txt --max_mix_components 3 --mix_type rel -c 1 -r > /dev/null 2>&1")
                
                os.system("sed -i -e 's/\t/,/g' sirms_test.txt")
                
            with st.spinner('CALCULATING PADEL DESCRIPTORS FOR MIXTURES (STEP 5 OF 6)...'):
                process2 = subprocess.Popen(["Rscript", "gtg.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
                result2 = process2.communicate()

            with st.spinner('CALCULATING PREDICTIONS (STEP 6 OF 6)...'):
                process3 = subprocess.Popen(["Rscript", "fgv.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
                result3 = process3.communicate()
                
                def cooling_highlight(val):
                    color = 'red' if val == "X0" else 'green'
                    return f'background-color: {color}'
                
                df = pd.read_csv(r'fin_results.csv',index_col=0)
                df = df.rename(columns={0: "Polymer", 1: "LC10", 2: "LC20", 3: "LC30", 4: "LC35", 5: "LC40", 6: "LE20", 7: "LE40", 8: "LE60", 9: "LE70", 10: "LE80"})
                df1 = df[["LC10","LC20","LC30","LC35","LC40"]]
                df2 = df[["LE20","LE40","LE60","LE70","LE80"]]
                
                col1, col2 = st.columns(2)
                with col1:
                    st.dataframe(df2.style.applymap(cooling_highlight))
                with col2:
                    st.dataframe(df1.style.applymap(cooling_highlight))
                st.image(im)            
                
            # reference
            
            st.caption("[github page](https://github.com/juppifluppi/poxload)")
    
        if option == "PaDEL (30 - 60s)":     
            with st.spinner('CALCULATING PADEL DESCRIPTORS FOR COMPOUND (STEP 1 OF 4)...'):
                NAME = "testcompound"
                
                mol = Chem.MolFromSmiles(SMI)
                sdm = pretreat.StandardizeMol()
                mol = sdm.disconnect_metals(mol)
                SMI = str(Chem.MolToSmiles(mol))
                im = Draw.MolToImage(mol,fitImage=True) 
                  
                descriptors = from_smiles(SMI)
                items = list(descriptors.items())
                descriptors = dict(items)
                items.insert(0, ('Name', NAME))
                
                with open("descriptors_padeltest.csv","w") as f:
                    for o in descriptors.keys():
                        f.write(str(o)+",")
                    f.write("\n")
                
                with open("descriptors_padeltest.csv","a") as f:
                    for o in descriptors.values():
                        f.write(str(o)+",")
                
                mols=[]
                sum_MW=[]
                sum_SMILES=[]
                sum_NAME=[]
                
                sum_SMILES.append(SMI)
                sum_NAME.append(NAME)
                
                mj = Chem.Descriptors.ExactMolWt(mol)
                sum_MW.append(mj)
    
                dfx = pd.DataFrame(columns=['NAME', "SMILES","MW"])
                dfx["NAME"]=sum_NAME
                dfx["SMILES"]=sum_SMILES
                dfx["MW"]=sum_MW
                
                dfx.to_csv("db_molstest.csv",index=False)
                
            with st.spinner('CREATING FORMULATIONS (STEP 2 OF 4)...'):
                
                process1 = subprocess.Popen(["Rscript", "cxdb.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
                result1 = process1.communicate()
                               
                os.system("sed -i -e 's/\"//g' formulations3test_db.csv")
                
                tune_DF=str("sed -i -e 's/10\\t6\\t/10\\t"+set_DF+"\\t/g' formulations3test_db.csv")
                os.system(tune_DF)
                
            with st.spinner('CALCULATING PADEL DESCRIPTORS FOR MIXTURES (STEP 3 OF 4)...'):
                process2 = subprocess.Popen(["Rscript", "gtg.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
                result2 = process2.communicate()
            with st.spinner('CALCULATING PREDICTIONS (STEP 4 OF 4)...'):
                process3 = subprocess.Popen(["Rscript", "fgv3.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
                result3 = process3.communicate()
                
                def cooling_highlight(val):
                    color = 'red' if val == "X0" else 'green'
                    return f'background-color: {color}'
                
                df = pd.read_csv(r'fin_results.csv',index_col=0)
                df = df.rename(columns={0: "Polymer", 1: "LC10", 2: "LC20", 3: "LC30", 4: "LC35", 5: "LC40", 6: "LE20", 7: "LE40", 8: "LE60", 9: "LE70", 10: "LE80"})
                df1 = df[["LC10","LC20","LC30","LC35","LC40"]]
                df2 = df[["LE20","LE40","LE60","LE70","LE80"]]
                
                col1, col2 = st.columns(2)
                with col1:
                    st.dataframe(df2.style.applymap(cooling_highlight))
                with col2:
                    st.dataframe(df1.style.applymap(cooling_highlight))
                st.image(im)
                
            # reference
            
            #st.caption("[github page](https://github.com/juppifluppi/poxload)")
          
    except:
        st.write("Cannot parse SMILES string!")
