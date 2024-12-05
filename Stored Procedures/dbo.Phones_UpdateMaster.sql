SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Phones_UpdateMaster]
	@MasterPhoneID INTEGER,
	@PhoneTypeID INTEGER,
	@Relationship VARCHAR(50) = '',
	@PhoneStatusID INTEGER = 0,
	@OnHold BIT = 0,
	@PhoneNumber VARCHAR(30),
	@PhoneExt VARCHAR(10) = '',
	@DebtorID INTEGER,
	@RequestID INTEGER = NULL,
	@PhoneName VARCHAR(50) = NULL,
	@NearbyContactID INTEGER = NULL,
	@UpdatePhoneHistory BIT = 0,
	@PhoneHistoryType INTEGER = NULL,
	@NewPhoneNumber VARCHAR(30) = NULL
AS
SET NOCOUNT ON;

DECLARE @AccountID INTEGER;
DECLARE	@LoginName VARCHAR(10);
SET @PhoneStatusID=ISNULL(@PhoneStatusID,0)
    SELECT @LoginName = [LoginName]
	FROM [dbo].[GetCurrentLatitudeUser]();

--Custom SIMM changes from 8.5
IF @PhoneNumber = '**********' RETURN 0;


--LAT-10597 After adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table
UPDATE [dbo].[Phones_Master]
SET @AccountID = [Number],
	[PhoneTypeID] = @PhoneTypeID,
	[Relationship] = @Relationship,
	[PhoneStatusID] = @PhoneStatusID,
	[OnHold] = @OnHold,
	[PhoneNumber] = @PhoneNumber,
	[PhoneExt] = @PhoneExt,
	[DebtorID] = @DebtorID,
	[RequestID] = @RequestID,
	[PhoneName] = @PhoneName,
	[NearbyContactID] = @NearbyContactID,
	[LastUpdated] = GETDATE(),
	[UpdatedBy] = @LoginName
WHERE [MasterPhoneID] = @MasterPhoneID;

IF @@ROWCOUNT = 0 RETURN 0;


--Custom SIMM changes from 8.5
--IF @UpdatePhoneHistory = 1 AND @PhoneHistoryType IN (1, 2) BEGIN
	

	IF @NewPhoneNumber IS NULL BEGIN
		SET @NewPhoneNumber = '';
	END;

	SET @PhoneHistoryType = COALESCE(@PhoneHistoryType, @PhoneTypeID)

	EXEC [dbo].[PhoneHistory_Insert] @AccountID = @AccountID, @DebtorID = @DebtorID, @UserChanged = @LoginName, @PhoneType = @PhoneHistoryType, @OldNumber = @PhoneNumber, @NewNumber = @NewPhoneNumber;
--END;

RETURN 0;
GO
