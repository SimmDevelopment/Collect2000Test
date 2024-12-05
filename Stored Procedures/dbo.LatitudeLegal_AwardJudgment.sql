SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[LatitudeLegal_AwardJudgment] @CourtCaseID INTEGER, @UserID INTEGER, @JudgmentDate DATETIME, @JudgmentCourtID INTEGER, @RecordedDate DATETIME, @JudgmentBook VARCHAR(20), @JudgmentPage VARCHAR(20), @PrincipalAward MONEY, @InterestAward MONEY, @CourtCostAward MONEY, @AttorneyCostAward MONEY, @OtherCostAward MONEY, @InterestRate REAL, @InterestDate DATETIME, @AccruedInterest MONEY, @PaidToInterest MONEY, @Balance1 MONEY, @Balance2 MONEY, @Balance3 MONEY, @Balance4 MONEY, @Balance5 MONEY, @Balance6 MONEY, @Balance7 MONEY, @Balance8 MONEY, @Balance9 MONEY, @Balance10 MONEY
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

IF EXISTS (SELECT * FROM [dbo].[CourtCases] WHERE [CourtCaseID] = @CourtCaseID AND [Judgement] = 1) BEGIN
	RAISERROR('@CourtCaseID %d already contains judgment information.', 16, 1, @CourtCaseID);
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

DECLARE @Today DATETIME;
SET @Today = { fn CURDATE() };

SET @JudgmentDate = ISNULL(@JudgmentDate, @Today);

SET @PrincipalAward = ISNULL(@PrincipalAward, 0);
SET @InterestAward = ISNULL(@InterestAward, 0);
SET @CourtCostAward = ISNULL(@CourtCostAward, 0);
SET @AttorneyCostAward = ISNULL(@AttorneyCostAward, 0);
SET @OtherCostAward = ISNULL(@OtherCostAward, 0);
SET @Balance1 = ISNULL(@Balance1, 0);
SET @Balance2 = ISNULL(@Balance2, 0);
SET @Balance3 = ISNULL(@Balance3, 0);
SET @Balance4 = ISNULL(@Balance4, 0);
SET @Balance5 = ISNULL(@Balance5, 0);
SET @Balance6 = ISNULL(@Balance6, 0);
SET @Balance7 = ISNULL(@Balance7, 0);
SET @Balance8 = ISNULL(@Balance8, 0);
SET @Balance9 = ISNULL(@Balance9, 0);
SET @Balance10 = ISNULL(@Balance10, 0);

DECLARE @TotalAward MONEY;
DECLARE @TotalBalance MONEY;
DECLARE @TotalAwardString VARCHAR(20);

SET @TotalAward = @PrincipalAward + @InterestAward + @CourtCostAward + @AttorneyCostAward + @OtherCostAward;
SET @TotalBalance = @Balance1 + @Balance2 + @Balance3 + @Balance4 + @Balance5 + @Balance6 + @Balance7 + @Balance8 + @Balance9 + @Balance10;
SET @TotalAwardString = CONVERT(VARCHAR(20), @TotalAward, 1);

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
DECLARE @CurrentInterestRate REAL;
DECLARE @CurrentInterestDate DATETIME;
DECLARE @Customer VARCHAR(7);
DECLARE @QueueLevel VARCHAR(3);
DECLARE @Desk VARCHAR(10);
DECLARE @AttorneyID INTEGER;
DECLARE @CollectorFeeSchedule VARCHAR(5);
DECLARE @FeeSchedule VARCHAR(5);
DECLARE @TotalPaid MONEY;

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
	@CurrentInterestRate = [master].[InterestRate],
	@CurrentInterestDate = [master].[LastInterest],
	@Customer = [master].[customer],
	@QueueLevel = [master].[qlevel],
	@Desk = [master].[desk],
	@AttorneyID = [master].[AttorneyID],
	@CollectorFeeSchedule = ISNULL([customer].[CollectorFeeSchedule], ''),
	@FeeSchedule = COALESCE([master].[FeeSchedule], [customer].[LegalFeeSchedule], [customer].[FeeSchedule], ''),
	@TotalPaid = ABS([master].[paid])
FROM [dbo].[CourtCases]
INNER JOIN [dbo].[master]
ON [CourtCases].[AccountID] = [master].[number]
INNER JOIN [dbo].[customer]
ON [master].[customer] = [customer].[customer]
WHERE [CourtCases].[CourtCaseID] = @CourtCaseID;

IF @AccountID IS NULL BEGIN
	RAISERROR('Account for @CourtCase %d cannot be found.', 16, 1, @CourtCaseID);
	RETURN 1;
END;

IF @QueueLevel IN ('998', '999') BEGIN
	RAISERROR('You may not apply judgment to a closed account.', 16, 1);
	RETURN 1;
END;

DECLARE @TotalAdjustment MONEY;
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

SET @Adjustment1 = @Balance1 - @Current1;
SET @Adjustment2 = @Balance2 - @Current2;
IF @AccruedInterest > 0 SET @Adjustment2 = @Adjustment2 - (@AccruedInterest - @PaidToInterest);
SET @Adjustment3 = @Balance3 - @Current3;
SET @Adjustment4 = @Balance4 - @Current4;
SET @Adjustment5 = @Balance5 - @Current5;
SET @Adjustment6 = @Balance6 - @Current6;
SET @Adjustment7 = @Balance7 - @Current7;
SET @Adjustment8 = @Balance8 - @Current8;
SET @Adjustment9 = @Balance9 - @Current9;
SET @Adjustment10 = @Balance10 - @Current10;
SET @TotalAdjustment = @Adjustment1 + @Adjustment2 + @Adjustment3 + @Adjustment4 + @Adjustment5 + @Adjustment6 + @Adjustment7 + @Adjustment8 + @Adjustment9 + @Adjustment10;

DECLARE @SystemYear SMALLINT;
DECLARE @SystemMonth TINYINT;

SELECT TOP 1 @SystemYear = [controlFile].[CurrentYear],
	@SystemMonth = [controlFile].[CurrentMonth]
FROM [dbo].[controlFile];

IF @SystemYear IS NULL OR @SystemMonth IS NULL BEGIN
	RAISERROR('Latitude system is not configured correctly.', 16, 1);
	RETURN 1;
END;

BEGIN TRANSACTION;

DECLARE @PayhistoryUID INTEGER;

UPDATE [dbo].[master]
SET [current0] = @TotalBalance,
	[current1] = @Balance1,
	[current2] = @Balance2,
	[accrued2] = @AccruedInterest,
	[current3] = @Balance3,
	[current4] = @Balance4,
	[current5] = @Balance5,
	[current6] = @Balance6,
	[current7] = @Balance7,
	[current8] = @Balance8,
	[current9] = @Balance9,
	[current10] = @Balance10,
	[InterestRate] = @InterestRate,
	[LastInterest] = @Today
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
	[Created], [BatchPmtCreatedBy], [BatchPmtCreated])
VALUES (@AccountID, 0, 'LJ', 'N', @Customer, 'Legal Judgment', 'Legal Judgment',
	@SystemMonth, @SystemYear, { fn CURDATE() }, @Desk, '', 15.0, '', '',
	'Legal Judgment Awarded', @JudgmentDate, @TotalAdjustment, @Adjustment1,
	@Adjustment2, @Adjustment3, @Adjustment4, @Adjustment5, @Adjustment6,
	@Adjustment7, @Adjustment8, @Adjustment9, @Adjustment10, @Current0, @Current1,
	@Current2, @Current3, @Current4, @Current5, @Current6, @Current7, @Current8,
	@Current9, @Current10, 0.0, '0000000000', 0, 0, 0, 0, 0, @AttorneyID,
	@FeeSchedule, @CollectorFeeSchedule, @TotalPaid, @UserName, GETDATE(),
	@UserName, GETDATE());

IF @@ERROR <> 0 GOTO ErrorHandler;

SET @PayhistoryUID = SCOPE_IDENTITY();

IF @@ERROR <> 0 GOTO ErrorHandler;

UPDATE [dbo].[payhistory]
SET [PAIdentifier] = @PayhistoryUID
WHERE [UID] = @PayhistoryUID;

IF @@ERROR <> 0 GOTO ErrorHandler;

UPDATE [dbo].[CourtCases]
	SET [Status] = 'JDGMT', 
	[Judgement] = 1,
	[JudgementAmt] = @PrincipalAward,
	[JudgementIntRate] = @InterestRate,
	[JudgementDate] = @JudgmentDate,
	[JudgementIntAward] = @InterestAward,
	[JudgementCostAward] = @CourtCostAward,
	[JudgementOtherAward] = @OtherCostAward,
	[IntFromDate] = @InterestDate,
	[AccruedInt] = @AccruedInterest,
	[UpdatedBy] = ISNULL(@UserID, 0),
	[DateUpdated] = GETDATE(),
	[UpdateChecksum] = CAST(CHECKSUM(GETDATE()) AS VARCHAR(50)),
	[JudgementAttorneyCostAward] = @AttorneyCostAward,
	[JudgementCourtID] = ISNULL(@JudgmentCourtID, [CourtCases].[CourtID]),
	[JudgementRecordedDate] = @RecordedDate,
	[JudgementBook] = @JudgmentBook,
	[JudgementPage] = @JudgmentPage,
	[JudgementPreviousInterestRate] = @CurrentInterestRate,
	[JudgementPreviousInterestDate] = @CurrentInterestDate,
	[JudgementPayhistoryUID] = @PayhistoryUID,
	[JudgementPreviousInterestAmt] = @Current2
WHERE [CourtCases].[CourtCaseID] = @CourtCaseID;

IF @@ERROR <> 0 GOTO ErrorHandler;

INSERT INTO [dbo].[notes] ([number], [ctl], [created], [UtcCreated], [user0], [action], [result], [comment])
VALUES (@AccountID, 'LGL', GETDATE(), GETUTCDATE(), @UserName, 'LEGAL', 'JDGMT', 'Legal judgment awarded for ' + @TotalAwardString);

IF @@ERROR <> 0 GOTO ErrorHandler;	

COMMIT TRANSACTION;
RETURN 0;

ErrorHandler:
ROLLBACK TRANSACTION;
RETURN 1;

GO
