SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*

DECLARE @startDate datetime
DECLARE	@endDate datetime
DECLARE	@customer varchar(8000)
SET @startDate = '20070201'
SET @endDate = '20070228'
SET @customer = '0000831|0000895|'
EXECUTE [Custom_Simms_Pinnacle_Payment]    @startDate, @endDate, @customer

*/

CREATE     PROCEDURE [dbo].[Custom_Simms_Pinnacle_Payment]
	@startDate datetime,
	@endDate datetime,
	@customer varchar(8000)
AS
BEGIN

	SELECT 
		m.account as [data_id],
		CASE	WHEN p.batchtype in ('DA','DAR') THEN '3000'
				WHEN p.batchtype in ('PA','PU') and m.status not in ('SIF','PIF') THEN '1000'
				WHEN p.batchtype in ('PA','PU') and m.status = 'SIF' THEN '1002'
				WHEN p.batchtype in ('PA','PU') and m.status = 'PIF' THEN '1001'
				WHEN p.batchtype in ('PAR','PUR') THEN '1003'
		END AS [trans_type],
		p.datepaid AS [tran_date],
		CASE WHEN p.batchtype in ('PA','PU') THEN dbo.Custom_CalculatePaymentTotalPaid (p.uid) ELSE (-1*dbo.Custom_CalculatePaymentTotalPaid (p.uid)) END AS [tran_amount],
		CASE WHEN p.batchtype in ('DAR','PA','PU') THEN p.paid1 ELSE (-1*p.paid1) END AS [tran_principal],
		CASE WHEN p.batchtype in ('DAR','PA','PU') THEN p.paid2 ELSE (-1*p.paid2) END AS [tran_interest],
		CASE WHEN p.batchtype in ('DAR','PA','PU') THEN p.paid8 ELSE (-1*p.paid8) END AS [tran_court],
		CASE WHEN p.batchtype in ('DAR','PA','PU') THEN p.paid5 ELSE (-1*p.paid5) END AS [tran_attorney],
		CASE WHEN p.batchtype in ('PAR','PUR') THEN p.paid6 ELSE 0.00 END AS [tran_nsf],
		0.00 AS [tran_general],
		CASE WHEN p.batchtype in ('DAR','PA','PU') THEN (p.paid4 + p.paid7) ELSE (-1*(p.paid4 + p.paid7)) END AS [tran_other],
		CASE WHEN p.batchtype in ('DAR','PA','PU') and m.customer = '0000831' THEN (dbo.Custom_CalculatePaymentTotalFee (p.uid))
			WHEN p.batchtype in ('PA','PU') and m.customer = '0000895' THEN (dbo.Custom_CalculatePaymentTotalFee (p.uid))
			WHEN p.batchtype in ('DAR','PAR','PUR') and m.customer = '0000831' THEN (-1*(dbo.Custom_CalculatePaymentTotalFee (p.uid)))
			ELSE (-1*(dbo.Custom_CalculatePaymentTotalFee (p.uid))) END AS [tran_retained]
	FROM PayHistory p with (nolock)
	JOIN master m with (nolock) ON m.number=p.number
	WHERE p.datepaid BETWEEN @startDate AND @endDate
	AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
	AND p.batchtype in ('PUR','PAR','PU','PA')
	

END



GO
