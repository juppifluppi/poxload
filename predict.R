library("caret")
devtools::load_all("Cubist")
load("cubist.rda")

fda=read.csv("fdaset.dat")

fg=rep(10,nrow(fda))
fz=rep(0,nrow(fda))
fda=cbind(fda,fg)

colnames(fda)[ncol(fda)]="formulations.DF"
fda=cbind(fda,fz)
colnames(fda)[ncol(fda)]="formulations.Time"

axb=fda$POL

#for(i in c(1:ncol(fda))){
#  fda[,i]=(as.numeric(as.character(fda[,i]))
#}

print(fda[1,])           
           
fx=predict(final_model[["cubist"]],fda,na.action=na.pass)
iji=cbind(axb,fx)
colnames(iji)=c("Polymer","LE (%)")
write.csv(iji,"fx.csv",row.names=F)
