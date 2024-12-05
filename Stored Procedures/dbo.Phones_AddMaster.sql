SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Phones_AddMaster]
	@Number INTEGER,
	@PhoneTypeID INTEGER,
	@Relationship VARCHAR(50) = NULL,
	@PhoneStatusID INTEGER = 0,
	@OnHold BIT = 0,
	@PhoneNumber VARCHAR(30),
	@PhoneExt VARCHAR(10) = '',
	@DebtorID INTEGER = NULL,
	@RequestID INTEGER = NULL,
	@PhoneName VARCHAR(50) = NULL,
	@NearbyContactID INTEGER = NULL,
	@LoginName VARCHAR(10) = NULL,
	@MasterPhoneID INTEGER OUTPUT
AS
SET NOCOUNT ON;

IF @LoginName IS NULL BEGIN
	SELECT @LoginName = [LoginName]
	FROM [dbo].[GetCurrentLatitudeUser]();
END;
  SET @PhoneStatusID=ISNULL(@PhoneStatusID,0)
--LAT-10597 Adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table
IF NOT EXISTS(SELECT * FROM [dbo].[Phones_Master] WHERE [Phones_Master].[Number] = @Number AND [Phones_Master].[PhoneNumber] = @PhoneNumber AND [Phones_Master].[DebtorID] = @DebtorID)
INSERT INTO [dbo].[Phones_Master] ([Number], [PhoneTypeID], [Relationship], [PhoneStatusID], [OnHold], [PhoneNumber], [PhoneExt], [DebtorID], [DateAdded], [RequestID], [PhoneName], [NearbyContactID], [LoginName], [LastUpdated], [UpdatedBy])
VALUES (@Number, @PhoneTypeID, @Relationship, @PhoneStatusID, @OnHold, @PhoneNumber, @PhoneExt, @DebtorID, GETDATE(), @RequestID, @PhoneName, @NearbyContactID, @LoginName, NULL, NULL);

SET @MasterPhoneID = SCOPE_IDENTITY();
SELECT @MasterPhoneID = CASE WHEN @MasterPhoneID IS NOT NULL THEN @MasterPhoneID ELSE 0 END

RETURN 0;
GO
