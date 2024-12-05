SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[LatitudeLegal_ReverseJudgment] @CourtCaseID INTEGER, @UserID INTEGER, @AccruedInterest MONEY, @IsCorrection BIT
AS
SET NOCOUNT ON;

IF @CourtCaseID IS NULL BEGIN
	RAISERROR('@CourtCaseID cannot be NULL.', 16, 1);
	RETURN 1;
END;

IF NOT EXISTS (SELECT * FROM [dbo].[CourtCases] WHERE [CourtCaseID] = @CourtCaseID) BEGIN
	RAISERROR('@CourtCaseID %d could not be found.', 16, 1, @CourtCaseID);
	RETURN 1;
END;

IF NOT EXISTS (SELECT * FROM [dbo].[CourtCases] WHERE [CourtCaseID] = @CourtCaseID AND [Judgement] = 1) BEGIN
	RAISERROR('@CourtCaseID %d does not contain judgment information.', 16, 1, @CourtCaseID);
	RETURN 1;
END;

DECLARE @UserName VARCHAR(10);

IF @UserID IS NULL OR @UserID = 0
	SET @UserName = 'GLOBAL';
ELSE
	SELECT @UserName = [LoginName]
	FROM [dbo].[Users]
	WHERE [ID] = @UserID
	AND [Active] = 1;

IF @UserName IS NULL BEGIN
	RAISERROR('@UserID %d is invalid.', 16, 1, @UserID);
	RETURN 1;
END;

DECLARE @PayhistoryUID INTEGER;

SELECT @PayhistoryUID = [payhistory].[UID]
FROM [dbo].[CourtCases]
INNER JOIN [dbo].[payhistory]
ON [CourtCases].[JudgementPayhistoryUID] = [payhistory].[UID]
AND [CourtCases].[AccountID] = [payhistory].[number]
WHERE [CourtCases].[CourtCaseID] = @CourtCaseID
AND [payhistory].[batchtype] = 'LJ'
AND [payhistory].[ReverseOfUID] = 0;

IF @PayhistoryUID IS NULL BEGIN
	RAISERROR('@CourtCaseID %d does not contain valid payhistory record for legal judgment awards.', 16, 1, @CourtCaseID);
	RETURN 1;
END;

DECLARE @AccountID INTEGER;
DECLARE @Current0 MONEY;
DECLARE @Current1 MONEY;
DECLARE @Current2 MONEY;
DECLARE @Current3 MONEY;
DECLARE @Current4 MONEY;
DECLARE @Current5 MONEY;
DECLARE @Current6 MONEY;
DECLARE @Current7 MONEY;
DECLARE @Current8 MONEY;
DECLARE @Current9 MONEY;
DECLARE @Current10 MONEY;
DECLARE @Desk VARCHAR(10);

SELECT @AccountID = [master].[number],
	@Current0 = [master].[current0],
	@Current1 = [master].[current1],
	@Current2 = [master].[current2],
	@Current3 = [master].[current3],
	@Current4 = [master].[current4],
	@Current5 = [master].[current5],
	@Current6 = [master].[current6],
	@Current7 = [master].[current7],
	@Current8 = [master].[current8],
	@Current9 = [master].[current9],
	@Current10 = [master].[current10],
	@Desk = [master].[desk]
FROM [dbo].[CourtCases]
INNER JOIN [dbo].[master]
ON [CourtCases].[AccountID] = [master].[number]
WHERE [CourtCases].[CourtCaseID] = @CourtCaseID;

DECLARE @Adjustment1 MONEY;
DECLARE @Adjustment2 MONEY;
DECLARE @Adjustment3 MONEY;
DECLARE @Adjustment4 MONEY;
DECLARE @Adjustment5 MONEY;
DECLARE @Adjustment6 MONEY;
DECLARE @Adjustment7 MONEY;
DECLARE @Adjustment8 MONEY;
DECLARE @Adjustment9 MONEY;
DECLARE @Adjustment10 MONEY;

SELECT @Adjustment1 = -[paid1],
	@Adjustment2 = -[paid2],
	@Adjustment3 = -[paid3],
	@Adjustment4 = -[paid4],
	@Adjustment5 = -[paid5],
	@Adjustment6 = -[paid6],
	@Adjustment7 = -[paid7],
	@Adjustment8 = -[paid8],
	@Adjustment9 = -[paid9],
	@Adjustment10 = -[paid10]
FROM [dbo].[payhistory]
WHERE [UID] = @PayhistoryUID;

DECLARE @PreviousInterestRate MONEY;
DECLARE @PreviousInterestDate DATETIME;
DECLARE @PreviousInterestAmount MONEY;

SELECT @PreviousInterestRate = [JudgementPreviousInterestRate],
	@PreviousInterestDate = [JudgementPreviousInterestDate],
	@PreviousInterestAmount = [JudgementPreviousInterestAmt]
FROM [dbo].[CourtCases]
WHERE [CourtCaseID] = @CourtCaseID;

DECLARE @Balance0 MONEY;
DECLARE @Balance1 MONEY;
DECLARE @Balance2 MONEY;
DECLARE @Balance3 MONEY;
DECLARE @Balance4 MONEY;
DECLARE @Balance5 MONEY;
DECLARE @Balance6 MONEY;
DECLARE @Balance7 MONEY;
DECLARE @Balance8 MONEY;
DECLARE @Balance9 MONEY;
DECLARE @Balance10 MONEY;

SET @Balance1 = @Current1 + @Adjustment1;
SET @Balance2 = COALESCE(@AccruedInterest, @Current2 + @Adjustment2);
SET @Balance3 = @Current3 + @Adjustment3;
SET @Balance4 = @Current4 + @Adjustment4;
SET @Balance5 = @Current5 + @Adjustment5;
SET @Balance6 = @Current6 + @Adjustment6;
SET @Balance7 = @Current7 + @Adjustment7;
SET @Balance8 = @Current8 + @Adjustment8;
SET @Balance9 = @Current9 + @Adjustment9;
SET @Balance10 = @Current10 + @Adjustment10;
SET @Balance0 = @Balance1 + @Balance2 + @Balance3 + @Balance4 + @Balance5 + @Balance6 + @Balance7 + @Balance8 + @Balance9 + @Balance10;

DECLARE @SystemYear SMALLINT;
DECLARE @SystemMonth TINYINT;

SELECT TOP 1 @SystemYear = [controlFile].[CurrentYear],
	@SystemMonth = [controlFile].[CurrentMonth]
FROM [dbo].[controlFile];

IF @SystemYear IS NULL OR @SystemMonth IS NULL BEGIN
	RAISERROR('Latitude system is not configured correctly.', 16, 1);
	RETURN 1;
END;

DECLARE @Comment VARCHAR(30);

IF @IsCorrection = 1
	SET @Comment = 'Judgment Correction';
ELSE
	SET @Comment = 'Judgment Reversal';

BEGIN TRANSACTION;

UPDATE [dbo].[master]
SET [current0] = @Balance0,
	[current1] = @Balance1,
	[current2] = @Balance2,
	[current3] = @Balance3,
	[current4] = @Balance4,
	[current5] = @Balance5,
	[current6] = @Balance6,
	[current7] = @Balance7,
	[current8] = @Balance8,
	[current9] = @Balance9,
	[current10] = @Balance10,
	[InterestRate] = @PreviousInterestRate,
	[LastInterest] = { fn CURDATE() }
WHERE [master].[number] = @AccountID;

IF @@ERROR <> 0 GOTO ErrorHandler;

INSERT INTO [dbo].[payhistory] ([number], [Seq], [batchtype], [matched], [customer],
	[paymethod], [paytype], [systemmonth], [systemyear], [entered], [desk],
	[checknbr], [InvoicePayType], [InvoiceType], [InvoiceSort], [comment],
	[datepaid], [totalpaid], [paid1], [paid2], [paid3], [paid4], [paid5], [paid6],
	[paid7], [paid8], [paid9], [paid10], [balance], [balance1], [balance2],
	[balance3], [balance4], [balance5], [balance6], [balance7], [balance8],
	[balance9], [balance10], [BatchNumber], [InvoiceFlags], [OverPaidAmt],
	[ForwardeeFee], [ReverseOfUID], [AccruedSurcharge], [CollectorFee],
	[AttorneyID], [FeeSched], [CollectorFeeSched], [PaidToDate], [CreatedBy],
	[Created], [BatchPmtCreatedBy], [BatchPmtCreated], [IsCorrection])
SELECT [number], [Seq], 'LJR', [matched], [customer],
	@Comment, @Comment, @SystemMonth, @SystemYear, { fn CURDATE() }, @Desk,
	[checknbr], [InvoicePayType], [InvoiceType], [InvoiceSort], @Comment,
	[datepaid], [totalpaid], [paid1], [paid2], [paid3], [paid4], [paid5], [paid6],
	[paid7], [paid8], [paid9], [paid10], [balance], [balance1], [balance2],
	[balance3], [balance4], [balance5], [balance6], [balance7], [balance8],
	[balance9], [balance10], [BatchNumber], [InvoiceFlags], [OverPaidAmt],
	[ForwardeeFee], @PayhistoryUID, [AccruedSurcharge], [CollectorFee],
	[AttorneyID], [FeeSched], [CollectorFeeSched], [PaidToDate], @UserName,
	GETDATE(), @UserName, GETDATE(), @IsCorrection
FROM [dbo].[payhistory]
WHERE [payhistory].[UID] = @PayhistoryUID;

IF @@ERROR <> 0 GOTO ErrorHandler;

UPDATE [dbo].[CourtCases]
SET [Status] = 
	CASE @IsCorrection 
		WHEN 1 THEN 'FILED' 
		ELSE 'DSWOP' 	
	END,
	[Judgement] = 0,
	[AccruedInt] = @Current2,
	[UpdatedBy] = ISNULL(@UserID, 0),
	[DateUpdated] = GETDATE(),
	[UpdateChecksum] = CAST(CHECKSUM(GETDATE()) AS VARCHAR(50))
WHERE [CourtCases].[CourtCaseID] = @CourtCaseID;

IF @@ERROR <> 0 GOTO ErrorHandler;

IF @IsCorrection = 1
	INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment])
	VALUES (@AccountID, 'LGL', GETDATE(), @UserName, 'LEGAL', 'REVRS', 'Legal judgment corrected');
ELSE
	INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment])
	VALUES (@AccountID, 'LGL', GETDATE(), @UserName, 'LEGAL', 'REVRS', 'Legal judgment reversed');

IF @@ERROR <> 0 GOTO ErrorHandler;

COMMIT TRANSACTION;
RETURN 0;

ErrorHandler:
ROLLBACK TRANSACTION;
RETURN 1;

GO
