SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_ValidationNotice_Add*/
/*sp_ValidationNotice_Add*/
CREATE PROCEDURE [dbo].[sp_ValidationNotice_Add]
	@AccountId int,	
	@DebtorID int,
	@ValidationNoticeType varchar (25),
	@CreatedBy varchar (10) = null,
	@ValidationPeriodExpiration  date = null,
	@LetterRequestID int = null,
	@ValidationNoticeSentDate  date = null,
	@LastUpdated datetime = null,
	@Status VARCHAR(10) = 'Sent',
	@ValidationPeriodCompleted bit = 0
 AS	

 SET NOCOUNT ON;
	 Declare @noOfDays INT
	 Declare @NoticeID INT
	BEGIN TRAN
		IF(@ValidationNoticeSentDate IS NULL)
		BEGIN
			SET @ValidationNoticeSentDate = GETUTCDATE();
			IF (@LastUpdated IS NULL)
			BEGIN
				SET @LastUpdated = GETDATE();
			END
		END
		EXEC sp_LetterRequest_CalcValidationPeriodExpiration 
		@ValidationPeriodExpiration=@ValidationPeriodExpiration OUTPUT,
		@ValidationNoticeType = @ValidationNoticeType,
		@AccountID = @AccountId,
		@ProcessedDate = @ValidationNoticeSentDate	

		IF (@ValidationPeriodExpiration is not null)
		BEGIN 
		Select @NoticeID = NoticeID from ValidationNotice where DebtorID=@DebtorID
		IF  isnull(@NoticeID,0) <> 0 
		Begin
			select Top 1  @LetterRequestID =lr.LetterRequestID from LetterRequest lr  
			inner join letter l on l.code =lr.LetterCode where lr.SubjDebtorID =@DebtorID and l.type  ='DUN' order by l.LetterID desc
			IF @ValidationNoticeType ='Verbally' Set @LetterRequestID =NULL
			Update ValidationNotice set ValidationNoticeSentDate=GETUTCDATE() ,
			ValidationNoticeType =@ValidationNoticeType,
			ValidationPeriodExpiration=@ValidationPeriodExpiration ,
			LetterRequestID =@LetterRequestID ,
			ValidationPeriodCompleted =0,
			LastUpdated =GETUTCDATE() ,
			[Status] ='Sent' where DebtorID =@DebtorID
		End
		Else 
		Begin
		
		DECLARE @PolicySetting nvarchar(max);

		DECLARE @Configured BIT ;
		EXEC [dbo].[GetValidationnoticePolicySettings]
				@AccountID = @AccountID,
				@Configured = @Configured OUTPUT,
				@PolicySetting = @PolicySetting OUTPUT;


	  IF isnull(@Configured,0) <> 0 
	  BEGIN
			INSERT INTO ValidationNotice(LetterRequestID,
			AccountID,
			ValidationNoticeSentDate,
			ValidationPeriodExpiration,
			LastUpdated,[Status],
			ValidationNoticeType,
			ValidationPeriodCompleted,
			DebtorID)
			VALUES (@LetterRequestID,
			 @AccountId,
			 Cast(@ValidationNoticeSentDate AS date), 
			 CAST (@ValidationPeriodExpiration AS date), 
			 CAST (@LastUpdated as datetime),
			 @Status, 
			 @ValidationNoticeType,
			 @ValidationPeriodCompleted,
			 @DebtorID)
			end	
		
		IF @ValidationNoticeType <> 'Verbally'
		 BEGIN
		 	DECLARE @DebtorName VARCHAR(50);
		 	SELECT @DebtorName = Name FROM Debtors WHERE DebtorID = @DebtorID;
		 	INSERT notes VALUES(@AccountId,
		 	null, 
		 	GETDATE(), 
		 	@CreatedBy, 
		 	'+++++', 
		 	'+++++', 
		 	'Debtor '+@DebtorName+' provided Validation Notice through ' + @ValidationNoticeType,
		 	NULL, 
		 	NULL, 
		 	GETDATE())
		 END
		END
	 END
		IF (@@error = 0)
		begin 				
			COMMIT TRAN
		end
		ELSE
		BEGIN
			ROLLBACK TRAN	
		END
GO
