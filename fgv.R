#05
thr05_1=12.713983
thr05_2=12.540893
thr05_3=10.051199
thr05_4=6.991115
thr05_5=13.183467
thr05_6=11.724952
thr05_7=11.724952
thr05_8=11.724952
#1
thr1_1=16.439715
thr1_2=16.183039
thr1_3=13.146608
thr1_4=9.215794
thr1_5=17.161885
thr1_6=15.094306
thr1_7=15.094306
thr1_8=15.094306
#2
thr2_1=23.89118
thr2_2=23.46733
thr2_3=19.33742
thr2_4=13.66515
thr2_5=25.11872
thr2_6=21.83301
thr2_7=21.83301
thr2_8=21.83301

library("caret")
library("randomForest")
library("kernlab")
library("devtools")
library("Matrix")
library("proxy")

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

# Extract the distances for each row in afx2 and calculate the mean
z1 <- sapply(1:nrow(afx2), function(huh) {
  aggg = abs(sort(distances[huh, ])[1:15])
  mean(aggg, na.rm = TRUE)
})



al=unique(af$POL)
a=af$POL
ld=af$DF

a=as.data.frame(a)
a=cbind(a,ld)

print(z1)

b=as.character(unlist(predict(m1,newdata=afx)))
gzy=as.numeric(unlist(as.vector(z1)))
print(gzy)
gzy=gzy<thr2_1
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

# Extract the distances for each row in afx2 and calculate the mean
z1 <- sapply(1:nrow(afx2), function(huh) {
  aggg = abs(sort(distances[huh, ])[1:15])
  mean(aggg, na.rm = TRUE)
})



b=as.character(unlist(predict(m2,newdata=afx)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr2_2
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

# Extract the distances for each row in afx2 and calculate the mean
z1 <- sapply(1:nrow(afx2), function(huh) {
  aggg = abs(sort(distances[huh, ])[1:15])
  mean(aggg, na.rm = TRUE)
})



b=as.character(unlist(predict(m3,newdata=afx)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr2_3
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

# Extract the distances for each row in afx2 and calculate the mean
z1 <- sapply(1:nrow(afx2), function(huh) {
  aggg = abs(sort(distances[huh, ])[1:15])
  mean(aggg, na.rm = TRUE)
})


b=as.character(unlist(predict(m4,newdata=afx)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr2_4
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

# Extract the distances for each row in afx2 and calculate the mean
z1 <- sapply(1:nrow(afx2), function(huh) {
  aggg = abs(sort(distances[huh, ])[1:15])
  mean(aggg, na.rm = TRUE)
})



b=as.character(unlist(predict(m5,newdata=afx)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr2_5
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

# Extract the distances for each row in afx2 and calculate the mean
z1 <- sapply(1:nrow(afx2), function(huh) {
  aggg = abs(sort(distances[huh, ])[1:15])
  mean(aggg, na.rm = TRUE)
})


b=as.character(unlist(predict(m6,newdata=afx)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr2_6
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

# Extract the distances for each row in afx2 and calculate the mean
z1 <- sapply(1:nrow(afx2), function(huh) {
  aggg = abs(sort(distances[huh, ])[1:15])
  mean(aggg, na.rm = TRUE)
})



b=as.character(unlist(predict(m7,newdata=afx)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr2_7
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

# Extract the distances for each row in afx2 and calculate the mean
z1 <- sapply(1:nrow(afx2), function(huh) {
  aggg = abs(sort(distances[huh, ])[1:15])
  mean(aggg, na.rm = TRUE)
})


b=as.character(unlist(predict(m8,newdata=afx)))
gzy=as.numeric(unlist(as.vector(z1)))
gzy=gzy<thr2_8
b[gzy==FALSE]="AD"
a=cbind(a,b)

ck=t(apply(a, 1, function(u) table(factor(u, levels=c("X1","X0","AD")))))
a=cbind(a,ck[,1])

         
colnames(a)=c("POL","DF","LC10","LC20","LC30","LC40","LE20","LE40","LE60","LE80","Passed")
a=a[with(a, order(DF, POL)),]
write.csv(a,"fin_results.csv",row.names=F)
         
a[a[,3]=="X0",3]=0
a[a[,3]=="X1",3]=20
a[a[,3]=="AD",3]=0
a[a[,4]=="X0",4]=0
a[a[,4]=="X1",4]=30
a[a[,4]=="AD",4]=0
a[a[,5]=="X0",5]=0
a[a[,5]=="X1",5]=40
a[a[,5]=="AD",5]=0
a[a[,6]=="X0",6]=0
a[a[,6]=="X1",6]=50
a[a[,6]=="AD",6]=0
a[a[,7]=="X0",7]=0
a[a[,7]=="X1",7]=20
a[a[,7]=="AD",7]=0
a[a[,8]=="X0",8]=0
a[a[,8]=="X1",8]=40
a[a[,8]=="AD",8]=0
a[a[,9]=="X0",9]=0
a[a[,9]=="X1",9]=80
a[a[,9]=="AD",9]=0           
a[a[,10]=="X0",10]=0
a[a[,10]=="X1",10]=100
a[a[,10]=="AD",10]=0           
           
fg1=as.matrix(a[,c(3:6)])
fg2=as.matrix(a[,c(7:10)])

get_last_non_zero <- function(vec) {
  non_zero_elements <- vec[vec != 0]
  if (length(non_zero_elements) == 0) {
    return(0)  # If there are no non-zero elements, return 0
  } else {
    return(tail(non_zero_elements, 1))
  }
}


# Apply the function to each row of the dataframe
last_non_zero_elements <- apply(fg1, 1, get_last_non_zero)

# Create a new dataframe with the last non-zero elements
fg1 <- data.frame(LastNonZero = last_non_zero_elements)

# Apply the function to each row of the dataframe
last_non_zero_elements <- apply(fg2, 1, get_last_non_zero)

# Create a new dataframe with the last non-zero elements
fg2 <- data.frame(LastNonZero = last_non_zero_elements)
          
a=cbind(a[,1],a[,2],fg1,fg2)
colnames(a)=c("POL","DF","LC","LE")
write.csv(a,"fin_results2.csv",row.names=F)

#a=cbind(a[,1],a[,2],(as.numeric(a[,4])/100)*as.numeric(a[,2]))
#colnames(a)=c("POL","DF","SD")
#write.csv(a,"fin_results3.csv",row.names=F)
