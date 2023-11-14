descriptors=read.csv("descriptors.csv",sep="\t")

smi=read.csv("db_test.csv")
names=smi[,1]
formulations=read.csv("db_formulations.csv",dec=".",sep="\t")

formulations$MR1=(formulations$DF/formulations$DMW)/(formulations$PF/formulations$PMW)
formulations$POLFRAC=formulations$PMR/(formulations$PMR+formulations$MR1)
formulations$D1FRAC=formulations$MR1/(formulations$PMR+formulations$MR1)

formulations$Solvent[is.na(formulations$Solvent)]<-0
formulations$Temperature[is.na(formulations$Temperature)]<-0
formulations$Hydration[is.na(formulations$Hydration)]<-0
formulations$VOL[is.na(formulations$VOL)]<-0

descriptors=descriptors[ , purrr::map_lgl(descriptors, is.numeric)]
bbb=paste0(formulations$A1,"+",formulations$B,"+",formulations$A2,"+",formulations$D,"+",formulations$B2,"+",formulations$D2)

LC=rep(NA,nrow(formulations))
LE=rep(NA,nrow(formulations))
formulations=cbind(LC,formulations)
formulations=cbind(LE,formulations)

desc=read.csv("descrf.dat")[,1]
descriptors=descriptors[,colnames(descriptors)%in%desc]

am1=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  print(paste0("am1_",ij,"/",nrow(formulations)))
  bx=descriptors[names%in%formulations[ij,]$A1,]
  am1=rbind(am1,bx)
}
am1=am1[-1,]
for(ij in c(1:ncol(am1))){
colnames(am1)[ij]=paste0("ABLOCK1_",colnames(am1)[ij])
}

am2=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  print(paste0("am2_",ij,"/",nrow(formulations)))
  bx=descriptors[names%in%formulations[ij,]$A2,]
  am2=rbind(am2,bx)
}
am2=am2[-1,]
for(ij in c(1:ncol(am2))){
  colnames(am2)[ij]=paste0("ABLOCK2_",colnames(am2)[ij])
}

t1m=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  print(paste0("t1m_",ij,"/",nrow(formulations)))
  bx=descriptors[names%in%formulations[ij,]$T1,]
  t1m=rbind(t1m,bx)
}
t1m=t1m[-1,]
for(ij in c(1:ncol(t1m))){
  colnames(t1m)[ij]=paste0("T1_",colnames(t1m)[ij])
}

t2m=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  print(paste0("t2m_",ij,"/",nrow(formulations)))
  bx=descriptors[names%in%formulations[ij,]$T2,]
  t2m=rbind(t2m,bx)
}
t2m=t2m[-1,]
for(ij in c(1:ncol(t2m))){
  colnames(t2m)[ij]=paste0("T2_",colnames(t2m)[ij])
}

bm1=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  print(paste0("bm1_",ij,"/",nrow(formulations)))
  bx=descriptors[names%in%formulations[ij,]$B,]
  bm1=rbind(bm1,bx)
}
bm1=bm1[-1,]
for(ij in c(1:ncol(bm1))){
  colnames(bm1)[ij]=paste0("BBLOCK1_",colnames(bm1)[ij])
}
bm2=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  print(paste0("bm2_",ij,"/",nrow(formulations)))
  if(formulations[ij,]$B2 == "None"){
    bx=rep(0,ncol(descriptors))
    names(bx)=colnames(descriptors)
  }
  if(formulations[ij,]$B2 != "None"){
    bx=descriptors[names%in%formulations[ij,]$B2,]
  }
  bm2=rbind(bm2,bx)
}
bm2=bm2[-1,]
for(ij in c(1:ncol(bm2))){
  colnames(bm2)[ij]=paste0("BBLOCK2_",colnames(bm2)[ij])
}

dm=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  print(paste0("dm_",ij,"/",nrow(formulations)))
  bx=descriptors[names%in%formulations[ij,]$D,]
  dm=rbind(dm,bx)
}
dm=dm[-1,]
for(ij in c(1:ncol(dm))){
  colnames(dm)[ij]=paste0("DRUG_",colnames(dm)[ij])
}

dm2=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  print(paste0("dm2_",ij,"/",nrow(formulations)))
  if(formulations[ij,]$D2 == "None"){
    bx=rep(0,ncol(descriptors))
    names(bx)=colnames(descriptors)
  }
  if(formulations[ij,]$D2 != "None"){
    bx=descriptors[names%in%formulations[ij,]$D2,]
  }
  dm2=rbind(dm2,bx)
}
dm2=dm2[-1,]
for(ij in c(1:ncol(dm2))){
  colnames(dm2)[ij]=paste0("DRUG2_",colnames(dm2)[ij])
}

  totm=am1*formulations$A1n+am2*formulations$A2n+t1m+t2m+bm1*formulations$Bn+bm2*formulations$B2n+dm*formulations$MR1+dm2*formulations$MR2
  for(ij in c(1:ncol(totm))){
    colnames(totm)[ij]=paste0("MIX_",colnames(descriptors)[ij])
  }
  am=am1*formulations$A1n+am2*formulations$A2n
  for(ij in c(1:ncol(am))){
    colnames(am)[ij]=paste0("ABLOCK_",colnames(descriptors)[ij])
  }
  bm=bm1*formulations$Bn+bm2*formulations$B2n
  for(ij in c(1:ncol(bm))){
    colnames(bm)[ij]=paste0("BBLOCK_",colnames(descriptors)[ij])
  }
  dmx=dm*formulations$MR1
  for(ij in c(1:ncol(dmx))){
    colnames(dmx)[ij]=paste0("DRUG_",colnames(descriptors)[ij])
  }

rk_totm=totm[,c(grep("rdk5_", colnames(totm)),grep("rdk7_", colnames(totm)))]
rk_bm=bm[,c(grep("rdk5_", colnames(bm)),grep("rdk7_", colnames(bm)))]
rk_am=am[,c(grep("rdk5_", colnames(am)),grep("rdk7_", colnames(am)))]
rk_dmx=dmx[,c(grep("rdk5_", colnames(dmx)),grep("rdk7_", colnames(dmx)))]

g=cbind(formulations,rk_totm,rk_bm,rk_am,rk_dmx)
#g=g[,-c(5:9,16:19,20:22,24,26:28,32:35,38)]

gx=cbind(bbb,g)
colnames(gx)=c("Mixture",colnames(g))
write.csv(gx,file=paste0("testformulations.dat"),row.names = F)
