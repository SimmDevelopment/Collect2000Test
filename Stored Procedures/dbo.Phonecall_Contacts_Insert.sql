SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[Phonecall_Contacts_Insert]
			@AccountID int,
			@DebtorID int,
			@PhoneCallAttemptsId int,
			@ContactDate date,
			@ExpressConsentDate date,
			@loginName varchar(10),
			@CreatedDate Datetime =null,
			@ReturnID int Output
		AS 
BEGIN
SET NOCOUNT ON;		
		IF @DebtorID = 0
		Begin
			Set @DebtorID = (Select Top 1  DebtorId From Debtors WHERE  number = @AccountID)
		End
DECLARE @Status bit;
EXEC GetComplianceCallAttemptandConversation @AccountID=@AccountID,@DebtorID=@DebtorID,@Status=@Status OUTPUT

IF(@Status=1)
BEGIN
		INSERT INTO Phonecall_Contacts(number, DebtorID, ContactDate, ExpressConsentDate, PhoneCallAttemptsId, loginName)
		VALUES (@AccountID, @DebtorID, @ContactDate, @ExpressConsentDate, @PhoneCallAttemptsId, @loginName)

		DECLARE @DebtorName VARCHAR(50);
		SELECT @DebtorName = Name FROM Debtors WHERE DebtorID = @DebtorID;
		DECLARE @Consent VARCHAR(1) = CASE WHEN @ExpressConsentDate IS NOT NULL THEN 'Y' ELSE 'N' END;
		DECLARE @Note VARCHAR(500) = 'Conversation ' + @DebtorName + ' held, Consent to call again ' + @Consent;
		IF @ExpressConsentDate IS NOT NULL
		BEGIN
			SET @Note = @Note + ', Call Date ' + CONVERT(VARCHAR(10),@ExpressConsentDate);
		END
		INSERT INTO [dbo].[notes]
           ([number]
           ,[created]
           ,[user0]
           ,[action]
           ,[result]
           ,[comment]
           ,[UtcCreated])
		VALUES
           (@AccountID
           ,@CreatedDate
           ,@loginName
           ,'+++++'
           ,'+++++'
           ,@Note
           ,GETUTCDATE())
END
		IF @@Error = 0 BEGIN
			Select @ReturnID = CASE WHEN @Status=1 THEN SCOPE_IDENTITY() ELSE 0 END
			Return 0
		END

		Return @@Error
END
GO
