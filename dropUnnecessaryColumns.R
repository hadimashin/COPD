dropUnnecessaryColumns = function(myData,workingDirectoryData)
{
  drops <-
    c("NA\\.+" ,"APACHE3_Inclusion",
      "NIV.B.or.A.intubatedAmended", 
      "BMIAmended",
      "HeightAmended", "WeightAmended"	,"NA.",	"Postcode",
      "AgeHosp",	"DOB",
      "Height",	"Weight",
      "HOSP_ADM_DTM"	,"HOSP_DIS_DTM",	"ICU_ADM_DTM"	,"ICU_DIS_DTM",	"ICU_DIS_DEC_DTM",	"ICUSource",
      "ICUOutcome",
      "HospitalOutcome",
      "PregStatus",
      "ThromboPro",
      "SmokingStatus",
      "ExitBlockHrs",	"GCSDateTime",
      "GCSSedated",
      "CardArrest",	"Diabetes",
      "AIDS",
      "HepaticFailure",
      "Lymphoma",
      "Leukaemia",
      "ECMO",
      "Inotropes",
      "InvVent",
      "NIVVent",
      "RenalRep",	"Trachestomy",
      "INV_Hrs",	"NIV_Hrs",	"PT_identifier",	"HOSP_identifier",	
      "ICU_identifier",	"ALBUMHI",
      "Intubated",
      "CREATLO",
      "HCTHI",
      "HCTLO",
      "HMGNHI",	"HMGNLO",
      "LACTATE",
      "RRHI_VENT",
      "RRLO_VENT")
  
  masterDataColumns <- c("HRN.NIH", "PatientId",	"FirstName",	"LastName")
  masterData <- myData[,(names(myData) %in% masterDataColumns)]
  setwd(workingDirectoryData)
  write.xlsx(masterData, file = "masterData.xlsx")
  

  drops <- union(setdiff(masterDataColumns,"PatientId"), drops )
  myData <- myData[,!(names(myData) %in% drops)]
  
  return(myData)
  
  
  
}