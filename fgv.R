thr1_3=6.14126
thr2_3=6.946449
thr3_3=6.661318
thr35_3=6.251726
thr4_3=6.067827
thr5_3=6.259835
thr6_3=6.299993
thr7_3=6.334116
thr75_3=6.268914
thr8_3=6.622144

library("caret")
library("randomForest")
library("e1071")
library("foreach")

library("devtools")

# load package w/o installing
devtools::load_all('import')

af=read.csv("formulations3test_db.csv",sep="\t")
af2=read.csv("descp.csv")
af3=read.csv("sirms_test.txt",check.names = F)
colnames(af3)[1]="Mixture"
afx=cbind(af,af2,af3)

ui=read.csv("startdatayyymod.dat",check.names = F)
afx2=afx[,colnames(afx)%in%colnames(ui)]
Missing <- setdiff(colnames(ui), colnames(afx2))
afx2[Missing] <- 0
afx2 <- afx2[colnames(ui)]
is.na(afx2)<-sapply(afx2, is.infinite)
afx2[is.na(afx2)]<-0

preproc <- preProcess(ui, method=c("center","scale"))
uix <- predict(preproc, newdata = ui)
z1=c()
for(huh in 1:nrow(afx2)){
  scaled.new <- predict(preproc, newdata = afx2[huh,])
  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
  aggg=abs(sort(aggg)[1:14])
  aggg=mean(aggg,na.rm=T)
  z1=append(z1,aggg)
}

a=af$POL
a=as.data.frame(a)

load("xgb_m1w.rda")
b=unlist(predict(final_model,newdata=afx2))
gzy=z1<thr1_3
b[gzy==FALSE]="AD"
a=cbind(a,b)

load("xgb_m2w.rda")
b=unlist(predict(final_model,newdata=afx2))
gzy=z1<thr2_3
b[gzy==FALSE]="AD"
a=cbind(a,b)

ui=read.csv("startdatayyy6mod.dat",check.names = F)
afx2=afx[,colnames(afx)%in%colnames(ui)]
Missing <- setdiff(colnames(ui), colnames(afx2))
afx2[Missing] <- 0
afx2 <- afx2[colnames(ui)]
is.na(afx2)<-sapply(afx2, is.infinite)
afx2[is.na(afx2)]<-0

preproc <- preProcess(ui, method=c("center","scale"))
uix <- predict(preproc, newdata = ui)
z1=c()
for(huh in 1:nrow(afx2)){
  scaled.new <- predict(preproc, newdata = afx2[huh,])
  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
  aggg=abs(sort(aggg)[1:14])
  aggg=mean(aggg,na.rm=T)
  z1=append(z1,aggg)
}

load("xgb_m3v.rda")
b=unlist(predict(final_model,newdata=afx2))
gzy=z1<thr3_3
b[gzy==FALSE]="AD"
a=cbind(a,b)

ui=read.csv("startdatayyy7mod.dat",check.names = F)
afx2=afx[,colnames(afx)%in%colnames(ui)]
Missing <- setdiff(colnames(ui), colnames(afx2))
afx2[Missing] <- 0
afx2 <- afx2[colnames(ui)]
is.na(afx2)<-sapply(afx2, is.infinite)
afx2[is.na(afx2)]<-0

preproc <- preProcess(ui, method=c("center","scale"))
uix <- predict(preproc, newdata = ui)
z1=c()
for(huh in 1:nrow(afx2)){
  scaled.new <- predict(preproc, newdata = afx2[huh,])
  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
  aggg=abs(sort(aggg)[1:14])
  aggg=mean(aggg,na.rm=T)
  z1=append(z1,aggg)
}

load("xgb_m35j.rda")
b=unlist(predict(final_model,newdata=afx2))
gzy=z1<thr35_3
b[gzy==FALSE]="AD"
a=cbind(a,b)

ui=read.csv("startdatayyymod.dat",check.names = F)
afx2=afx[,colnames(afx)%in%colnames(ui)]
Missing <- setdiff(colnames(ui), colnames(afx2))
afx2[Missing] <- 0
afx2 <- afx2[colnames(ui)]
is.na(afx2)<-sapply(afx2, is.infinite)
afx2[is.na(afx2)]<-0

preproc <- preProcess(ui, method=c("center","scale"))
uix <- predict(preproc, newdata = ui)
z1=c()
for(huh in 1:nrow(afx2)){
  scaled.new <- predict(preproc, newdata = afx2[huh,])
  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
  aggg=abs(sort(aggg)[1:14])
  aggg=mean(aggg,na.rm=T)
  z1=append(z1,aggg)
}

load("xgb_m4w.rda")
b=unlist(predict(final_model,newdata=afx2))
gzy=z1<thr4_3
b[gzy==FALSE]="AD"
a=cbind(a,b)

ui=read.csv("startdatayyy6mod.dat",check.names = F)
afx2=afx[,colnames(afx)%in%colnames(ui)]
Missing <- setdiff(colnames(ui), colnames(afx2))
afx2[Missing] <- 0
afx2 <- afx2[colnames(ui)]
is.na(afx2)<-sapply(afx2, is.infinite)
afx2[is.na(afx2)]<-0

preproc <- preProcess(ui, method=c("center","scale"))
uix <- predict(preproc, newdata = ui)
z1=c()
for(huh in 1:nrow(afx2)){
  scaled.new <- predict(preproc, newdata = afx2[huh,])
  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
  aggg=abs(sort(aggg)[1:14])
  aggg=mean(aggg,na.rm=T)
  z1=append(z1,aggg)
}

load("xgb_m5v.rda")
b=unlist(predict(final_model,newdata=afx2))
gzy=z1<thr5_3
b[gzy==FALSE]="AD"
a=cbind(a,b)

load("xgb_m6v.rda")
b=unlist(predict(final_model,newdata=afx2))
gzy=z1<thr6_3
b[gzy==FALSE]="AD"
a=cbind(a,b)

preproc <- preProcess(ui, method=c("center","scale"))
uix <- predict(preproc, newdata = ui)
z1=c()
for(huh in 1:nrow(afx2)){
  scaled.new <- predict(preproc, newdata = afx2[huh,])
  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
  aggg=abs(sort(aggg)[1:14])
  aggg=mean(aggg,na.rm=T)
  z1=append(z1,aggg)
}

ui=read.csv("startdatayyy7mod.dat",check.names = F)
afx2=afx[,colnames(afx)%in%colnames(ui)]
Missing <- setdiff(colnames(ui), colnames(afx2))
afx2[Missing] <- 0
afx2 <- afx2[colnames(ui)]
is.na(afx2)<-sapply(afx2, is.infinite)
afx2[is.na(afx2)]<-0

preproc <- preProcess(ui, method=c("center","scale"))
uix <- predict(preproc, newdata = ui)
z1=c()
for(huh in 1:nrow(afx2)){
  scaled.new <- predict(preproc, newdata = afx2[huh,])
  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
  aggg=abs(sort(aggg)[1:14])
  aggg=mean(aggg,na.rm=T)
  z1=append(z1,aggg)
}

load("xgb_m7j.rda")
b=unlist(predict(final_model,newdata=afx2))
gzy=z1<thr7_3
b[gzy==FALSE]="AD"
a=cbind(a,b)

load("xgb_m75j.rda")
b=unlist(predict(final_model,newdata=afx2))
gzy=z1<thr75_3
b[gzy==FALSE]="AD"
a=cbind(a,b)

ui=read.csv("startdatayyy6mod.dat",check.names = F)
afx2=afx[,colnames(afx)%in%colnames(ui)]
Missing <- setdiff(colnames(ui), colnames(afx2))
afx2[Missing] <- 0
afx2 <- afx2[colnames(ui)]
is.na(afx2)<-sapply(afx2, is.infinite)
afx2[is.na(afx2)]<-0

preproc <- preProcess(ui, method=c("center","scale"))
uix <- predict(preproc, newdata = ui)
z1=c()
for(huh in 1:nrow(afx2)){
  scaled.new <- predict(preproc, newdata = afx2[huh,])
  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
  aggg=abs(sort(aggg)[1:14])
  aggg=mean(aggg,na.rm=T)
  z1=append(z1,aggg)
}

load("xgb_m8v.rda")
b=unlist(predict(final_model,newdata=afx2))
gzy=z1<thr8_3
b[gzy==FALSE]="AD"
a=cbind(a,b)

colnames(a)=c("POL","LC10","LC20","LC30","LC35","LC40","LE20","LE40","LE60","LE70","LE80")
a
write.csv(a,"fin_results.csv",row.names=F)
