SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spScheduleAccounts] @AgeQueues BIT = 1, @ConsolidateBrokenPromises BIT = 1, @ConsolidateCustomQueueLevels BIT = 0, @ConsolidateNewBusiness BIT = 1, @ConsolidateNightQueue BIT = 0, @ConsolidateNSF BIT = 1 	
AS

	DECLARE @NextQueueDate DATETIME
	SET @NextQueueDate = GETDATE()
	IF DATEPART(HOUR,@NextQueueDate) > 18 SET @NextQueueDate=DATEADD(day,1,GETDATE()) ELSE SET @NextQueueDate = GETDATE()

BEGIN TRY

	UPDATE master
		SET qlevel= CASE WHEN SUBSTRING(qlevel,1,1)='?' THEN '4'+SUBSTRING(qlevel,2,2) ELSE qlevel END
		WHERE SUBSTRING(qlevel,1,1)='?'

	UPDATE master
		SET qlevel='400'
		WHERE qlevel BETWEEN '400' AND '404' AND @ConsolidateNightQueue=1

	UPDATE master
		SET qlevel='015'
		WHERE status='NEW' AND qlevel <> '015' AND (ISNULL(link,0) = 0 OR linkdriver = 1)

	UPDATE master
		SET qlevel='875'
		WHERE status='NEW' AND qlevel <> '875' AND ISNULL(link,0) <> 0 AND linkdriver = 0

	UPDATE master
		SET qdate=dbo.MakeQDate(@NextQueueDate)
		WHERE (qlevel BETWEEN '425' AND '499' AND @ConsolidateCustomQueueLevels=1)
		OR (qlevel='015' AND @ConsolidateNewBusiness=1) 
		OR (qlevel='012' AND @ConsolidateNSF=1)
		OR (qlevel='010' AND @ConsolidateBrokenPromises=1)

	IF @AgeQueues=1
		UPDATE master
			SET qlevel=
				CASE 
					WHEN DATEDIFF(day, received, @NextQueueDate) < 31 THEN '020'
					WHEN DATEDIFF(day, received, @NextQueueDate) < 61 THEN '030'
					WHEN DATEDIFF(day, received, @NextQueueDate) < 91 THEN '060'
					WHEN DATEDIFF(day, received, @NextQueueDate) < 121 THEN '090'
					ELSE '120'
				END
			WHERE qlevel IN ('020','030','060','090','120','599') AND qlevel < '600'


END TRY

BEGIN CATCH
    SELECT * FROM [dbo].[fnGetErrorInfo]()
	RETURN 1
END CATCH

RETURN 0;

GO
