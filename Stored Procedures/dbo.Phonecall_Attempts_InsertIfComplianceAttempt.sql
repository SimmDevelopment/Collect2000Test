SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[Phonecall_Attempts_InsertIfComplianceAttempt]
			@AccountID int Output,
			@DebtorID int Output,
			@ActionCode varchar(10),
			@ResultCode varchar(10),
			@MasterPhoneId int,
			@AttemptDate date,
			@loginName varchar(10),
			@ReturnID int Output
		AS 
BEGIN
SET NOCOUNT ON;
		-- we must consider if we don't have a debtor id, then we need to use the primary debtor for account.
		--		This situation occurs regularly with DialerUpdateSvc which doesn't often know the debtorid.
		-- we must consider if we have a debtor id, then should we trust the given accountid OR query debtors
		--		for the accountid (HINT: use debtorid to query for accountid).
		-- if neither accountid nor debtorid is valid, then who cares what this inserts or doesn't insert. Its an 
		--		unlikely condition, and does no harm other than possibly wasted space if it actually inserts something.
		--		This situation should never occur, anywhere.
		-- Whichever debtorID we use, we need to send it back to whomever called this method.

		IF ISNULL(@DebtorID, 0) <= 0 
		BEGIN
			-- we need to get the primary debtorid for accountid
			SELECT TOP 1 @DebtorID = d.DebtorID
			FROM master m INNER JOIN debtors d
				ON m.number = d.Number AND d.Seq = 0
			WHERE m.number = @AccountID
		END
		ELSE
		BEGIN
			-- we should get the filenumber from the debtor record.
			SELECT TOP 1 @AccountId = d.Number
			FROM debtors d
			WHERE d.DebtorID = @DebtorId
		END
DECLARE @Status bit;
EXEC GetComplianceCallAttemptandConversation @AccountID=@AccountID,@DebtorID=@DebtorID,@Status=@Status OUTPUT

IF(@Status=1)
BEGIN
		INSERT INTO Phonecall_Attempts(number, DebtorID, AttemptDate, MasterPhoneId, loginName)
		SELECT @AccountID, @DebtorID, @AttemptDate, @MasterPhoneId, @loginName
		FROM [result] r inner join [action] a 
				ON a.code = @ActionCode
					AND r.code = @ResultCode
					AND a.WasAttempt = 1
					AND r.ComplianceAttempt != 0
END
		IF @@Error = 0 AND @@ROWCOUNT = 1
			SET @ReturnID = SCOPE_IDENTITY();
		ELSE
			SET @ReturnID = 0;

		Return @@Error
END
GO
