SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_TransactionExportOverview]
AS
BEGIN

	DECLARE @majorVersion INT
	SELECT @majorVersion =  CAST(left(softwareversion,1) as int) from controlfile

declare @agencies table (agencyid int,trancount int)
--DIRECT PAYMENTS AND ADJUSTMENTS
insert into @agencies (agencyid,trancount)
	select
		pv.aimagencyid as agencyid,
		count(*)
		
	from
		payhistory pv with (nolock)
		join AIM_accountreference ar with (nolock) on ar.referencenumber = pv.number
	where
		ar.currentlyplacedagencyid is not null
 		and (dbo.AIM_GetLastFileDate(8,ar.currentlyplacedagencyid) is null or pv.entered > dbo.AIM_GetLastFileDate(8,ar.currentlyplacedagencyid))
		and pv.entered + 1 > ar.lastplacementdate
		and pv.batchtype not in ('PA','PAR')
		and pv.aimagencyid is not null
	group by pv.aimagencyid
	union
	
--PAYMENTS FROM AGENCY THAT NEED TO FORWARD ADJUSTMENTS
	select ar.currentlyplacedagencyid,count(*)

	from
		payhistory pv with (nolock)
		join AIM_accountreference ar with (nolock) on ar.referencenumber = pv.number
	where 
		ar.currentlyplacedagencyid is not null
 		and (dbo.AIM_GetLastFileDate(8,ar.currentlyplacedagencyid) is null or pv.entered > dbo.AIM_GetLastFileDate(8,ar.currentlyplacedagencyid))
		and pv.entered + 1 > ar.lastplacementdate
		and pv.batchtype in ('PA','PAR') and aimagencyid is not null and aimagencyid = aimsendingid and aimagencyid <> ar.currentlyplacedagencyid
	group by ar.currentlyplacedagencyid

	union
--PAYMENTS FROM OTHER AGENCIES THAT NEED TO BE FORWARDED AS PAYMENTS
	select
		pv.aimagencyid as agencyid,count(*)
		
	from
		payhistory pv with (nolock)
		join AIM_accountreference ar with (nolock) on ar.referencenumber = pv.number
	where
		ar.currentlyplacedagencyid is not null
 		and (dbo.AIM_GetLastFileDate(8,ar.currentlyplacedagencyid) is null or pv.entered > dbo.AIM_GetLastFileDate(8,ar.currentlyplacedagencyid))
		and pv.entered + 1 > ar.lastplacementdate
		and pv.batchtype in ('PA','PAR')
		and pv.aimagencyid is not null and pv.aimagencyid <> aimsendingid and pv.aimagencyid = ar.currentlyplacedagencyid
	group by pv.aimagencyid

SELECT [Export Type] = 'Payments or Adjustments',
	a.name as [Agency],
	sum(t.trancount) as [Count]
FROM @agencies t JOIN AIM_Agency a on t.agencyid = a.agencyid
GROUP BY a.name

UNION

SELECT [Export Type] = 
CASE transactiontypeid 
	WHEN '17' THEN 'Deceases'
	WHEN '18' THEN 'Bankruptcies'
	WHEN '20' THEN 'Miscellaneous Extra Data'
	WHEN '21' THEN 'Notes' END,
a.name as [Agency],
count(*) as [Count]
FROM AIM_AccountREference ar WITH (NOLOCK) JOIN AIM_AccountTransaction atr WITH (NOLOCK) ON 
ar.accountreferenceid = atr.accountreferenceid JOIN AIM_Agency a ON currentlyplacedagencyid = a.agencyid AND atr.agencyid = ar.currentlyplacedagencyid
WHERE
atr.transactionstatustypeid = 1 and atr.transactiontypeid in (17,18,20,21)
GROUP BY currentlyplacedagencyid,transactiontypeid,a.name



UNION

SELECT [Export Type] = 'Address Updates',
	a.name as [Agency],
	count(*) as [Count]
FROM	addresshistory ah with (nolock)
		join AIM_accountreference ar with(nolock) on ar.referencenumber = ah.accountid
		JOIN AIM_Agency a ON currentlyplacedagencyid = a.agencyid
WHERE	(dbo.AIM_GetLastFileDate(9,ar.currentlyplacedagencyid) is null or ah.datechanged > dbo.AIM_GetLastFileDate(9,ar.currentlyplacedagencyid))
		and ar.isplaced = 1
		and ah.transmitteddate is null
		and ah.datechanged + 1 > ar.lastplacementdate
GROUP BY ar.currentlyplacedagencyId,a.name
	



UNION 
SELECT [Export Type] = 'Auto Final Recalls',
	a.name as [Agency],
	count(*) as [Count]
FROM AIM_AccountReference ar with (nolock)
JOIN AIM_Agency a with (nolock) on ar.currentlyplacedagencyid = a.agencyid

WHERE  ar.expectedfinalrecalldate < getdate()
GROUP BY a.name

UNION

SELECT [Export Type] = 'Auto Pending Recalls',
	a.name as [Agency],
	count(*) as [Count]
FROM AIM_AccountReference ar with (nolock)
JOIN AIM_Agency a with (nolock) on ar.currentlyplacedagencyid = a.agencyid

WHERE  ar.expectedpendingrecalldate < getdate() and ar.expectedfinalrecalldate > getdate()
GROUP BY a.name

UNION

SELECT [Export Type] = CASE WHEN transactiontypeid = 3 THEN 'Waiting Final Recalls' ELSE 'Waiting Pending Recalls' END,
	a.name as [Agency],
	count(*) as [Count]
FROM AIM_AccountREference ar WITH (NOLOCK) JOIN AIM_AccountTransaction atr WITH (NOLOCK) ON 
ar.accountreferenceid = atr.accountreferenceid JOIN AIM_Agency a ON currentlyplacedagencyid = a.agencyid
WHERE
atr.transactionstatustypeid = 1 and atr.transactiontypeid in (2,3)
GROUP BY currentlyplacedagencyid,transactiontypeid,a.name


ORDER BY [Export Type]


IF(@majorVersion < 8)
BEGIN


SELECT [Export Type] = 'Phone Updates',
	a.name as [Agency],
	count(*) as [Count]
FROM	phonehistory ph with (nolock)
		join AIM_accountreference ar with (nolock) on ar.referencenumber = ph.accountid
		JOIN AIM_Agency a ON currentlyplacedagencyid = a.agencyid
WHERE	(dbo.AIM_GetLastFileDate(9,ar.currentlyplacedagencyid) is null or ph.datechanged > dbo.AIM_GetLastFileDate(9,ar.currentlyplacedagencyid))
		and ph.datechanged + 1 > ar.lastplacementdate
		and ar.isplaced = 1
		and ph.transmitteddate is null
		and ltrim(rtrim(ph.newnumber)) <> ''
GROUP BY ar.currentlyplacedagencyId,a.name
END
ELSE
BEGIN

SELECT [Export Type] = 'Phone Updates',
	a.name as [Agency],
	count(*) as [Count]
FROM	phones_master pm with (nolock)
		join AIM_accountreference ar with (nolock) on ar.referencenumber = pm.number
		JOIN AIM_Agency a ON currentlyplacedagencyid = a.agencyid
WHERE	(dbo.AIM_GetLastFileDate(9,ar.currentlyplacedagencyid) is null or pm.dateadded > dbo.AIM_GetLastFileDate(9,ar.currentlyplacedagencyid))
		and (pm.dateadded > ar.lastplacementdate or pm.LastUpdated > ar.lastplacementdate)
		and ar.isplaced = 1
		and pm.dateadded < getdate()
		and ltrim(rtrim(pm.phonenumber)) <> ''
		and pm.phonetypeid in (1,2)
		and pm.loginname <> 'CONVERSION'
GROUP BY ar.currentlyplacedagencyId,a.name
END
END
GO
