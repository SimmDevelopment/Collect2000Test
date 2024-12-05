SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_LINK_BD_Remittance] 
	-- Add the parameters for the stored procedure here
	@invoice VARCHAR(8000)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here



	    
SELECT CASE WHEN P.batchtype = 'PU' THEN 'P' WHEN P.batchtype = 'PUR' THEN 'R' END  AS [Record_Type], 'SAI' AS [VendorID], m.id1 AS [AccountID], m.account AS [ClientAccountID], 
(select top 1 (thedata) from miscextra me with (nolock) where number = m.number and title = 'Acc.0.MedicalRecordNumber') AS [MedicalRecordNumber], FORMAT(P.datepaid, 'MM/dd/yyyy') AS [Date],
CASE p.batchtype WHEN 'PUR' THEN -(p.paid1 + p.paid2 + p.paid3 + p.paid4) WHEN 'PU' THEN (p.paid1 + p.paid2 + p.paid3 + p.paid4) ELSE 0.00 END AS [Amount],
CASE WHEN p.batchtype LIKE '%r' THEN -(p.CollectorFee) ELSE (p.CollectorFee) END AS [ContingencyFee],
CASE  p.batchtype WHEN '%r' THEN -((p.paid1 + p.paid2 + p.paid3 + p.paid4) - (p.collectorfee)) WHEN 'PU' THEN ((p.paid1 + p.paid2 + p.paid3 + p.paid4) - (p.collectorfee)) WHEN 'PC' THEN -(p.CollectorFee) ELSE (p.paid1 + p.paid2 + p.paid3 + p.paid4 + p.paid5 + p.paid6 + p.paid7 + p.paid8 + p.paid9) - p.CollectorFee END AS [Remitted], 
CASE WHEN P.batchtype = 'PU' THEN 'FOR' WHEN P.batchtype =  'PUR' THEN 'NSF' END AS [Transaction_Type], 
CASE WHEN p.batchtype LIKE '%r' THEN FORMAT(P.datepaid, 'MM/dd/yyyy') ELSE '' END AS [OrigDate],
--CASE P.batchtype WHEN 'PUR' THEN FORMAT(P.datepaid, 'MM/dd/yyyy') AS [OrigDate],
CASE WHEN P.batchtype LIKE '%r' THEN -(p.paid1 + p.paid2 + p.paid3 + p.paid4) ELSE  '' END AS [OrigAmount],
CASE WHEN P.batchtype LIKE '%r' THEN -(p.CollectorFee) ELSE '' END AS [OrigContingencyFee],
CASE WHEN P.batchtype LIKE '%r' THEN -(p.totalpaid - p.CollectorFee) ELSE '' END AS [OrigRemitted],
(SELECT datepaid FROM payhistory WITH (NOLOCK) WHERE p.ReverseOfUID = uid) AS [NSFDate],
m.current0 AS [Balance],
'' AS [Notes]
FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = P.number
WHERE batchtype LIKE 'pu%' AND invoice IN (select string from dbo.CustomStringToSet(@invoice,'|') )
and m.customer IN ('0003115') 
--AND closed IS NULL
--group by m.id1,m.current0, m.original, p.batchtype, p.paid1, p.paid2, m.number


END

GO
