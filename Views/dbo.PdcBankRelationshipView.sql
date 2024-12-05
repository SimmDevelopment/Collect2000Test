SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[PdcBankRelationshipView]
AS
SELECT [pdc].[UID] AS [PdcID],
	(
		SELECT TOP 1 [DebtorBankInfo].[BankID]
		FROM [dbo].[DebtorBankInfo]
		WHERE (
			[pdc].[number] = [DebtorBankInfo].[AcctID]
			AND COALESCE([pdc].[Seq], 0) = [DebtorBankInfo].[DebtorID]
			AND [pdc].[PaymentVendorTokenId] = [DebtorBankInfo].[PaymentVendorTokenId]
		)
		OR [pdc].[DebtorBankID] = [DebtorBankInfo].[BankID]
		ORDER BY CASE
			WHEN [pdc].[DebtorBankID] = [DebtorBankInfo].[BankID] THEN 0
			ELSE 0
		END
	) AS [DebtorBankID]
FROM [dbo].[pdc]
GO
