SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[YGC_Recall_SelectTransactionsReadyForFile]
	@agencyId INT,
	@transactionTypeID int
AS
BEGIN

DECLARE @sqlbatchsize int
SELECT @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = 'AIM.Database.SqlBatchTransactionSize'
DECLARE @myyougotclaimsid VARCHAR(20),@AIMYGCID VARCHAR(10)
	
create table #recallaccounts (referenceNumber int primary key, accountreferenceid int)
declare @executeSQL varchar(8000)
set @executeSQL =
'insert into #recallaccounts
select	top ' + cast(@sqlbatchsize as VARCHAR(16)) + ' referenceNumber
	,max(ar.accountreferenceid)
from	AIM_accountreference ar with (nolock)
	join AIM_accounttransaction atr with (nolock) on atr.accountreferenceid = ar.accountreferenceid
where	atr.agencyid = ' + CAST(@agencyId as VARCHAR(8)) + ' 
	and transactiontypeid in (2,3) 
	and transactionstatustypeid = 1
group by referencenumber'

exec(@executeSQL)

SELECT  
@myyougotclaimsid = yougotclaimsid
FROM controlfile;

SELECT
@AIMYGCID = AlphaCode
FROM AIM_Agency WHERE AgencyID = @agencyID;

SELECT            
		'09'						as [Record Code],
		m.number					as [FILENO],
		m.account					as [FORW_FILE],
		null						as [MASCO_FILE],
		@myyougotclaimsid			as [FORW_ID],
		@AIMYGCID					as FIRM_ID,
		getdate()					as PDATE, 
		CASE atr.transactiontypeid WHEN 3 THEN '*CC:C111' WHEN 2 THEN '*CC:R115' END as PCODE,
		CASE atr.transactiontypeid WHEN 3 THEN 'Final Recall of Account.  Please Close Promptly.' WHEN 2 THEN 'Pending Recall Notification.  This Account will be Recalled in the pre-specified number of days.  Please remit appropriate Objection Code if it is desired that the Account remain Placed.' END as PCMT

FROM #recallaccounts ra
JOIN [dbo].[master] m WITH (NOLOCK) ON m.number = ra.referencenumber
JOIN [dbo].[AIM_AccountReference] ar WITH (NOLOCK) ON ar.referencenumber = m.number
JOIN [dbo].[AIM_AccountTransaction] atr WITH (NOLOCK) ON atr.accountreferenceid = ar.accountreferenceid
WHERE
atr.transactiontypeid in (2,3)
AND atr.transactionstatustypeid = 1
AND ar.currentlyplacedagencyid = @agencyId


	-- now mark as being processed

		update  AIM_accounttransaction with (rowlock) 
			set transactionstatustypeid = 4 -- being recalled
		from #recallaccounts ra
		join aim_accounttransaction atr  on ra.accountreferenceid = atr.accountreferenceid
		where
			transactiontypeid in (2,3) -- recall
			and transactionstatustypeid = 1 -- open
			and agencyid = @agencyid
	
		drop table #recallaccounts


END

GO
