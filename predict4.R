#05
thr05_1=12.713983
thr05_2=12.399847
thr05_3=10.627242
thr05_4=6.175544
thr05_5=13.183467
thr05_6=13.243743
thr05_7=12.684053
thr05_8=12.868084
#1
thr1_1=16.439715
thr1_2=15.581986
thr1_3=13.381183
thr1_4=8.090294
thr1_5=17.161885
thr1_6=17.220897
thr1_7=16.592384
thr1_8=16.285579
#2
thr2_1=23.89118
thr2_2=21.94626
thr2_3=18.88907
thr2_4=11.91979
thr2_5=25.11872
thr2_6=25.17520
thr2_7=24.40905
thr2_8=23.12057
#3
thr3_1=31.34264
thr3_2=28.31054
thr3_3=24.39695
thr3_4=15.74929
thr3_5=33.07556
thr3_6=33.12951
thr3_7=32.22571
thr3_8=29.95556
#4
thr4_1=38.79411
thr4_2=34.67481
thr4_3=29.90483
thr4_4=19.57880
thr4_5=41.03239
thr4_6=41.08382
thr4_7=40.04237
thr4_8=36.79055

using<-function(...) {
    libs<-unlist(list(...))
    req<-unlist(lapply(libs,require,character.only=TRUE))
    need<-libs[req==FALSE]
    if(length(need)>0){ 
        install.packages(need)
        lapply(need,require,character.only=TRUE)
    }
}
using("caret","randomForest","kernlab","proxy","xgboost")

#library("caret")
#library("randomForest")
#library("kernlab")
#library("devtools")
#library("proxy")

#devtools::load_all("/mount/src/poxload/xgboost",helpers=FALSE,quiet=TRUE,export_all=FALSE)

load("model_final_LC10.rda")
m1=model
load("model_final_LC20.rda")
m2=model
load("model_final_LC30.rda")
m3=model
load("model_final_LC40.rda")
m4=model
load("model_final_LE20.rda")
m5=model
load("model_final_LE40.rda")
m6=model
load("model_final_LE60.rda")
m7=model
load("model_final_LE80.rda")
m8=model

af=read.csv("testformulations.dat",check.names = F)
afx=af

#ui=m1$trainingData[-1]
#afx2=afx[,colnames(afx)%in%colnames(ui)]
#Missing <- setdiff(colnames(ui), colnames(afx2))
#afx2[Missing] <- 0
#afx2 <- afx2[colnames(ui)]
#is.na(afx2)<-sapply(afx2, is.infinite)
#afx2[is.na(afx2)]<-0
#
#preproc <- preProcess(ui, method=c("center","scale","YeoJohnson"))
#uix <- predict(preproc, newdata = ui)
#z1=c()
#for(huh in 1:nrow(afx2)){
#  scaled.new <- predict(preproc, newdata = afx2[huh,])
#  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
#  aggg=abs(sort(aggg)[1:15])
#  aggg=mean(aggg,na.rm=T)
#  z1=append(z1,aggg)
#}

ui <- m1$trainingData[-1]
afx2 <- afx[, colnames(afx) %in% colnames(ui)]
Missing <- setdiff(colnames(ui), colnames(afx2))
afx2[Missing] <- 0
afx2 <- afx2[colnames(ui)]
is.na(afx2) <- sapply(afx2, is.infinite)
afx2[is.na(afx2)] <- 0

preproc <- preProcess(ui, method = c("center", "scale", "YeoJohnson"))
uix <- predict(preproc, newdata = ui)
scaled_new <- predict(preproc, newdata = afx2)

# Use proxy package for efficient distance calculation
distances <- proxy::dist(proxy::as.matrix(scaled_new), proxy::as.matrix(uix))

## Extract the distances for each row in afx2 and calculate the mean
#z1 <- sapply(1:nrow(afx2), function(huh) {
#  aggg = abs(sort(distances[huh, distances[huh, ] > 0])[1:15])
#  mean(aggg, na.rm = TRUE)
#})
agggsx=c()
for(uj in 1:nrow(afx2)){
  agggsx = append(agggsx,mean(abs(sort(distances[uj, distances[uj, ] > 0])[1:15]),na.rm=T))
}
z1=agggsx



al=unique(af$POL)
a=af$POL
c=af$D
ld=af$DF

a=as.data.frame(a)
a=cbind(a,c,ld)

b=as.character(unlist(predict(m1,newdata=afx2)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr4_1
b[gzy==FALSE]="AD"
a=cbind(a,b)



#ui=m2$trainingData[-1]
#afx2=afx[,colnames(afx)%in%colnames(ui)]
#Missing <- setdiff(colnames(ui), colnames(afx2))
#afx2[Missing] <- 0
#afx2 <- afx2[colnames(ui)]
#is.na(afx2)<-sapply(afx2, is.infinite)
#afx2[is.na(afx2)]<-0
#
#preproc <- preProcess(ui, method=c("center","scale","YeoJohnson"))
#uix <- predict(preproc, newdata = ui)
#z1=c()
#for(huh in 1:nrow(afx2)){
#  scaled.new <- predict(preproc, newdata = afx2[huh,])
#  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
#  aggg=abs(sort(aggg)[1:15])
#  aggg=mean(aggg,na.rm=T)
#  z1=append(z1,aggg)
#}

ui <- m2$trainingData[-1]
afx2 <- afx[, colnames(afx) %in% colnames(ui)]
Missing <- setdiff(colnames(ui), colnames(afx2))
afx2[Missing] <- 0
afx2 <- afx2[colnames(ui)]
is.na(afx2) <- sapply(afx2, is.infinite)
afx2[is.na(afx2)] <- 0

preproc <- preProcess(ui, method = c("center", "scale", "YeoJohnson"))
uix <- predict(preproc, newdata = ui)
scaled_new <- predict(preproc, newdata = afx2)

# Use proxy package for efficient distance calculation
distances <- proxy::dist(proxy::as.matrix(scaled_new), proxy::as.matrix(uix))

## Extract the distances for each row in afx2 and calculate the mean
#z1 <- sapply(1:nrow(afx2), function(huh) {
#  aggg = abs(sort(distances[huh, distances[huh, ] > 0])[1:15])
#  mean(aggg, na.rm = TRUE)
#})
agggsx=c()
for(uj in 1:nrow(afx2)){
  agggsx = append(agggsx,mean(abs(sort(distances[uj, distances[uj, ] > 0])[1:15]),na.rm=T))
}
z1=agggsx



b=as.character(unlist(predict(m2,newdata=afx2)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr4_2
b[gzy==FALSE]="AD"
a=cbind(a,b)





#ui=m3$trainingData[-1]
#afx2=afx[,colnames(afx)%in%colnames(ui)]
#Missing <- setdiff(colnames(ui), colnames(afx2))
#afx2[Missing] <- 0
#afx2 <- afx2[colnames(ui)]
#is.na(afx2)<-sapply(afx2, is.infinite)
#afx2[is.na(afx2)]<-0
#
#preproc <- preProcess(ui, method=c("center","scale","YeoJohnson"))
#uix <- predict(preproc, newdata = ui)
#z1=c()
#for(huh in 1:nrow(afx2)){
#  scaled.new <- predict(preproc, newdata = afx2[huh,])
#  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
#  aggg=abs(sort(aggg)[1:15])
#  aggg=mean(aggg,na.rm=T)
#  z1=append(z1,aggg)
#}

ui <- m3$trainingData[-1]
afx2 <- afx[, colnames(afx) %in% colnames(ui)]
Missing <- setdiff(colnames(ui), colnames(afx2))
afx2[Missing] <- 0
afx2 <- afx2[colnames(ui)]
is.na(afx2) <- sapply(afx2, is.infinite)
afx2[is.na(afx2)] <- 0

preproc <- preProcess(ui, method = c("center", "scale", "YeoJohnson"))
uix <- predict(preproc, newdata = ui)
scaled_new <- predict(preproc, newdata = afx2)

# Use proxy package for efficient distance calculation
distances <- proxy::dist(proxy::as.matrix(scaled_new), proxy::as.matrix(uix))

## Extract the distances for each row in afx2 and calculate the mean
#z1 <- sapply(1:nrow(afx2), function(huh) {
#  aggg = abs(sort(distances[huh, distances[huh, ] > 0])[1:15])
#  mean(aggg, na.rm = TRUE)
#})
agggsx=c()
for(uj in 1:nrow(afx2)){
  agggsx = append(agggsx,mean(abs(sort(distances[uj, distances[uj, ] > 0])[1:15]),na.rm=T))
}
z1=agggsx



b=as.character(unlist(predict(m3,newdata=afx2)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr4_3
b[gzy==FALSE]="AD"
a=cbind(a,b)



#ui=m4$trainingData[-1]
#afx2=afx[,colnames(afx)%in%colnames(ui)]
#Missing <- setdiff(colnames(ui), colnames(afx2))
#afx2[Missing] <- 0
#afx2 <- afx2[colnames(ui)]
#is.na(afx2)<-sapply(afx2, is.infinite)
#afx2[is.na(afx2)]<-0
#
#preproc <- preProcess(ui, method=c("center","scale","YeoJohnson"))
#uix <- predict(preproc, newdata = ui)
#z1=c()
#for(huh in 1:nrow(afx2)){
#  scaled.new <- predict(preproc, newdata = afx2[huh,])
#  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
#  aggg=abs(sort(aggg)[1:15])
#  aggg=mean(aggg,na.rm=T)
#  z1=append(z1,aggg)
#}

ui <- m4$trainingData[-1]
afx2 <- afx[, colnames(afx) %in% colnames(ui)]
Missing <- setdiff(colnames(ui), colnames(afx2))
afx2[Missing] <- 0
afx2 <- afx2[colnames(ui)]
is.na(afx2) <- sapply(afx2, is.infinite)
afx2[is.na(afx2)] <- 0

preproc <- preProcess(ui, method = c("center", "scale", "YeoJohnson"))
uix <- predict(preproc, newdata = ui)
scaled_new <- predict(preproc, newdata = afx2)

# Use proxy package for efficient distance calculation
distances <- proxy::dist(proxy::as.matrix(scaled_new), proxy::as.matrix(uix))

## Extract the distances for each row in afx2 and calculate the mean
#z1 <- sapply(1:nrow(afx2), function(huh) {
#  aggg = abs(sort(distances[huh, distances[huh, ] > 0])[1:15])
#  mean(aggg, na.rm = TRUE)
#})
agggsx=c()
for(uj in 1:nrow(afx2)){
  agggsx = append(agggsx,mean(abs(sort(distances[uj, distances[uj, ] > 0])[1:15]),na.rm=T))
}
z1=agggsx


b=as.character(unlist(predict(m4,newdata=afx2)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr4_4
b[gzy==FALSE]="AD"
a=cbind(a,b)


#ui=m5$trainingData[-1]
#afx2=afx[,colnames(afx)%in%colnames(ui)]
#Missing <- setdiff(colnames(ui), colnames(afx2))
#afx2[Missing] <- 0
#afx2 <- afx2[colnames(ui)]
#is.na(afx2)<-sapply(afx2, is.infinite)
#afx2[is.na(afx2)]<-0
#
#preproc <- preProcess(ui, method=c("center","scale","YeoJohnson"))
#uix <- predict(preproc, newdata = ui)
#z1=c()
#for(huh in 1:nrow(afx2)){
#  scaled.new <- predict(preproc, newdata = afx2[huh,])
#  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
#  aggg=abs(sort(aggg)[1:15])
#  aggg=mean(aggg,na.rm=T)
#  z1=append(z1,aggg)
#}

ui <- m5$trainingData[-1]
afx2 <- afx[, colnames(afx) %in% colnames(ui)]
Missing <- setdiff(colnames(ui), colnames(afx2))
afx2[Missing] <- 0
afx2 <- afx2[colnames(ui)]
is.na(afx2) <- sapply(afx2, is.infinite)
afx2[is.na(afx2)] <- 0

preproc <- preProcess(ui, method = c("center", "scale", "YeoJohnson"))
uix <- predict(preproc, newdata = ui)
scaled_new <- predict(preproc, newdata = afx2)

# Use proxy package for efficient distance calculation
distances <- proxy::dist(proxy::as.matrix(scaled_new), proxy::as.matrix(uix))

## Extract the distances for each row in afx2 and calculate the mean
#z1 <- sapply(1:nrow(afx2), function(huh) {
#  aggg = abs(sort(distances[huh, distances[huh, ] > 0])[1:15])
# mean(aggg, na.rm = TRUE)
#})
agggsx=c()
for(uj in 1:nrow(afx2)){
  agggsx = append(agggsx,mean(abs(sort(distances[uj, distances[uj, ] > 0])[1:15]),na.rm=T))
}
z1=agggsx



b=as.character(unlist(predict(m5,newdata=afx2)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr4_5
b[gzy==FALSE]="AD"
a=cbind(a,b)



#ui=m6$trainingData[-1]
#afx2=afx[,colnames(afx)%in%colnames(ui)]
#Missing <- setdiff(colnames(ui), colnames(afx2))
#afx2[Missing] <- 0
#afx2 <- afx2[colnames(ui)]
#is.na(afx2)<-sapply(afx2, is.infinite)
#afx2[is.na(afx2)]<-0
#
#preproc <- preProcess(ui, method=c("center","scale","YeoJohnson"))
#uix <- predict(preproc, newdata = ui)
#z1=c()
#for(huh in 1:nrow(afx2)){
#  scaled.new <- predict(preproc, newdata = afx2[huh,])
#  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
#  aggg=abs(sort(aggg)[1:15])
#  aggg=mean(aggg,na.rm=T)
#  z1=append(z1,aggg)
#}

ui <- m6$trainingData[-1]
afx2 <- afx[, colnames(afx) %in% colnames(ui)]
Missing <- setdiff(colnames(ui), colnames(afx2))
afx2[Missing] <- 0
afx2 <- afx2[colnames(ui)]
is.na(afx2) <- sapply(afx2, is.infinite)
afx2[is.na(afx2)] <- 0

preproc <- preProcess(ui, method = c("center", "scale", "YeoJohnson"))
uix <- predict(preproc, newdata = ui)
scaled_new <- predict(preproc, newdata = afx2)

# Use proxy package for efficient distance calculation
distances <- proxy::dist(proxy::as.matrix(scaled_new), proxy::as.matrix(uix))

## Extract the distances for each row in afx2 and calculate the mean
#z1 <- sapply(1:nrow(afx2), function(huh) {
#  aggg = abs(sort(distances[huh, distances[huh, ] > 0])[1:15])
#  mean(aggg, na.rm = TRUE)
#})
agggsx=c()
for(uj in 1:nrow(afx2)){
  agggsx = append(agggsx,mean(abs(sort(distances[uj, distances[uj, ] > 0])[1:15]),na.rm=T))
}
z1=agggsx


b=as.character(unlist(predict(m6,newdata=afx2)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr4_6
b[gzy==FALSE]="AD"
a=cbind(a,b)




#ui=m7$trainingData[-1]
#afx2=afx[,colnames(afx)%in%colnames(ui)]
#Missing <- setdiff(colnames(ui), colnames(afx2))
#afx2[Missing] <- 0
#afx2 <- afx2[colnames(ui)]
#is.na(afx2)<-sapply(afx2, is.infinite)
#afx2[is.na(afx2)]<-0
#
#preproc <- preProcess(ui, method=c("center","scale","YeoJohnson"))
#uix <- predict(preproc, newdata = ui)
#z1=c()
#for(huh in 1:nrow(afx2)){
#  scaled.new <- predict(preproc, newdata = afx2[huh,])
#  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
#  aggg=abs(sort(aggg)[1:15])
#  aggg=mean(aggg,na.rm=T)
#  z1=append(z1,aggg)
#}

ui <- m7$trainingData[-1]
afx2 <- afx[, colnames(afx) %in% colnames(ui)]
Missing <- setdiff(colnames(ui), colnames(afx2))
afx2[Missing] <- 0
afx2 <- afx2[colnames(ui)]
is.na(afx2) <- sapply(afx2, is.infinite)
afx2[is.na(afx2)] <- 0

preproc <- preProcess(ui, method = c("center", "scale", "YeoJohnson"))
uix <- predict(preproc, newdata = ui)
scaled_new <- predict(preproc, newdata = afx2)

# Use proxy package for efficient distance calculation
distances <- proxy::dist(proxy::as.matrix(scaled_new), proxy::as.matrix(uix))

## Extract the distances for each row in afx2 and calculate the mean
#z1 <- sapply(1:nrow(afx2), function(huh) {
#  aggg = abs(sort(distances[huh, distances[huh, ] > 0])[1:15])
#  mean(aggg, na.rm = TRUE)
#})
agggsx=c()
for(uj in 1:nrow(afx2)){
  agggsx = append(agggsx,mean(abs(sort(distances[uj, distances[uj, ] > 0])[1:15]),na.rm=T))
}
z1=agggsx



b=as.character(unlist(predict(m7,newdata=afx2)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr4_7
b[gzy==FALSE]="AD"
a=cbind(a,b)


#ui=m8$trainingData[-1]
#afx2=afx[,colnames(afx)%in%colnames(ui)]
#Missing <- setdiff(colnames(ui), colnames(afx2))
#afx2[Missing] <- 0
#afx2 <- afx2[colnames(ui)]
#is.na(afx2)<-sapply(afx2, is.infinite)
#afx2[is.na(afx2)]<-0
#
#preproc <- preProcess(ui, method=c("center","scale","YeoJohnson"))
#uix <- predict(preproc, newdata = ui)
#z1=c()
#for(huh in 1:nrow(afx2)){
#  scaled.new <- predict(preproc, newdata = afx2[huh,])
#  aggg=as.matrix(dist(rbind(scaled.new,uix)))[1,-1]
#  aggg=abs(sort(aggg)[1:15])
#  aggg=mean(aggg,na.rm=T)
#  z1=append(z1,aggg)
#}

ui <- m8$trainingData[-1]
afx2 <- afx[, colnames(afx) %in% colnames(ui)]
Missing <- setdiff(colnames(ui), colnames(afx2))
afx2[Missing] <- 0
afx2 <- afx2[colnames(ui)]
is.na(afx2) <- sapply(afx2, is.infinite)
afx2[is.na(afx2)] <- 0

preproc <- preProcess(ui, method = c("center", "scale", "YeoJohnson"))
uix <- predict(preproc, newdata = ui)
scaled_new <- predict(preproc, newdata = afx2)

# Use proxy package for efficient distance calculation
distances <- proxy::dist(proxy::as.matrix(scaled_new), proxy::as.matrix(uix))

## Extract the distances for each row in afx2 and calculate the mean
#z1 <- sapply(1:nrow(afx2), function(huh) {
#  aggg = abs(sort(distances[huh, distances[huh, ] > 0])[1:15])
#  mean(aggg, na.rm = TRUE)
#})
agggsx=c()
for(uj in 1:nrow(afx2)){
  agggsx = append(agggsx,mean(abs(sort(distances[uj, distances[uj, ] > 0])[1:15]),na.rm=T))
}
z1=agggsx


b=as.character(unlist(predict(m8,newdata=afx2)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr4_8
b[gzy==FALSE]="AD"
a=cbind(a,b)

ck=t(apply(a, 1, function(u) table(factor(u, levels=c("X1","X0","AD")))))
a=cbind(a,ck[,1])

         
colnames(a)=c("POL","D","DF","LC10","LC20","LC30","LC40","LE20","LE40","LE60","LE80","Passed")
a=a[with(a, order(DF, D, POL)),]
write.csv(a,"fin_results.csv",row.names=F)
         
a[a[,3]=="X0",3]=0
a[a[,3]=="X1",3]=19
a[a[,3]=="AD",3]=0
a[a[,4]=="X0",4]=0
a[a[,4]=="X1",4]=29
a[a[,4]=="AD",4]=0
a[a[,5]=="X0",5]=0
a[a[,5]=="X1",5]=39
a[a[,5]=="AD",5]=0
a[a[,6]=="X0",6]=0
a[a[,6]=="X1",6]=44.5
a[a[,6]=="AD",6]=0
a[a[,7]=="X0",7]=0
a[a[,7]=="X1",7]=39
a[a[,7]=="AD",7]=0
a[a[,8]=="X0",8]=0
a[a[,8]=="X1",8]=59
a[a[,8]=="AD",8]=0
a[a[,9]=="X0",9]=0
a[a[,9]=="X1",9]=79
a[a[,9]=="AD",9]=0           
a[a[,10]=="X0",10]=0
a[a[,10]=="X1",10]=100
a[a[,10]=="AD",10]=0           
           
fg1=as.matrix(a[,c(3:6)])
fg2=as.matrix(a[,c(7:10)])

get_last_non_zero <- function(vec) {
  last_non_zero <- 0
  consecutive_zeros <- 0
  
  for (element in vec) {
    if (element == 0) {
      consecutive_zeros <- consecutive_zeros + 1
    } else {
      if (consecutive_zeros > 1) {
        return(last_non_zero)
      }
      last_non_zero <- element
      consecutive_zeros <- 0
    }
  }
  
  return(last_non_zero)
}


# Apply the function to each row of the dataframe
last_non_zero_elements <- apply(fg1, 1, get_last_non_zero)

# Create a new dataframe with the last non-zero elements
fg1 <- data.frame(LastNonZero = last_non_zero_elements)

# Apply the function to each row of the dataframe
last_non_zero_elements <- apply(fg2, 1, get_last_non_zero)

# Create a new dataframe with the last non-zero elements
fg2 <- data.frame(LastNonZero = last_non_zero_elements)
          
a=cbind(a[,1],a[,2],a[,3],fg1,fg2)
colnames(a)=c("POL","D","DF","LC","LE")
write.csv(a,"fin_results2.csv",row.names=F)

#a=cbind(a[,1],a[,2],(as.numeric(a[,4])/100)*as.numeric(a[,2]))
#colnames(a)=c("POL","DF","SD")
#write.csv(a,"fin_results3.csv",row.names=F)


