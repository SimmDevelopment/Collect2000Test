SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_Export_Remit_V34] 
	-- Add the parameters for the stored procedure here
	@invoice varchar(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'Ran.0.partner_id') AS [Partner Portfolio ID], '' AS [Partner Account ID],
	(SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'Acc.0.client_id') AS [Equabli Client ID], (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'Acc.0.client_account_number') AS [Equabli Client Account Number],
	(SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'Acc.0.portfolio_code') AS [Equabli Portfolio ID], (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'Acc.0.account_id') AS [Equabli Account ID],
	m.account AS [Original Account Number], m.Name AS [Consumer Name], m.original AS [Original Balance Placed],CASE WHEN m.customer = '0003096' THEN 'FRESH' WHEN m.customer = '0003111' THEN 'SECONDS' end as [Placement Stage (Primary, Secondary, etc.)], '' AS [Product Type (i.e. card, loan, auto, etc.)],
FORMAT(p.entered, 'yyyy-MM-dd') as [Payment Date], FORMAT(p.BatchPmtCreated, 'yyyy-MM-dd') AS [Posting Date], p.UID AS [Reference Number], CASE p.batchtype WHEN 'PU' THEN 'N' ELSE 'F' END AS [Payment Type], CASE WHEN m.customer = '0003096' THEN '20' WHEN m.customer = '0003111' THEN '25' end AS [Commission Rate (%)],
CASE WHEN p.batchtype LIKE '%r' THEN -(p.paid1 + p.paid2 + p.paid3 + p.paid4) ELSE (p.paid1 + p.paid2 + p.paid3 + p.paid4) END AS [Amount Paid (Gross due to Client)],
CASE WHEN p.batchtype LIKE '%r' THEN -(p.CollectorFee) ELSE (p.CollectorFee) END AS [Commission Due to Partner],
CASE WHEN p.batchtype LIKE '%r' THEN -((p.paid1 + p.paid2 + p.paid3 + p.paid4) - (p.collectorfee)) ELSE ((p.paid1 + p.paid2 + p.paid3 + p.paid4) - (p.collectorfee)) END AS [Net Due to Client after Invoice is paid],
m.current0 AS [Current Account Balance], m.OriginalCreditor AS [Orignal Creditor], 
Case When m.status in ('PCC','PDC','PPA') then 'PA'  ELSE m.status END as [Status],
CASE p.batchtype WHEN 'PC' THEN 'Y' ELSE 'N' END AS [Direct Pay (Y/N)]
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
WHERE invoice IN (select string from dbo.CustomStringToSet(@invoice, '|'))
END
GO
