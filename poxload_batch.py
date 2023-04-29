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
from rdkit.Chem.Fingerprints import FingerprintMols
from scopy.ScoPretreat import pretreat
import scopy.ScoDruglikeness
from padelpy import from_smiles
import sys, os
import pandas as pd
import time 

startTime = time.time()

df=pd.read_csv(str(sys.argv[1]))

NAMES=[]
SMILES=[]
sum_MW=[]

for i in df["name"]:
    NAMES.append(i)
for i in df["smiles"]:
    SMILES.append(i)

print("CALCULATING PADEL DESCRIPTORS FOR COMPOUNDS (STEP 1 OF 6)...")

try:
    os.remove("descriptors_padeltest.csv")
except:
    pass

for molecule in range(0,len(SMILES)):
    SMI = str(SMILES[molecule])
    mol = Chem.MolFromSmiles(SMI)
    sdm = pretreat.StandardizeMol()
    mol = sdm.disconnect_metals(mol)
    SMI = str(Chem.MolToSmiles(mol))
    descriptors = from_smiles(SMI)
    items = list(descriptors.items())
    items.insert(0, ('Name', NAMES[molecule]))
    descriptors = dict(items)

    if molecule == 0:
        with open("descriptors_padeltest.csv","a") as f:
            for o in descriptors.keys():
                f.write(str(o)+",")
            f.write("\n")   
    with open("descriptors_padeltest.csv","a") as f:
        for o in descriptors.values():
            f.write(str(o)+",")
        f.write("\n")

print("CALCULATING ATOMIC PROPERTIES FOR SiRMS (STEP 2 OF 6)...")

mols=[]

for molecule in range(0,len(SMILES)):
    try:
        SMI = str(SMILES[molecule])
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

        mol.SetProp('_Name',NAMES[molecule])   
        mols.append(mol)
              
        mj = Chem.Descriptors.ExactMolWt(mol)
        sum_MW.append(mj)
    
    except:
        pass

with Chem.SDWriter('librarytest.sdf') as w:
    for m in mols:
        w.write(m)


CON = os.path.expandvars('$CONDA_PREFIX')     
command=str("cp "+CON+"/smiles3.csv .")
os.system(command)

os.system("sed -i -e 's/atom.prop.//g' librarytest.sdf")
os.system("sed -i -e 's/; /;/g' librarytest.sdf")
command = str("cat librarytest.sdf "+CON+"/library_pol.sdf > db_library_merged.sdf")
os.system(command)

dfx = pd.DataFrame(columns=['NAME', "SMILES","MW"])
dfx["NAME"]=NAMES
dfx["SMILES"]=SMILES
dfx["MW"]=sum_MW

dfx.to_csv("db_molstest.csv",index=False)

print("CREATING FORMULATIONS (STEP 3 OF 6)...")

os.system("Rscript $CONDA_PREFIX/cxdb.R")

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

print("CALCULATING SiRMS DESCRIPTORS (STEP 4 OF 6)...")

command=str("cp "+CON+"/setup.txt .")
os.system(command)

os.system("sirms -i db_library_merged.sdf -a mr logp eeq alp sa sdx sdc at -o sirms_test.txt -m mixture_test.txt --max_mix_components 3 --mix_type rel -c 1 -r > /dev/null 2>&1")

os.system("sed -i -e 's/\t/,/g' sirms_test.txt")

print("CALCULATING PADEL DESCRIPTORS FOR MIXTURES (STEP 5 OF 6)...")
command=str("cp "+CON+"/startdatayyy3.dat .")
os.system(command)
command=str("cp "+CON+"/m*.rda .")
os.system(command)
command=str("cp "+CON+"/descriptors_padel_pol.csv .")
os.system(command)
command=str("Rscript "+CON+"/gtg.R > /dev/null 2>&1")
os.system(command)
print("CALCULATING PREDICTIONS (STEP 6 OF 6)...")
command=str("Rscript "+CON+"/fgv.R > /dev/null 2>&1")
os.system(command)
print("WRITE RESULTS TO CSV...")
print("DONE! CALCULATION TIME: {0} SECONDS".format(time.time() - startTime))
os.system("rm db_library_merged.sdf m*.rda startdatayyy3.dat db_molstest.csv descriptors_padel_pol.csv descriptors_padeltest.csv formulations3test_db.csv librarytest.sdf mixture_test.txt setup.txt sirms_test.txt descp.csv smiles3.csv")
