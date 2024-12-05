SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Changes:
-- 8/12/2016 Added SIF to be included.  BGM.
-- 10/26/2016 Added Portfolio Column to Report.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_GS2_UAS_FirstMark_Payments_New] 
	-- Add the parameters for the stored procedure here
	@invoice VARCHAR(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT (SELECT TOP 1 thedata FROM dbo.MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'Pri.0.ServicerAccountNumber') + '-' +(SELECT TOP 1 thedata FROM dbo.MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'Pri.0.ServicerSubAccountNumber') AS [Account_Number],
	CASE WHEN p.batchtype LIKE '%r' THEN '20' ELSE '10' END AS [Transaction_Action_Code],
	CASE WHEN batchtype LIKE '%r' THEN -(p.paid1 + p.paid2) ELSE p.paid1 + p.paid2 END AS [Payment_Amount],
	replace(CONVERT(varchar(10), p.datepaid, 112), '/', '') AS [Payment_Effective_Date],
	'GS' AS [Source_Code],
	--ISNULL(m.clidlp, '') AS [Genesis Last Paid Date],
	--ISNULL(m.clialp, '') AS [Genesis Amount Last Paid],
	'0' AS [Cash_Noncash_Indicator]
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
WHERE batchtype LIKE 'pu%' AND invoice IN (select string from dbo.CustomStringToSet(@invoice,'|'))

END
GO
