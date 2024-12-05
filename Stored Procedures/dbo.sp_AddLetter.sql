SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/****** ALTER  PROCEDURE sp_AddLetter    Script Date: 10/13/2002 8:30:34 PM ******/
CREATE PROCEDURE [dbo].[sp_AddLetter]
	@AcctID int,
	@Seq tinyint,
	@lettercode varchar(5),
	@requested datetime,
	@Amount money,
	@DueDate datetime,
	@SifPmt1 varchar (30),
	@SifPmt2 varchar (30),
	@SifPmt3 varchar (30),
	@SifPmt4 varchar (30),
	@SifPmt5 varchar (30),
	@SifPmt6 varchar (30),
	@SifPmt7 varchar (30),
	@SifPmt8 varchar (30),
	@SifPmt9 varchar (30),
	@SifPmt10 varchar (30),
	@SifPmt11 varchar (30),
	@SifPmt12 varchar (30),
	@SifPmt13 varchar (30),
	@SifPmt14 varchar (30),
	@SifPmt15 varchar (30),
	@SifPmt16 varchar (30),
	@SifPmt17 varchar (30),
	@SifPmt18 varchar (30),
	@SifPmt19 varchar (30),
	@SifPmt20 varchar (30),
	@SifPmt21 varchar (30),
	@SifPmt22 varchar (30),
	@SifPmt23 varchar (30),
	@SifPmt24 varchar (30),
	@ReturnString varchar(25) output,
	@ReturnID int output

AS

DECLARE @DebtorID INTEGER;
DECLARE @Customer VARCHAR(7);
DECLARE @LetterID INTEGER;
DECLARE @LoginName VARCHAR(10);
DECLARE @UserID INTEGER;
DECLARE @SaveImage BIT;
DECLARE @CopyCustomer BIT;
DECLARE @LetterRequestID INTEGER;
DECLARE @Rows INTEGER;

IF NOT EXISTS (SELECT * FROM [dbo].[master] WHERE [master].[number] = @AcctID) BEGIN
	SET @ReturnString = 'Invalid Account';
	RETURN -1;
END;
IF NOT EXISTS (SELECT * FROM [dbo].[Debtors] WHERE [Debtors].[number] = @AcctID AND [Debtors].[Seq] = @Seq) BEGIN
	SET @ReturnString = 'Invalid Codebtor';
	RETURN -1;
END;
IF NOT EXISTS (SELECT * FROM [dbo].[letter] WHERE [letter].[code] = @LetterCode) BEGIN
	SET @ReturnString = 'Invalid Letter';
	RETURN -1;
END;

SELECT @Customer = [master].[customer]
FROM [dbo].[master]
WHERE [master].[number] = @AcctID;

SELECT TOP 1
	@DebtorID = [Debtors].[DebtorID]
FROM [dbo].[Debtors]
WHERE [Debtors].[number] = @AcctID
AND [Debtors].[Seq] = @Seq;

SELECT @LetterID = [LetterID], @CopyCustomer = [CopyCustomer], @SaveImage = [SaveImage]
FROM [dbo].[letter]
WHERE [letter].[code] = @LetterCode;

IF @SaveImage = 0 BEGIN
	SELECT @SaveImage = [CustLtrAllow].[SaveImage]
	FROM [CustLtrAllow]
	WHERE [CustLtrAllow].[CustCode] = @Customer
	AND [CustLtrAllow].[LtrCode] = @lettercode;
END;

SELECT @UserID = [UserID],
	@LoginName = [LoginName]
FROM [dbo].[GetCurrentLatitudeUser]();

INSERT INTO [dbo].[LetterRequest] ([AccountID], [CustomerCode], [LetterID], [LetterCode], [DateRequested], [DateProcessed], [DueDate], [AmountDue], [UserName], [SifPmt1], [SifPmt2], [SifPmt3], [SifPmt4], [SifPmt5], [SifPmt6], [SifPmt7], [SifPmt8], [SifPmt9], [SifPmt10], [SifPmt11], [SifPmt12], [SifPmt13], [SifPmt14], [SifPmt15], [SifPmt16], [SifPmt17], [SifPmt18], [SifPmt19], [SifPmt20], [SifPmt21], [SifPmt22], [SifPmt23], [SifPmt24], [SubjDebtorID], [SenderID], [RequesterID], [RecipientDebtorID], [RecipientDebtorSeq], [CopyCustomer], [SaveImage])
VALUES (@AcctID, @Customer, @LetterID, @LetterCode, @requested, '1753-01-01 12:00 PM', @DueDate, @Amount, @LoginName, @SifPmt1, @SifPmt2, @SifPmt3, @SifPmt4, @SifPmt5, @SifPmt6, @SifPmt7, @SifPmt8, @SifPmt9, @SifPmt10, @SifPmt11, @SifPmt12, @SifPmt13, @SifPmt14, @SifPmt15, @SifPmt16, @SifPmt17, @SifPmt18, @SifPmt19, @SifPmt20, @SifPmt21, @SifPmt22, @SifPmt23, @SifPmt24, @DebtorID, @UserID, @UserID, @DebtorID, @Seq, @CopyCustomer, @SaveImage);

IF @@ROWCOUNT = 0 BEGIN
	SET @ReturnString = 'Insert Failed';
	RETURN -1;
END;

SET @LetterRequestID = SCOPE_IDENTITY();

INSERT INTO [dbo].[LetterRequestRecipient] ([LetterRequestID], [AccountID], [Seq], [DebtorID])
VALUES (@LetterRequestID, @AcctID, @Seq, @DebtorID);

SET @ReturnID = @LetterRequestID;

RETURN 0;

GO
