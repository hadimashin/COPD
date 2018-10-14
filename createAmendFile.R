createAmendFile=function(myData,workingDirectoryData)
{
  setwd(workingDirectoryData)
  #There is some vital information missing from this source. This information can be collected from another source
  #adding columns that requires more data collection
  myData$IntubatedAmended <- as.character(myData$Intubated)
  myData[myData$IntubatedAmended == "Unknown",]$IntubatedAmended <- ""
  myData$NIVVentAmended <- as.character(myData$NIVVent)
  myData[myData$NIVVentAmended == "Unknown",]$NIVVentAmended <- ""
  myData$BMIAmended <- ""
  myData$WeightAmended <- as.character(myData$Weight)
  myData[myData$WeightAmended == "",]$WeightAmended <- ""
  myData$HeightAmended <- as.character(myData$Height)
  myData[myData$HeightAmended == "",]$HeightAmended <- ""
  #reorder the columns to make the data entry easier
  firstColumns <- c("APACHE3_Inclusion","HRN.NIH","PatientId","FirstName","LastName","IntubatedAmended", "NIVVentAmended", "BMIAmended", "HeightAmended", "WeightAmended")
  myData <- myData[c(firstColumns, setdiff(names(myData), firstColumns))]
  write.xlsx(myData, file = "COPDStichedAmend.xlsx")
  write.xlsx(myData, file = "COPDStichedAmended.xlsx")
}