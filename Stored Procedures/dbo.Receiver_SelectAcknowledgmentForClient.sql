SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE  procedure [dbo].[Receiver_SelectAcknowledgmentForClient]
@historyids varchar(8000),
@clientId int

as

DECLARE @sql VARCHAR(8000)

SET @sql = 
'SELECT
	''AACK'' as record_type,
	rr.sendernumber as file_number,
	m.account as account,
	m.original as original_balance,
	m.received as received_date,
	m.current0 as current_balance,
	m.lastpaid as last_payment_date,
	m.lastpaidamt as last_payment_amount

FROM 
	master m  with (nolock) join receiver_reference rr  with (nolock) on rr.receivernumber = m.number
	join receiver_historydetail rhd on rhd.number = rr.receivernumber
	join receiver_history rh on rhd.historyid = rh.historyid
WHERE
	rr.clientid = ' +   cast(@clientid as varchar(4)) + ' AND
	rhd.historyid IN (' +  @historyids + ')
	and received = convert(varchar(10),transactiondate,121)'


EXEC(@sql)
GO
