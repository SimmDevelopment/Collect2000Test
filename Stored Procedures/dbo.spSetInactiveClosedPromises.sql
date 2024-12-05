SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spSetInactiveClosedPromises] 
AS

BEGIN TRY

	BEGIN TRANSACTION

	INSERT INTO NOTES (number,created,user0,action,result,comment)
 		SELECT number,getdate(),'Custodian','+++++','+++++','Promise for '+
			cast(Promises.Amount as varchar(50))+' due on ' +
			cast(Promises.DueDate as varchar(50)) + 
			' deactivated because account was closed.'
		FROM dbo.promises
		INNER JOIN dbo.master ON promises.AcctID=master.number
		WHERE master.qlevel IN ('998', '999') 
		AND promises.Active = 1
		AND promises.Suspended = 0
		AND NOT EXISTS (Select PromiseDetails.AccountID FROM dbo.PromiseDetails
						Where PromiseDetails.PromiseID = Promises.ID
						AND PromiseDetails.AccountID <> master.number)

			--Update Arrangement with Review Flag	
	UPDATE Arrangements
		SET ReviewFlag = 'Inactive Payments'
			FROM (SELECT DISTINCT A.id from dbo.Arrangements A
			INNER JOIN dbo.promises ON promises.ArrangementID = A.ID
			INNER JOIN dbo.master ON promises.AcctID=master.number
			WHERE master.qlevel IN ('998', '999') 
			AND promises.Active = 1
			AND ISNULL(A.ReviewFlag,'') <> 'Inactive Payments'
			AND NOT EXISTS (Select PromiseDetails.AccountID FROM dbo.PromiseDetails
							Where PromiseDetails.PromiseID = Promises.ID
							AND PromiseDetails.AccountID <> master.number)
			group by A.ID) Grouped where Arrangements.Id = Grouped.Id

	UPDATE promises
		SET Suspended = 1,Active=0
		FROM dbo.promises
		INNER JOIN dbo.master ON promises.AcctID=master.number
		WHERE master.qlevel IN ('998', '999') 
		AND promises.Active = 1
		AND (promises.Suspended = 0 or promises.Suspended is null)
		AND NOT EXISTS (Select PromiseDetails.AccountID FROM dbo.PromiseDetails
						Where PromiseDetails.PromiseID = Promises.ID
						AND PromiseDetails.AccountID <> master.number)              

	COMMIT TRANSACTION

END TRY

BEGIN CATCH
    SELECT * FROM [dbo].[fnGetErrorInfo]()
	ROLLBACK TRANSACTION
	RETURN 1
END CATCH

RETURN 0
GO
