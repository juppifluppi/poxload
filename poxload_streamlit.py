from rdkit import Chem, RDConfig
from rdkit.Chem import AllChem, rdFingerprintGenerator
from rdkit.Chem.MolStandardize import rdMolStandardize
from rdkit.Chem.Fingerprints import FingerprintMols
from rdkit.DataStructs import cDataStructs
from io import StringIO
import numpy as np
import pandas as pd
import sys, os
import streamlit as st
import time
import subprocess
from PIL import Image

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
   color = 'green' if val == 10 else "green" if val == 9 else "green" if val == 8 else "yellow" if val == 7 else "yellow" if val == 6 else "yellow" if val == 5 else "red" if val == 4  else "red" if val == 3 else "red" if val == 2 else "red" if val == 1 else "red" if val == 0 else "white"                    
   return f'background-color: {color}'

NAMES=["MeOx","EtOx","nPrOx","nBuOx","iBuOx","cPrOx","iPrOx","cPrMeOx","sBuOx","EtHepOx","nNonOx","PhOx","PentOx","nPrOzi","nBuOzi","iBuOzi","cPrOzi","iPrOzi","cPrMeOzi","sBuOzi","EtHepOzi","nNonOzi","PhOzi","BzOx","BzOzi","PhenOx","PhenOzi","Pid","EIP","PgMeOx","Pip","PipBoc","nBuEnOx","nBuOxPh","nBuOxNH2","nBuOxCOOH","PcBOx","OH","NH2","rEtEtOx","sEtEtOx","EtEtOx","rPrMeOx","sPrMeOx","PrMeOx","Bz"]
SMILES=["CC(=O)N(C)CC","CCC(=O)N(C)CC","CCCC(=O)N(C)CC","CCCCC(=O)N(C)CC","CC(C)CC(=O)N(C)CC","CCN(C)C(=O)C1CC1","CC(C)C(=O)N(C)CC","CCN(C)C(=O)CC1CC1","CCC(C)C(=O)N(C)CC","CCCCC(CC)CCC(=O)N(C)CC","CCCCCCCCCC(=O)N(C)CC","CCN(C)C(=O)c1ccccc1","CCCCCC(=O)N(C)CC","CCCC(=O)N(C)CCC","CCCCC(=O)N(C)CCC","CC(C)CC(=O)N(C)CCC","CCCN(C)C(=O)C1CC1","CCCN(C)C(=O)C(C)C","CCCN(C)C(=O)CC1CC1","CCC(C)C(=O)N(C)CCC","CCCCC(CC)CCC(=O)N(C)CCC","CCCCCCCCCC(=O)N(C)CCC","CCCN(C)C(=O)c1ccccc1","CCN(C)C(=O)Cc1ccccc1","CCCN(C)C(=O)Cc1ccccc1","CCN(C)C(=O)CCc1ccccc1","CCCN(C)C(=O)CCc1ccccc1","CN1CCCCC1","CCOC(=O)C1CCN(C)CC1","C#CCCN(C)C(C)=O","CN1CCNCC1","CN1CCN(C(=O)OC(C)(C)C)CC1","C=CCCC(=O)N(C)CC","CCN(C)C(=O)CCCCSCc1ccccc1","CCN(C)C(=O)CCCCSCC(=O)O","CCN(C)C(=O)CCCCSCC(=O)O","CCN(C)C(=O)CCc1nc(N)nc(N(C)C)n1","CO","CN","CCC(=O)N(C)[C@H](C)CC","CCC(=O)N(C)[C@@H](C)CC","CCC(=O)N(C)C(C)CC","CCCC(=O)N(C)[C@H](C)C","CCCC(=O)N(C)[C@@H](C)C","CCCC(=O)N(C)C(C)C","Cc1ccccc1"]
MW=[]

NAMES.append("COMPOUND")
SMILES.append(SMI)

st.image('logo.png')

st.caption("""Input a [molecule SMILES code](https://pubchem.ncbi.nlm.nih.gov/edit3/index.html). Predictions for loading efficencies (LE) and
loading capacities (LC) for different ABA-triblock poly(2-oxazoline)- and poly(2-oxazine)-based micelles are listed, given a polymer feed of 10 g/L and a standard drug feed of 8 g/L.
Random forest classifications for different thresholds are listed (LE ≥ 20, 40, 60, 70 and 80%; LC ≥ 10, 20, 30, 35 and 40%).
Mixtures that exceed these thresholds are labeled "X1". Mixtures outside of the applicability domain of the respective model are labeled with "AD".
Formulations that pass at least 8 out of 10 thresholds are marked green, indicating high solubility; those that pass 5-7 are colored yellow and those that pass less than 5 thresholds are marked red.
Predictions with PaDEL descriptors usually take around 30 seconds, calculations for models including SiRMS descriptors are slower.""")

set_DF = st.selectbox('Drug feed (g/L):',('8', '2', '4', '6', '10', '12'))   

with st.form(key='my_form_to_submit'):
    SMI = st.text_input('Enter SMILES code of drug to load (paclitaxel given as example)', 'CC1=C2[C@@]([C@]([C@H]([C@@H]3[C@]4([C@H](OC4)C[C@@H]([C@]3(C(=O)[C@@H]2OC(=O)C)C)O)OC(=O)C)OC(=O)c5ccccc5)(C[C@@H]1OC(=O)[C@H](O)[C@@H](NC(=O)c6ccccc6)c7ccccc7)O)(C)C') 
    submit_button = st.form_submit_button(label='Submit')

if submit_button:

    try:

       with st.spinner('CALCULATING FINGERPRINTS (STEP 1 OF 6)...'):

          for molecule in range(0,len(SMILES)):
          
             mol = standardize(SMILES[molecule])
             AllChem.EmbedMolecule(mol,useRandomCoords=True)
             AllChem.MMFFOptimizeMolecule(mol, "MMFF94s", maxIters=5000)
             rdkitfp = fingerprint_rdk7(mol)

             if molecule == 0:
                with open("descriptors_rdk7.csv","a") as f:
                    for o in range(0,len(rdkitfp)):
                        f.write("rdk7_"+str(o)+"\t")
                    f.write("\n")

             with open("descriptors_rdk7.csv","a") as f:
                for o in range(0,len(rdkitfp2)):
                   f.write(str(rdkitfp[o])+"\t")
                f.write("\n")

             mj = Chem.Descriptors.ExactMolWt(mol)
             MW.append(mj)
      
          dfx = pd.DataFrame(columns=['NAME', "SMILES","MW"])
          dfx["NAME"]=NAMES
          dfx["SMILES"]=SMILES
          dfx["MW"]=MW

          dfx.to_csv("db_test.csv",index=False)

                             
       with st.spinner('CREATING FORMULATIONS (STEP 2 OF 6)...'):
          process1 = subprocess.Popen(["Rscript", "cxdb.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
          result1 = process1.communicate()
          os.system("sed -i -e 's/\"//g' db_formulations.csv")
          tune_DF=str("sed -i -e 's/10\\t8\t/10\\t"+set_DF+"\\t/g' db_formulations.csv")
          os.system(tune_DF)
                
       with st.spinner('CALCULATING PREDICTIONS (STEP 6 OF 6)...'):
          process3 = subprocess.Popen(["Rscript", "fgv.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
          result3 = process3.communicate()
                
          df = pd.read_csv(r'fin_results.csv',index_col=0)

                df = df.rename(columns={0: "Polymer", 1: "LC10", 2: "LC20", 3: "LC30", 4: "LC35", 5: "LC40", 6: "LE20", 7: "LE40", 8: "LE60", 9: "LE70", 10: "LE80", 11:"Passed"})
                df = df.sort_values(by=['Passed'], ascending=False)
                #df1 = df[["LC10","LC20","LC30","LC35","LC40"]]
                #df2 = df[["LE20","LE40","LE60","LE70","LE80"]]


                #col1, col2 = st.columns(2)
                #with col1:
                #    st.dataframe(df1.style.applymap(cooling_highlight))
                #    #st.dataframe(df2)
                #with col2:
                #    st.dataframe(df2.style.applymap(cooling_highlight))
                #    #st.dataframe(df1)
                #st.image(im)            

                st.dataframe(df.style.applymap(cooling_highlight))
                #st.dataframe(df)
                st.image(im)
                       
            # reference
            
            st.caption("[github page](https://github.com/juppifluppi/poxload)")
              
  #      except:
  #          st.write("Cannot parse SMILES string!")

        if option == "PaDEL":
            with st.spinner('CALCULATING PADEL DESCRIPTORS FOR COMPOUND (STEP 1 OF 5)...'):
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
                
            with st.spinner('CALCULATING ATOMIC PROPERTIES FOR SiRMS (STEP 2 OF 5)...'):
                        
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
                    dfx["MW"]=sum_MW[0]
                
                    dfx.to_csv("db_molstest.csv",index=False)
                
            with st.spinner('CREATING FORMULATIONS (STEP 3 OF 5)...'):
                
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
                
            #with st.spinner('CALCULATING SiRMS DESCRIPTORS (STEP 4 OF 6)...'):

                #os.system("sirms -i db_library_merged.sdf -a mr logp eeq alp sa sdx sdc at -o sirms_test.txt -m mixture_test.txt --max_mix_components 3 --mix_type rel -c 1 -r > /dev/null 2>&1")
             #   os.system("sirms -i db_library_merged.sdf -a mr eeq alp at -o sirms_test.txt -m mixture_test.txt --max_mix_components 3 --mix_type rel -c 1 -r > /dev/null 2>&1")
                
              #  os.system("sed -i -e 's/\t/,/g' sirms_test.txt")
               
            with st.spinner('CALCULATING PADEL DESCRIPTORS FOR MIXTURES (STEP 4 OF 5)...'):
                process2 = subprocess.Popen(["Rscript", "gtg.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
                result2 = process2.communicate()

            with st.spinner('CALCULATING PREDICTIONS (STEP 5 OF 5)...'):
                process3 = subprocess.Popen(["Rscript", "fgv3.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
                result3 = process3.communicate()
                
                #def cooling_highlight(val):
                #    color = 'red' if val == "X0" else 'grey' if val=="AD" else 'green'
                #    return f'background-color: {color}'
                def cooling_highlight(val):
                    color = 'green' if val == 10 else "green" if val == 9 else "green" if val == 8 else "yellow" if val == 7 else "yellow" if val == 6 else "yellow" if val == 5 else "red" if val == 4  else "red" if val == 3 else "red" if val == 2 else "red" if val == 1 else "red" if val == 0 else "white"                    
                    return f'background-color: {color}'

                df = pd.read_csv(r'fin_results.csv',index_col=0)

                df = df.rename(columns={0: "Polymer", 1: "LC10", 2: "LC20", 3: "LC30", 4: "LC35", 5: "LC40", 6: "LE20", 7: "LE40", 8: "LE60", 9: "LE70", 10: "LE80", 11:"Passed"})
                df = df.sort_values(by=['Passed'], ascending=False)
                #df1 = df[["LC10","LC20","LC30","LC35","LC40"]]
                #df2 = df[["LE20","LE40","LE60","LE70","LE80"]]


                #col1, col2 = st.columns(2)
                #with col1:
                #    st.dataframe(df1.style.applymap(cooling_highlight))
                #    #st.dataframe(df2)
                #with col2:
                #    st.dataframe(df2.style.applymap(cooling_highlight))
                #    #st.dataframe(df1)
                #st.image(im)           
               
                st.dataframe(df.style.applymap(cooling_highlight))
                #st.caption("Polymer names: A = poly(2-methyl-2-oxazoline); PrOx = poly(2-propyl-2-oxazoline); PrOzi = poly(2-propyl-2-oxazinen; BuOx = poly(2-butyl-2-oxazoline); BuOzi = poly(2-butyl-2-oxazine); PentOx = poly(2-pentyl-2-oxazoline); PhOx = poly(2-phenyl-2-oxazoline); BzOx = poly(2-benzyl-2-oxazoline)")
                st.caption("Polymer names: A = poly(2-methyl-2-oxazoline); A* = poly(2-ethyl-2-oxazoline); Ox = poly(2-alkyl-2-oxazoline); Ozi = poly(2-alkyl-2-oxazine); n = linear alkyl; c = cyclo alkyl; i = iso-alkyl; s = sec-alkyl; Pr = propyl; Bu = butyl; EtHep = 3-etyhl heptyl; PrMe = propyl methylene; Ph = phenyl; Bz = benzyl; Pent = pentyl; Phen = phenetyhl; Non = nonyl; Px, Py and P1-P8 = A-nBuOx-A with different chain lengths.") 
                st.caption("Sources for polymer structures: -L = Biomacromolecules 2019, 20, 8, 3041–3056; -H = Biomacromolecules 2018, 19, 7, 3119–3128; -M = in-house data; Px, Py and P1-P8 = Sci. Adv. 2019, 5, eaav9784; no suffix = 10.26434/chemrxiv-2022-s8xc3.")
                #st.dataframe(df)
                st.image(im)
               
            # reference
            
            st.caption("[github page](https://github.com/juppifluppi/poxload)")
              
    except:
        st.write("Cannot parse SMILES string!")
