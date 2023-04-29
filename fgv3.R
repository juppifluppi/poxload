library("caret")
af=read.csv("formulations3test_db.csv",sep="\t")
af2=read.csv("descp.csv")
afx=cbind(af,af2)
ui=read.csv("startdatayyy.dat",check.names = F)
afx=afx[,colnames(afx)%in%colnames(ui)]
Missing <- setdiff(colnames(ui), colnames(afx))
afx[Missing] <- 0
afx <- afx[colnames(ui)]

a=af$POL
a=as.data.frame(a)

load("m1w.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m2w.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m3w.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m35w.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m4w.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m5w.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m6w.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m7w.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m75w.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

load("m8w.rda")
b=unlist(predict(final_model,newdata=afx))
a=cbind(a,b)

colnames(a)=c("POL","LC10","LC20","LC30","LC35","LC40","LE20","LE40","LE60","LE70","LE80")
write.csv(a,"fin_results.csv",row.names=F)
