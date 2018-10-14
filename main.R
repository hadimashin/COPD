
rm(list=ls(all=TRUE))
library(xlsx)


workingDirectory = "C:/repo/COPD/"
workingDirectoryCode = paste(workingDirectory , "Code/", sep = "")
workingDirectoryData = paste(workingDirectory , "Data/", sep = "")

setwd(workingDirectoryData)

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

setwd(workingDirectoryCode)
source("exclusionCriteria.R")
includedData <- exclusionCriteria(workingDirectoryData)
