from rdkit import Chem, RDConfig
from rdkit.Chem import AllChem, rdFingerprintGenerator, Descriptors, Draw
from rdkit.Chem.MolStandardize import rdMolStandardize
from rdkit.Chem.Fingerprints import FingerprintMols
from rdkit.DataStructs import cDataStructs
from io import StringIO
from mordred import Calculator, descriptors
import numpy as np
import pandas as pd
import sys, os, time

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

NAMES=["MeOx","EtOx","nPrOx","nBuOx","iBuOx","cPrOx","iPrOx","cPrMeOx","sBuOx","EtHepOx","nNonOx","PhOx","PentOx","nPrOzi","nBuOzi","iBuOzi","cPrOzi","iPrOzi","cPrMeOzi","sBuOzi","EtHepOzi","nNonOzi","PhOzi","BzOx","BzOzi","PhenOx","PhenOzi","Pid","EIP","PgMeOx","Pip","PipBoc","nBuEnOx","nBuOxPh","nBuOxNH2","nBuOxCOOH","PcBOx","OH","NH2","rEtEtOx","sEtEtOx","EtEtOx","rPrMeOx","sPrMeOx","PrMeOx","Bz"]
SMILES=["CC(=O)N(C)CC","CCC(=O)N(C)CC","CCCC(=O)N(C)CC","CCCCC(=O)N(C)CC","CC(C)CC(=O)N(C)CC","CCN(C)C(=O)C1CC1","CC(C)C(=O)N(C)CC","CCN(C)C(=O)CC1CC1","CCC(C)C(=O)N(C)CC","CCCCC(CC)CCC(=O)N(C)CC","CCCCCCCCCC(=O)N(C)CC","CCN(C)C(=O)c1ccccc1","CCCCCC(=O)N(C)CC","CCCC(=O)N(C)CCC","CCCCC(=O)N(C)CCC","CC(C)CC(=O)N(C)CCC","CCCN(C)C(=O)C1CC1","CCCN(C)C(=O)C(C)C","CCCN(C)C(=O)CC1CC1","CCC(C)C(=O)N(C)CCC","CCCCC(CC)CCC(=O)N(C)CCC","CCCCCCCCCC(=O)N(C)CCC","CCCN(C)C(=O)c1ccccc1","CCN(C)C(=O)Cc1ccccc1","CCCN(C)C(=O)Cc1ccccc1","CCN(C)C(=O)CCc1ccccc1","CCCN(C)C(=O)CCc1ccccc1","CN1CCCCC1","CCOC(=O)C1CCN(C)CC1","C#CCCN(C)C(C)=O","CN1CCNCC1","CN1CCN(C(=O)OC(C)(C)C)CC1","C=CCCC(=O)N(C)CC","CCN(C)C(=O)CCCCSCc1ccccc1","CCN(C)C(=O)CCCCSCC(=O)O","CCN(C)C(=O)CCCCSCC(=O)O","CCN(C)C(=O)CCc1nc(N)nc(N(C)C)n1","CO","CN","CCC(=O)N(C)[C@H](C)CC","CCC(=O)N(C)[C@@H](C)CC","CCC(=O)N(C)C(C)CC","CCCC(=O)N(C)[C@H](C)C","CCCC(=O)N(C)[C@@H](C)C","CCCC(=O)N(C)C(C)C","Cc1ccccc1"]
MW=[]

startTime = time.time()

SMI = str(sys.argv[1])


NAMES.append("COMPOUND")
SMILES.append(SMI)
try:
    os.remove("descriptors.csv")
except:
    pass

options=["A-nPrOx-A","A-nPrOzi-A","A-nBuOx-A","A-nBuOzi-A"]

file_path = 'options.csv'
with open(file_path, 'w') as file:
    for item in options:
        file.write(str(item) + '\n')

try:

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
    
    dfx = pd.DataFrame(columns=['NAME', "SMILES","MW"])
    dfx["NAME"]=NAMES
    dfx["SMILES"]=SMILES
    dfx["MW"]=MW
    
    dfx.to_csv("db_test.csv",index=False)
    
    
    CON = os.path.expandvars('$CONDA_PREFIX')
    
    command=str("cp -r "+CON+"/xgboost/ .")
    os.system(command)   
    
    command=str("cp "+CON+"/db_smiles.csv .")
    os.system(command)   
    
    command=str("cp "+CON+"/model_*rda .")
    os.system(command)   
    
    command=str("cp "+CON+"/desc.dat .")
    os.system(command)    
    
    print("CREATING FORMULATION DATABASE...")
    
    command=str("Rscript "+CON+"/create_formulations.R > /dev/null 2>&1")
    os.system(command)
    
    print("CALCULATING MIXTURE DESCRIPTORS...")
    
    command=str("Rscript "+CON+"/create_mixtures2.R > /dev/null 2>&1")
    os.system(command)
    
    print("CALCULATING PREDICTIONS...")
    
    command=str("Rscript "+CON+"/predict2.R > /dev/null 2>&1")
    os.system(command)
    
    print("WRITE RESULTS TO CSV...")
    print("DONE! CALCULATION TIME: {0} SECONDS".format(time.time() - startTime))
    os.system("rm -r db_formulations.csv db_test.csv descriptors.csv fin_results2.csv options.csv testformulations.dat xgboost/ db_smiles.csv desc.dat model_*rda")
    os.system("mv fin_results.csv poxload_results.csv")
    sys.exit()
    
except:
    print("Something went wrong. Please check your SMILES codes!")
