SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PhoneConsentPanel_GetHistoryForId]
	@MasterPhoneID INT
AS
BEGIN

SELECT *
FROM dbo.Phones_Consent
WHERE MasterPhoneId = @MasterPhoneID

END

GO
