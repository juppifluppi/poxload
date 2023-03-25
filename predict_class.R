library("caret")
load("treebag_reduced.rda")

fda=read.csv("fdaset.dat")

fg=rep(10,nrow(fda))
fz=rep(0,nrow(fda))
fda=cbind(fda,fg)

colnames(fda)[ncol(fda)]="formulations.DF"
fda=cbind(fda,fz)
colnames(fda)[ncol(fda)]="formulations.Time"

axb=fda$POL    
           
fx=predict(final_model[["treebag"]],fda,na.action=na.pass,type="prob")$X1
fx=round(fx,0)
iji=cbind(axb,fx)

fda$formulations.DF=rep(8,nrow(fda))
fx=predict(final_model[["treebag"]],fda,na.action=na.pass,type="prob")$X1
fx=round(fx,0)
iji=cbind(iji,fx)

fda$formulations.DF=rep(6,nrow(fda))
fx=predict(final_model[["treebag"]],fda,na.action=na.pass,type="prob")$X1
fx=round(fx,0)
iji=cbind(iji,fx)

fda$formulations.DF=rep(4,nrow(fda))
fx=predict(final_model[["treebag"]],fda,na.action=na.pass,type="prob")$X1
fx=round(fx,0)
iji=cbind(iji,fx)

fda$formulations.DF=rep(2,nrow(fda))
fx=predict(final_model[["treebag"]],fda,na.action=na.pass,type="prob")$X1
fx=round(fx,0)
iji=cbind(iji,fx)

iji=iji[-c(20,26),]

colnames(iji)=c("Polymer","LE10","LE8","LE6","LE4","LE2")
write.csv(iji,"fx.csv",row.names=F)
