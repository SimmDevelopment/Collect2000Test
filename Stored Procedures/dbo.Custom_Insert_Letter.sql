SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE        PROCEDURE [dbo].[Custom_Insert_Letter]
@number as int,
@letterCode as varchar(5)

as

DECLARE @debtorId as int
DECLARE @requestForDate as datetime
DECLARE @userName as varchar(10)
DECLARE @letterRequestId as int

DECLARE @errorMessage as varchar(400)
begin
	SELECT @debtorId = (SELECT debtorid from debtors where number= @number and seq=0)--@number)
	SET @RequestForDate = GETDATE()
	SET @UserName='EXCHANGE'
	--SET @LetterRequestID=3502510
	
	DECLARE @NullDate as datetime
	SET @NullDate = '1/1/1753 12:00:00'
	
	DECLARE @Empty as varchar(1)
	SET @Empty = ''
	
	INSERT INTO LetterRequest
	(
	AccountID,
	CustomerCode,
	LetterID,
	LetterCode,
	DateRequested,
	DueDate,
	AmountDue,
	UserName,
	Suspend,
	SifPmt1,
	SifPmt2,
	SifPmt3,
	SifPmt4,
	SifPmt5,
	SifPmt6,
	CopyCustomer,
	SaveImage,
	ProcessingMethod,
	DateCreated,
	DateUpdated,
	FutureID,
	SubjDebtorID
--	JobName
	)
	SELECT distinct
		@number,
		M.Customer,
		L.LetterID,
		@lettercode,
		@RequestForDate,
		@NullDate,
		0,
		@UserName,
		0,
		@Empty,
		@Empty,
		@Empty,
		@Empty,
		@Empty,
		@Empty,
		CLA.CopyCustomer,
		CLA.SaveImage,
		0,
		GetDate(),
		GetDate(),
		0,
		@DebtorID
--		'Exchange'
	FROM Master M
	JOIN Letter L ON L.Code = @LetterCode
	JOIN CustLtrAllow CLA ON M.customer = CLA.CustCode AND CLA.LtrCode = @lettercode
	WHERE m.number = @number

	--Added by SG 2006/07/03
	--Now add the recipient
	INSERT INTO LetterRequestRecipient
	(
	LetterRequestID,
	AccountID,
	Seq,
	DebtorID,
	DateCreated,
	DateUpdated
	)
	SELECT
	LetterRequestID,
	@number,
	0,
	@DebtorID,
	@RequestForDate,
	@RequestForDate
	FROM LetterRequest WITH(NOLOCK)
	WHERE accountid = @number
	and daterequested = @RequestForDate


--make sure that the letter was inserted otherwise give error feedback
--if( @@ROWCOUNT <= 0 ) BEGIN
--    set @errorMessage = 'Unable to insert letter [' + @letterCode + '] for account [' + cast(@number as varchar) +']';
--	select @errorMessage
 --   RAISERROR(@errorMessage,10,1)  with nowait
--END
end

GO
