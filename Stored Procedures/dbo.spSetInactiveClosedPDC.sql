SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spSetInactiveClosedPDC] 
AS

BEGIN TRY

	BEGIN TRANSACTION
	INSERT INTO NOTES (number,created,user0,action,result,comment)
	 	SELECT master.number,getdate(),'Custodian','+++++','+++++','PDC for '+cast(pdc.Amount as varchar(50))+' with a deposit date of ' + cast(pdc.Deposit as varchar(50)) + ' deactivated because account was closed.'
		FROM pdc
		INNER JOIN dbo.master ON pdc.number=master.number
		WHERE master.qlevel IN ('998', '999') 
		AND pdc.Active = 1
		AND onhold IS NULL
		AND NOT EXISTS (Select PdcDetails.AccountID FROM dbo.PdcDetails
						Where PdcDetails.PdcID = Pdc.UID
						AND PdcDetails.AccountID <> master.number)
		
	--Update Arrangement with Review Flag
	UPDATE Arrangements
		SET ReviewFlag = 'Inactive Payments'
			FROM (SELECT DISTINCT A.id from dbo.Arrangements A
			INNER JOIN dbo.pdc ON pdc.ArrangementID = A.ID
			INNER JOIN dbo.master ON pdc.number=master.number
			WHERE master.qlevel IN ('998', '999') 
			AND pdc.Active = 1
			AND ISNULL(A.ReviewFlag,'') <> 'Inactive Payments'
			AND NOT EXISTS (Select PdcDetails.AccountID FROM dbo.PdcDetails
					Where PdcDetails.PdcID = Pdc.UID
					AND PdcDetails.AccountID <> master.number)
			group by A.ID) Grouped where Arrangements.Id = Grouped.Id

	UPDATE pdc
		SET onhold = CAST({ fn CURDATE() } AS DATETIME),Active=0
		FROM pdc
		INNER JOIN dbo.master ON pdc.number=master.number
		WHERE master.qlevel IN ('998', '999') 
		AND pdc.Active = 1
		AND onhold IS NULL
		AND NOT EXISTS (Select PdcDetails.AccountID FROM dbo.PdcDetails
						Where PdcDetails.PdcID = Pdc.UID
						AND PdcDetails.AccountID <> master.number)

	COMMIT TRANSACTION

END TRY

BEGIN CATCH
    SELECT * FROM [dbo].[fnGetErrorInfo]()
	ROLLBACK TRANSACTION
	RETURN 1
END CATCH

RETURN 0
GO
