SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE          procedure [dbo].[AIM_Placement_UpdateTransactionsCompleted]
(
	@agencyId   int
	,@batchFileHistoryId int
)
AS
--11/20/2007 KMG Modifed to use a cursor instead of a bulk update
--BEGIN
--DECLARE @updateNumber int
--DECLARE @updateFeeCode varchar(5)
--DECLARE @updateDateTime datetime
--
--SET @updateDateTime = getdate()
--
--
----CREATE TEMP TABLE
--DECLARE @tempUpdate TABLE (Number int,feecode varchar(5))
--INSERT INTO @tempUpdate
--SELECT ar.referencenumber,CASE WHEN ar.FeeSchedule = 'null' THEN null ELSE ar.FeeSchedule END FROM AIM_AccountReference ar WITH (NOLOCK)
--JOIN AIM_AccountTransaction atr WITH (NOLOCK) ON atr.accountreferenceid = ar.accountreferenceid
--where	atr.transactiontypeid = 1 and atr.transactionstatustypeid = 3 and atr.agencyid = @agencyid and atr.batchfilehistoryid = @batchFileHistoryId
--and ar.isplaced = 1 and ar.currentlyplacedagencyid = @agencyid
--
--
----DECLARE CURSOR FOR UPDATING MASTER
--DECLARE update_cursor CURSOR FAST_FORWARD READ_ONLY FOR
--SELECT Number,feecode FROM @tempUpdate
--
--OPEN update_cursor
--FETCH NEXT FROM update_cursor INTO @updateNumber,@updateFeeCode
--
--WHILE @@FETCH_STATUS = 0
--BEGIN
--
--UPDATE Master SET AIMAgency = @agencyid,AIMAssigned = @updateDateTime,FeeCode = @updateFeeCode WHERE Number = @updateNumber
--
--FETCH NEXT FROM update_cursor INTO @updateNumber,@updateFeeCode
--
--END
--CLOSE update_cursor
--DEALLOCATE update_cursor

--END


GO
