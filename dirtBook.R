

#remove columns that have only one observation or less (blank)


#in HospitalOutcome only Survived and Died needs to be considered
#convert any classes to Survieved if it is not Died
dataStiched$HospitalOutcomeBinary <- as.character(dataStiched$HospitalOutcome)
dataStiched[dataStiched$HospitalOutcome != "Died",]$HospitalOutcomeBinary <- c("Survived")
dataStiched$HospitalOutcomeBinary <- as.factor(dataStiched$HospitalOutcomeBinary)


#extract the patients that have an unknown INV or NIV
needsFurtherDataCollection = dataStiched[dataStiched$NIVVent == "Unknown" | dataStiched$InvVent == "Unknown", ]
#assumption NIVVent = yes and InvVent = unknown:   NIVVent = yes and InvVent = no
#assumption NIVVent = yes and InvVent = unknown:   NIVVent = yes and InvVent = no
dataStiched[dataStiched$NIVVent == "Yes" &  dataStiched$InvVent == "Unknown", ]$treatment = ""

table(dataStiched$Intubated)
table(dataStiched$InvVent)
table(dataStiched$NIVVent)
needsFurtherDataCollection = dataStiched[dataStiched$NIVVent == "Unknown" | dataStiched$InvVent == "Unknown", ]

numericColNames = c("SYSTOLICHI",	"SYSTOLICLO",	"TEMPHI",	"TEMPLO",	"PLATHI",	"PLATLO",	"UREA",	"WCCHI",	"WCCLO",
                    "URINEOP", "RRLO", "ALBUMHI",	"ALBUMLO",	"AP3FIO",	"AP3PO2",	"AP3CO2O",	"AP3PH",	"Intubated",	"BILI",	"CREATHI",
                    "CREATLO",	"DIASTOLICHI", "DIASTOLICLO",	"FIO2",	"PAO2",	"PACO2",	"PH",	"GLUCHI",	"GLUCLO",	"HCO3HI",	"HCO3LO",	"HCTHI",
                    "HCTLO",	"HMGNHI",	"HMGNLO",	"HRHI",	"HRLO",	"KHI",	"KLO",	"LACTATE",	"MAPHI",	"MAPLO",	"NAHI",
                    "NALO",	"RRHI", "INV_Hrs",	"NIV_Hrs", "AP2score",	"AP3score",	"AP3ROD",	"ANZROD", "ExitBlockHrs", "HOSLOS", "ICULOS", "Height",
                    "Weight", "AgeICU",	"AgeHosp")

ordinalColumnNames = c("GCS",	"GCSEye",	"GCSVerb",	"GCSMotor",	"GCSSedated", "ExitBlockHrs")  



dataStiched <-includedData
#covert to numeric
toNumList<-lapply(dataStiched[,names(dataStiched) %in% numericColNames], as.numeric)
dataStiched[,names(dataStiched) %in% numericColNames] <- do.call(cbind,toNumList)

#covert to ordered
toOrderedList<-lapply(dataStiched[,names(dataStiched) %in% ordinalColumnNames], as.ordered)
dataStiched[,names(dataStiched) %in% ordinalColumnNames] <- do.call(cbind,toOrderedList)




#Return the sig variables for a given output variable
myfunc = function(myData,outputVariableName)
{
  pValue = 0.05
  outputVariableName = "HospitalOutcomeBinary"
  
  myData[,outputVariableName]<-as.factor(myData[,outputVariableName])
  
  inputVariables<- names(myData)[names(myData) %in% numericColNames]
  regressionFormula = paste(paste(outputVariableName,"~"),paste(inputVariables,collapse  = "+") ,sep = "")
  regressionFormula <- as.formula(regressionFormula) 
  model <- glm(regressionFormula, family=binomial(link='logit'), data=myData)
  significantVariables <- summary(model)$coeff[-1,4] < pValue
  significantVariables <- names(significantVariables)[significantVariables == TRUE] 
  
  
  
  regressionFormula = paste(paste(outputVariableName,"~"),paste(significantVariables,collapse  = "+") ,sep = "")
  regressionFormula <- as.formula(regressionFormula) 
  
  model <- glm(regressionFormula, family=binomial(link='logit'), data=myData)
  significantVariables <- summary(model)$coeff < pValue
  return(model)
  
}

myData <-dataStiched
model <-myfunc(dataStiched,outputVariableName = HospitalOutcomeBinary)
significantVariables <- summary(model)$coeff[-1,4] < pValue
significantVariables <- names(significantVariables)[significantVariables == TRUE] 



myDatawithImportantCols <- myData[,colnames(myData) %in% c(significantVariables, "HospitalOutcomeBinary")]


hist(subset(myData, HospitalOutcomeBinary == "Survived")$HCO3LO, col=rgb(1,0,0,0.7), 25)
par(new=TRUE)
hist(subset(myData, HospitalOutcomeBinary == "Died")$HCO3LO, col=rgb(0,0,1,0.7), 25)

CI95 <- quantile(subset(myData, HospitalOutcomeBinary == "Died")$HCO3LO, c(.05, .95)) 
meanVal <- mean(subset(myData, HospitalOutcomeBinary == "Died")$HCO3LO)



myDataDied <- subset(myData, HospitalOutcomeBinary == "Died")
myDataSurvived <- subset(myData, HospitalOutcomeBinary == "Survived")

meansDied <- sapply(myDatawithImportantCols[1:4], mean)
meansDied

set.seed(0815)
x <- "X"
F <- meanVal
L <- CI95[1]
U <- CI95[2]

require(plotrix)
plotCI(x, F, ui=U, li=L)


