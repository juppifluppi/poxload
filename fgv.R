library("caret")
af=read.csv("formulations3test_db.csv",sep="\t")
af2=read.csv("descp.csv")
af3=read.csv("sirms_test.txt",check.names = F)
colnames(af3)[1]="Mixture"
afx=cbind(af,af2,af3)
ui=read.csv("startdatayyy3.dat",check.names = F)
afx=afx[,colnames(afx)%in%colnames(ui)]
Missing <- setdiff(colnames(ui), colnames(afx))
afx[Missing] <- 0
afx <- afx[colnames(ui)]

a=af$POL
a=as.data.frame(a)

load("m1.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m2.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m3.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m4.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m5.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m6.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m7.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m8.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

print(a)

colnames(a)=c("POL","LC10","LC20","LC30","LC40","LE20","LE40","LE60","LE80")
write.csv(a,"fin_results.csv",row.names=F)
