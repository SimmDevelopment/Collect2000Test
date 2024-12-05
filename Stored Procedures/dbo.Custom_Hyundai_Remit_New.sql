SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Hyundai_Remit_New] 
	-- Add the parameters for the stored procedure here
	@invoice varchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 'SIMM 2nd Placement' AS [Note],m.account AS [Account Number], null as [Group Code],upper(left(CONVERT(VARCHAR(15), received ,107),3))+ ' - ' + right(CONVERT(VARCHAR(15), received ,107),4) AS [Batch/Placement Month],CONVERT(VARCHAR(10), invoiced, 101) AS [Effective Date],  CASE WHEN p.batchtype LIKE '%r' THEN -(p.paid1 + p.paid2 + p.paid3 + p.paid4) ELSE (p.paid1 + p.paid2 + p.paid3 + p.paid4) END AS [Payment Amount],	
'35' AS [Commision Percentage],CASE WHEN p.batchtype LIKE '%r' THEN -(p.CollectorFee) ELSE (p.CollectorFee) END AS [Commission Fee],
CASE WHEN p.batchtype LIKE '%r' THEN -((p.paid1 + p.paid2 + p.paid3 + p.paid4) - (p.collectorfee)) ELSE ((p.paid1 + p.paid2 + p.paid3 + p.paid4) - (p.collectorfee)) END AS [Net Due to Us]
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
WHERE invoice IN (select string from dbo.CustomStringToSet(@invoice, '|'))
END
GO
