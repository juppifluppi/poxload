from rdkit import Chem, RDConfig
from rdkit.Chem import AllChem, rdFingerprintGenerator, Descriptors, Draw
from rdkit.Chem.MolStandardize import rdMolStandardize
from rdkit.Chem.Fingerprints import FingerprintMols
from rdkit.DataStructs import cDataStructs
from io import StringIO
from mordred import Calculator, descriptors
import numpy as np
import pandas as pd
import seaborn as sns
import sys, os
import matplotlib.pyplot as plt
import streamlit as st
from streamlit_ketcher import st_ketcher
import time
import subprocess
from PIL import Image

calc = Calculator(descriptors, ignore_3D=False)

def fingerprint_rdk5(self) -> np.ndarray:
    fp_gen = rdFingerprintGenerator.GetRDKitFPGenerator(maxPath=5,fpSize=16384)
    return fp_gen.GetCountFingerprintAsNumPy(self).astype(int)

def fingerprint_rdk7(self) -> np.ndarray:
    fp_gen = rdFingerprintGenerator.GetRDKitFPGenerator(maxPath=7,fpSize=16384)
    return fp_gen.GetCountFingerprintAsNumPy(self).astype(int)

def standardize(smiles):
    mol = Chem.MolFromSmiles(smiles)
    clean_mol = rdMolStandardize.Cleanup(mol) 
    parent_clean_mol = rdMolStandardize.FragmentParent(clean_mol)
    uncharger = rdMolStandardize.Uncharger()
    uncharged_parent_clean_mol = uncharger.uncharge(parent_clean_mol)    
    te = rdMolStandardize.TautomerEnumerator()
    taut_uncharged_parent_clean_mol = te.Canonicalize(uncharged_parent_clean_mol)     
    taut_uncharged_parent_clean_mol_addH = Chem.AddHs(taut_uncharged_parent_clean_mol)
    Chem.SanitizeMol(taut_uncharged_parent_clean_mol_addH)
    return taut_uncharged_parent_clean_mol_addH

def cooling_highlight(val):
   color = 'green' if val == 8 else "green" if val == 7 else "green" if val == 6 else "yellow" if val == 5 else "yellow" if val == 4  else "yellow" if val == 3 else "red" if val == 2 else "red" if val == 1 else "red" if val == 0 else "white"                    
   return f'background-color: {color}'

NAMES=["MeOx","EtOx","nPrOx","nBuOx","iBuOx","cPrOx","iPrOx","cPrMeOx","sBuOx","EtHepOx","nNonOx","PhOx","PentOx","nPrOzi","nBuOzi","iBuOzi","cPrOzi","iPrOzi","cPrMeOzi","sBuOzi","EtHepOzi","nNonOzi","PhOzi","BzOx","BzOzi","PhenOx","PhenOzi","Pid","EIP","PgMeOx","Pip","PipBoc","nBuEnOx","nBuOxPh","nBuOxNH2","nBuOxCOOH","PcBOx","OH","NH2","rEtEtOx","sEtEtOx","EtEtOx","rPrMeOx","sPrMeOx","PrMeOx","Bz"]
SMILES=["CC(=O)N(C)CC","CCC(=O)N(C)CC","CCCC(=O)N(C)CC","CCCCC(=O)N(C)CC","CC(C)CC(=O)N(C)CC","CCN(C)C(=O)C1CC1","CC(C)C(=O)N(C)CC","CCN(C)C(=O)CC1CC1","CCC(C)C(=O)N(C)CC","CCCCC(CC)CCC(=O)N(C)CC","CCCCCCCCCC(=O)N(C)CC","CCN(C)C(=O)c1ccccc1","CCCCCC(=O)N(C)CC","CCCC(=O)N(C)CCC","CCCCC(=O)N(C)CCC","CC(C)CC(=O)N(C)CCC","CCCN(C)C(=O)C1CC1","CCCN(C)C(=O)C(C)C","CCCN(C)C(=O)CC1CC1","CCC(C)C(=O)N(C)CCC","CCCCC(CC)CCC(=O)N(C)CCC","CCCCCCCCCC(=O)N(C)CCC","CCCN(C)C(=O)c1ccccc1","CCN(C)C(=O)Cc1ccccc1","CCCN(C)C(=O)Cc1ccccc1","CCN(C)C(=O)CCc1ccccc1","CCCN(C)C(=O)CCc1ccccc1","CN1CCCCC1","CCOC(=O)C1CCN(C)CC1","C#CCCN(C)C(C)=O","CN1CCNCC1","CN1CCN(C(=O)OC(C)(C)C)CC1","C=CCCC(=O)N(C)CC","CCN(C)C(=O)CCCCSCc1ccccc1","CCN(C)C(=O)CCCCSCC(=O)O","CCN(C)C(=O)CCCCSCC(=O)O","CCN(C)C(=O)CCc1nc(N)nc(N(C)C)n1","CO","CN","CCC(=O)N(C)[C@H](C)CC","CCC(=O)N(C)[C@@H](C)CC","CCC(=O)N(C)C(C)CC","CCCC(=O)N(C)[C@H](C)C","CCCC(=O)N(C)[C@@H](C)C","CCCC(=O)N(C)C(C)C","Cc1ccccc1"]
MW=[]

st.image('logo2.png')

with st.form(key='my_form_to_submit'):
    with st.expander("More info"):
        
        st.caption("""POxload is a web tool to evaluate the amount of drug solubilized by amphiphilic, triblock copolymeric poly(oxazoline)/poly(oxazine) (pOx/pOzi) micelles.
It is based on predictions for loading efficiency (LE) and loading capacity (LC) using four differen thresholds for each parameter (LC10, LC20, LC30, LC40, LE20, LE40, LE60, LE80).
The formulations are assumed to be made via thin-film hydration using ethanol as solvent and an elevated temperature of 55 °C during re-hydration. Enter the SMILES code of a drug 
(and potential co-formulated compounds) and select the polymers of interest. A formulation report is generated, outputting predictions for all models, given a polymer feed of 10 g/L
 and drug feeds of 2-10 g/L. The software is hosted at our [github page](https://github.com/juppifluppi/poxload).""")
 

    SMI = st.text_input('Enter [SMILES code](https://pubchem.ncbi.nlm.nih.gov/edit3/index.html) of drug to load', 'COc2cc(/C=C/C(=O)/C=C(O)/C=C/c1ccc(O)c(OC)c1)ccc2O') 

    agree = st.checkbox('Draw instead')
    if agree:
            SMI = st_ketcher(SMI)

    col1, col2 = st.columns(2)
    with col1:
        SMI2 = st.text_input('Add potential co-formulated drug:', '')
    with col2:
        numberSD2 = st.number_input('Drug feed of co-formulated drug',min_value=0, max_value=12, value="min", step=2)

    
    options = st.multiselect(
        'Polymers to calculate loading for',
        options=["A-cPrOx-A","A-cPrOzi-A","A-nPrOx-A","A-nPrOzi-A","A-iPrOx-A","A-iPrOzi-A","A-cPrMeOx-A","A-cPrMeOzi-A","A-nBuOx-A","A-nBuOzi-A","A-iBuOx-A","A-iBuOzi-A","A-sBuOx-A","A-sBuOzi-A","A-PentOx-A","A*-nPrOzi-A*","A*-nBuOx-A*","A-BzOx-A","A-BzOzi-A","A-PhOx-A","A-PhOzi-A","A-EtHepOx-A","A-EtHepOzi-A","A-nNonOx-A","A-nNonOzi-A"],
        default=["A-nPrOx-A","A-nPrOzi-A","A-nBuOx-A","A-nBuOzi-A"])


    choosemodel = st.selectbox('Models to use:',
                         ('RDK7-RF (recommended)','Final (slower)'))

    emoji = '💊'
    label = 'Formulate!'
    
    submit_button = st.form_submit_button(label=f'{emoji} {label}')



if submit_button:   
    if len(SMI2) > 2:
        NAMES.insert(0, "CO-COMPOUND")
        SMILES.insert(0, SMI2)
        tune_DF=str("sed -i -e 's/XXXX/"+str(numberSD2)+"/g' cxdb.R")
        os.system(tune_DF)

    
    # Specify the file path
    file_path = 'options.csv'

    # Write the list to the CSV file as a single column
    with open(file_path, 'w') as file:
        for item in options:
            file.write(str(item) + '\n')
    
    NAMES.append("COMPOUND")
    SMILES.append(SMI)
    try:
        os.remove("descriptors.csv")
    except:
        pass
    
    with st.spinner('CALCULATING DESCRIPTORS (STEP 1 OF 4)...'):
        
        for molecule in range(0,len(SMILES)):            
                        
            mol = standardize(SMILES[molecule])
            AllChem.EmbedMolecule(mol,useRandomCoords=True)
            AllChem.MMFFOptimizeMolecule(mol, "MMFF94s", maxIters=5000)
            rdkitfp = fingerprint_rdk7(mol)
            rdkitfp2 = fingerprint_rdk5(mol)

            if molecule == 0:
                with open("descriptors.csv","a") as f:
                    for o in range(0,len(rdkitfp)):
                        f.write("rdk7_"+str(o)+"\t")
                    for o in range(0,len(rdkitfp2)):
                        f.write("rdk5_"+str(o)+"\t")
                    for o in calc(mol).asdict().keys():
                        f.write(str(o)+"\t")
                    f.write("\n")

            with open("descriptors.csv","a") as f:
                for o in range(0,len(rdkitfp)):
                    f.write(str(rdkitfp[o])+"\t")
                for o in range(0,len(rdkitfp2)):
                    f.write(str(rdkitfp2[o])+"\t")
                for o in calc(mol).asdict().values():
                    f.write(str(o)+"\t")                
                f.write("\n")
            
            mj = Chem.Descriptors.ExactMolWt(mol)
            MW.append(mj)
            if molecule == len(SMILES)-1:
                im = Draw.MolToImage(Chem.MolFromSmiles(SMILES[molecule]),fitImage=True) 
      
        dfx = pd.DataFrame(columns=['NAME', "SMILES","MW"])
        dfx["NAME"]=NAMES
        dfx["SMILES"]=SMILES
        dfx["MW"]=MW
        
        dfx.to_csv("db_test.csv",index=False)
                               
    with st.spinner('CREATING FORMULATION DATABASE (STEP 2 OF 4)...'):
        process1 = subprocess.Popen(["Rscript", "cxdb.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        result1 = process1.communicate()

    with st.spinner('CALCULATING MIXTURE DESCRIPTORS (STEP 3 OF 4)...'):        
        process2 = subprocess.Popen(["Rscript", "create.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        result2 = process2.communicate()
                           
    with st.spinner('CALCULATING PREDICTIONS (STEP 4 OF 4)...'):
        if choosemodel == 'RDK7-RF (recommended)':
            process3 = subprocess.Popen(["Rscript", "fgv.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            result3 = process3.communicate()
        if choosemodel == 'Final (slower)':
            process3 = subprocess.Popen(["Rscript", "fgv2.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            result3 = process3.communicate()
        
        df2 = pd.read_csv(r'fin_results2.csv')
        df2 = df2.rename(columns={0: "POL", 1: "DF", 2: "LC", 3: "LE"})

        SDc = ((df2["DF"])*((df2["LE"])/100))
        SDc2 = (((df2["LC"]/100)*10)/(1-(df2["LC"]/100)))
        #SDcx = ((SDc+SDc2)/2)
        SDcx = pd.concat([SDc, SDc2], axis=1).min(axis=1)
        
        #if len(SMI2) > 2:
        #    SDc = ((df2["DF"])*((df2["LE"])/100))
        #    SDc2 = (((df2["LC"]/100)*(10+numberSD2))/(1-(df2["LC"]/100)))
        #    #SDcx = ((SDc+SDc2)/2)
        #    SDcx = pd.concat([SDc, SDc2], axis=1).min(axis=1)
        
        
        df3={'POL' : df2["POL"], 'DF' : df2["DF"], 'SD': SDcx}
        df3=pd.DataFrame(df3,columns=["POL","DF","SD"])
        
        df4={'POL' : df2["POL"], 'DF' : df2["DF"], 'SD': SDc}
        df4=pd.DataFrame(df4,columns=["POL","DF","SD"])

        df5={'POL' : df2["POL"], 'DF' : df2["DF"], 'SD': SDc2}
        df5=pd.DataFrame(df5,columns=["POL","DF","SD"])
        
        custom_palette = sns.color_palette("deep")

        max_indexes = SDcx[SDcx == max(SDcx)].index.tolist()
        
        col1, col2 = st.columns(2)

        finalLE=round((round(max(SDcx),1)/df3.loc[SDcx.idxmax(), "DF"])*100,0)
        finalLC=round((round(max(SDcx),1)/(df3.loc[SDcx.idxmax(), "DF"]+10))*100,0)

        with col1: 
            st.header("Formulation report")
            #st.write("Maximum solubilized drug: "+str(round(max(SDcx),1))+" g/L at "+str(df3.loc[SDcx.idxmax(), "DF"])+" g/L drug feed (LE: "+str(df2.loc[SDcx.idxmax(), "LE"])+" %, LC: "+str(df2.loc[SDcx.idxmax(), "LC"])+" %)")
            st.write("Maximum solubilized drug: "+str(round(max(SDcx),1))+" g/L at "+str(df3.loc[SDcx.idxmax(), "DF"])+" g/L drug feed (LE: "+str(finalLE)+" %, LC: "+str(finalLC)+" %)")
            
            
            # Group by the 'first_column' and get the maximum value in 'third_column' for each group
            max_values = df3.groupby('POL')['SD'].max()

            # Find the maximum value in the entire 'max_values' Series
            max_value = max_values.max()

            # Filter and print only the keys with the maximum value
            keys_with_max_value = max_values[max_values == max_value].index.tolist()
            comma_separated_keys = ', '.join(str(key) for key in keys_with_max_value)
            st.write(comma_separated_keys)

                
        with col2:
            st.image(im)

        st.write("Predicted amount of solubilized drug (maximum detected by both LE and LC models, see below)")
        fig3=plt.figure(figsize=(10, 6))
        ax = sns.barplot(x="DF", y="SD", hue="POL", data=df3)
        plt.xlabel("Drug feed [g/L]")
        plt.ylabel("Solubilized drug [g/L]")
        #plt.title("Predicted maximum amount of solubilized drug based on LE and LC models")
        plt.ylim(0, 10)
        ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))
        st.pyplot(fig3)

        col1, col2 = st.columns(2)
        with col1:
            st.write("Amount based on LE models:")
            fig1a=plt.figure(figsize=(10, 6))
            ax = sns.barplot(x="DF", y="SD", hue="POL", data=df4)
            plt.xlabel("Drug feed [g/L]")
            plt.ylabel("Solubilized drug [g/L]")
            #plt.title("Predicted amount of solubilized drug based on LE models")
            plt.ylim(0, 10)
            ax.get_legend().remove()
            st.pyplot(fig1a)

            st.write("Calculated from LE predictions:")
            fig1b=plt.figure(figsize=(10, 6))
            ax = sns.barplot(x="DF", y="LE", hue="POL", data=df2)
            plt.xlabel("Drug feed [g/L]")
            plt.ylabel("Ligand efficiency [%]")
            plt.ylim(0, 100)
            #plt.title("Maximum predicted LE values")
            ax.get_legend().remove()
            st.pyplot(fig1b)
        
        
        with col2:
            st.write("Amount based on LC models:")
            fig2a=plt.figure(figsize=(10, 6))
            ax = sns.barplot(x="DF", y="SD", hue="POL", data=df5)
            plt.xlabel("Drug feed [g/L]")
            plt.ylabel("Solubilized drug [g/L]")
            #plt.title("Predicted amount of solubilized drug based on LC models")
            plt.ylim(0, 10)
            ax.get_legend().remove()
            st.pyplot(fig2a)

            st.write("Calculated from LC predictions:")
            fig2b=plt.figure(figsize=(10, 6))
            ax = sns.barplot(x="DF", y="LC", hue="POL", data=df2)
            plt.xlabel("Drug feed [g/L]")
            plt.ylabel("Loading capacity [%]")
            plt.ylim(0, 50)
            #plt.title("Maximum predicted LC values")  
            ax.get_legend().remove()
            st.pyplot(fig2b)

        st.write("Table of predictions for all classification models:")
        df = pd.read_csv(r'fin_results.csv',index_col=0)
        df = df.rename(columns={0: "POL", 1: "DF", 2: "LC10", 3: "LC20", 4: "LC30", 5: "LC40", 6: "LE20", 7: "LE40", 8: "LE60", 9: "LE80", 10:"Passed"})
        #df = df.sort_values(by=['Passed'], ascending=False)    
        st.write(df)
        #st.dataframe(df.style.applymap(cooling_highlight))
        
        #st.caption("[github page](https://github.com/juppifluppi/poxload)")
