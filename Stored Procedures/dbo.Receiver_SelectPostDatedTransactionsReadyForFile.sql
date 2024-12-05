SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE    procedure [dbo].[Receiver_SelectPostDatedTransactionsReadyForFile]
 
@clientid int

AS

BEGIN

SELECT
	'APDT' as record_type,
	r.sendernumber as file_number,
	pdc.amount as amount,
	pdc.deposit as duedate
FROM
	master m with (nolock) join receiver_reference r with (nolock)
	on r.receivernumber = m.number join
	pdc pdc with (nolock) on pdc.number = m.number
WHERE
	m.closed is null
	and r.clientid = @clientid
	and active = 1 and deposit > getdate()

UNION

SELECT
	'APDT' as record_type,
	r.sendernumber as file_number,
	dcc.amount as amount,
	dcc.depositdate as duedate
FROM
	master m with (nolock) join receiver_reference r with (nolock)
	on r.receivernumber = m.number join
	debtorcreditcards dcc with (nolock) on dcc.number = m.number
WHERE
	m.closed is null
	and r.clientid = @clientid
	and isactive = 1 and depositdate > getdate()


END
GO
