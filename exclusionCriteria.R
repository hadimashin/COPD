exclusionCriteria = function(workingDirectoryData)
{
  setwd(workingDirectoryData)
  myData = read.xlsx(file = "COPDStichedAmended.xlsx", sheetIndex = 1)
  #removing cols that is introduced by R
  drops = grep("NA\\.+", colnames(myData),  perl=TRUE, value=TRUE)
  myData <- myData[,!(names(myData) %in% drops)]
  
  #filter MetastaticCancer = Yes
  includedData = subset(myData, MetastaticCancer=="No")
  excludedData = subset(myData, MetastaticCancer=="Yes")
  excludedDataTotal <- excludedData
  
  #filter AIDs = YES
  includedData = subset(includedData, AIDS=="No")
  excludedData = subset(includedData, AIDS=="Yes")
  if (nrow(excludedData)!= 0 )  cbind(excludedDataTotal,excludedData)
  
  return(includedData)

}
