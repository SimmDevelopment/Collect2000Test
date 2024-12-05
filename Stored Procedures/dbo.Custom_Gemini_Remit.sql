SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Gemini_Remit] 
	-- Add the parameters for the stored procedure here
	@invoice varchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.account AS [Account],CONVERT(VARCHAR(10), p.entered, 101) as [Payment Date],CASE batchtype WHEN 'pur' THEN -(p.paid1 + p.paid2 + p.paid3 + p.paid4 + p.paid5 + p.paid6 + p.paid7 + p.paid8 + p.paid9) WHEN 'PU' then (p.paid1 + p.paid2 + p.paid3 + p.paid4 + p.paid5 + p.paid6 + p.paid7 + p.paid8 + p.paid9) ELSE 0.00 END AS [Amount of Payment],
CASE batchtype WHEN 'PCR' THEN -(p.paid1 + p.paid2 + p.paid3 + p.paid4 + p.paid5 + p.paid6 + p.paid7 + p.paid8 + p.paid9) WHEN 'PC' then (p.paid1 + p.paid2 + p.paid3 + p.paid4 + p.paid5 + p.paid6 + p.paid7 + p.paid8 + p.paid9) ELSE 0.00 END AS [Direct Payment],
f.fee1 AS [Commision Rate],
CASE WHEN p.batchtype LIKE '%r' THEN -(p.CollectorFee) ELSE (p.CollectorFee) END AS [Commission Amount],
CASE WHEN batchtype LIKE '%r' THEN -((p.paid1 + p.paid2 + p.paid3 + p.paid4 + p.paid5 + p.paid6 + p.paid7 + p.paid8 + p.paid9) - p.CollectorFee) ELSE (p.paid1 + p.paid2 + p.paid3 + p.paid4 + p.paid5 + p.paid6 + p.paid7 + p.paid8 + p.paid9) - p.CollectorFee END AS [Net Amount],
m.current0 AS [Remaining Balance], m.status AS [status]
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number INNER JOIN dbo.FeeScheduleDetails f WITH (NOLOCK) ON p.FeeSched = f.Code
WHERE invoice IN (select string from dbo.CustomStringToSet(@invoice, '|'))
END

GO
