SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_JHCapital_Direct_Payments] 
	-- Add the parameters for the stored procedure here
	@invoice VARCHAR(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.id1 AS data_id, CASE WHEN batchtype = 'pc' AND m.status NOT IN ('sif', 'pif') THEN '1000' WHEN batchtype = 'pc' AND m.status = 'sif' THEN '1002' WHEN batchtype = 'pc' AND m.status = 'pif' THEN '1001'  WHEN batchtype = 'pcr' THEN '1003' END AS tran_type,
	p.datepaid AS tran_date, CASE WHEN batchtype LIKE '%r' THEN -(p.paid1 + p.paid2) ELSE p.paid1 + p.paid2 END AS tran_amount,
	CASE WHEN batchtype LIKE '%r' THEN -(p.paid1) ELSE p.paid1 END AS tran_principal,
	CASE WHEN batchtype LIKE '%r' THEN -(p.paid2) ELSE p.paid2 END AS tran_interest,
	'' AS tran_court, '' AS tran_attorney, '' AS tran_nsf, '' AS tran_general, '' AS tran_other,
	CASE WHEN batchtype LIKE '%r' THEN -(CollectorFee) ELSE CollectorFee END AS tran_retained, '' AS tran_subtype
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
WHERE batchtype LIKE 'pc%' AND invoice IN (select string from dbo.CustomStringToSet(@invoice,'|') )
and id2 not in ('AllGate','ARS-JMET')

END
GO
