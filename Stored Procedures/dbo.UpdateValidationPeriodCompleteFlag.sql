SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Rupali Patil
-- Create date: 27-09-2021
-- Description:	This SP is Attached To A Custodian Task -  to set Validation Period Completed Flag based upon Validation Period Expiration Date
-- =============================================
CREATE PROCEDURE [dbo].[UpdateValidationPeriodCompleteFlag] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--- This need to be added in events
	--INSERT INTO NOTES (number,created,user0,action,result,comment)
	--		SELECT master.number,GETUTCDATE(),'Custodian','+++++','+++++','Validation period expired for'+ vn.ValidationNoticeType +' - '+'Notice Sent Date: ' + CONVERT(VARCHAR(MAX),vn.ValidationNoticeSentDate) +', Status: '+ vn.status+', Letter Request ID: '+ CONVERT(VARCHAR(MAX),vn.LetterRequestID)
	--	FROM dbo.ValidationNotice vn
	--	INNER JOIN dbo.[Master] ON vn.accountId = [master].number
	--	WHERE 
	--	vn.NoticeID IN(
	--	SELECT NoticeID FROM ValidationNotice WHERE CONVERT(DATE, ValidationPeriodExpiration) < GETUTCDATE() AND ValidationPeriodCompleted <>1
	--	)
   
   DECLARE @AccountID INT, @Summary VARCHAR(500);
	DECLARE cur_validation CURSOR FOR
	SELECT AccountID, 'Validation Period completed on ' + CONVERT(VARCHAR(10), GETUTCDATE(), 101) + ' for ' + d.Name
	FROM ValidationNotice v
	INNER JOIN Debtors d ON d.DebtorID = v.DebtorID
	WHERE CONVERT(DATE, ValidationPeriodExpiration) < GETUTCDATE() AND ValidationPeriodCompleted <> 1
	OPEN cur_validation
	FETCH NEXT FROM cur_validation INTO @AccountID, @Summary
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT notes VALUES(@AccountID, null, GETDATE(), 'SYSTEM', '+++++', '+++++', @Summary, NULL, NULL, GETUTCDATE())    

		FETCH NEXT FROM cur_validation INTO @AccountID, @Summary
	END
	CLOSE cur_validation
	DEALLOCATE cur_validation
   
	UPDATE ValidationNotice SET ValidationPeriodCompleted = 1, LastUpdated=GETDATE(), Status='Completed' WHERE NoticeID IN(
	SELECT NoticeID FROM ValidationNotice WHERE CONVERT(DATE, ValidationPeriodExpiration) < GETUTCDATE() AND ValidationPeriodCompleted <>1
	)
END
GO
