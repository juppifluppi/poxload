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

devtools::load_all('xgboost',helpers=FALSE,quiet=TRUE,export_all=FALSE)

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
         
a[a[,3]=="X0",3]=0
a[a[,3]=="X1",3]=19
a[a[,4]=="X0",4]=0
a[a[,4]=="X1",4]=29
a[a[,5]=="X0",5]=0
a[a[,5]=="X1",5]=39
a[a[,6]=="X0",6]=0
a[a[,6]=="X1",6]=50
a[a[,7]=="X0",7]=0
a[a[,7]=="X1",7]=19
a[a[,8]=="X0",8]=0
a[a[,8]=="X1",8]=39
a[a[,9]=="X0",9]=0
a[a[,9]=="X1",9]=69
a[a[,10]=="X0",10]=0
a[a[,10]=="X1",10]=99
           
fg1=as.data.frame(a[,c(3:6)])
fg2=as.data.frame(a[,c(7:10)])

## Function to get the last non-zero element before the first zero
#getLastNonZeroBeforeFirstZero <- function(row) {
#  first_zero_index <- which(row == 0)[1]  # Find the index of the first zero
#  if (is.na(first_zero_index)) {
#    return(tail(row, 1))  # If there's no zero, return the last element
#  } else {
#    last_non_zero_index <- max(which(row[1:first_zero_index - 1] != 0))
#    if (!is.na(last_non_zero_index)) {
#      return(row[last_non_zero_index])
#    } else {
#      return(0)  # If there are no non-zero elements before the first zero
#    }
#  }
#}

getLastNonZeroBeforeFirstZero <- function(row) {
  first_zero_index <- which(row == 0)[1]  # Find the index of the first zero

  if (is.na(first_zero_index)) {
    return(tail(row, 1))  # If there's no zero, return the last element
  }

  # Check if there are at least two consecutive zero elements before the first zero
  if (sum(diff(which(row == 0)) == 1) >= 2) {
    last_non_zero_index <- max(which(row[1:first_zero_index - 1] != 0))
  
    if (!is.na(last_non_zero_index)) {
      return(row[last_non_zero_index])
    }
  }
  return(0)  # If there are no non-zero elements before the first zero
}

           
fg1=apply(fg1, 1, getLastNonZeroBeforeFirstZero)
fg2=apply(fg2, 1, getLastNonZeroBeforeFirstZero)
#fg1[!is.finite(fg1)]<-0
#fg2[!is.finite(fg2)]<-0           
a=cbind(a[,1],a[,2],fg1,fg2)
colnames(a)=c("POL","DF","LC","LE")
write.csv(a,"fin_results2.csv",row.names=F)

#a=cbind(a[,1],a[,2],(as.numeric(a[,4])/100)*as.numeric(a[,2]))
#colnames(a)=c("POL","DF","SD")
#write.csv(a,"fin_results3.csv",row.names=F)
