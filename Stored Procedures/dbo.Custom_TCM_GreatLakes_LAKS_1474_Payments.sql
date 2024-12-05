SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_TCM_GreatLakes_LAKS_1474_Payments] 
	-- Add the parameters for the stored procedure here
	@invoice VARCHAR(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.account AS [Account Reference], m.ssn AS [Borr SSN], 
	m.NAME AS [Borr Name], p.datepaid AS [Effective Date],
	CASE WHEN batchtype LIKE '%r' THEN -(p.paid1 + p.paid2) ELSE p.paid1 + p.paid2 END AS [Payment Amount],
	--CASE WHEN m.status = 'PIF' THEN 'Paid in Full' WHEN m.STATUS = 'SIF' THEN 'Settled in Full' WHEN p.batchtype LIKE '%r' THEN 'NSF' ELSE 'Regular Payment' END AS [Payment Type],
	--ISNULL(m.clidlp, '') AS [Genesis Last Paid Date],
	--ISNULL(m.clialp, '') AS [Genesis Amount Last Paid],
	CASE m.customer WHEN '0001474' THEN 'Great Lakes' ELSE '' END AS [Portfolio]
	--THEN 'BLST' WHEN '0001467' THEN 'CRC HEALTH' WHEN '0001468' THEN 'DSN' 
	--WHEN '0001469' THEN 'KEISER' WHEN '0001470' THEN 'SOUTH COLLEGE' ELSE '' END AS [Portfolio]
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
WHERE batchtype LIKE 'pu%' AND invoice IN (select string from dbo.CustomStringToSet(@invoice,'|'))
END
GO
