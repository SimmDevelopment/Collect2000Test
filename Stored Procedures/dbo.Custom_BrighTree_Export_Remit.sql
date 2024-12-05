SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 08/30/2018
-- Description:	Creates export remit file
-- =============================================
CREATE PROCEDURE [dbo].[Custom_BrighTree_Export_Remit]
	-- Add the parameters for the stored procedure here
	@invoice varchar(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--Get Account information
SELECT m.id1 AS AgencyPlacementID, m.OriginalCreditor AS CreditorName, m.name AS RSPName,
--Payment code determines Paid us or Paid Client 
CASE WHEN batchtype LIKE 'PU%' THEN 1 ELSE 2 END AS PaymentCodeID,
--Get payment information including remaining balance
p.datepaid AS PaymentDate, CASE WHEN batchtype LIKE '%r' THEN -(p.paid1 + p.paid2) ELSE p.paid1 + p.paid2 END AS PaymentAmount, p.balance AS BalanceOwed,
CASE WHEN batchtype LIKE '%r' THEN -(p.CollectorFee) ELSE p.CollectorFee END AS AgencyFee,
p.invoiced AS RemitDate,
--Must include communication ID of the direct pay
CASE WHEN batchtype LIKE 'PC%' THEN p.checknbr ELSE '' END AS CommunicationID
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
LEFT OUTER JOIN LinkedBalances lb WITH (NOLOCK) ON m.link = lb.link
WHERE p.batchtype LIKE 'P%' AND p.Invoice in (select string from dbo.CustomStringToSet(@invoice, '|'))

END
GO
