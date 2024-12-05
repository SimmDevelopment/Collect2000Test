SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 4/8/2020
-- Description:	Export Payments
-- =============================================
CREATE PROCEDURE [dbo].[Custom_ARC_Payments] 
	-- Add the parameters for the stored procedure here
	@invoice VARCHAR(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.id2 AS data_id, 
	CASE WHEN batchtype = 'pu' AND m.status NOT IN ('sif', 'pif') THEN '1000' WHEN batchtype = 'pu' AND m.status = 'sif' THEN '1002' WHEN batchtype = 'pu' AND m.status = 'pif' THEN '1001' WHEN batchtype = 'pur' THEN '1003' WHEN batchtype = 'pu' AND m.current1 = 0 THEN '1001' END AS tran_type,
	p.datepaid AS tran_date,
	--CASE WHEN batchtype LIKE '%r' THEN (SELECT datepaid FROM payhistory WITH (NOLOCK) WHERE uid = p.reverseofuid) ELSE p.datepaid END AS tran_date, 
	CASE WHEN batchtype LIKE '%r' THEN -(p.totalpaid) ELSE p.totalpaid END AS tran_amount,
	CASE WHEN batchtype LIKE '%r' THEN -(p.paid1) ELSE p.paid1 END AS tran_principal,
	CASE WHEN batchtype LIKE '%r' THEN -(p.paid2) ELSE p.paid2 END AS tran_interest,
	CASE WHEN batchtype LIKE '%r' THEN -(p.paid3) ELSE p.paid3 END AS tran_court, 
	CASE WHEN batchtype LIKE '%r' THEN -(p.paid4) ELSE p.paid4 END AS tran_attorney, 
	CASE WHEN batchtype LIKE '%r' THEN -(p.paid5) ELSE p.paid5 END AS tran_other,
	CASE WHEN batchtype LIKE '%r' THEN -(p.CollectorFee) ELSE p.CollectorFee END AS tran_retained,
	'' AS tran_source_bal_total,
	'' AS tran_source_bal_principal,
	'' AS tran_source_bal_interest,
	'' AS tran_source_bal_court,
	'' AS tran_source_bal_attorney,
	'' AS tran_source_bal_other,
	'' AS tran_source_rate,
	'' AS intrate
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
--WHERE invoice IN (select string from dbo.CustomStringToSet(@invoice, '|'))
WHERE batchtype LIKE 'pu%' AND invoice IN (select string from dbo.CustomStringToSet(@invoice,'|') )


END
GO
