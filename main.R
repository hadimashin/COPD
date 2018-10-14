
rm(list=ls(all=TRUE))
library(xlsx)
reporDirectory = "C:/repo/COPD/"
workingDirectoryData = paste(reporDirectory,"Data/", sep = "")
workingDirectoryCode = paste(reporDirectory,"Code/", sep = "") 
setwd(workingDirectoryData)


#to be done: check the column names, they need to be the same
dataIsStored = FALSE
if(!dataIsStored)
{
  #reading the input that contains what columns are to be included
  inclusionColumnNames = read.xlsx(file = "columnNamesCOPDStudy.xlsx", sheetIndex = 1)
  columnNamesforInclusion = names(inclusionColumnNames)[which(inclusionColumnNames == TRUE)]
  #reading the data and remove tge data with APACHEDiagnosis != 206
  fileNames = list.files(pattern="COMET-Extract-APD*", all.files=FALSE,full.names=FALSE)
  myfunc <- function(x) {
    myData<-read.xlsx(x, sheetIndex = 1)
    myData<-subset(myData, APACHEDiagnosis == 206, select=-c(APACHEDiagnosis)) 
    myData <- myData[,columnNamesforInclusion[-which(columnNamesforInclusion ==  "APACHEDiagnosis")]]
    return(myData)
  } 
  dataList <- lapply(fileNames, myfunc)
  dataStiched <- do.call(rbind,dataList)
  write.xlsx(dataStiched, file = "COPDStiched.xlsx")
} else
{
  dataStiched = read.xlsx(file = "COPDStiched.xlsx", sheetIndex = 1)
}

#There is some vital information missing from this source. This information can be collected from another source
#adding columns that requires more data collection
setwd(workingDirectoryCode)
source("createAmendFile.R")
requiresAmendment = TRUE
if(requiresAmendment)
{
  createAmendFile(dataStiched,workingDirectoryData) #create COPDStichedAmend.xlsx for the user to store the data into
}

#removing observations based on the Exclusion criteria of the study protocol
setwd(workingDirectoryCode)
source("exclusionCriteria.R")
includedData = exclusionCriteria(workingDirectoryData)





