SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PhoneContactPreferenceChoiceHistory_GetCurrent]
	@MasterPhoneID INT
AS
BEGIN

SELECT MasterPhoneId, SaveGroupId, ContactPreferenceChoiceCode, CanCall, CreatedBy, CreatedWhen
FROM dbo.PhoneContactPreferenceChoiceCurrent
WHERE MasterPhoneId = @MasterPhoneID

END

GO
