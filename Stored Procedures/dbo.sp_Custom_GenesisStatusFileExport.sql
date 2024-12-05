SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO




/*

DECLARE @customer varchar(8000)
DECLARE @dateBegin datetime
DECLARE @dateEnd datetime
SET @customer = '0000858|0000901|0000919|0000920|'
SET @dateBegin = '20070222'
SET @dateEnd = '20070223'
EXEC [sp_Custom_GenesisStatusFileExport] @customer, @dateBegin, @dateEnd

*/


CREATE         PROCEDURE [dbo].[sp_Custom_GenesisStatusFileExport]
@customer varchar(8000),
@dateBegin datetime,
@dateEnd datetime

AS
BEGIN
	DECLARE @returnDate datetime
	SET @returnDate = CAST(CONVERT(varchar(10),getdate(),20) + ' 00:00:00.000' as datetime)	
--	SET @dateEnd = CAST(CONVERT(varchar(10),getdate(),20) + ' 23:59:59.000' as datetime)		
	
	CREATE TABLE #Returns(number int)

	/*
	RC02	Confirmed Bankruptcy	B07, B11, B13, BKY
	RC03	Confirmed Deceased	DEC
	RC04 	Agency Recall	AEX
	RC05	Account Paid in Full	PIF
	RC06	Account Settled in Full	SIF
	RC09	Incarceration	DIP:  DIP
	RC10	Confirmed Fraud	FRD:  FRD
	RC11	Cease and Desist	CAD:  CAD
	*/

	-- Find accoutns to return
	--added 30day hold to pif sif status accounts
	INSERT INTO #Returns(number)
	SELECT m.number FROM master m with(NOLOCK)
	WHERE m.Qlevel IN('998') AND ((m.status IN('B07','B11','B13','BKY','DEC','AEX','DIP','FRD','CAD', 'CCR', 'RFP')) OR
	(m.status IN('PIF','SIF') AND m.closed < (@datebegin - 30)))   and
	m.customer IN (select string from dbo.StringToSet(@customer, '|'))
	
	-- Return the accounts
	UPDATE master SET Qlevel='999',returned=@returnDate
	WHERE number IN(SELECT number FROM #Returns)
	
	-- Note the account.
	INSERT INTO Notes(number,user0,created,action,result,comment)
	SELECT number,'EXG',@returnDate,'+++++','+++++','Account returned to Genesis.'
	FROM #Returns 

	-- Build records for account that were just returned
	SELECT DISTINCT CONVERT(varchar(8), @returndate,112) as fileDate,
	case 	when m.customer = '0000901' then '2SIM01-SIR'
		when m.customer = '0000919' then '3SIM01-CGL'
		when m.customer = '0000920' then '3SIM02-CHV'
		when m.customer = '0000933' then '2SIM02-MCB'
		when m.customer = '0000934' then '2SIM03-MCB'
		when m.customer = '0000977' then '3SIM05-GEC'
		when m.customer = '0000978' then '3SIM04-GEC'
		when m.customer = '0000994' then '3SIM07-GEC'
		when m.customer = '0000995' and m.originalcreditor = 'MONTEREY COUNTY BANK' then '3SIM08-MCB'
		when m.customer = '0000995' and m.originalcreditor = 'WebBank' then '3SIM08-WBK'
	end  as placementId,
	m.number as number,
	m.account as account,
	m.street1 as street1,
	m.street2 as street2,
	m.city as city,
	m.state as state,
	[dbo].[StripNonDigits](m.zipcode) as zipCode,
	[dbo].[StripNonDigits](m.homephone) as homePhone,
	m.original as originalBalance,
	CASE 
		WHEN m.closed IS NULL THEN CONVERT(varchar(8), @returndate,112)
		ELSE CONVERT(varchar(8), m.closed,112) 
	END as changeDate,
	CASE WHEN m.current0 < 0 THEN 0.00 ELSE m.current0 END as currentBalance,
	CASE WHEN m.current1 < 0 THEN 0.00 ELSE m.current1 END as principalBalance,
	CASE 
		WHEN (m.current2+m.current3+m.current4+m.current5+m.current6+m.current7+m.current8+m.current9+m.current10) < 0 THEN 0.00 
		ELSE (m.current2+m.current3+m.current4+m.current5+m.current6+m.current7+m.current8+m.current9+m.current10) 
	END as otherBalance,
	isnull(b.casenumber,(Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'BKYCASENUMBER')) as bkyCaseNumber,
	CASE WHEN b.chapter IS NOT NULL THEN
		CASE 
			WHEN (Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'BKYCHAPTER') <> '' THEN (Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'BKYCHAPTER')
			WHEN b.chapter IN(7,11,12,13) THEN b.chapter
			WHEN b.chapter IN(6) THEN 13
			WHEN b.chapter IN(52) THEN 7
			WHEN b.chapter IN(53) THEN 11
		END
	END as bkyChapter,
	isnull((Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'BKYSTATUS'),'') as bkyStatus,
	isnull(CONVERT(varchar(8),b.DateFiled,112),(Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'BKYFILEDATE')) as bkyDate,
	isnull(CONVERT(varchar(8),dc.DOD,112),(Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'DECEASEDATE')) as deceasedDate,
	CASE 
		WHEN m.status IN ('B07','B11','B13','BKY') THEN 'RC02'
		WHEN m.status IN ('DEC') THEN 'RC03'
		WHEN m.status IN ('AEX', 'RFP') THEN 'RC04'		
		WHEN m.status IN ('PIF') THEN 'RC05'		
		WHEN m.status IN ('SIF') THEN 'RC06'	
		WHEN m.status IN ('CCR') THEN 'RC08'	
		WHEN m.status IN ('DIP') THEN 'RC09'		
		WHEN m.status IN ('FRD') THEN 'RC10'		
		WHEN m.status IN ('CAD') THEN 'RC11'		
	END as status,
	m.status as latStatus
	FROM master m WITH(NOLOCK) 
	INNER JOIN debtors d WITH(NOLOCK)
	ON d.number=m.number and d.SEQ=0
	LEFT OUTER JOIN Bankruptcy b WITH(NOLOCK)
	ON b.accountid = d.number and b.DebtorId=d.DebtorId AND m.Status IN('B07','B11','B13','BKY')
	LEFT OUTER JOIN DECEASED dc WITH(NOLOCK) 
	ON dc.accountid = d.number and dc.DebtorId=d.DebtorId AND m.Status IN('DEC')
	WHERE m.number IN(SELECT number from #Returns)
	
	UNION
	
	-- Find Accounts that were returned By GENESIS
	--added 30 day hold to sif pif
	SELECT DISTINCT CONVERT(varchar(8), @returndate,112) as fileDate,
	case 	when m.customer = '0000901' then '2SIM01-SIR'
		when m.customer = '0000919' then '3SIM01-CGL'
		when m.customer = '0000920' then '3SIM02-CHV'
		when m.customer = '0000933' then '2SIM02-MCB'
		when m.customer = '0000934' then '2SIM03-MCB'
		when m.customer = '0000977' then '3SIM05-GEC'
		when m.customer = '0000978' then '3SIM04-GEC'
		when m.customer = '0000994' then '3SIM07-GEC'
		when m.customer = '0000995' and m.originalcreditor = 'MONTEREY COUNTY BANK' then '3SIM08-MCB'
		when m.customer = '0000995' and m.originalcreditor = 'WebBank' then '3SIM08-WBK'
	end  as placementId,
	m.number as number,
	m.account as account,
	m.street1 as street1,
	m.street2 as street2,
	m.city as city,
	m.state as state,
	[dbo].[StripNonDigits](m.zipcode) as zipCode,
	[dbo].[StripNonDigits](m.homephone) as homePhone,
	m.original as originalBalance,
	CASE 
		WHEN m.closed IS NULL THEN CONVERT(varchar(8), @returndate,112) 
		ELSE CONVERT(varchar(8), m.closed,112) 
	END as changeDate,
	CASE WHEN m.current0 < 0 THEN 0.00 ELSE m.current0 END as currentBalance,
	CASE WHEN m.current1 < 0 THEN 0.00 ELSE m.current1 END as principalBalance,
	CASE 
		WHEN (m.current2+m.current3+m.current4+m.current5+m.current6+m.current7+m.current8+m.current9+m.current10) < 0 THEN 0.00 
		ELSE (m.current2+m.current3+m.current4+m.current5+m.current6+m.current7+m.current8+m.current9+m.current10) 
	END as otherBalance,
	isnull(b.casenumber,(Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'BKYCASENUMBER')) as bkyCaseNumber,
	CASE WHEN b.chapter IS NOT NULL THEN
		CASE 
			WHEN (Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'BKYCHAPTER') <> '' THEN (Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'BKYCHAPTER')
			WHEN b.chapter IN(7,11,12,13) THEN b.chapter
			WHEN b.chapter IN(6) THEN 13
			WHEN b.chapter IN(52) THEN 7
			WHEN b.chapter IN(53) THEN 11
		END
	END as bkyChapter,
	isnull((Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'BKYSTATUS'),'') as bkyStatus,
	isnull(CONVERT(varchar(8),b.DateFiled,112),(Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'BKYFILEDATE')) as bkyDate,
	isnull(CONVERT(varchar(8),dc.DOD,112),(Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'DECEASEDATE')) as deceasedDate,
	CASE 
		WHEN RTRIM(LTRIM(m.custbranch)) IN('RC01','RC02','RC03','RC05','RC06','RC08','RC09','RC10','RC11','RC12','RC13','RC20','RC21','RC22','RC30') THEN RTRIM(LTRIM(custbranch))
		ELSE
			CASE 
				WHEN m.status IN ('B07','B11','B13','BKY') THEN 'RC02'
				WHEN m.status IN ('DEC') THEN 'RC03'
				WHEN m.status IN ('AEX', 'RFP') THEN 'RC04'		
				WHEN m.status IN ('PIF') THEN 'RC05'		
				WHEN m.status IN ('SIF') THEN 'RC06'		
				WHEN m.status IN ('DIP') THEN 'RC09'		
				WHEN m.status IN ('FRD') THEN 'RC10'		
				WHEN m.status IN ('CAD') THEN 'RC11'		
				WHEN m.status IN ('CCR') THEN 'RC08'		
			END
	END as status,
	m.status as latStatus
	FROM master m WITH(NOLOCK) 
	INNER JOIN debtors d WITH(NOLOCK)
	ON d.number=m.number and d.SEQ=0
	LEFT OUTER JOIN Bankruptcy b WITH(NOLOCK)
	ON b.accountid = d.number and b.DebtorId=d.DebtorId AND m.Status IN('B07','B11','B13','BKY')
	LEFT OUTER JOIN DECEASED dc WITH(NOLOCK)
	ON dc.accountid = d.number and dc.DebtorId=d.DebtorId  AND m.Status IN('DEC')
	WHERE m.number NOT IN(SELECT number from #Returns) AND
	(m.status IN('CCR','B07','B11','B13','BKY','DEC','AEX','DIP','FRD','CAD', 'RFP') or (m.status IN('PIF','SIF') AND m.closed < (@datebegin - 30))) AND m.Qlevel='999'
	AND m.returned BETWEEN @dateBegin AND @dateEnd AND
	m.customer IN (select string from dbo.StringToSet(@customer, '|'))
	
END
GO
