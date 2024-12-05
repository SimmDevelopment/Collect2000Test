SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PhoneConsentPanel_Insert]
	@MasterPhoneID INT,
	@CanCall BIT,
	@CanText BIT,
	@WrittenConsent BIT,
	@ConsentBy VARCHAR(100),
	@Comment TEXT,
	@UserId INT,
	@SaveGroupId UNIQUEIDENTIFIER
AS
BEGIN

INSERT INTO dbo.Phones_Consent (MasterPhoneId, AllowManualCall, AllowText, WrittenConsent, ObtainedFrom, UserId, EffectiveDate, comment, SaveGroupId)
VALUES (@MasterPhoneID, @CanCall, @CanText, @WrittenConsent, @ConsentBy, @UserId, GETDATE(), @Comment, @SaveGroupId)

END

GO
