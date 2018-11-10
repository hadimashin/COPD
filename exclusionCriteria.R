exclusionCriteria = function(myData,workingDirectoryData)
{
  #setwd(workingDirectoryData)
  #myData = read.xlsx(file = "COPDStichedAmended.xlsx", sheetIndex = 1)
  
  #removing cols that is introduced by R
  drops = grep("NA\\.+", colnames(myData),  perl=TRUE, value=TRUE)
  myData <- myData[,!(names(myData) %in% drops)]
  includedData<-myData
  #filter MetastaticCancer = Yes
  #includedData = subset(myData, MetastaticCancer=="No")
  #excludedData = subset(myData, MetastaticCancer=="Yes")
  #excludedDataTotal <- excludedData
  
  #filter AIDs = YES
  #includedData = subset(includedData, AIDS=="No")
  #excludedData = subset(includedData, AIDS=="Yes")
  #if (nrow(excludedData)!= 0 )  cbind(excludedDataTotal,excludedData)
  
  
  #filter IntubatedAmended	NIVVentAmended if NO or Unknown
  includedData = subset(includedData,  !(IntubatedAmended =="No" & NIVVentAmended =="No"))
  includedData = subset(includedData,  !(IntubatedAmended =="Unknown" & NIVVentAmended =="Unknown"))
  
  
  #filter notesAmended  with specific descriptions
  drops <- c("Angina",
             "APO",
             "Asthma",
             "CCF",
             "CLL",
             "Colon a",
             "CREST",
             "Diarrhoea",
             "Epilim OD",
             "Epistaxis",
             "Haemoptysis, PE",
             "HyperK+",
             "HypoNa and NIV in ED",
             "Hypotension",
             "IHD",
             "ILD",
             "ILD + COPD",
             "Iron def",
             "Liver failure",
             "Lung abscess",
             "Lung ca",
             "Lung ca, palliation",
             "Lymphoma",
             "Mental health",
             "Met breast ca",
             "Met ca",
             "Met lung ca",
             "MM",
             "NSTEMI",
             "NSTEMI+COP",
             "OHS - palliated",
             "OSA",
             "PE",
             "Post op",
             "Post surgery",
             "PTX",
             "Quadraplegia",
             "Ruptured bulla",
             "Sepsis",
             "Urosepsis")
  includedData = subset(includedData, !(Other.notesAmended %in% drops))
  includedData <- includedData[,!(names(includedData) %in% c("Other.notesAmended"))] 
  setwd(workingDirectoryData)
  write.xlsx(includedData, file = "includedData.xlsx")
    
  excludedPatientIDs <- setdiff(as.character(unique(myData$PatientId)),as.character(unique(includedData$PatientId)))
  myData$PatientId <- as.character(myData$PatientId)
  excludedData <- myData[myData$PatientId %in% excludedPatientIDs,]
  setwd(workingDirectoryData)
  write.xlsx(excludedData, file = "excludedData.xlsx")

  
  return(includedData)

}
