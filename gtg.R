padelx=read.csv("descriptors_padeltest.csv")
padel=read.csv("descriptors_padel_pol.csv")
padelx=cbind("testcompound",padelx)
colnames(padelx)[1]="Name"
padel=rbind(padelx,padel)
descriptors=padel
formulations=read.csv("formulations3test_db.csv",dec=".",sep="\t")
names=descriptors$Name
descriptors=descriptors[ , purrr::map_lgl(descriptors, is.numeric)]

totx=c()
pmw=c()
molratio=c()
molratio2=c()
for(ij in c(1:nrow(formulations))){
  bx=descriptors[names%in%formulations[ij,]$A1,]
  ax=(bx$MW-2)*(formulations[ij,]$A1n+formulations[ij,]$A2n)
  bx=descriptors[names%in%formulations[ij,]$B,]
  fx=(bx$MW-2)*(formulations[ij,]$Bn)
  bx=descriptors[names%in%formulations[ij,]$T1,]
  t1x=bx$MW-1
  bx=descriptors[names%in%formulations[ij,]$T2,]
  t2x=bx$MW-1
  bx=descriptors[names%in%formulations[ij,]$D,]  
  dx=bx$MW
  
  dx2=0
  if(formulations[ij,]$D2 != "None"){
  bx2=descriptors[names%in%formulations[ij,]$D2,]  
  dx2=bx2$MW
  }
  
  fx3=0
  if(formulations[ij,]$B2 != "None"){  
  bx3=descriptors[names%in%formulations[ij,]$B2,]
  fx3=(bx3$MW-2)*(formulations[ij,]$B2n)
  }
  
  polmw=ax+fx+t1x+t2x+fx3
  pmw=append(pmw,polmw)
  
  molratio=append(molratio,((formulations[ij,]$DF/formulations[ij,]$PF)*polmw)/dx)
  
  if(formulations[ij,]$D2 != "None"){
  molratio2=append(molratio2,((formulations[ij,]$DF2/formulations[ij,]$PF)*polmw)/dx2)
  }
  if(formulations[ij,]$D2 == "None"){
  molratio2=append(molratio2,0)
  }
  
  totx=append(totx,(formulations[ij,]$A1n+formulations[ij,]$A2n+formulations[ij,]$Bn+2+molratio[ij]+molratio2[ij]))
}

am=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
bx=descriptors[names%in%formulations[ij,]$A1,]
bx=bx*((formulations[ij,]$A1n+formulations[ij,]$A2n)/totx[ij])
am=rbind(am,bx)
}
am=am[-1,]
for(ij in c(1:ncol(am))){
colnames(am)[ij]=paste0("ABLOCK_",colnames(am)[ij])
}

t1m=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  bx=descriptors[names%in%formulations[ij,]$T1,]
  bx=bx*(1/totx[ij])
  t1m=rbind(t1m,bx)
}
t1m=t1m[-1,]
for(ij in c(1:ncol(t1m))){
  colnames(t1m)[ij]=paste0("T1_",colnames(t1m)[ij])
}

t2m=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  bx=descriptors[names%in%formulations[ij,]$T2,]
  bx=bx*(1/totx[ij])
  t2m=rbind(t2m,bx)
}
t2m=t2m[-1,]
for(ij in c(1:ncol(t2m))){
  colnames(t2m)[ij]=paste0("T2_",colnames(t2m)[ij])
}

bm=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  bx=descriptors[names%in%formulations[ij,]$B,]
  
  bx3=0
  if(formulations[ij,]$B2 != "None"){  
    bx3=descriptors[names%in%formulations[ij,]$B2,]
  }
  
  bx=bx*((formulations[ij,]$Bn)/totx[ij])+bx3*((formulations[ij,]$B2n)/totx[ij])
  bm=rbind(bm,bx)
}
bm=bm[-1,]
for(ij in c(1:ncol(bm))){
  colnames(bm)[ij]=paste0("BBLOCK_",colnames(bm)[ij])
}

dm=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  bx=descriptors[names%in%formulations[ij,]$D,]
  
  bx=bx*(molratio[ij]/totx[ij])
  dm=rbind(dm,bx)
}
dm=dm[-1,]
for(ij in c(1:ncol(dm))){
  colnames(dm)[ij]=paste0("DRUG_",colnames(dm)[ij])
}

dm2=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  if(formulations[ij,]$D2 == "None"){  
    bx=rep(0,ncol(descriptors))
    names(bx)=colnames(descriptors)
  }
  if(formulations[ij,]$D2 != "None"){  
    bx=descriptors[names%in%formulations[ij,]$D2,]
    bx=bx*(molratio2[ij]/totx[ij])
  }
  dm2=rbind(dm2,bx)
}
dm2=dm2[-1,]
for(ij in c(1:ncol(dm2))){
  colnames(dm2)[ij]=paste0("DRUG2_",colnames(dm2)[ij])
}

totm=am+t1m+t2m+bm+dm+dm2
for(ij in c(1:ncol(totm))){
  colnames(totm)[ij]=paste0("MIX_",colnames(descriptors)[ij])
}

colnames(totm)=colnames(descriptors)
g=cbind(formulations,totm,am,bm,dm,dm2)

print(g)
write.csv(g,file=paste0("descp.csv"),row.names = F)
