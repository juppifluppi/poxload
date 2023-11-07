descriptors=read.csv("descriptors_rdk7.csv",sep="\t")

smi=read.csv("db_test.csv")
names=smi[,1]
formulations=read.csv("db_formulations.csv",dec=".",sep="\t")
print(colnames(formulations))
#formulations$Solvent[is.na(formulations$Solvent)]<-0
#formulations$Temperature[is.na(formulations$Temperature)]<-0
#formulations$Hydration[is.na(formulations$Hydration)]<-0
#formulations$VOL[is.na(formulations$VOL)]<-0

#formulations=na.omit(formulations)

descriptors=descriptors[ , purrr::map_lgl(descriptors, is.numeric)]
bbb=paste0(formulations$A1,"+",formulations$B,"+",formulations$A2,"+",formulations$D,"+",formulations$B2,"+",formulations$D2)

LC=rep(0,nrow(formulations))
LE=rep(0,nrow(formulations))
formulations=cbind(LC,formulations)
formulations=cbind(LE,formulations)

load("model1.rda")
m1=model
load("model2.rda")
m2=model
load("model3.rda")
m3=model
load("model4.rda")
m4=model
load("model5.rda")
m5=model
load("model6.rda")
m6=model
load("model7.rda")
m7=model
load("model8.rda")
m8=model

#ref=c(colnames(m1$trainingData)[-1],colnames(m2$trainingData)[-1],colnames(m3$trainingData)[-1],colnames(m4$trainingData)[-1],colnames(m5$trainingData)[-1],colnames(m6$trainingData)[-1],colnames(m7$trainingData)[-1],colnames(m8$trainingData)[-1])
#ref=unique(ref)
#ref=ref[!(ref%in%colnames(formulations))]
#refnames=paste(sapply(strsplit(ref,"_"), "[[", 2),sapply(strsplit(ref,"_"), "[[", 3),sep = "_")
#descriptors=descriptors[,colnames(descriptors)%in%refnames]

print(colnames(formulations))
am1=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  bx=descriptors[names%in%formulations[ij,]$A1,]
  am1=rbind(am1,bx)
}
am1=am1[-1,]
for(ij in c(1:ncol(am1))){
colnames(am1)[ij]=paste0("ABLOCK1_",colnames(am1)[ij])
}

am2=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  bx=descriptors[names%in%formulations[ij,]$A2,]
  am2=rbind(am2,bx)
}
am2=am2[-1,]
for(ij in c(1:ncol(am2))){
  colnames(am2)[ij]=paste0("ABLOCK2_",colnames(am2)[ij])
}

t1m=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  bx=descriptors[names%in%formulations[ij,]$T1,]
  t1m=rbind(t1m,bx)
}
t1m=t1m[-1,]
for(ij in c(1:ncol(t1m))){
  colnames(t1m)[ij]=paste0("T1_",colnames(t1m)[ij])
}

t2m=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  bx=descriptors[names%in%formulations[ij,]$T2,]
  t2m=rbind(t2m,bx)
}
t2m=t2m[-1,]
for(ij in c(1:ncol(t2m))){
  colnames(t2m)[ij]=paste0("T2_",colnames(t2m)[ij])
}

bm1=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  bx=descriptors[names%in%formulations[ij,]$B,]
  bm1=rbind(bm1,bx)
}
bm1=bm1[-1,]
for(ij in c(1:ncol(bm1))){
  colnames(bm1)[ij]=paste0("BBLOCK1_",colnames(bm1)[ij])
}

bm2=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
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
  bx=descriptors[names%in%formulations[ij,]$D,]
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

g=cbind(formulations,totm,bm,am,dmx)
print(colnames(g))
g=g[,-c(4:9,16:19,20:22,24,26:28,32:35,38)]

#gx=cbind(bbb,g)
#colnames(gx)=c("Mixture",colnames(g))
#print(colnames(g))
write.csv(g,file=paste0("testformulations.dat"),row.names = F)
