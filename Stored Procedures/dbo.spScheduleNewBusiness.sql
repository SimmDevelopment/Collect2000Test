SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spScheduleNewBusiness] 
AS
BEGIN TRY

	DECLARE @NextQueueDate DATETIME
	SET @NextQueueDate = GETDATE()
	IF DATEPART(HOUR,@NextQueueDate) > 18 SET @NextQueueDate=DATEADD(day,1,GETDATE()) ELSE SET @NextQueueDate = GETDATE()

	UPDATE master 
		SET qlevel = '016', qdate=dbo.MakeQDate(@NextQueueDate)
	FROM
		(SELECT master.*,d.NewBizDays FROM master
		 INNER JOIN desk d ON d.code=desk AND NewBizDays >= 1) m2
	WHERE 
		master.number=m2.number AND getdate() < DATEADD(day, NewBizDays, m2.Complete1)
		AND m2.Complete1 IS NOT NULL AND m2.QLevel < '600' 

END TRY

BEGIN CATCH
    SELECT * FROM [dbo].[fnGetErrorInfo]()
	RETURN 1
END CATCH

RETURN 0;

GO
