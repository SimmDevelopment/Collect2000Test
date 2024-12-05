SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Changes:
--			03/29/2023 BGM Temporarily added Full Name to query to double check first name last name being sent.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_College_Avenue_Remit]
	-- Add the parameters for the stored procedure here
	@invoice varchar(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT CASE WHEN batchtype LIKE '%r' THEN -(p.paid1 + p.paid2) ELSE (p.paid1 + p.paid2) END AS [# Amount],d.firstName as [First Name], d.lastName AS [Last Name],m.account as [Connect Identifier],CONVERT(VARCHAR(10), p.datepaid,101) AS [Effective Date], 
	CASE p.paymethod WHEN 'CASH' THEN 'SIMM CASH' WHEN 'CHECK' THEN 'SIMM CHECK' WHEN 'PAPER DRAFT' THEN 'SIMM PAPER DRAFT' WHEN 'MONEY ORDER' THEN 'SIMM MONEY ORDER' WHEN 'WESTERN UNION' THEN 'SIMM WESTERN UNION'
	WHEN 'CREDIT CARD' THEN 'SIMM CREDIT CARD PAYMENT' WHEN 'ACH DEBIT' THEN 'SIMM ACH DEBIT' WHEN 'POST-DATED CHECK' THEN 'SIMM POST-DATED CHECK' WHEN 'BANK WIRE' THEN 'SIMM BANK WIRE' WHEN 'SAVINGS ACH' THEN 'SIMM SAVINGS ACH'
	WHEN 'MONEY GRAM' THEN 'SIMM MONEY GRAM' ELSE '' END AS [Description], '' as [University Number],'' as [Client ID],'' as [Client Type], '' as [Client Description], '' as [Client Source],
    'Y' as [Cash], '' as [Subclass], '' as [Contingency Paid]
	, CASE WHEN SUBSTRING(D.name, 1, CHARINDEX(',', D.name)-1) <> D.lastname THEN 'Check' ELSE 'Good' END AS CheckName
	, (SELECT TOP 1 TheData FROM MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.full_name') AS LastNameFirst
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
WHERE invoice IN (select string from dbo.CustomStringToSet(@invoice, '|'))

END
GO
