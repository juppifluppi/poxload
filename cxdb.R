dr=read.csv("db_molstest.csv")
formulations=read.csv("smiles3.csv",dec=".")
fill=read.csv("smiles3.csv")

fill$DF=8
fill$D2="None"
fill$DF2=0
fill$DRUGNAME2="None"
fill$DMW2=0
fill$MR2=0
fill$D2FRAC=0

#fill=fill[fill$POL%in%c("A-nPrOzi-A","A-nBuOx-A","A-nBuOzi-A","A-PentOx-A"),]

full=rep(NA,ncol(fill))

for(i in c(1:nrow(dr))){
  fillx=fill
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

write.table(full,file="formulations3test_db.csv",row.names = F,sep="\t",quote=F)
