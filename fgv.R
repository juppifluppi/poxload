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

#devtools::load_all('xgboost',helpers=FALSE,quiet=TRUE,export_all=FALSE)

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
a[a[,3]=="X1",3]=20
a[a[,4]=="X0",4]=0
a[a[,4]=="X1",4]=30
a[a[,5]=="X0",5]=0
a[a[,5]=="X1",5]=40
a[a[,6]=="X0",6]=0
a[a[,6]=="X1",6]=50
a[a[,7]=="X0",7]=0
a[a[,7]=="X1",7]=20
a[a[,8]=="X0",8]=0
a[a[,8]=="X1",8]=40
a[a[,9]=="X0",9]=0
a[a[,9]=="X1",9]=80
a[a[,10]=="X0",10]=0
a[a[,10]=="X1",10]=100
           
fg1=as.matrix(a[,c(3:6)])
fg2=as.matrix(a[,c(7:10)])
print(fg2)
         
find_last_nonzero_before_first_zero <- function(matrix) {
  result <- vector("numeric", length = nrow(matrix))
  
  for (i in 1:nrow(matrix)) {
    row <- matrix[i, ]
    last_nonzero <- NA
    
    for (j in 1:(length(row) - 1)) {
      if (row[j] != 0) {
        last_nonzero <- row[j]
      } else if (!is.na(last_nonzero)) {
        result[i] <- last_nonzero
      }
    }
    
    if (is.na(result[i])) {
      # If the loop didn't find a zero, return the last non-zero element
      result[i] <- last_nonzero
    }
  }
  
  return(result)
}
fg1 <- find_last_nonzero_before_first_zero(fg1)
fg2 <- find_last_nonzero_before_first_zero(fg2)           
a=cbind(a[,1],a[,2],fg1,fg2)
print(a)
colnames(a)=c("POL","DF","LC","LE")
write.csv(a,"fin_results2.csv",row.names=F)

#a=cbind(a[,1],a[,2],(as.numeric(a[,4])/100)*as.numeric(a[,2]))
#colnames(a)=c("POL","DF","SD")
#write.csv(a,"fin_results3.csv",row.names=F)
