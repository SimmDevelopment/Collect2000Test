SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE  PROCEDURE [dbo].[sp_Custom_GenesisMassRecallFileExport]
@customer varchar(8000),
@dateBegin datetime,
@dateEnd datetime

AS
BEGIN
	DECLARE @returnDate datetime
	CREATE TABLE #Holds(number int)
	
	SET @returnDate = getdate()
	SET @dateEnd = CAST(CONVERT(varchar(10),getdate(),20) + ' 23:59:59.000' as datetime)		
	
	--Status Of  -"PDC" Or  "PPA" "PCC" Or "HOT" Or  "STL" Or "REF" Or  "NSF"   or Qlevel Of - "010" Or "012" Or  "018" Or "019" Or  "025" Or "820" Or  "830" Or "840"
	-- needs to prevent the account from being returned and will generate an extra data record,
	-- Find accounts to notify Genesis that need to be held. This could have changed after the record was sent
	INSERT INTO #Holds(number)
	SELECT DISTINCT m.number
	FROM master m WITH(NOLOCK)
	INNER JOIN ExtraData e WITH(NOLOCK)
	ON e.number = m.number AND extracode = 'RC' AND line1 = '0' AND line2 IS NULL
	WHERE m.custbranch = 'MASS RECALL' AND
	m.customer IN (select string from dbo.StringToSet(@customer, '|'))
	
	-- Update the Extra Data records so as not be be sent again.
	UPDATE ExtraData
	SET line1 = '1', line2 = CONVERT(varchar(30), getdate(),120)
	WHERE number IN(SELECT number FROM #Holds)
	
	-- Note the account that a HOLD record was sent.
	INSERT INTO Notes(number,user0,created,action,result,comment)
	SELECT number,'EXG',@returnDate,'+++++','+++++','Sent RC23 Code to Genesis To Hold The Account.'
	FROM #Holds
	
	-- Build records for account that were returned previousyl
	SELECT DISTINCT CONVERT(varchar(8), @returndate,112) as fileDate,
	case 	
		when m.customer = '0000858' then '3SIM2M-PPS'
		when m.customer = '0000901' then '2SIM01-SIR'
		when m.customer = '0000919' then '3SIM01-CGL'
		when m.customer = '0000920' then '3SIM02-CHV'
		when m.customer = '0000933' then '2SIM02-MCB'
		when m.customer = '0000934' then '2SIM03-MCB'
		when m.customer = '0000977' then '3SIM05-GEC'
		when m.customer = '0000978' then '3SIM04-GEC'
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
	'' as bkyCaseNumber,
	'' as bkyChapter,
	'' as bkyStatus,
	'' as bkyDate,
	'' as deceasedDate,
	'RC08' as status,
	m.status as latStatus
	FROM master m WITH(NOLOCK) 
	WHERE m.custbranch = 'MASS RECALL' AND m.Qlevel = '999' AND status = 'CCR' AND
	m.returned BETWEEN @dateBegin and @dateEnd
	
	UNION
	
	SELECT DISTINCT CONVERT(varchar(8), @returndate,112) as fileDate,
	case 	
		when m.customer = '0000858' then '3SIM2M-PPS'
		when m.customer = '0000901' then '2SIM01-SIR'
		when m.customer = '0000919' then '3SIM01-CGL'
		when m.customer = '0000920' then '3SIM02-CHV'
		when m.customer = '0000933' then '2SIM02-MCB'
		when m.customer = '0000934' then '2SIM03-MCB'
		when m.customer = '0000977' then '3SIM05-GEC'
		when m.customer = '0000978' then '3SIM04-GEC'
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
	'' as bkyCaseNumber,
	'' as bkyChapter,
	'' as bkyStatus,
	'' as bkyDate,
	'' as deceasedDate,
	'RC23' as status,
	m.status as latStatus
	FROM master m WITH(NOLOCK) 
	WHERE m.number IN(SELECT number from #Holds)

END
GO
