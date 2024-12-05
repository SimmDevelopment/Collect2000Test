SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE     Procedure [dbo].[LatitudeLegal_RebuildStairStep] 
	@batchid int
AS
Declare @BatchFileHistoryId int
Declare @CSysMo tinyint
Declare @CSysYr smallint
Declare @PSysMo tinyint
Declare @PSysYr smallint
Declare @Batch varchar (3)
Declare @Paid money
Declare @Fee money
Declare @MoDiff smallint
Declare @Err int
declare @dateplaced datetime


SET NOCOUNT ON

--9/12/2007 KMG Modified to use BatchID as opposed to Batchfilehistoryid

--DELETE OLD STATS FROM Attorney_STAIRSTEP WHERE BATCHID IS THE PASSED BATCHID
DELETE FROM Attorney_STAIRSTEP WHERE BatchID = @batchid
--FROM Attorney_Batchfilehistory bfh WITH (NOLOCK) JOIN Attorney_Stairstep ss WITH (NOLOCK) 
--	ON bfh.batchfilehistoryid = ss.batchfilehistoryid and bfh.batchid = @BatchId


--GET TEMP TABLE OF PLACEMENT ACCOUNTS WITHOUT DUPLICATES/REPLACEMENTS
DECLARE @tempAccounts TABLE (BatchId int,AttorneyID int,Customer char(7),Number int,Balance money)
INSERT INTO @tempAccounts
SELECT llhrd.LLHistoryID,llhrd.AttorneyID,m.Customer,m.Number,max(llhrd.balance)
FROM master m WITH (NOLOCK) JOIN LatitudeLegal_HistoryRecordDetail llhrd WITH (NOLOCK) ON m.number = llhrd.number
--JOIN LatitudeLegal_HistoryDetail llhd WITH (NOLOCK) ON llhrd.LLHistoryDetailID = llhd.LLHistoryDetailID
JOIN LatitudeLegal_History llh WITH (NOLOCK) ON llh.LLHistoryID = llhrd.LLHistoryID
WHERE llhrd.TransactionType = 1 AND llhrd.TransactionStatus = 1 and llh.endeddatetime is not null
GROUP BY llhrd.LLHistoryID,llhrd.AttorneyID,m.Customer,m.Number

--GET COUNT AND PLACEMENT DOLLARS FOR EACH BATCHID
INSERT INTO Attorney_STAIRSTEP (BatchId,AttorneyId,Customer,PlacementSysMonth,PlacementSysYear,DatePlaced,TotalNumberPlaced,TotalDollarsPlaced)
SELECT llh.LLHistoryID,ta.AttorneyId,customer,month(llh.EndedDateTime),year(llh.EndedDateTime),llh.EndedDateTime,count(*),sum(Balance) 
FROM @tempAccounts ta JOIN LatitudeLegal_History llh WITH (NOLOCK) ON llh.LLHistoryID = ta.BatchID
GROUP BY llh.LLHistoryID,ta.AttorneyID,customer,llh.EndedDateTime



UPDATE Attorney_Stairstep SET 
		Adjustments=0,Month1=0,month2=0,month3=0,month4=0,month5=0,month6=0,month7=0,month8=0,month9=0,month10=0,
		Month11=0,month12=0,month13=0,month14=0,month15=0,month16=0,month17=0,month18=0,month19=0,month20=0,
		Month21=0,month22=0,month23=0,month24=0,month99=0,totalcollected=0,totalfees=0
--FROM Attorney_BatchFileHistory bfh WITH (NOLOCK) JOIN Attorney_StairStep ss WITH (NOLOCK) ON bfh.BatchFileHistoryId = ss.BatchFileHistoryId
WHERE BatchId = @BatchId


--NOW GET THE PAYMENTS/REVERSALS FOR THE PASSED BATCH



DECLARE @tempStairStep TABLE (batchid int,Attorneyid int,customer char(7),totalpaid money,paid1 money,paid2 money,paid3 money,paid4 money,paid5 money,paid6 money,paid7 money,paid8 money,paid9 money,paid10 money,paid11 money,paid12 money,paid13 money,paid14 money,paid15 money,paid16 money,paid17 money,paid18 money,paid19 money,paid20 money,paid21 money,paid22 money,paid23 money,paid24 money,paid99 money,fees money)
INSERT INTO @tempStairStep
SELECT 
		llhrd.LLHistoryID,
		p.AttorneyID,
		p.Customer,
		sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) as PaidAmt,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 0 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 1 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 2 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 3 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 4 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 5 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 6 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 7 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 8 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 9 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 10 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 11 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 12 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 13 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 14 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 15 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 16 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 17 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 18 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 19 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 20 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 21 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 22 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced)))
			WHEN 23 THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	CASE WHEN ((p.SystemYear * 12) + p.SystemMonth) - ((datepart(year,max(ss.dateplaced)) * 12) + datepart(month,max(ss.dateplaced))) > 23
			THEN sum(CASE WHEN p.BatchType IN ('PAR','PCR','PUR') THEN -1*isnull(p.totalpaid,0) ELSE isnull(p.totalpaid,0) END) ELSE 0 END,
	   sum(abs(isnull(p.ForwardeeFee,0))) as FeeAmt
FROM PayHistory p WITH(NOLOCK)
inner join master m with(nolock) on m.number = p.number
inner join Attorney_stairstep ss on  p.entered + 1 > ss.DatePlaced and ss.Attorneyid = p.AttorneyID and ss.customer = p.customer
inner join LatitudeLegal_HistoryRecordDetail llhrd WITH (NOLOCK) ON p.number = llhrd.number and p.attorneyid = llhrd.attorneyid 
--inner join  LatitudeLegal_HistoryDetail llhd WITH (NOLOCK) ON llhrd.LLHistoryDetailID = llhd.LLHistoryDetailID
inner join  LatitudeLegal_History llh WITH (NOLOCK) ON llh.LLHistoryID = llhrd.LLHistoryID and p.entered + 1 > llh.endeddatetime
inner join status s with (nolock) on m.status = s.code and s.reducestats = 0
WHERE p.Batchtype in ('PU', 'PU', 'PC', 'PC', 'PUR', 'PCR', 'PA', 'PAR') 
and p.AttorneyID = ss.Attorneyid
and p.entered + 1 > ss.DatePlaced
GROUP BY llhrd.LLHistoryID,p.AttorneyID,month(ss.dateplaced),year(ss.dateplaced),p.systemmonth,p.systemyear,p.Customer


DECLARE @tempStairStep2 TABLE (batchid int,customer char(7),Attorneyid int,totalpaid money,paid1 money,paid2 money,paid3 money,paid4 money,paid5 money,paid6 money,paid7 money,paid8 money,paid9 money,paid10 money,paid11 money,paid12 money,paid13 money,paid14 money,paid15 money,paid16 money,paid17 money,paid18 money,paid19 money,paid20 money,paid21 money,paid22 money,paid23 money,paid24 money,paid99 money,fees money)
INSERT INTO @tempStairStep2
SELECT t.batchid,t.customer,t.Attorneyid,sum(totalpaid),sum(paid1),sum(paid2),sum(paid3),sum(paid4),sum(paid5),sum(paid6),sum(paid7),sum(paid8),sum(paid9),sum(paid10),sum(paid11),sum(paid12),sum(paid13),sum(paid14),sum(paid15),sum(paid16),sum(paid17),sum(paid18),sum(paid19),sum(paid20),sum(paid21),sum(paid22),sum(paid23),sum(paid24),sum(paid99),sum(fees)
FROM @tempStairStep t GROUP BY t.batchid,t.Attorneyid,t.customer

UPDATE Attorney_StairStep
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

FROM Attorney_StairStep ss JOIN @tempStairStep2 t
on ss.batchid = t.batchid and ss.Attorneyid = t.Attorneyid and t.customer = ss.customer


DELETE FROM Attorney_Stairstep where totaldollarsplaced = 0




GO
