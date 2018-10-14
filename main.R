
rm(list=ls(all=TRUE))
library(xlsx)
setwd("C:/Users/home/Desktop/COPD research")

dataIsStored = TRUE
if(!dataIsStored)
{
  #reading the data and remove tge data with APACHEDiagnosis != 206
  fileNames = list.files(pattern=".xlsx", all.files=FALSE,full.names=FALSE)
  myfunc <- function(x) {
    myData<-read.xlsx(x, sheetIndex = 1)
    myData<-subset(myData, APACHEDiagnosis == 206, select=-c(APACHEDiagnosis)) 
    return(myData)
  } 
  dataList <- lapply(fileNames, myfunc)
  dataStiched <- do.call(rbind,dataList)
  write.xlsx(dataStiched, file = "COPDStiched.xlsx")
} else
{
  dataStiched = read.xlsx(file = "COPDStiched.xlsx", sheetIndex = 1)
}

myData<-dataStiched



#Return the sig variables for a given output variable
function(myData,outputVariableName)
{
  pValue = 0.05
  outputVariableName = "HospitalOutcome"
  myData[,outputVariableName]<-as.factor(myData[,outputVariableName])
  inputVariables <- names(myData)[!(names(myData) %in% outputVariableName)]
  regressionFormula = paste(paste(outputVariableName,"~"),paste(inputVariables,collapse  = "+") ,sep = "")
  regressionFormula <- as.formula(regressionFormula) 
  model <- glm("HospitalOutcome~ Sex",data=myData)
  significantVariables <- summary(model)$coeff < pValue
  
  
  
  regressionFormula <- as.formula(paste(paste(outputVariableName,"~"),significantVariables,sep = "+")) 
  model <- glm(regressionFormula,data=mydata)
  significantVariables <- summary(model)$coeff < pValue
  return(model)
  
}
