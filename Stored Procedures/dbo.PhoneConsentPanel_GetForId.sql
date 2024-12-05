SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PhoneConsentPanel_GetForId]
	@MasterPhoneID INT
AS
BEGIN

SELECT TOP 1 AllowManualCall, AllowText, WrittenConsent, ObtainedFrom, comment
FROM dbo.Phones_Consent
WHERE MasterPhoneId = @MasterPhoneID
ORDER BY EffectiveDate DESC

END

GO
