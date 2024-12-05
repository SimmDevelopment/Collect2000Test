SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PhoneContactPreferenceChoiceHistory_Insert]
	@MasterPhoneID INT,
	@SaveGroupId UNIQUEIDENTIFIER,
	@ContactPreferenceChoiceCode VARCHAR(20),
	@CanCall BIT,
	@CreatedBy VARCHAR(50),
	@CreatedWhen DATETIME NULL
AS
BEGIN

INSERT INTO dbo.PhoneContactPreferenceChoiceHistory (MasterPhoneId, SaveGroupId, ContactPreferenceChoiceCode, CanCall, CreatedBy, CreatedWhen)
VALUES (@MasterPhoneID, @SaveGroupId, @ContactPreferenceChoiceCode, @CanCall, @CreatedBy, @CreatedWhen)
 
END

GO
