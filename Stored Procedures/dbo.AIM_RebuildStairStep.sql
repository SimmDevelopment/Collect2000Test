SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     Procedure [dbo].[AIM_RebuildStairStep] 
	@batchid int,
	@placementCalculationString varchar(max),
	@collectionCalculationString varchar(max)
AS



SET NOCOUNT ON

--9/12/2007 KMG Modified to use BatchID as opposed to Batchfilehistoryid
--06/14/2010 KAR Modified so 	@placementCalculationString and	@collectionCalculationString are varchar(max).
-- this is because the dynamic sql that is created using a local variable of varchar(max) is 'resetting' to varchar(8000)
-- due to the concatenation of a varchar(max) variable with a varchar(n) variable.

--DELETE OLD STATS FROM AIM_STAIRSTEP WHERE BATCHID IS THE PASSED BATCHID
DELETE FROM AIM_STAIRSTEP WHERE BatchID = @batchid
--GET TEMP TABLE OF PLACEMENT ACCOUNTS WITHOUT DUPLICATES/REPLACEMENTS
CREATE TABLE #tempAIMSSAccounts (BatchId int,AgencyID int,Customer char(7),Number int,Balance money,EquipmentCount int,EquipmentValue money)
DECLARE @InsertPlacementTempSQL VARCHAR(8000)
SET @InsertPlacementTempSQL =
'INSERT INTO #tempAIMSSAccounts
SELECT bfh.BatchID,bfh.AgencyID,m.Customer,m.Number,SUM('+@placementCalculationString+'),SUM(ISNULL(PlacedEquipmentCount,0)),SUM(ISNULL(PlacedEquipmentValue,0))
FROM master m WITH (NOLOCK) JOIN AIM_AccountReference ar WITH (NOLOCK) ON m.number = ar.referencenumber
JOIN AIM_AccountTransaction atr WITH (NOLOCK) ON atr.accountreferenceid = ar.accountreferenceid
JOIN AIM_BatchFileHistory bfh WITH (NOLOCK) ON bfh.batchfilehistoryid = atr.batchfilehistoryid and atr.agencyid = bfh.agencyid
WHERE atr.TransactionTypeID = 1 AND atr.ValidPlacement = 1 AND atr.TransactionStatusTypeId = 3 and atr.completeddatetime is not null
and bfh.BatchID = '+cast(@batchid AS VARCHAR)+'
GROUP BY bfh.BatchID,bfh.AgencyID,m.Customer,m.Number'

EXEC(@InsertPlacementTempSQL)

--GET COUNT AND PLACEMENT DOLLARS FOR EACH BATCHID
INSERT INTO AIM_STAIRSTEP (BatchId,AgencyId,Customer,PlacementSysMonth,PlacementSysYear,DatePlaced,TotalNumberPlaced,TotalDollarsPlaced,TotalEquipmentNumberPlaced,TotalEquipmentDollarsPlaced)
SELECT b.BatchId,ta.AgencyId,customer,b.SystemMonth,b.SystemYear,b.CompletedDateTime,count(*),sum(Balance),sum(ISNULL(EquipmentCount,0)),sum(ISNULL(EquipmentValue,0))
FROM #tempAIMSSAccounts ta JOIN AIM_Batch b WITH (NOLOCK) ON b.BatchID = ta.BatchID
GROUP BY b.BatchID,ta.AgencyID,customer,b.SystemMonth,b.SystemYear,b.CompletedDateTime

DROP TABLE #tempAIMSSAccounts
UPDATE aim_Stairstep SET 
		Adjustments=0,Month1=0,month2=0,month3=0,month4=0,month5=0,month6=0,month7=0,month8=0,month9=0,month10=0,
		Month11=0,month12=0,month13=0,month14=0,month15=0,month16=0,month17=0,month18=0,month19=0,month20=0,
		Month21=0,month22=0,month23=0,month24=0,month99=0,totalcollected=0,totalfees=0,equipmentmonth1=0,equipmentmonth2=0,equipmentmonth3=0,equipmentmonth4=0,equipmentmonth5=0,equipmentmonth6=0,equipmentmonth7=0,equipmentmonth8=0,equipmentmonth9=0,equipmentmonth10=0,
		equipmentmonth11=0,equipmentmonth12=0,equipmentmonth13=0,equipmentmonth14=0,equipmentmonth15=0,equipmentmonth16=0,equipmentmonth17=0,equipmentmonth18=0,equipmentmonth19=0,equipmentmonth20=0,
		equipmentmonth21=0,equipmentmonth22=0,equipmentmonth23=0,equipmentmonth24=0,equipmentmonth99=0,equipmentcountmonth1=0,equipmentcountmonth2=0,equipmentcountmonth3=0,equipmentcountmonth4=0,equipmentcountmonth5=0,equipmentcountmonth6=0,equipmentcountmonth7=0,equipmentcountmonth8=0,equipmentcountmonth9=0,equipmentcountmonth10=0,
		equipmentcountmonth11=0,equipmentcountmonth12=0,equipmentcountmonth13=0,equipmentcountmonth14=0,equipmentcountmonth15=0,equipmentcountmonth16=0,equipmentcountmonth17=0,equipmentcountmonth18=0,equipmentcountmonth19=0,equipmentcountmonth20=0,
		equipmentcountmonth21=0,equipmentcountmonth22=0,equipmentcountmonth23=0,equipmentcountmonth24=0,equipmentcountmonth99=0
--FROM AIM_BatchFileHistory bfh WITH (NOLOCK) JOIN AIM_StairStep ss WITH (NOLOCK) ON bfh.BatchFileHistoryId = ss.BatchFileHistoryId
WHERE BatchId = @BatchId


--NOW GET THE PAYMENTS/REVERSALS FOR THE PASSED BATCH
CREATE TABLE #tempAIMStairStepTABLE (SysMonth INT,SysYear INT,batchid int,agencyid int,customer char(7),totalpaid money,paid1 money,paid2 money,paid3 money,paid4 money,paid5 money,paid6 money,paid7 money,paid8 money,paid9 money,paid10 money,paid11 money,paid12 money,paid13 money,paid14 money,paid15 money,paid16 money,paid17 money,paid18 money,paid19 money,paid20 money,paid21 money,paid22 money,paid23 money,paid24 money,paid99 money,fees money)
DECLARE @InsertTempStairStepPaymentSQL VARCHAR(MAX)
SET @InsertTempStairStepPaymentSQL =
'INSERT INTO #tempAIMStairStepTABLE
SELECT 
	ss.PlacementSysMonth,
	ss.PlacementSysYear,
	p.AIMBatchID,
	p.AIMAgencyID,
	p.Customer,
	CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull(SUM('+@collectionCalculationString+'),0) ELSE isnull(SUM('+@collectionCalculationString+'),0) END as PaidAmt,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 0 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 1 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 2 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 3 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 4 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 5 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 6 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 7 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 8 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 9 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 10 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 11 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 12 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 13 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 14 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 15 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 16 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 17 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 18 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 19 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 20 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 21 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 22 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth)
			WHEN 23 THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	CASE WHEN ((p.SystemYear * 12) + p.SystemMonth) - ((ss.PlacementSysYear*12) + ss.PlacementSysMonth) > 23
			THEN sum(CASE WHEN p.BatchType IN (''PAR'',''PCR'',''PUR'') THEN -1*isnull('+@collectionCalculationString+',0) ELSE isnull('+@collectionCalculationString+',0) END) ELSE 0 END,
	   sum(isnull(p.AIMAgencyFee,0)) as FeeAmt

FROM PayHistory p WITH(NOLOCK)
inner join master m with(nolock) on m.number = p.number
inner join aim_stairstep ss on  ss.batchid = p.aimbatchid and ss.agencyid = p.aimagencyid and ss.customer = p.customer
inner join status s with (nolock) on m.status = s.code and s.reducestats = 0
WHERE p.Batchtype in (''PU'', ''PU'', ''PC'', ''PC'', ''PUR'', ''PCR'', ''PA'', ''PAR'') 
and p.aimagencyid = ss.agencyid
and p.aimbatchid = ss.batchid
and p.aimbatchid =' + CAST( @BatchId AS VARCHAR) +'
GROUP BY p.AIMBatchID,p.AIMagencyID,ss.PlacementSysMonth,ss.PlacementSysYear,p.systemmonth,p.systemyear,p.Customer,p.BatchType'

EXEC(@InsertTempStairStepPaymentSQL)
DECLARE  @tempAIMStairStepTABLE2 TABLE (SysMonth INT,SysYear INT,batchid int,agencyid int,customer char(7),totalpaid money,paid1 money,paid2 money,paid3 money,paid4 money,paid5 money,paid6 money,paid7 money,paid8 money,paid9 money,paid10 money,paid11 money,paid12 money,paid13 money,paid14 money,paid15 money,paid16 money,paid17 money,paid18 money,paid19 money,paid20 money,paid21 money,paid22 money,paid23 money,paid24 money,paid99 money,fees money)
INSERT INTO @tempAIMStairStepTABLE2
SELECT SysMonth,SysYear,batchid,agencyid,customer,
SUM(totalpaid),SUM(paid1),SUM(paid2 ),SUM(paid3 ),SUM(paid4 ),SUM(paid5 ),SUM(paid6 ),SUM(paid7 ),SUM(paid8 ),SUM(paid9 ),SUM(paid10 ),SUM(paid11 ),SUM(paid12 ),SUM(paid13 ),SUM(paid14 ),SUM(paid15 ),SUM(paid16 ),SUM(paid17 ),SUM(paid18 ),SUM(paid19 ),SUM(paid20 ),SUM(paid21),SUM(paid22),SUM(paid23),SUM(paid24),SUM(paid99),SUM(fees )
FROM #tempAIMStairStepTABLE
GROUP BY SysMonth,SysYear,batchid,agencyid,customer

UPDATE AIM_StairStep
SET 
Month1 = t.paid1,
Month2 = t.paid2,
Month3 = t.paid3,
Month4 = t.paid4,
Month5 = t.paid5,
Month6 = t.paid6,
Month7 = t.paid7,
Month8 = t.paid8,
Month9 = t.paid9,
Month10 = t.paid10,
Month11 = t.paid11,
Month12 = t.paid12,
Month13 = t.paid13,
Month14 = t.paid14,
Month15 = t.paid15,
Month16 = t.paid16,
Month17 = t.paid17,
Month18 = t.paid18,
Month19 = t.paid19,
Month20 = t.paid20,
Month21 = t.paid21,
Month22 = t.paid22,
Month23 = t.paid23,
Month24 = t.paid24,
Month99 = t.paid99,
totalcollected= t.totalpaid,
totalfees = t.fees

FROM AIM_StairStep ss JOIN @tempAIMStairStepTABLE2 t
on ss.batchid = t.batchid and ss.agencyid = t.agencyid and t.customer = ss.customer

DROP TABLE #tempAIMStairStepTABLE

DECLARE @tempStairStepEqp TABLE
(
SysMonth INT,
SysYear INT,
BatchID INT,
AgencyID INT,
Customer VARCHAR(10),
EquipmentCountTotalCollected int,
equipmentcountmonth1 int,
equipmentcountmonth2 int,
equipmentcountmonth3 int,
equipmentcountmonth4 int,
equipmentcountmonth5 int,
equipmentcountmonth6 int,
equipmentcountmonth7 int,
equipmentcountmonth8 int,
equipmentcountmonth9 int,
equipmentcountmonth10 int,
equipmentcountmonth11 int,
equipmentcountmonth12 int,
equipmentcountmonth13 int,
equipmentcountmonth14 int,
equipmentcountmonth15 int,
equipmentcountmonth16 int,
equipmentcountmonth17 int,
equipmentcountmonth18 int,
equipmentcountmonth19 int,
equipmentcountmonth20 int,
equipmentcountmonth21 int,
equipmentcountmonth22 int,
equipmentcountmonth23 int,
equipmentcountmonth24 int,
equipmentcountmonth99 int,
EquipmentTotalCollected money,
equipmentmonth1 money,
equipmentmonth2 money,
equipmentmonth3 money,
equipmentmonth4 money,
equipmentmonth5 money,
equipmentmonth6 money,
equipmentmonth7 money,
equipmentmonth8 money,
equipmentmonth9 money,
equipmentmonth10 money,
equipmentmonth11 money,
equipmentmonth12 money,
equipmentmonth13 money,
equipmentmonth14 money,
equipmentmonth15 money,
equipmentmonth16 money,
equipmentmonth17 money,
equipmentmonth18 money,
equipmentmonth19 money,
equipmentmonth20 money,
equipmentmonth21 money,
equipmentmonth22 money,
equipmentmonth23 money,
equipmentmonth24 money,
equipmentmonth99 money)

INSERT INTO @tempStairStepEqp
SELECT 
ss.PlacementSysMonth,
ss.PlacementSysYear,
eqp.AIMBatchID,
eqp.AIMAgencyID,
m.Customer,
EquipmentCountTotalCollected = ISNULL(SUM(CASE ISNULL(Recovered,0) WHEN 0 THEN 0 WHEN 1 THEN 1 END),0),
EquipmentCountMonth1 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 0 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth2 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 1 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth3 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 2 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth4 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 3 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth5 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 4 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth6 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 5 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth7 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 6 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth8 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 7 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth9 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 8 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth10 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 9 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth11 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 10 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth12 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 11 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth13 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 12 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth14 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 13 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth15 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 14 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth16 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 15 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth17 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 16 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth18 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 17 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth19 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 18 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth20 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 19 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth21 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 20 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth22 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 21 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth23 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 22 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth24 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 23 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),
EquipmentCountMonth99 = ISNULL(SUM(CASE WHEN (((RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) >= 24 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN 1 ELSE 0 END ELSE 0 END),0),

EquipmentTotalCollected = ISNULL(SUM(CASE ISNULL(Recovered,0) WHEN 0 THEN 0 WHEN 1 THEN ISNULL(Val,0) END),0),
EquipmentMonth1 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 0 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth2 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 1 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth3 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 2 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth4 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 3 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth5 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 4 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth6 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 5 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth7 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 6 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth8 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 7 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth9 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 8 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth10 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 9 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth11 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 10 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth12 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 11 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth13 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 12 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth14 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 13 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth15 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 14 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth16 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 15 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth17 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 16 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth18 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 17 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth19 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 18 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth20 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 19 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth21 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 20 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth22 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 21 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth23 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 22 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth24 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) = 23 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0),
EquipmentMonth99 = ISNULL(SUM(CASE	WHEN (((eqp.RecoveredSystemYear*12)+eqp.RecoveredSystemMonth)-((ss.PlacementSysYear*12)+ss.PlacementSysMonth)) >= 24 THEN CASE ISNULL(Recovered,0) WHEN 1 THEN ISNULL(Val,0) ELSE 0 END ELSE 0 END),0)

FROM PBEquipment eqp WITH (NOLOCK)
JOIN [master] m WITH (NOLOCK) ON eqp.Number = m.Number
JOIN AIM_StairStep ss ON ss.BatchID = eqp.AIMBatchID AND ss.AgencyID = eqp.AIMAgencyID AND ss.Customer = m.Customer
WHERE eqp.AIMBatchID = @BatchID
GROUP BY eqp.AIMBatchID,eqp.AIMAgencyID,ss.PlacementSysMonth,ss.PlacementSysYear,eqp.RecoveredSystemMonth,eqp.RecoveredSystemYear,m.Customer



DECLARE @tempStairStepEqp2 TABLE
(
SysMonth INT,
SysYear INT,
BatchID INT,
AgencyID INT,
Customer VARCHAR(10),
EquipmentCountTotalCollected int,
equipmentcountmonth1 int,
equipmentcountmonth2 int,
equipmentcountmonth3 int,
equipmentcountmonth4 int,
equipmentcountmonth5 int,
equipmentcountmonth6 int,
equipmentcountmonth7 int,
equipmentcountmonth8 int,
equipmentcountmonth9 int,
equipmentcountmonth10 int,
equipmentcountmonth11 int,
equipmentcountmonth12 int,
equipmentcountmonth13 int,
equipmentcountmonth14 int,
equipmentcountmonth15 int,
equipmentcountmonth16 int,
equipmentcountmonth17 int,
equipmentcountmonth18 int,
equipmentcountmonth19 int,
equipmentcountmonth20 int,
equipmentcountmonth21 int,
equipmentcountmonth22 int,
equipmentcountmonth23 int,
equipmentcountmonth24 int,
equipmentcountmonth99 int,
EquipmentTotalCollected money,
equipmentmonth1 money,
equipmentmonth2 money,
equipmentmonth3 money,
equipmentmonth4 money,
equipmentmonth5 money,
equipmentmonth6 money,
equipmentmonth7 money,
equipmentmonth8 money,
equipmentmonth9 money,
equipmentmonth10 money,
equipmentmonth11 money,
equipmentmonth12 money,
equipmentmonth13 money,
equipmentmonth14 money,
equipmentmonth15 money,
equipmentmonth16 money,
equipmentmonth17 money,
equipmentmonth18 money,
equipmentmonth19 money,
equipmentmonth20 money,
equipmentmonth21 money,
equipmentmonth22 money,
equipmentmonth23 money,
equipmentmonth24 money,
equipmentmonth99 money)

INSERT INTO @tempStairStepEqp2
SELECT SysMonth ,
SysYear ,
BatchID ,
AgencyID ,
Customer ,
sum(equipmentCountTotalCollected ),
sum(equipmentcountmonth1 ),
sum(equipmentcountmonth2 ),
sum(equipmentcountmonth3 ),
sum(equipmentcountmonth4 ),
sum(equipmentcountmonth5 ),
sum(equipmentcountmonth6 ),
sum(equipmentcountmonth7 ),
sum(equipmentcountmonth8 ),
sum(equipmentcountmonth9 ),
sum(equipmentcountmonth10 ),
sum(equipmentcountmonth11 ),
sum(equipmentcountmonth12 ),
sum(equipmentcountmonth13 ),
sum(equipmentcountmonth14 ),
sum(equipmentcountmonth15 ),
sum(equipmentcountmonth16 ),
sum(equipmentcountmonth17 ),
sum(equipmentcountmonth18 ),
sum(equipmentcountmonth19 ),
sum(equipmentcountmonth20 ),
sum(equipmentcountmonth21 ),
sum(equipmentcountmonth22 ),
sum(equipmentcountmonth23 ),
sum(equipmentcountmonth24 ),
sum(equipmentcountmonth99 ),
sum(equipmentTotalCollected ),
sum(equipmentmonth1 ),
sum(equipmentmonth2 ),
sum(equipmentmonth3 ),
sum(equipmentmonth4 ),
sum(equipmentmonth5 ),
sum(equipmentmonth6 ),
sum(equipmentmonth7 ),
sum(equipmentmonth8 ),
sum(equipmentmonth9 ),
sum(equipmentmonth10 ),
sum(equipmentmonth11 ),
sum(equipmentmonth12 ),
sum(equipmentmonth13 ),
sum(equipmentmonth14 ),
sum(equipmentmonth15 ),
sum(equipmentmonth16 ),
sum(equipmentmonth17 ),
sum(equipmentmonth18 ),
sum(equipmentmonth19 ),
sum(equipmentmonth20 ),
sum(equipmentmonth21 ),
sum(equipmentmonth22 ),
sum(equipmentmonth23 ),
sum(equipmentmonth24 ),
sum(equipmentmonth99 )

FROM @tempStairStepEqp
GROUP BY  SysMonth ,
SysYear ,
BatchID ,
AgencyID ,
Customer 



UPDATE AIM_StairStep
SET
EquipmentCountTotalCollected = ISNULL(eqp.EquipmentCountTotalCollected,0),
EquipmentCountMonth1 =    ISNULL(eqp.EquipmentCountMonth1,0),
EquipmentCountMonth2 =	  ISNULL(eqp.EquipmentCountMonth2,0), 
EquipmentCountMonth3 =	  ISNULL(eqp.EquipmentCountMonth3,0), 
EquipmentCountMonth4 =	  ISNULL(eqp.EquipmentCountMonth4,0), 
EquipmentCountMonth5 =	  ISNULL(eqp.EquipmentCountMonth5,0), 
EquipmentCountMonth6 =	  ISNULL(eqp.EquipmentCountMonth6,0), 
EquipmentCountMonth7 =	  ISNULL(eqp.EquipmentCountMonth7,0), 
EquipmentCountMonth8 =	  ISNULL(eqp.EquipmentCountMonth8,0), 
EquipmentCountMonth9 =	  ISNULL(eqp.EquipmentCountMonth9,0) , 
EquipmentCountMonth10 =	  ISNULL(eqp.EquipmentCountMonth10,0) ,
EquipmentCountMonth11 =	  ISNULL(eqp.EquipmentCountMonth11,0) ,
EquipmentCountMonth12 =	  ISNULL(eqp.EquipmentCountMonth12,0) ,
EquipmentCountMonth13 =	  ISNULL(eqp.EquipmentCountMonth13,0) ,
EquipmentCountMonth14 =	  ISNULL(eqp.EquipmentCountMonth14,0) ,
EquipmentCountMonth15 =	  ISNULL(eqp.EquipmentCountMonth15,0) ,
EquipmentCountMonth16 =	  ISNULL(eqp.EquipmentCountMonth16,0) ,
EquipmentCountMonth17 =	  ISNULL(eqp.EquipmentCountMonth17,0) ,
EquipmentCountMonth18 =	  ISNULL(eqp.EquipmentCountMonth18,0) ,
EquipmentCountMonth19 =	  ISNULL(eqp.EquipmentCountMonth19,0) ,
EquipmentCountMonth20 =	  ISNULL(eqp.EquipmentCountMonth20,0) ,
EquipmentCountMonth21 =	  ISNULL(eqp.EquipmentCountMonth21,0) ,
EquipmentCountMonth22 =	  ISNULL(eqp.EquipmentCountMonth22,0) ,
EquipmentCountMonth23 =	  ISNULL(eqp.EquipmentCountMonth23,0) ,
EquipmentCountMonth24 =	  ISNULL(eqp.EquipmentCountMonth24,0) ,
EquipmentCountMonth99 =	  ISNULL(eqp.EquipmentCountMonth99,0) ,
EquipmentTotalCollected = ISNULL(eqp.EquipmentTotalCollected,0),
EquipmentMonth1 =   ISNULL(eqp.EquipmentMonth1,0) , 
EquipmentMonth2 =	ISNULL(eqp.EquipmentMonth2,0) , 
EquipmentMonth3 =	ISNULL(eqp.EquipmentMonth3 ,0), 
EquipmentMonth4 =	ISNULL(eqp.EquipmentMonth4 ,0), 
EquipmentMonth5 =	ISNULL(eqp.EquipmentMonth5 ,0), 
EquipmentMonth6 =	ISNULL(eqp.EquipmentMonth6 ,0), 
EquipmentMonth7 =	ISNULL(eqp.EquipmentMonth7 ,0), 
EquipmentMonth8 =	ISNULL(eqp.EquipmentMonth8 ,0), 
EquipmentMonth9 =	ISNULL(eqp.EquipmentMonth9 ,0), 
EquipmentMonth10 =	ISNULL(eqp.EquipmentMonth10,0) ,
EquipmentMonth11 =	ISNULL(eqp.EquipmentMonth11 ,0),
EquipmentMonth12 =	ISNULL(eqp.EquipmentMonth12 ,0),
EquipmentMonth13 =	ISNULL(eqp.EquipmentMonth13 ,0),
EquipmentMonth14 =	ISNULL(eqp.EquipmentMonth14 ,0),
EquipmentMonth15 =	ISNULL(eqp.EquipmentMonth15 ,0),
EquipmentMonth16 =	ISNULL(eqp.EquipmentMonth16 ,0),
EquipmentMonth17 =	ISNULL(eqp.EquipmentMonth17 ,0),
EquipmentMonth18 =	ISNULL(eqp.EquipmentMonth18 ,0),
EquipmentMonth19 =	ISNULL(eqp.EquipmentMonth19 ,0),
EquipmentMonth20 =	ISNULL(eqp.EquipmentMonth20 ,0),
EquipmentMonth21 =	ISNULL(eqp.EquipmentMonth21 ,0),
EquipmentMonth22 =	ISNULL(eqp.EquipmentMonth22 ,0),
EquipmentMonth23 =	ISNULL(eqp.EquipmentMonth23 ,0),
EquipmentMonth24 =	ISNULL(eqp.EquipmentMonth24 ,0),
EquipmentMonth99 =	ISNULL(eqp.EquipmentMonth99,0) 

FROM AIM_StairStep ss WITH (NOLOCK)
JOIN @tempStairStepEqp2 eqp ON ss.BatchID = eqp.BatchID AND ss.Customer = eqp.Customer AND ss.AgencyID = eqp.AgencyID

UPDATE AIM_Stairstep
SET DatePlaced = CAST(PlacementSysMonth AS VARCHAR) + '/1/' + CAST(PlacementSysYear AS VARCHAR)

GO
