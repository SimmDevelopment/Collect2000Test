SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwPhonesConsent]
AS
	SELECT pm.Number,pm.DebtorID, pc.* FROM Phones_Consent pc
	INNER JOIN Phones_Master pm ON pm.MasterPhoneID = pc.MasterPhoneId

GO
