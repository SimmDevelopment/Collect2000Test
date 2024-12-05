SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Latitude
-- Create date: Unknown
-- Description:	Set Phone Consent when a new phone is added on account
-- Changes:		Set default settings to True for Allow Manual Call, AutoDialer, Fax and Text
-- =============================================


CREATE PROCEDURE [dbo].[Phones_AddConsent]
@MasterPhoneID INTEGER,
@AllowManualCall BIT = 1,
@AllowAutoDialer BIT = 1,
@AllowFax BIT = 1,
@AllowText BIT = 1,
@WrittenConsent BIT = 0,
@ObtainedFrom VARCHAR(200) = NULL,
@DocumentationId INTEGER = NULL,
@UserId INTEGER = NULL,
@EffectiveDate datetime,
@Comment text = NULL ,
@UserName Varchar(30) =''

AS
BEGIN
SET NOCOUNT ON;

	SET @ObtainedFrom = ISNULL(@ObtainedFrom, '');
	
	DECLARE @DebtorID INT, @Number VARCHAR(10), @DebtorName VARCHAR(50), @PhoneNumber VARCHAR(12), @CurrentManualCall BIT, @CurrentAutoDialer BIT, @CurrentFax BIT, @CurrentText BIT, @PhoneTypeID INT;

	SELECT @DebtorID = DebtorID, @PhoneNumber = PhoneNumber, @PhoneTypeID = PhoneTypeID FROM [dbo].[Phones_Master] WITH (NOLOCK) WHERE MasterPhoneID = @MasterPhoneID;
	SELECT @Number = Number, @DebtorName = Name FROM Debtors With (NOLOCK) WHERE DebtorID = @DebtorId;
	SELECT TOP 1 @CurrentManualCall = AllowManualCall, @CurrentAutoDialer = AllowAutoDialer, @CurrentFax = AllowFax, @CurrentText = AllowText 
	FROM [dbo].[Phones_Consent] WITH (NOLOCK) WHERE MasterPhoneID = @MasterPhoneID ORDER BY EffectiveDate DESC;

	INSERT INTO [dbo].[Phones_Consent] ([MasterPhoneId], [AllowManualCall], [AllowAutoDialer], [AllowFax], [AllowText], [WrittenConsent], [ObtainedFrom], [DocumentationId], [UserId], [EffectiveDate], [Comment])
	VALUES (@MasterPhoneID, @AllowManualCall, @AllowAutoDialer, @AllowFax, @AllowText, @WrittenConsent, @ObtainedFrom, @DocumentationId, @UserId, @EffectiveDate, @Comment);

	DECLARE @LinkedAccounts TABLE (
		[AccountID] [INT] NOT NULL,
		[Linked] [BIT] NOT NULL
	)

	INSERT INTO @LinkedAccounts ([AccountId], [Linked])
	SELECT [AccountID], [Linked] FROM [dbo].[fnGetLinkedAccounts](@Number, NULL)

	IF EXISTS (SELECT 1 FROM @LinkedAccounts WHERE AccountID <> @Number)
	BEGIN
		DECLARE @PhoneMasters TABLE (
			[MasterPhoneId] [INT] NOT NULL,
			[PhoneNumber] [VARCHAR](30) NOT NULL,
			[DebtorName] [VARCHAR](300) NULL,
			[Number] [INT] NOT NULL
		)

		INSERT INTO @PhoneMasters ([MasterPhoneId], [PhoneNumber], [Number], [DebtorName])
		SELECT pm.[MasterPhoneID], pm.[PhoneNumber], jd.[AccountID], d.[Name]
		FROM [dbo].[Phones_Master] pm WITH (NOLOCK)
			INNER JOIN @LinkedAccounts jd
				ON pm.[Number] = jd.[AccountID]
			INNER JOIN [dbo].[Debtors] d WITH (NOLOCK)
				ON pm.DebtorID = d.DebtorID
		WHERE pm.[PhoneNumber] = @PhoneNumber
			AND pm.[PhoneTypeID] = @PhoneTypeID
			AND jd.AccountID <> @Number
			AND NOT EXISTS (SELECT 1 FROM [dbo].[Phones_Consent] pp WITH (NOLOCK) WHERE pp.[MasterPhoneId] = pm.[MasterPhoneId])

		IF EXISTS (SELECT 1 FROM @PhoneMasters)
		BEGIN
			INSERT INTO [dbo].[Phones_Consent] ([MasterPhoneId], [AllowManualCall], [AllowAutoDialer], [AllowFax], [AllowText], [WrittenConsent], [ObtainedFrom], [DocumentationId], [UserId], [EffectiveDate], [Comment])         
			SELECT pm.[MasterPhoneId], @AllowManualCall, @AllowAutoDialer, @AllowFax, @AllowText, @WrittenConsent, @ObtainedFrom, @DocumentationId, @UserId, @EffectiveDate, @Comment   
			FROM @PhoneMasters pm;
		END  
	END

	IF @CurrentManualCall <> @AllowManualCall
	BEGIN
		INSERT notes VALUES(@Number, null, GETDATE(), @UserName, '+++++', '+++++', 'Debtor '+@DebtorName+' phone '+@PhoneNumber+' consent changed for Manual Call from ' + CASE @CurrentManualCall WHEN 1 THEN 'Y' ELSE 'N' END+' to ' + CASE @AllowManualCall WHEN 1 THEN 'Y' ELSE 'N' END, NULL, NULL, GETUTCDate()) 

		IF EXISTS (SELECT 1 FROM @PhoneMasters)
		BEGIN
			INSERT notes 
			SELECT [Number], null, GETDATE(), @UserName, '+++++', '+++++', 'Debtor '+ [DebtorName] +' Phone '+ [PhoneNumber] +' consent changed for Manual Call from ' + CASE @CurrentManualCall WHEN 1 THEN 'Y' ELSE 'N' END+' to ' + CASE @AllowManualCall WHEN 1 THEN 'Y' ELSE 'N' END, NULL, NULL, GETUTCDate() 
			FROM @PhoneMasters
		END
	END
	IF @CurrentAutoDialer <> @AllowAutoDialer
	BEGIN
		INSERT notes VALUES(@Number, null, GETDATE(), @UserName, '+++++', '+++++', 'Debtor '+@DebtorName+' phone '+@PhoneNumber+' consent changed for Auto Dialer from ' + CASE @CurrentAutoDialer WHEN 1 THEN 'Y' ELSE 'N' END+' to ' + CASE @AllowAutoDialer WHEN 1 THEN 'Y' ELSE 'N' END, NULL, NULL, GETUTCDate()) 

		IF EXISTS (SELECT 1 FROM @PhoneMasters)
		BEGIN
			INSERT notes 
			SELECT [Number], null, GETDATE(), @UserName, '+++++', '+++++', 'Debtor '+@DebtorName+' phone '+@PhoneNumber+' consent changed for Auto Dialer from ' + CASE @CurrentAutoDialer WHEN 1 THEN 'Y' ELSE 'N' END+' to ' + CASE @AllowAutoDialer WHEN 1 THEN 'Y' ELSE 'N' END, NULL, NULL, GETUTCDate() 
			FROM @PhoneMasters
		END
	END
	IF @CurrentFax <> @AllowFax
	BEGIN
		INSERT notes VALUES(@Number, null, GETDATE(), @UserName, '+++++', '+++++', 'Debtor '+@DebtorName+' phone '+@PhoneNumber+' consent changed for Fax from ' + CASE @CurrentFax WHEN 1 THEN 'Y' ELSE 'N' END+' to ' + CASE @AllowFax WHEN 1 THEN 'Y' ELSE 'N' END, NULL, NULL, GETUTCDate()) 

		IF EXISTS (SELECT 1 FROM @PhoneMasters)
		BEGIN
			INSERT notes 
			SELECT [Number], null, GETDATE(), @UserName, '+++++', '+++++', 'Debtor '+@DebtorName+' phone '+@PhoneNumber+' consent changed for Fax from ' + CASE @CurrentFax WHEN 1 THEN 'Y' ELSE 'N' END+' to ' + CASE @AllowFax WHEN 1 THEN 'Y' ELSE 'N' END, NULL, NULL, GETUTCDate() 
			FROM @PhoneMasters
		END
	END
	IF @CurrentText <> @AllowText
	BEGIN
		INSERT notes VALUES(@Number, null, GETDATE(), @UserName, '+++++', '+++++', 'Debtor '+@DebtorName+' phone '+@PhoneNumber+' consent changed for Text/SMS from ' + CASE @CurrentText WHEN 1 THEN 'Y' ELSE 'N' END+' to ' + CASE @AllowText WHEN 1 THEN 'Y' ELSE 'N' END, NULL, NULL, GETUTCDate()) 

		IF EXISTS (SELECT 1 FROM @PhoneMasters)
		BEGIN
			INSERT notes 
			SELECT [Number], null, GETDATE(), @UserName, '+++++', '+++++', 'Debtor '+@DebtorName+' phone '+@PhoneNumber+' consent changed for Text/SMS from ' + CASE @CurrentText WHEN 1 THEN 'Y' ELSE 'N' END+' to ' + CASE @AllowText WHEN 1 THEN 'Y' ELSE 'N' END, NULL, NULL, GETUTCDate() 
			FROM @PhoneMasters
		END
	END
END
GO
