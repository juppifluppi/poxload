library("dplyr")
padel=read.csv("descriptors_padel_fda.csv")
padelpol=read.csv("descriptors_padel_pol.csv")
mordred=read.csv("descriptors_mordred_fda.csv")
mordredpol=read.csv("descriptors_mordred_pol.csv")

x=(padel[c(((nrow(padel)/2)+1):(nrow(padel))),1])
x=c("Drug",x)
names(x)=c("Name",(padel[c(1:(nrow(padel)/2)),1]))
padelpol=padelpol[,colnames(padelpol)%in%names(x)]

padel=rbind(x,padelpol)

x=(mordred[c(((nrow(mordred)/2)+1):(nrow(mordred))),1])
x=c("Drug",x)
names(x)=c("Name",(mordred[c(1:(nrow(mordred)/2)),1]))
mordredpol=mordredpol[,colnames(mordredpol)%in%names(x)]

#mordred=mordred[mordred$Name%in%padel$Name,]
#padel=padel[padel$Name%in%mordred$Name,]

mordred=rbind(x,mordredpol)

#mordred=mordred[,-1]
descriptors=cbind(padel,mordred)
#descriptors=padel



names=descriptors[,1]

#nums <- unlist(lapply(descriptors, is.numeric), use.names = FALSE)  
#print(descriptors[ , nums])

#descriptors=(as.matrix(descriptors))
#descriptors=descriptors[, sapply(descriptors, class) == "numeric"]
#descriptors <- descriptors %>% dplyr::select(where(is.numeric))
#descriptors=select_if(descriptors, is.numeric)
#descriptors=descriptors[ , purrr::map_lgl(descriptors, is.numeric)]
compounds="Drug"

descriptors[] <- lapply(descriptors, function(x) as.numeric(as.character(x)))
descriptors=descriptors[ , colSums(is.na(descriptors))==0]

                    
print(descriptors[names%in%formulations[1,]$D,colnames(descriptors)%in%"MW"])                
                    
                        
wholeset=rep(NA,ncol(descriptors))
olo=0
for(kj in compounds){
olo=olo+1
  
formulations=read.csv("formulations.csv",dec=",")
formulations$D=kj

#print(descriptors[names%in%formulations[1,]$D,])    
  
am=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  bx=descriptors[names%in%formulations[ij,]$A1,]
  bx=bx*(formulations[ij,]$A1n+formulations[ij,]$A2n)
  t1x=descriptors[names%in%formulations[ij,]$T1,]
  t2x=descriptors[names%in%formulations[ij,]$T2,]
  bx=bx+t1x+t2x
  am=rbind(am,bx)
}
am=am[-1,]
for(ij in c(1:ncol(am))){
  colnames(am)[ij]=paste0("ABLOCK_",colnames(am)[ij])
}


bm=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  bx=descriptors[names%in%formulations[ij,]$B,]
  bx=bx*(formulations[ij,]$Bn)
  bm=rbind(bm,bx)
}
bm=bm[-1,]
for(ij in c(1:ncol(bm))){
  colnames(bm)[ij]=paste0("BBLOCK_",colnames(bm)[ij])
}

molratio=c()
for(ij in c(1:nrow(formulations))){
  bx=descriptors[names%in%formulations[ij,]$A1,]
  ax=bx$MW*(formulations[ij,]$A1n+formulations[ij,]$A1n)
  bx=descriptors[names%in%formulations[ij,]$B,]
  fx=bx$MW*(formulations[ij,]$Bn)
  bx=descriptors[names%in%formulations[ij,]$T1,]
  t1x=bx$MW
  bx=descriptors[names%in%formulations[ij,]$T2,]
  t2x=bx$MW
  polmw=ax+fx+t1x+t2x
  bx=descriptors[names%in%formulations[ij,]$D,]  
  dx=as.numeric(as.character(bx$MW))
  print(ax)
  print(fx)
  print(t1x)
  print(t2x)
  print(dx)
  molratio=append(molratio,((formulations[ij,]$DF/formulations[ij,]$PF)*polmw)/dx)
}

  
dm=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  bx=descriptors[names%in%formulations[ij,]$D,]
  bx=bx*molratio[ij]
  dm=rbind(dm,bx)
}
dm=dm[-1,]
for(ij in c(1:ncol(dm))){
  colnames(dm)[ij]=paste0("DRUG_",colnames(dm)[ij])
}

g=cbind(formulations,am,bm,dm)
wholeset=rbind(wholeset,g)
}
wholeset=wholeset[-1,]
write.csv(wholeset,file=paste0("fdaset.dat"),row.names = F)
