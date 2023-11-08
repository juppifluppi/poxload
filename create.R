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

load("alt_model1.rda")
m1=model
load("alt_model2.rda")
m2=model
load("alt_model3.rda")
m3=model
load("alt_model4.rda")
m4=model
load("alt_model5.rda")
m5=model
load("alt_model6.rda")
m6=model
load("alt_model7.rda")
m7=model
load("alt_model8.rda")
m8=model

#ref=c(colnames(m1$trainingData)[-1],colnames(m2$trainingData)[-1],colnames(m3$trainingData)[-1],colnames(m4$trainingData)[-1],colnames(m5$trainingData)[-1],colnames(m6$trainingData)[-1],colnames(m7$trainingData)[-1],colnames(m8$trainingData)[-1])
ref=c(colnames(m1$trainingData)[-1],colnames(m4$trainingData)[-1],colnames(m5$trainingData)[-1],colnames(m6$trainingData)[-1],colnames(m7$trainingData)[-1])
refnames=paste(sapply(strsplit(ref,"_"), "[[", 2),sapply(strsplit(ref,"_"), "[[", 3),sep = "_")

ref2=c(colnames(m2$trainingData)[-1],colnames(m3$trainingData)[-1],colnames(m8$trainingData)[-1])
ref2=sub("^.*?_", "", colnames(ref2))
ref2=append(ref2,"MW")

ref=unique(c(ref,ref2))
ref=ref[!(ref%in%colnames(formulations))]

descriptors=descriptors[,colnames(descriptors)%in%refnames]

totx=c()
pmw=c()
molratio=c()
molratio2=c()
for(ij in c(1:nrow(formulations))){
  print(paste0("mol_",ij,"/",nrow(formulations)))
  bx=descriptors[names%in%formulations[ij,]$A1,]
  ax=(bx$MW-2-14)*(formulations[ij,]$A1n)
  bx=descriptors[names%in%formulations[ij,]$A2,]
  ax2=(bx$MW-2-14)*(formulations[ij,]$A2n)
  bx=descriptors[names%in%formulations[ij,]$B,]
  fx=(bx$MW-2-14)*(formulations[ij,]$Bn)
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
  fx3=(bx3$MW-2-14)*(formulations[ij,]$B2n)
  }

  polmw=ax+fx+t1x+t2x+fx3+ax2
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

amxxx1=c()
am1=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  print(paste0("am1_",ij,"/",nrow(formulations)))
  bx=descriptors[names%in%formulations[ij,]$A1,]
  amxxx1=append(amxxx1,((formulations[ij,]$A1n)/totx[ij]))
  am1=rbind(am1,bx)
}
am1=am1[-1,]
for(ij in c(1:ncol(am1))){
colnames(am1)[ij]=paste0("ABLOCK1_",colnames(am1)[ij])
}

amxxx2=c()
am2=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  print(paste0("am2_",ij,"/",nrow(formulations)))
  bx=descriptors[names%in%formulations[ij,]$A2,]
  amxxx2=append(amxxx2,((formulations[ij,]$A2n)/totx[ij]))
  am2=rbind(am2,bx)
}
am2=am2[-1,]
for(ij in c(1:ncol(am2))){
  colnames(am2)[ij]=paste0("ABLOCK2_",colnames(am2)[ij])
}

t1mxxx=c()
t1m=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  print(paste0("t1m_",ij,"/",nrow(formulations)))
  bx=descriptors[names%in%formulations[ij,]$T1,]
  t1mxxx=append(t1mxxx,(1/totx[ij]))
  t1m=rbind(t1m,bx)
}
t1m=t1m[-1,]
for(ij in c(1:ncol(t1m))){
  colnames(t1m)[ij]=paste0("T1_",colnames(t1m)[ij])
}

t2mxxx=c()
t2m=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  print(paste0("t2m_",ij,"/",nrow(formulations)))
  bx=descriptors[names%in%formulations[ij,]$T2,]
  t2mxxx=append(t2mxxx,(1/totx[ij]))
  t2m=rbind(t2m,bx)
}
t2m=t2m[-1,]
for(ij in c(1:ncol(t2m))){
  colnames(t2m)[ij]=paste0("T2_",colnames(t2m)[ij])
}

bmxxx1=c()
bm1=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  print(paste0("bm1_",ij,"/",nrow(formulations)))
  bx=descriptors[names%in%formulations[ij,]$B,]
  bmxxx1=append(bmxxx1,((formulations[ij,]$Bn)/totx[ij]))
  bm1=rbind(bm1,bx)
}
bm1=bm1[-1,]
for(ij in c(1:ncol(bm1))){
  colnames(bm1)[ij]=paste0("BBLOCK1_",colnames(bm1)[ij])
}
bmxxx2=c()
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
  bmxxx2=append(bmxxx2,((formulations[ij,]$B2n)/totx[ij]))
  bm2=rbind(bm2,bx)
}
bm2=bm2[-1,]
for(ij in c(1:ncol(bm2))){
  colnames(bm2)[ij]=paste0("BBLOCK2_",colnames(bm2)[ij])
}

dmxxx=c()
dm=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  print(paste0("dm_",ij,"/",nrow(formulations)))
  bx=descriptors[names%in%formulations[ij,]$D,]
  dmxxx=append(dmxxx,(molratio[ij]/totx[ij]))
  dm=rbind(dm,bx)
}
dm=dm[-1,]
for(ij in c(1:ncol(dm))){
  colnames(dm)[ij]=paste0("DRUG_",colnames(dm)[ij])
}

dm2xxx=c()
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
  dm2xxx=append(dm2xxx,(molratio2[ij]/totx[ij]))
  dm2=rbind(dm2,bx)
}
dm2=dm2[-1,]
for(ij in c(1:ncol(dm2))){
  colnames(dm2)[ij]=paste0("DRUG2_",colnames(dm2)[ij])
}

  totm=am1*amxxx1+am2*amxxx2+t1m*t1mxxx+t2m*t2mxxx+bm1*bmxxx1+bm2*bmxxx2+dm*dmxxx+dm2*dm2xxx
  for(ij in c(1:ncol(totm))){
    colnames(totm)[ij]=paste0("MIX_",colnames(descriptors)[ij])
  }
  bm=bm1*(bmxxx1/(bmxxx1+bmxxx2))+bm2*(bmxxx2/(bmxxx1+bmxxx2))
  for(ij in c(1:ncol(bm))){
    is.nan.data.frame <- function(x)
      do.call(cbind, lapply(x, is.nan))
    bm[is.nan(bm)] <- 0
    colnames(bm)[ij]=paste0("BBLOCK_",colnames(descriptors)[ij])
  }
  am=am1*(amxxx1/(amxxx1+amxxx2))+am2*(amxxx1/(amxxx1+amxxx2))
  for(ij in c(1:ncol(am))){
    colnames(am)[ij]=paste0("ABLOCK_",colnames(descriptors)[ij])
  }
  dmx=dm
  for(ij in c(1:ncol(dmx))){
    colnames(dmx)[ij]=paste0("DRUG_",colnames(descriptors)[ij])
  }

mr_totm=totm[,-c(grep("rdk5_", colnames(totm)),grep("rdk7_", colnames(totm)))]
mr_bm=bm[,-c(grep("rdk5_", colnames(bm)),grep("rdk7_", colnames(bm)))]
mr_am=am[,-c(grep("rdk5_", colnames(am)),grep("rdk7_", colnames(am)))]
mr_dmx=dmx[,-c(grep("rdk5_", colnames(dmx)),grep("rdk7_", colnames(dmx)))]

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

g=cbind(formulations,mr_totm,mr_bm,mr_am,mr_dmx,rk_totm,rk_bm,rk_am,rk_dmx)
g=g[,-c(4:9,16:19,20:22,24,26:28,32:35,38)]

gx=cbind(bbb,g)
colnames(gx)=c("Mixture",colnames(g))
write.csv(gx,file=paste0("testformulations.dat"),row.names = F)
