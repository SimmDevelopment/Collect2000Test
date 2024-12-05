SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[PhoneContactPreferenceChoiceCurrent]
AS

SELECT MasterPhoneId, SaveGroupId, ContactPreferenceChoiceCode, CanCall, CreatedBy, CreatedWhen
FROM PhoneContactPreferenceChoiceHistory p (NOLOCK)
WHERE SaveGroupId = (SELECT TOP 1 SaveGroupId FROM PhoneContactPreferenceChoiceHistory (NOLOCK) WHERE MasterPhoneId = p.MasterPhoneId ORDER BY CreatedWhen DESC)

GO
