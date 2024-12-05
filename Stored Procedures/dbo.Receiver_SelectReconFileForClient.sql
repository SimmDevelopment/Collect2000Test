SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  procedure [dbo].[Receiver_SelectReconFileForClient]
@clientid int,
@agencyid int 

as
DECLARE @agencyName varchar(50)

SELECT @agencyName = 
case 
	WHEN ISNULL(UsingAlphacode,0) = 0 THEN cast(Name as varchar(50))
	else AlphaCode
END
FROM Receiver_Client with (Nolock)
where clientid = @clientid

SELECT
	'AREC' as record_type,
	rr.sendernumber as file_number,
	m.account as account,
	m.original as original_balance,
	m.received as received_date,
	isnull(rc.bucket1,1)*current1+
	isnull(rc.bucket2,1)*current2+
	isnull(rc.bucket3,1)*current3+
	isnull(rc.bucket4,1)*current4+
	isnull(rc.bucket5,1)*current5+
	isnull(rc.bucket6,1)*current6+
	isnull(rc.bucket7,1)*current7+
	isnull(rc.bucket8,1)*current8+
	isnull(rc.bucket9,1)*current9+
	isnull(rc.bucket10,1)*current10 as current_balance,
	m.lastpaid as last_payment_date,
	m.lastpaidamt as last_payment_amount

FROM 
	master m  with (nolock) join receiver_reference rr  with (nolock) on rr.receivernumber = m.number
	LEFT OUTER JOIN Receiver_ReconciliationConfig rc with (nolock) on rr.clientid = rc.clientid
WHERE
	rr.clientid = @clientid and
	m.returned is null and m.qlevel <> '999'

	
SELECT 
	'ATRL' as record_type,
	@agencyid as agency_id,
	@agencyName as agency_name,
	count(*) as records,
	sum(original) as total_original_balance,
	sum(isnull(rc.bucket1,1)*current1+
	isnull(rc.bucket2,1)*current2+
	isnull(rc.bucket3,1)*current3+
	isnull(rc.bucket4,1)*current4+
	isnull(rc.bucket5,1)*current5+
	isnull(rc.bucket6,1)*current6+
	isnull(rc.bucket7,1)*current7+
	isnull(rc.bucket8,1)*current8+
	isnull(rc.bucket9,1)*current9+
	isnull(rc.bucket10,1)*current10) as total_current_balance,
	getdate()

FROM
	master m  with (nolock) join receiver_reference rr  with (nolock) on rr.receivernumber = m.number
	LEFT OUTER JOIN Receiver_ReconciliationConfig rc with (nolock) on rr.clientid = rc.clientid
WHERE
	rr.clientid = @clientid and
	m.returned is null and m.qlevel <> '999'
GO
