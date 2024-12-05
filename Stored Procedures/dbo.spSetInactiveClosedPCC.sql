SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spSetInactiveClosedPCC] 
AS

BEGIN TRY

	BEGIN TRANSACTION

	INSERT INTO NOTES (number,created,user0,action,result,comment)
		SELECT master.number,getdate(),'Custodian','+++++','+++++',
		'Credit card for '+cast(dcc.Amount as varchar(50))+
		' with a deposit date of ' + 
		cast(dcc.DepositDate as varchar(50)) + 
		' deactivated because account was closed.'
		FROM DebtorCreditCards dcc
		INNER JOIN dbo.master ON dcc.number=master.number
		WHERE master.qlevel IN ('998', '999') 
		AND dcc.IsActive = 1
		AND dcc.OnHoldDate IS NULL
		AND NOT EXISTS (Select DebtorCreditCardDetails.AccountID FROM dbo.DebtorCreditCardDetails
						Where DebtorCreditCardDetails.DebtorCreditCardID = dcc.ID
						AND DebtorCreditCardDetails.AccountID <> master.number)

	--Update Arrangement with Review Flag
	UPDATE Arrangements
		SET ReviewFlag = 'Inactive Payments'
			FROM (SELECT DISTINCT A.id from dbo.Arrangements A
			INNER JOIN DebtorCreditCards dcc ON dcc.ArrangementID = A.ID
			INNER JOIN dbo.master ON dcc.number=master.number
			WHERE master.qlevel IN ('998', '999') 
			AND dcc.IsActive = 1
			AND ISNULL(A.ReviewFlag,'') <> 'Inactive Payments'
			AND NOT EXISTS (Select DebtorCreditCardDetails.AccountID FROM dbo.DebtorCreditCardDetails
						Where DebtorCreditCardDetails.DebtorCreditCardID = dcc.ID
						AND DebtorCreditCardDetails.AccountID <> master.number) 
			group by A.ID) Grouped where Arrangements.Id = Grouped.Id
			
	UPDATE DebtorCreditCards
		SET OnHoldDate = CAST({ fn CURDATE() } AS DATETIME),IsActive=0
		FROM DebtorCreditCards dcc
		INNER JOIN dbo.master ON dcc.number=master.number
		WHERE master.qlevel IN ('998', '999') 
		AND dcc.IsActive = 1
		AND dcc.OnHoldDate IS NULL
		AND NOT EXISTS (Select DebtorCreditCardDetails.AccountID FROM dbo.DebtorCreditCardDetails
						Where DebtorCreditCardDetails.DebtorCreditCardID = dcc.ID
						AND DebtorCreditCardDetails.AccountID <> master.number)

     
	COMMIT TRANSACTION

END TRY

BEGIN CATCH
    SELECT * FROM [dbo].[fnGetErrorInfo]()
	ROLLBACK TRANSACTION
	RETURN 1
END CATCH

RETURN 0
GO
