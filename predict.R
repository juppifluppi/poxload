library("caret")

fda=read.csv("fdaset.dat")
fg=rep(10,nrow(fda))
fz=rep(0,nrow(fda))
fda=cbind(fda,fg)
colnames(fda)[ncol(fda)]="formulations.DF"
fda=cbind(fda,fz)
colnames(fda)[ncol(fda)]="formulations.Time"

fx=predict(final_model[["cubist"]],fda,na.action=na.pass)
print(fx)
