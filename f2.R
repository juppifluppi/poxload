pkgs = c("dplyr","ggplot2","PerformanceAnalytics","ggthemes","corrplot","car","psych","caret","caretEnsemble","doParallel","pROC","epiR","leaps","chemometrics","corrplot","MLmetrics",
         "fastAdaboost", "purrr","adabag", "plyr", "adaptDA", "frbs", "VGAM", "adabag", "plyr", "ipred", "plyr", "e1071", "earth", "earth", "mda", "logicFS", "earth", "earth", "caret", "bartMachine", "arm", "brnn", "monomvn", "monomvn", "binda", "ada", "plyr", "mboost", "plyr", "import", "plyr", "mboost", "bst", "plyr", "caTools", "bst", "plyr", "party", "mboost", "plyr", "partykit", "bst", "plyr", "RWeka", "C50", "plyr", "rpart", "rpart", "rpart", "rpartScore", "plyr", "CHAID", "party", "party", "party", "VGAM", "C50", "plyr", "rpart", "plyr", "Cubist", "VGAM", "deepboost", "sparsediscrim", "kerndwd", "kernlab", "kerndwd", "frbs", "elasticnet", "randomGLM", "xgboost", "plyr", "xgboost", "xgboost", "plyr", "elmNN", "HiDimDA", "earth", "mda", "frbs", "frbs", "frbs", "frbs", "frbs", "frbs", "frbs", "kernlab", "kernlab", "kernlab", "gam", "mgcv", "mgcv", "gam", "", "MASS", "gpls", "frbs", "glmnet", "Matrix", "h2o", "h2o", "proxy", "protoclass", "hda", "HDclassif", "sparsediscrim", "frbs", "fastICA", "kknn", "", "LiblineaR", "LiblineaR", "class", "lars", "lars", "kernlab", "kernlab", "kernlab", "MASS", "MASS", "klaR", "MASS", "kerndwd", "", "leaps", "leaps", "leaps", "MASS", "e1071", "klaR", "LogicReg", "RWeka", "HiDimDA", "mda", "bnclassify", "nnet", "RWeka", "RWeka", "monmlp", "RSNNS", "RSNNS", "RSNNS", "RSNNS", "msaenet", "FCNN4R", "plyr", "keras", "keras", "keras", "keras", "earth", "earth", "naivebayes", "klaR", "bnclassify", "bnclassify", "pamr", "MASS", "neuralnet", "nnet", "nnet", "rqPen", "", "nnls", "obliqueRF", "obliqueRF", "obliqueRF", "obliqueRF", "snn", "MASS", "e1071", "randomForest", "foreach", "import", "partDSA", "pls", "pls", "pls", "pls", "plsRglm", "supervisedPRIM", "mda", "mda", "penalizedLDA", "plyr", "penalized", "stepPlr", "nnet", "ordinalNet", "plyr", "KRLS", "pls", "", "MASS", "klaR", "MASS", "quantregForest", "qrnn", "rqPen", "KRLS", "kernlab", "RSNNS", "RSNNS", "rFerns", "e1071", "ranger", "dplyr", "ordinalForest", "e1071", "ranger", "dplyr", "randomForest", "extraTrees", "randomForest", "inTrees", "plyr", "klaR", "sparsediscrim", "LiblineaR", "randomForest", "RRF", "RRF", "relaxo", "plyr", "kernlab", "kernlab", "kernlab", "elasticnet", "foba", "rrcov", "MASS", "robustDA", "rrcov", "rrlda", "rrcovHD", "rocc", "rotationForest", "rpart", "plyr", "rotationForest", "RWeka", "RWeka", "kohonen", "bnclassify", "sda", "rrcov", "rrcovHD", "frbs", "C50", "C50", "RWeka", "sdwd", "sparseLDA", "sparseLDA", "spls", "spikeslab", "plyr", "ipred", "snn", "deepnet", "gbm", "plyr", "frbs", "superpc", "kernlab", "kernlab", "kernlab", "kernlab", "e1071", "kernlab", "kernlab", "kernlab", "kernlab", "kernlab", "monomvn", "elasticnet", "bnclassify", "bnclassify", "bnclassify", "evtree", "nodeHarvest", "vbmp", "frbs", "wsrf")
pkgs = unique(pkgs)
lapply(pkgs, FUN = function(X) {
  do.call("require", list(X)) 
})

padel=read.csv("descriptors_padel_fda.csv")
padelpol=read.csv("descriptors_padel_pol.csv")
mordred=read.csv("descriptors_mordred_fda.csv")
mordredpol=read.csv("descriptors_mordred_pol.csv")
mordred=mordred[mordred$Name%in%padel$Name,]
padel=padel[padel$Name%in%mordred$Name,]
padel=rbind(padelpol,padel)
mordred=rbind(mordredpol,mordred)
mordred=mordred[,-1]
descriptors=cbind(padel,mordred)
names=descriptors$Name
descriptors=descriptors[ , purrr::map_lgl(descriptors, is.numeric)]
compounds=padel$Name[!padel$Name%in%padelpol$Name]

wholeset=rep(NA,ncol(descriptors))
olo=0
for(kj in compounds){
olo=olo+1
print(paste0(olo,"/",length(compounds)))  
  
formulations=read.csv("test.csv",dec=",")
formulations$D=kj

am=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  bx=descriptors[names%in%formulations[ij,]$A1,]
  bx=bx*(formulations[ij,]$A1n+formulations[ij,]$A2n)
  t1x=descriptors[names%in%formulations[ij,]$T1,]
  t2x=descriptors[names%in%formulations[ij,]$T2,]
  bx=bx+t1x+t2x
  am=rbind(am,bx)
}
am=am[-1,]
for(ij in c(1:ncol(am))){
  colnames(am)[ij]=paste0("ABLOCK_",colnames(am)[ij])
}

bm=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  bx=descriptors[names%in%formulations[ij,]$B,]
  bx=bx*(formulations[ij,]$Bn)
  bm=rbind(bm,bx)
}
bm=bm[-1,]
for(ij in c(1:ncol(bm))){
  colnames(bm)[ij]=paste0("BBLOCK_",colnames(bm)[ij])
}

molratio=c()
for(ij in c(1:nrow(formulations))){
  bx=descriptors[names%in%formulations[ij,]$A1,]
  ax=bx$MW*(formulations[ij,]$A1n+formulations[ij,]$A1n)
  bx=descriptors[names%in%formulations[ij,]$B,]
  fx=bx$MW*(formulations[ij,]$Bn)
  bx=descriptors[names%in%formulations[ij,]$T1,]
  t1x=bx$MW
  bx=descriptors[names%in%formulations[ij,]$T2,]
  t2x=bx$MW
  polmw=ax+fx+t1x+t2x
  bx=descriptors[names%in%formulations[ij,]$D,]  
  dx=bx$MW
  molratio=append(molratio,((formulations[ij,]$DF/formulations[ij,]$PF)*polmw)/dx)
}

dm=rep(NA,ncol(descriptors))
for(ij in c(1:nrow(formulations))){
  bx=descriptors[names%in%formulations[ij,]$D,]
  bx=bx*molratio[ij]
  dm=rbind(dm,bx)
}
dm=dm[-1,]
for(ij in c(1:ncol(dm))){
  colnames(dm)[ij]=paste0("DRUG_",colnames(dm)[ij])
}

g=cbind(formulations,am,bm,dm)
wholeset=rbind(wholeset,g)
}
wholeset=wholeset[-1,]
save.image("testset1.RData")
write.csv(wholeset,file=paste0("fdaset.dat"),row.names = F)