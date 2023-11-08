#2
thr1_3=9999999
thr2_3=9999999
thr3_3=9999999
thr35_3=9999999
thr4_3=9999999
thr5_3=9999999
thr6_3=9999999
thr7_3=9999999
thr75_3=999999
thr8_3=9999999
gzy=99

library("caret")
library("randomForest")
library("kernlab")
library("devtools")

devtools::load_all('xgboost')

load("model_LC10.rda")
m1=model
load("model_LC20.rda")
m2=model
load("model_LC30.rda")
m3=model
load("model_LC40.rda")
m4=model
load("model_LE20.rda")
m5=model
load("model_LE40.rda")
m6=model
load("model_LE60.rda")
m7=model
load("model_LE80.rda")
m8=model

af=read.csv("testformulations.dat",check.names = F)
afx=af
#uix=read.csv("startdatayyyxmod_rdk2.dat",check.names = F)

#ui=m1$trainingData[-1]
#afx2=afx[,colnames(afx)%in%colnames(ui)]
#Missing <- setdiff(colnames(ui), colnames(afx2))
#afx2[Missing] <- 0
#afx2 <- afx2[colnames(ui)]
#is.na(afx2)<-sapply(afx2, is.infinite)
#afx2[is.na(afx2)]<-0
#
#preproc <- preProcess(ui, method=c("center","scale"))
#uix <- predict(preproc, newdata = ui)
#z1=c()
#for(huh in 1:nrow(afx2)){
#  scaled.new <- predict(preproc, newdata = afx2[huh,])
#  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
#  aggg=abs(sort(aggg)[1:14])
#  aggg=mean(aggg,na.rm=T)
#  z1=append(z1,aggg)
#}

al=unique(af$POL)
a=af$POL
ld=af$DF
#print(a)
a=as.data.frame(a)
a=cbind(a,ld)

b=as.character(unlist(predict(m1,newdata=afx)))
#gzy=as.numeric(unlist(as.vector(z1)))
#gzy=gzy<thr1_3
#b[gzy==FALSE]="AD"
a=cbind(a,b)



#ui=m2$trainingData[-1]
#afx2=afx[,colnames(afx)%in%colnames(ui)]
#Missing <- setdiff(colnames(ui), colnames(afx2))
#afx2[Missing] <- 0
#afx2 <- afx2[colnames(ui)]
#is.na(afx2)<-sapply(afx2, is.infinite)
#afx2[is.na(afx2)]<-0
#
#preproc <- preProcess(ui, method=c("center","scale"))
#uix <- predict(preproc, newdata = ui)
#z1=c()
#for(huh in 1:nrow(afx2)){
#  scaled.new <- predict(preproc, newdata = afx2[huh,])
#  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
#  aggg=abs(sort(aggg)[1:14])
#  aggg=mean(aggg,na.rm=T)
#  z1=append(z1,aggg)
#}

b=as.character(unlist(predict(m2,newdata=afx)))
#gzy=as.numeric(unlist(as.vector(z1)))
#gzy=gzy<thr2_3
#b[gzy==FALSE]="AD"
a=cbind(a,b)





#ui=m3$trainingData[-1]
#afx2=afx[,colnames(afx)%in%colnames(ui)]
#Missing <- setdiff(colnames(ui), colnames(afx2))
#afx2[Missing] <- 0
#afx2 <- afx2[colnames(ui)]
#is.na(afx2)<-sapply(afx2, is.infinite)
#afx2[is.na(afx2)]<-0
#
#preproc <- preProcess(ui, method=c("center","scale"))
#uix <- predict(preproc, newdata = ui)
#z1=c()
#for(huh in 1:nrow(afx2)){
#  scaled.new <- predict(preproc, newdata = afx2[huh,])
#  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
#  aggg=abs(sort(aggg)[1:14])
#  aggg=mean(aggg,na.rm=T)
#  z1=append(z1,aggg)
#}
#
b=as.character(unlist(predict(m3,newdata=afx)))
#gzy=as.numeric(unlist(as.vector(z1)))
#gzy=gzy<thr3_3
#b[gzy==FALSE]="AD"
a=cbind(a,b)



#ui=m4$trainingData[-1]
#afx2=afx[,colnames(afx)%in%colnames(ui)]
#Missing <- setdiff(colnames(ui), colnames(afx2))
#afx2[Missing] <- 0
#afx2 <- afx2[colnames(ui)]
#is.na(afx2)<-sapply(afx2, is.infinite)
#afx2[is.na(afx2)]<-0
#
#preproc <- preProcess(ui, method=c("center","scale"))
#uix <- predict(preproc, newdata = ui)
#z1=c()
#for(huh in 1:nrow(afx2)){
#  scaled.new <- predict(preproc, newdata = afx2[huh,])
#  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
#  aggg=abs(sort(aggg)[1:14])
#  aggg=mean(aggg,na.rm=T)
#  z1=append(z1,aggg)
#}
#

b=as.character(unlist(predict(m4,newdata=afx)))
#gzy=as.numeric(unlist(as.vector(z1)))
#gzy=gzy<thr4_3
#b[gzy==FALSE]="AD"
a=cbind(a,b)


#ui=m5$trainingData[-1]
#afx2=afx[,colnames(afx)%in%colnames(ui)]
#Missing <- setdiff(colnames(ui), colnames(afx2))
#afx2[Missing] <- 0
#afx2 <- afx2[colnames(ui)]
#is.na(afx2)<-sapply(afx2, is.infinite)
#afx2[is.na(afx2)]<-0
#
#preproc <- preProcess(ui, method=c("center","scale"))
#uix <- predict(preproc, newdata = ui)
#z1=c()
#for(huh in 1:nrow(afx2)){
#  scaled.new <- predict(preproc, newdata = afx2[huh,])
#  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
#  aggg=abs(sort(aggg)[1:14])
#  aggg=mean(aggg,na.rm=T)
#  z1=append(z1,aggg)
#}

b=as.character(unlist(predict(m5,newdata=afx)))
#gzy=as.numeric(unlist(as.vector(z1)))
#gzy=gzy<thr5_3
#b[gzy==FALSE]="AD"
a=cbind(a,b)



#ui=m6$trainingData[-1]
#afx2=afx[,colnames(afx)%in%colnames(ui)]
#Missing <- setdiff(colnames(ui), colnames(afx2))
#afx2[Missing] <- 0
#afx2 <- afx2[colnames(ui)]
#is.na(afx2)<-sapply(afx2, is.infinite)
#afx2[is.na(afx2)]<-0
#
#preproc <- preProcess(ui, method=c("center","scale"))
#uix <- predict(preproc, newdata = ui)
#z1=c()
#for(huh in 1:nrow(afx2)){
#  scaled.new <- predict(preproc, newdata = afx2[huh,])
#  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
#  aggg=abs(sort(aggg)[1:14])
#  aggg=mean(aggg,na.rm=T)
#  z1=append(z1,aggg)
#}


b=as.character(unlist(predict(m6,newdata=afx)))
#gzy=as.numeric(unlist(as.vector(z1)))
#gzy=gzy<thr6_3
#b[gzy==FALSE]="AD"
a=cbind(a,b)

#preproc <- preProcess(ui, method=c("center","scale"))
#uix <- predict(preproc, newdata = ui)
#z1=c()
#for(huh in 1:nrow(afx2)){
#  scaled.new <- predict(preproc, newdata = afx2[huh,])
#  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
#  aggg=abs(sort(aggg)[1:14])
#  aggg=mean(aggg,na.rm=T)
#  z1=append(z1,aggg)
#}


#ui=m7$trainingData[-1]
#afx2=afx[,colnames(afx)%in%colnames(ui)]
#Missing <- setdiff(colnames(ui), colnames(afx2))
#afx2[Missing] <- 0
#afx2 <- afx2[colnames(ui)]
#is.na(afx2)<-sapply(afx2, is.infinite)
#afx2[is.na(afx2)]<-0

#preproc <- preProcess(ui, method=c("center","scale"))
#uix <- predict(preproc, newdata = ui)
#z1=c()
#for(huh in 1:nrow(afx2)){
#  scaled.new <- predict(preproc, newdata = afx2[huh,])
#  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
#  aggg=abs(sort(aggg)[1:14])
#  aggg=mean(aggg,na.rm=T)
#  z1=append(z1,aggg)
#}

b=as.character(unlist(predict(m7,newdata=afx)))
#gzy=as.numeric(unlist(as.vector(z1)))
#gzy=gzy<thr7_3
#b[gzy==FALSE]="AD"
a=cbind(a,b)


#ui=m8$trainingData[-1]
#afx2=afx[,colnames(afx)%in%colnames(ui)]
#Missing <- setdiff(colnames(ui), colnames(afx2))
#afx2[Missing] <- 0
#afx2 <- afx2[colnames(ui)]
#is.na(afx2)<-sapply(afx2, is.infinite)
#afx2[is.na(afx2)]<-0

#preproc <- preProcess(ui, method=c("center","scale"))
#uix <- predict(preproc, newdata = ui)
#z1=c()
#for(huh in 1:nrow(afx2)){
#  scaled.new <- predict(preproc, newdata = afx2[huh,])
#  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
#  aggg=abs(sort(aggg)[1:14])
#  aggg=mean(aggg,na.rm=T)
#  z1=append(z1,aggg)
#}

b=as.character(unlist(predict(m8,newdata=afx)))
#gzy=as.numeric(unlist(as.vector(z1)))
#gzy=gzy<thr8_3
#b[gzy==FALSE]="AD"
a=cbind(a,b)

ck=t(apply(a, 1, function(u) table(factor(u, levels=c("X1","X0")))))
a=cbind(a,ck[,1])

         
colnames(a)=c("POL","DF","LC10","LC20","LC30","LC40","LE20","LE40","LE60","LE80","Passed")
a=a[with(a, order(DF, POL)),]
write.csv(a,"fin_results.csv",row.names=F)

b=a
         
a[a[,3]=="X0",3]=0
a[a[,3]=="X1",3]=10
a[a[,4]=="X0",4]=0
a[a[,4]=="X1",4]=20
a[a[,5]=="X0",5]=0
a[a[,5]=="X1",5]=30
a[a[,6]=="X0",6]=0
a[a[,6]=="X1",6]=40
a[a[,7]=="X0",7]=0
a[a[,7]=="X1",7]=20
a[a[,8]=="X0",8]=0
a[a[,8]=="X1",8]=40
a[a[,9]=="X0",9]=0
a[a[,9]=="X1",9]=60
a[a[,10]=="X0",10]=0
a[a[,10]=="X1",10]=80

b[b[,3]=="X0",3]=0
b[b[,3]=="X1",3]=20
b[b[,4]=="X0",4]=0
b[b[,4]=="X1",4]=30
b[b[,5]=="X0",5]=0
b[b[,5]=="X1",5]=40
b[b[,6]=="X0",6]=0
b[b[,6]=="X1",6]=50
b[b[,7]=="X0",7]=0
b[b[,7]=="X1",7]=40
b[b[,8]=="X0",8]=0
b[b[,8]=="X1",8]=60
b[b[,9]=="X0",9]=0
b[b[,9]=="X1",9]=80
b[b[,10]=="X0",10]=0
b[b[,10]=="X1",10]=100

fg1=a[,c(3:6)]
fg2=a[,c(7:10)]
fg3=b[,c(3:6)]
fg4=b[,c(7:10)]

a=a[,c(1,2,apply(fg1, 1, max),apply(fg2, 1, max))]
b=b[,c(1,2,apply(fg3, 1, max),apply(fg4, 1, max))]
colnames(a)=c("POL","DF","LC","LE")
colnames(b)=c("POL","DF","LC","LE")
write.csv(a,"fin_results2.csv",row.names=F)
write.csv(b,"fin_results3.csv",row.names=F)
