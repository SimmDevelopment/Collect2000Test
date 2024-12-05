SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Aim_Demographic_UpdateValidationNotice]
	@file_number int,
	@debtor_number int,
	@SentDate datetime,
	@PeriodEndDate datetime,
	@Method varchar(10),
	@Status varchar(10),
	@agencyid int
AS
BEGIN

	declare @seq int, @masterNumber int,@currentAgencyId int;
	select 	@seq = dv.seq
		,@masterNumber = dv.number 
		,@currentagencyid = currentlyplacedagencyid
	from 	debtors dv with (nolock)
		left outer join aim_accountreference r on dv.number = r.referencenumber
	where 	dv.debtorid = @debtor_number
	declare @agencyname varchar(100);
	select @agencyname = name from aim_agency where agencyid = @agencyid
	if(@masterNumber is null)
	begin
		RAISERROR ('15001', 16, 1)
		return
	end
	if(@masterNumber <> @file_number)
	begin
		RAISERROR ('15008',16,1)
		return
	end
	if(@currentAgencyId is null or (@currentAgencyId <> @agencyId))
	begin
		RAISERROR ('15004', 16, 1)
		return
	end

	DECLARE @Qlevel varchar(5)

	SELECT @QLevel = [QLevel] FROM [dbo].[Master] WITH (NOLOCK)
	WHERE [number] = @file_number

	IF(@QLevel = '999') 
	BEGIN
		RAISERROR('Account has been returned, QLevel 999.',16,1)
		RETURN
	END
 
	 SELECT @Method = CASE 
	 WHEN @Method='1' THEN 'Letter'
	 WHEN @Method='2' THEN 'Digital'
	 ELSE 'Verbally'
	 END 

	 
	 SELECT @Status = CASE 
	 WHEN @Status='1' THEN 'Sent'
	 WHEN @Status='2' THEN 'Returned'
	 WHEN @Status='3' THEN 'Completed'
	 ELSE 'Unknown'
	 END 

	 DECLARE @ValidationPeriodCompleted bit
	 SELECT @ValidationPeriodCompleted = CASE 
	 WHEN @PeriodEndDate >= GETDATE() AND @Status='Completed' THEN 1
	 ELSE 0
	 END 

    IF EXISTS (SELECT 1 FROM ValidationNotice WHERE AccountID = @file_number AND DebtorID = @debtor_number)
	BEGIN
		UPDATE ValidationNotice
			SET ValidationNoticeSentDate = @SentDate,
				ValidationPeriodExpiration = @PeriodEndDate,
				ValidationPeriodCompleted = @ValidationPeriodCompleted,
				LastUpdated = NULL,
				Status = @Status,
				ValidationNoticeType = @Method
		WHERE AccountID = @file_number AND DebtorID = @debtor_number
	END
	ELSE
	BEGIN

	DECLARE @PolicySetting nvarchar(max);

	DECLARE @Configured BIT ;
	EXEC [dbo].[GetValidationnoticePolicySettings]
			@AccountID = @file_number,
			@Configured = @Configured OUTPUT,
			@PolicySetting = @PolicySetting OUTPUT;


	IF isnull(@Configured,0) <> 0 
	BEGIN
		INSERT INTO ValidationNotice	(
		[AccountID],
		[LetterRequestID],
		[ValidationNoticeSentDate],
		[ValidationPeriodExpiration],
		[ValidationPeriodCompleted],
		[LastUpdated],
		[Status],
		[ValidationNoticeType],
		[DebtorID]) values (@file_number,NULL,@SentDate,@PeriodEndDate,@ValidationPeriodCompleted,NULL,@Status,@Method,@debtor_number)
	  END
	END
	INSERT INTO Notes (number,created,user0,action,result,comment,isprivate, UtcCreated)
	VALUES (@file_number,GETDATE(),'AIM','+++++','+++++','Validation Notice information has been updated from client',0, GETUTCDATE())
		

END

GO
