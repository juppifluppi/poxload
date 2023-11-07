#2
thr1_3=9999
thr2_3=9999
thr3_3=9999
thr35_3=9999
thr4_3=9999
thr5_3=9999
thr6_3=9999
thr7_3=9999
thr75_3=9999
thr8_3=9999

library("caret")
library("randomForest")

load("model1.rda")
m1=model
load("model2.rda")
m2=model
load("model3.rda")
m3=model
load("model4.rda")
m4=model
load("model5.rda")
m5=model
load("model6.rda")
m6=model
load("model7.rda")
m7=model
load("model8.rda")
m8=model

af=read.csv("db_formulations.csv",sep="\t")
af2=read.csv("descriptors_rdk7.csv")

afx=cbind(af,af2)

ui=read.csv("startdatayyyxmod_rdk2.dat",check.names = F)
ui=ui[,colnames(ui)%in%colnames(m1$trainingData)]
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



load("model1.rda")
b=as.character(unlist(predict(model,newdata=afx2)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr1_3
b[gzy==FALSE]="AD"
a=cbind(a,b)



ui=read.csv("startdatayyyxmod_rdk2.dat",check.names = F)
ui=ui[,colnames(ui)%in%colnames(m2$trainingData)]
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

load("model2.rda")
b=as.character(unlist(predict(model,newdata=afx2)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr2_3
b[gzy==FALSE]="AD"
a=cbind(a,b)





ui=read.csv("startdatayyyxmod_rdk2.dat",check.names = F)
ui=ui[,colnames(ui)%in%colnames(m3$trainingData)]
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

load("model3.rda")
b=as.character(unlist(predict(model,newdata=afx2)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr3_3
b[gzy==FALSE]="AD"
a=cbind(a,b)


ui=read.csv("startdatayyyxmod_rdk2.dat",check.names = F)
ui=ui[,colnames(ui)%in%colnames(m4$trainingData)]
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

load("model4.rda")
b=as.character(unlist(predict(model,newdata=afx2)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr4_3
b[gzy==FALSE]="AD"
a=cbind(a,b)

ui=read.csv("startdatayyyxmod_rdk2.dat",check.names = F)
ui=ui[,colnames(ui)%in%colnames(m5$trainingData)]
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

load("model5.rda")
b=as.character(unlist(predict(model,newdata=afx2)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr5_3
b[gzy==FALSE]="AD"
a=cbind(a,b)

ui=read.csv("startdatayyyxmod_rdk2.dat",check.names = F)
ui=ui[,colnames(ui)%in%colnames(m6$trainingData)]
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

load("model6.rda")
b=as.character(unlist(predict(model,newdata=afx2)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr6_3
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

ui=read.csv("startdatayyyxmod_rdk2.dat",check.names = F)
ui=ui[,colnames(ui)%in%colnames(m7$trainingData)]
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

load("model7.rda")
b=as.character(unlist(predict(model,newdata=afx2)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr7_3
b[gzy==FALSE]="AD"
a=cbind(a,b)

ui=read.csv("startdatayyyxmod_rdk2.dat",check.names = F)
ui=ui[,colnames(ui)%in%colnames(m8$trainingData)]
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

load("model8.rda")
b=as.character(unlist(predict(model,newdata=afx2)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr8_3
b[gzy==FALSE]="AD"
a=cbind(a,b)

ck=t(apply(a, 1, function(u) table(factor(u, levels=c("X1","X0","AD")))))
a=cbind(a,ck[,1])
           
colnames(a)=c("POL","LC10","LC20","LC30","LC40","LE20","LE40","LE60","LE80","Passed")
write.csv(a,"fin_results.csv",row.names=F)
