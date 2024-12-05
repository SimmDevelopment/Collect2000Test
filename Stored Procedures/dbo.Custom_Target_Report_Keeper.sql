SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_Target_Report_Keeper]
AS

DECLARE @accts TABLE (number int)

INSERT @accts
SELECT number
FROM master
WHERE id2 = 'PENRECALL' AND customer = '0000856' AND status IN ('BKN', 'HOT','HLD', 'NPC', 'NSF','PCC',
	'PDC','PPA','STL','REF')

insert into Custom_TargetKeeperHistory(Account)
select account 
from master with (nolock) 
where number in (select number from @accts)

UPDATE master
SET id2 = NULL
WHERE number IN (SELECT number FROM @accts)

SELECT account
FROM master
WHERE number IN (SELECT number FROM @accts)
GO
