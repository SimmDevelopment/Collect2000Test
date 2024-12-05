SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AIM_SelectLedgerTypesForGrid]

AS
SELECT 
LedgerTypeId,
Name,
[Credit Group Type] = CASE CreditGroupTypeId WHEN 0 THEN 'Buyers'
						WHEN 1 THEN 'Sellers'
						WHEN 2 THEN 'Investors'
						WHEN 3 THEN 'Management'
						WHEN 4 THEN 'Debtor'
						ELSE 'Not Assigned' END,
[Debit Group Type] = CASE DebitGroupTypeId WHEN 0 THEN 'Buyers'
						WHEN 1 THEN 'Sellers'
						WHEN 2 THEN 'Investors'
						WHEN 3 THEN 'Management'
						WHEN 4 THEN 'Debtor'
						ELSE 'Not Assigned' END,
[System] = CASE IsSystem WHEN 0 THEN 'False'
						WHEN 1 THEN 'True'
						ELSE 'False' END

FROM AIM_LedgerType
ORDER BY Name ASC


GO
