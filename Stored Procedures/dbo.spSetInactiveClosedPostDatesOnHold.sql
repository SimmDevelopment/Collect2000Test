SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spSetInactiveClosedPostDatesOnHold] 
AS

BEGIN TRY

BEGIN TRANSACTION

	DECLARE @AccountIds TABLE (
		[AccountId] INTEGER NOT NULL,
		[LinkId] INTEGER NULL,
		[PdcId] INTEGER NULL,
		[DccId] INTEGER NULL,
		[PromiseId] INTEGER NULL, 
		[ArrangementId] INTEGER NULL,
		[Amount] MONEY NULL, 
		[Due] DATETIME NULL
	);

	INSERT INTO @AccountIds([AccountId], [LinkId], [PdcId], [DccId], [PromiseId], [ArrangementId], [Amount], [Due])
	SELECT A.AcctId, A.LinkId, A.PdcId, A.DccId, A.PromiseId, A.ArrangementID, A.amount, A.DueDate
			FROM (
			SELECT pdc.number AS AcctId,
				master.link AS LinkId,
				pdc.UID AS PdcId,
				null AS DccId,
				null AS PromiseId, 
				pdc.ArrangementID,
				pdc.Amount,
				pdc.deposit AS DueDate
				FROM dbo.pdc
				INNER JOIN dbo.master ON pdc.number=master.number
				WHERE master.qlevel IN ('998', '999')
				AND pdc.Active = 1
				AND onhold IS NULL
	UNION
			SELECT PdcDetails.AccountID AS AcctId, 
				master.link AS LinkId, 
				PdcDetails.PdcID AS PdcId,
				null AS DccId,
				null AS PromiseId,
				pdc.ArrangementID,
				pdc.Amount,
				pdc.deposit AS DueDate
				FROM dbo.PdcDetails
				INNER JOIN dbo.master ON PdcDetails.AccountID=master.number
				INNER JOIN dbo.pdc on pdc.UID = PdcDetails.PdcID
				WHERE master.qlevel IN ('998', '999')
				AND pdc.Active = 1
				AND pdc.onhold IS NULL
	UNION
			SELECT DebtorCreditCards.Number AS AcctId,
				master.link AS LinkId,
				null AS PdcId,
				DebtorCreditCards.ID AS DccId,
				null AS PromiseId, 
				DebtorCreditCards.ArrangementID,
				DebtorCreditCards.Amount,
				DebtorCreditCards.DepositDate AS DueDate
				FROM dbo.DebtorCreditCards
				INNER JOIN dbo.master ON DebtorCreditCards.number=master.number
				WHERE master.qlevel IN ('998', '999')
				AND DebtorCreditCards.IsActive = 1
				AND DebtorCreditCards.OnHoldDate IS NULL
	UNION
			SELECT DebtorCreditCardDetails.AccountID AS AcctId, 
				master.link AS LinkId,
				null AS PdcId,
				DebtorCreditCardDetails.DebtorCreditCardID AS DccId,
				null AS PromiseId,
				DebtorCreditCards.ArrangementID,
				DebtorCreditCards.Amount,
				DebtorCreditCards.DepositDate AS DueDate
				FROM dbo.DebtorCreditCardDetails
				INNER JOIN dbo.master ON DebtorCreditCardDetails.AccountID=master.number
				INNER JOIN dbo.DebtorCreditCards on DebtorCreditCards.ID = DebtorCreditCardDetails.DebtorCreditCardID
				WHERE master.qlevel IN ('998', '999')
				AND DebtorCreditCards.IsActive = 1
				AND DebtorCreditCards.OnHoldDate IS NULL
	UNION 
			SELECT Promises.AcctID AS AcctId,
				master.link AS LinkId,
				null AS PdcId,
				null AS DccId,
				Promises.ID AS PromiseId,
				Promises.ArrangementID,
				Promises.Amount,
				Promises.DueDate AS DueDate
				FROM dbo.Promises
				INNER JOIN dbo.master ON Promises.AcctID=master.number
				WHERE master.qlevel IN ('998', '999')
				AND Promises.Active = 1
				AND promises.Suspended = 0
	UNION		
			SELECT PromiseDetails.AccountID AS AcctId, 
				master.link AS LinkId,
				null AS PdcId,
				null AS DccId,
				PromiseDetails.PromiseID AS PromiseId,
				Promises.ArrangementID,
				Promises.Amount,
				Promises.DueDate AS DueDate
				FROM dbo.PromiseDetails
				INNER JOIN dbo.master ON PromiseDetails.AccountID=master.number
				INNER JOIN dbo.Promises on Promises.ID = PromiseDetails.PromiseID
				WHERE master.qlevel IN ('998', '999')
				AND Promises.Active = 1
				AND promises.Suspended = 0) A

	INSERT INTO NOTES (number,created,user0,action,result,comment)
	SELECT DISTINCT AccountId,getdate(),'Custodian','+++++','+++++','Post Date for '+
			cast(Amount as varchar(50))+' due on ' +
			cast(Due as varchar(50)) + 
			' deactivated because account was closed.'
	FROM @AccountIds

	UPDATE dbo.Arrangements
		SET ReviewFlag = 'Inactive Account'
		FROM dbo.Arrangements 
		INNER JOIN (SELECT DISTINCT ArrangementId from @AccountIds WHERE ArrangementId IS NOT NULL) A on A.ArrangementId = Arrangements.ID
		WHERE Arrangements.ID IS NOT NULL

	UPDATE dbo.Promises
		SET Suspended = 1
		FROM dbo.promises
		INNER JOIN (SELECT DISTINCT PromiseId from @AccountIds WHERE PromiseId IS NOT NULL) A on A.PromiseId = promises.ID
		WHERE promises.ID IS NOT NULL

	UPDATE dbo.pdc
		SET onhold = CAST({ fn CURDATE() } AS DATETIME)
		FROM dbo.pdc
		INNER JOIN (SELECT DISTINCT PdcId from @AccountIds WHERE PdcId IS NOT NULL) A on A.PdcId = pdc.[UID]
		WHERE pdc.[UID] IS NOT NULL

	UPDATE DebtorCreditCards
		SET OnHoldDate = CAST({ fn CURDATE() } AS DATETIME)
		FROM dbo.DebtorCreditCards
		INNER JOIN (SELECT DISTINCT DccId from @AccountIds WHERE DccId IS NOT NULL) A on A.DccId = DebtorCreditCards.ID
		WHERE DebtorCreditCards.ID IS NOT NULL

COMMIT TRANSACTION

END 

TRY

BEGIN CATCH
    SELECT * FROM [dbo].[fnGetErrorInfo]()
	ROLLBACK TRANSACTION
	RETURN 1
END CATCH

RETURN 0
GO
