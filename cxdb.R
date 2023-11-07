dr=read.csv("descriptors_rdk7.csv",check.names = F,sep = "\t")
test=read.csv("db_test.csv")
fill=read.csv("db_smiles.csv")
dr=cbind(test,dr)

fill$DF=8
fill$D2="None"
fill$DF2=0
fill$DRUGNAME2="None"
fill$SD2="None"
fill$DMW2=0
fill$MR2=0
fill$D2FRAC=0

full=rep(NA,ncol(fill))

for(i in c(1:nrow(dr))){
  fillx=fill
  fillx$Source=dr[i,colnames(dr)%in%"NAME"]
  fillx$D=dr[i,colnames(dr)%in%"NAME"]
  fillx$DMW=dr[i,colnames(dr)%in%"MW"]
  fillx$DRUGNAME1=dr[i,colnames(dr)%in%"NAME"]
  fillx$MR1=(fillx$DF/fillx$DMW)/(fillx$PF/fillx$PMW)
  fillx$POLFRAC=fillx$PMR/(fillx$PMR+fillx$MR1)
  fillx$D1FRAC=fillx$MR1/(fillx$PMR+fillx$MR1)
  full=rbind(full,fillx)
}
colnames(full)=colnames(fill)
full=full[-1,]

write.table(full,file="db_formulations.csv",row.names = F,sep="\t",quote=F)
