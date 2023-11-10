dr=read.csv("db_test.csv")
formulations=read.csv("db_smiles3.csv")

formulations$DF=8
formulations$D2="None"
formulations$DF2=0
formulations$DRUGNAME2="None"
formulations$SD2="None"
formulations$DMW2=0
formulations$MR2=0
formulations$D2FRAC=0

full=rep(NA,ncol(formulations))

for(k in c(2,4,6,8,10)){

  formulations$DF=k
  
for(i in nrow(dr)){
  fillx=formulations
  fillx$Source=dr[i,colnames(dr)%in%"NAME"]
  fillx$D=dr[i,colnames(dr)%in%"NAME"]
  fillx$DMW=dr[i,colnames(dr)%in%"MW"]
  fillx$DRUGNAME1=dr[i,colnames(dr)%in%"NAME"]
  fillx$MR1=(fillx$DF/fillx$DMW)/(fillx$PF/fillx$PMW)
  if(dr[1,colnames(dr)%in%"NAME"] != "MeOx"){
  fillx$DF2=XXXX
  fillx$D2=dr[1,colnames(dr)%in%"NAME"]
  fillx$DRUGNAME2=dr[1,colnames(dr)%in%"NAME"]
  fillx$DMW2=dr[1,colnames(dr)%in%"MW"]
  fillx$MR2=(fillx$DF2/fillx$DMW2)/(fillx$PF/fillx$PMW)
  }
  fillx$POLFRAC=fillx$PMR/(fillx$PMR+fillx$MR1+fillx$MR2)
  fillx$D1FRAC=fillx$MR1/(fillx$PMR+fillx$MR1+fillx$MR2)  
  if(dr[1,colnames(dr)%in%"NAME"] != "MeOx"){
  fillx$D2FRAC=fillx$MR2/(fillx$PMR+fillx$MR1+fillx$MR2)
  } 
  full=rbind(full,fillx)
}
}
colnames(full)=colnames(formulations)
full=full[-1,]

write.table(full,file="db_formulations.csv",row.names = F,sep="\t",quote=F)
