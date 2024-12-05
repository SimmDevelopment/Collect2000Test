SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_JCAP_Report_KeeperNew]
@date datetime

AS
BEGIN
	--header date
	SELECT getdate() AS [Date]
	
	--Keeper Record
	SELECT DISTINCT
		m.id2		 AS [BFrame],
		--case when m.customer = '0001020' then '0824'
		--		when m.customer = '0001026' then '0898'
		--		when m.customer = '0001032' then '0956'
		--END
		'5555'		AS [RemoteID],
		m.received   AS [PlacedDate],
		(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Portfolioid')		 AS [Portfolio],
		'KP'		 AS [RecordType],
		m.account	 AS [Account],
		'ABC'		as [servicerID],
		getdate() AS [recallDate],
		m.name		as [acctname],
		m.current0 as [balance],
		case status when 'PDC' then 'PAYMNT'
					WHEN 'PPA' THEN 'PAYMNT'
					WHEN 'PCC' THEN 'PAYMNT'
					WHEN 'HOT' THEN 'PAYMNT'
					WHEN 'STL' THEN 'PAYMNT'
					WHEN 'REF' THEN 'PAYMNT'
					WHEN 'NSF' THEN 'PAYMNT'
					WHEN 'DCC' THEN 'PAYMNT'
					WHEN 'DBD' THEN 'PAYMNT'
			END AS [Reason]

FROM master m INNER JOIN Custom_JCAPKeeper j
	ON m.number = j.number
WHERE j.Date = @date


--Tailer
	SELECT COUNT(distinct m.number) AS [NumRecs]
	FROM master m INNER JOIN Custom_JCAPKeeper j
	ON m.number = j.number
	WHERE j.Date = @date


end
GO
