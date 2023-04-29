library("caret")
af=read.csv("formulations3test_db.csv",sep="\t")
af2=read.csv("descp.csv")
af3=read.csv("sirms_test.txt",check.names = F)
colnames(af3)[1]="Mixture"
afx=cbind(af,af2,af3)
ui=read.csv("startdatayyy6.dat",check.names = F)
afx=afx[,colnames(afx)%in%colnames(ui)]
Missing <- setdiff(colnames(ui), colnames(afx))
afx[Missing] <- 0
afx <- afx[colnames(ui)]

a=af$POL
a=as.data.frame(a)

load("m1v.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m2v.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m3v.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m35v.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m4v.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m5v.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m6v.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m7v.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m75v.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m8v.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

colnames(a)=c("POL","LC10","LC20","LC30","LC35","LC40","LE20","LE40","LE60","LE70","LE80")
write.csv(a,"fin_results.csv",row.names=F)
