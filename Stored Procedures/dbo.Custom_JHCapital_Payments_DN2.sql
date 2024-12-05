SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_JHCapital_Payments_DN2] 
	-- Add the parameters for the stored procedure here
	@invoice VARCHAR(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.id1 AS data_id, 
	CASE WHEN batchtype = 'pu' AND m.status NOT IN ('sif', 'pif') THEN '1000' WHEN batchtype = 'pu' AND m.status = 'sif' THEN '1002' WHEN batchtype = 'pu' AND m.status = 'pif' THEN '1001' WHEN batchtype = 'pur' THEN '1003' WHEN batchtype = 'pu' AND m.current1 = 0 THEN '1001' END AS pay_type,
	CASE WHEN batchtype LIKE '%r' THEN (SELECT datepaid FROM payhistory WITH (NOLOCK) WHERE uid = p.reverseofuid) ELSE p.datepaid END AS pay_date, 
	CASE WHEN batchtype LIKE '%r' THEN -(p.paid1 + p.paid2 + p.paid5) ELSE p.paid1 + p.paid2 + p.paid5 END AS pay_amount,--updated 09/15/21 so that pay_other is now included within the pay_amount
	CASE WHEN batchtype LIKE '%r' THEN -(p.paid1) ELSE p.paid1 END AS pay_principal,
	CASE WHEN batchtype LIKE '%r' THEN -(p.paid2) ELSE p.paid2 END AS pay_interest,
	CASE WHEN batchtype LIKE '%r' THEN -(p.paid3) ELSE p.paid3 END AS pay_court, 
	CASE WHEN batchtype LIKE '%r' THEN -(p.paid4) ELSE p.paid4 END AS pay_attorney, 
	CASE WHEN batchtype LIKE '%r' THEN -(p.paid5) ELSE p.paid5 END AS pay_other,
	CASE WHEN batchtype LIKE '%r' THEN -(CollectorFee) ELSE CollectorFee END AS pay_due,
	'' AS pay_intrate, 
	CASE WHEN p.paymethod IN ('ACH DEBIT', 'CHECK') THEN 'R35'
		 WHEN p.paymethod IN ('Credit Card', 'PAPER DRAFT') THEN 'R36'--added Paper Draft 09/21/21
		 WHEN p.paymethod IN ('Money Gram', 'MONEY ORDER') THEN 'R38'
		 WHEN p.paymethod IN ('WESTERN UNION') THEN 'R39'
		 ELSE 'R01' End AS pay_subtype,--updated to R01 per client 09/15/21 used to be R40
	'' AS pay_source_number,
	'' AS pay_source_code,
	'' AS pay_source_code_01,
	'' AS pay_source_other,
	'' AS pay_source_rate
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
WHERE batchtype LIKE 'pu%' AND invoice IN (select string from dbo.CustomStringToSet(@invoice,'|') )
and id2 not in ('AllGate','ARS-JMET')

END
GO
