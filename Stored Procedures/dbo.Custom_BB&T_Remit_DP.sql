SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_BB&T_Remit_DP] 
	-- Add the parameters for the stored procedure here
	@invoice varchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.Name AS [Name],m.account AS [Customer Account Number], p.datepaid AS [Pay Date],  '$0.00' AS [Paid To Client],	
'$0.00' AS [Net Amount],
CASE WHEN p.batchtype LIKE '%r' THEN -(p.paid1 + p.paid2 + p.paid3 + p.paid4) ELSE (p.paid1 + p.paid2 + p.paid3 + p.paid4) END AS[Paid To SIMM],
CASE WHEN p.batchtype LIKE '%r' THEN -(p.CollectorFee) ELSE (p.CollectorFee) END AS [Our Fee]
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
WHERE invoice IN (select string from dbo.CustomStringToSet(@invoice, '|')) AND batchtype IN ('pc', 'pcr')
END
GO
